--- Letter - Format Filter
--- @module "letter"
--- @license MIT
--- @copyright 2026 Mickaël Canouil
--- @author Mickaël Canouil
--- @version 1.2.0
--- @brief Validate front matter and prepare letterhead/signature assets.
--- @description Validates required fields for the letter-pdf format and
--- prepares optional `header-image` and `signature-image` blocks so the
--- LaTeX template can render them without bespoke escaping in the partials.

local EXTENSION_NAME = 'letter'
local log = require(quarto.utils.resolve_path('_modules/logging.lua'):gsub('%.lua$', ''))

--- Convert a metadata value to a trimmed string.
--- @param value any Pandoc metadata value or nil
--- @return string trimmed Trimmed plain-text value, empty string if absent
local function meta_to_string(value)
  if value == nil then
    return ''
  end
  local text = pandoc.utils.stringify(value)
  return text:gsub('^%s+', ''):gsub('%s+$', '')
end

--- Check that a metadata list has at least one non-empty entry.
--- @param value any Pandoc metadata value (expected to be a List)
--- @return boolean has_entries true when the list contains usable lines
local function list_has_entries(value)
  if value == nil then
    return false
  end
  if type(value) ~= 'table' then
    return meta_to_string(value) ~= ''
  end
  for _, item in ipairs(value) do
    if meta_to_string(item) ~= '' then
      return true
    end
  end
  return false
end

--- Reconstruct a LaTeX width string from Pandoc inline metadata.
--- Plain `Str` text is concatenated; `RawInline` content is kept verbatim so
--- LaTeX dimensions like `0.5\textwidth` survive the YAML round trip.
--- @param value any Pandoc metadata value (MetaInlines or similar)
--- @return string text Combined text representation
local function inlines_to_latex(value)
  if value == nil then
    return ''
  end
  if type(value) ~= 'table' then
    return meta_to_string(value)
  end
  local parts = {}
  pandoc.walk_inline(pandoc.Span(value), {
    Str = function(el)
      parts[#parts + 1] = el.text
    end,
    Space = function()
      parts[#parts + 1] = ' '
    end,
    RawInline = function(el)
      parts[#parts + 1] = el.text
    end
  })
  local text = table.concat(parts)
  return text:gsub('^%s+', ''):gsub('%s+$', '')
end

--- Resolve a width string for graphics inclusion in LaTeX.
--- Falls back to the supplied default when the value is empty.
--- @param value any Metadata value carrying a width (e.g. "4cm", "0.5\\textwidth")
--- @param default string Default width to use when value is empty
--- @return string width Width string suitable for \includegraphics
local function resolve_width(value, default)
  local width = inlines_to_latex(value)
  if width == '' then
    return default
  end
  return width
end

--- Build a `\includegraphics` LaTeX snippet for an optional image option.
--- @param path string Image path (already validated as non-empty)
--- @param width string LaTeX width argument
--- @return string snippet LaTeX `\includegraphics` call
local function include_graphics_snippet(path, width)
  return string.format('\\includegraphics[width=%s]{%s}', width, path)
end

--- Validate that the recipient address is present and well formed.
--- @param meta table Pandoc document metadata
--- @return boolean ok true when validation succeeds
local function validate_address(meta)
  if not list_has_entries(meta['address']) then
    log.log_error(
      EXTENSION_NAME,
      "Missing required 'address' field. " ..
      "Add at least one recipient address line under format.letter-pdf.address."
    )
    return false
  end
  return true
end

--- Detect a RawInline carrying an HTML tag inside a Pandoc inline list.
--- Pandoc parses bare `<tag>` patterns as RawInline format `html`, which the
--- LaTeX writer drops; surfacing this early avoids silent content loss.
--- @param value any Pandoc metadata value (MetaInlines or similar)
--- @return boolean has_raw_html true when raw HTML tokens are present
local function has_raw_html(value)
  if value == nil or type(value) ~= 'table' then
    return false
  end
  local found = false
  pandoc.walk_inline(pandoc.Span(value), {
    RawInline = function(el)
      if el.format == 'html' then
        found = true
      end
    end
  })
  return found
end

--- Warn on common front-matter inconsistencies that produce odd output.
--- @param meta table Pandoc document metadata
local function warn_on_inconsistencies(meta)
  local subject_title = meta_to_string(meta['subject-title'])
  local subject = meta_to_string(meta['subject'])
  if subject_title ~= '' and subject == '' then
    log.log_warning(
      EXTENSION_NAME,
      "'subject-title' is set but 'subject' is empty; the subject line will be omitted."
    )
  end

  if has_raw_html(meta['subject']) or has_raw_html(meta['subject-title']) then
    log.log_warning(
      EXTENSION_NAME,
      "'subject' or 'subject-title' contains raw HTML tokens (e.g. '<x>'); " ..
      "Pandoc strips these from LaTeX output. Escape with '\\<' / '\\>' or rewrite."
    )
  end
end

--- Prepare the header (letterhead) and signature image hooks in `header-includes`.
--- The hooks render before the letter body when `header-image` is set, and
--- replace the closing signature when `signature-image` is set.
--- Each hook is emitted as a single RawBlock so LaTeX sees one contiguous group.
--- @param meta table Pandoc document metadata
--- @return table meta Updated metadata
local function prepare_image_hooks(meta)
  local header_image = inlines_to_latex(meta['header-image'])
  local signature_image = inlines_to_latex(meta['signature-image'])

  if header_image == '' and signature_image == '' then
    return meta
  end

  local includes = meta['header-includes']
  if includes == nil then
    includes = pandoc.MetaList({})
  elseif includes.t ~= 'MetaList' then
    includes = pandoc.MetaList({ includes })
  end

  local snippets = { '\\usepackage{graphicx}' }

  if header_image ~= '' then
    local width = resolve_width(meta['header-image-width'], '\\textwidth')
    snippets[#snippets + 1] = table.concat({
      '\\makeatletter',
      '\\let\\letter@oldopening\\opening',
      '\\renewcommand{\\opening}[1]{%',
      include_graphics_snippet(header_image, width) .. '%',
      '\\par\\vspace{1em}%',
      '\\letter@oldopening{#1}%',
      '}',
      '\\makeatother'
    }, '\n')
  end

  if signature_image ~= '' then
    local width = resolve_width(meta['signature-image-width'], '4cm')
    snippets[#snippets + 1] = table.concat({
      '\\makeatletter',
      '\\let\\letter@oldclosing\\closing',
      '\\renewcommand{\\closing}[1]{%',
      '\\stopbreaks%',
      '\\noindent%',
      '\\ifx\\@empty\\fromaddress\\else%',
      '\\hspace*{\\longindentation}\\fi%',
      '\\parbox{\\indentedwidth}{\\raggedright%',
      '#1\\par\\vspace{0.5em}%',
      include_graphics_snippet(signature_image, width) .. '%',
      '\\par\\vspace{0.25em}%',
      '\\ignorespaces \\fromsig\\strut}\\par%',
      '}',
      '\\makeatother'
    }, '\n')
  end

  includes:insert(pandoc.MetaBlocks({
    pandoc.RawBlock('latex', table.concat(snippets, '\n'))
  }))

  meta['header-includes'] = includes
  return meta
end

--- Filter entry point.
--- Validates required fields and emits a clear, actionable diagnostic on failure.
--- Note: Quarto continues the pipeline after a Lua filter error, so the render
--- may still produce a malformed PDF; the early `(E) [letter] ...` diagnostic
--- makes the cause obvious in the log.
--- @param meta table Pandoc document metadata
--- @return table meta Updated metadata
local function process_meta(meta)
  if not quarto.doc.is_format('latex') then
    return meta
  end

  validate_address(meta)
  warn_on_inconsistencies(meta)
  return prepare_image_hooks(meta)
end

return {
  { Meta = process_meta }
}
