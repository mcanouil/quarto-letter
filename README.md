# Letter Format Template

This is a Quarto template that assists you in creating a manuscript using the letter format.

## Creating a New Letter

You can use this as a template to create a letter.
To do this, use the following command:

```bash
quarto use template mcanouil/quarto-letter@1.2.0
```

This will install the extension and create an example qmd file and bibliography that you can use as a starting place for your article.

## Installation For Existing Document

You may also use this format with an existing Quarto project or document.
From the quarto project or document directory, run the following command to install this format:

```bash
quarto add mcanouil/quarto-letter@1.2.0
```

## Usage

To use the format, you can use the format name `letter-pdf`[^1].
For example:

```bash
quarto render template.qmd --to letter-pdf
```

or in your document yaml

```yaml
format: letter-pdf
```

### Configuration

| Option                  | Type   | Default      | Description                                                                                                 |
| ----------------------- | ------ | ------------ | ----------------------------------------------------------------------------------------------------------- |
| `address`               | array  | (required)   | Recipient address lines. The render logs an error if missing or empty.                                      |
| `subject`               | string |              | Letter subject line.                                                                                        |
| `subject-title`         | string | `Subject`    | Label preceding the subject line.                                                                           |
| `subject-suffix`        | string | `:`          | Character appended after the subject title.                                                                 |
| `opening`               | string |              | Opening salutation.                                                                                         |
| `closing`               | string |              | Closing salutation.                                                                                         |
| `cc`                    | array  |              | Carbon copy recipients.                                                                                     |
| `encl`                  | array  |              | List of enclosures.                                                                                         |
| `ps`                    | string |              | Postscript text appended after the closing.                                                                 |
| `header-image`          | string |              | Path to a letterhead image inserted above the opening salutation.                                           |
| `header-image-width`    | string | `\textwidth` | LaTeX width for the letterhead image (e.g. `0.5\textwidth`, `8cm`).                                         |
| `signature-image`       | string |              | Path to a signature image inserted between the closing salutation and the printed name (digital signature). |
| `signature-image-width` | string | `4cm`        | LaTeX width for the signature image (e.g. `4cm`, `0.3\textwidth`).                                          |

### Bilingual Variants

It is possible to change the subject title and the subject suffix, e.g., for a French letter:

```yaml
format:
  letter-pdf:
    subject-title: Objet
    subject-suffix: "&nbsp;:"
```

The extension ships matching code snippets (`meta` for English, `meta-fr` for French, `meta-sig` for a letter with a signature image) that can be triggered in editors with Quarto IDE integration.

### Letterhead and Signature Images

To include a letterhead and a digital signature image:

```yaml
format:
  letter-pdf:
    header-image: letterhead.png
    header-image-width: "0.5\\textwidth"
    signature-image: signature.png
    signature-image-width: 4cm
```

> [!NOTE]
> Width values are passed through to `\includegraphics`, so any LaTeX dimension is accepted (e.g. `4cm`, `0.5\textwidth`, `120pt`).
> Use double backslashes in YAML double-quoted strings (`"0.5\\textwidth"`) so the literal backslash is preserved.

### Validation and Warnings

The extension emits prefixed diagnostics during rendering:

- An error when the required `address` field is missing or empty.
- A warning when `subject-title` is set but `subject` is empty.
- A warning when `subject` or `subject-title` contains raw HTML tokens (e.g. `<x>`), which Pandoc strips from LaTeX output.

You can view a preview of the rendered template at <https://m.canouil.dev/quarto-letter/index.pdf>.

[^1]: Currently only PDF is supported but HTML support will be added as soon as Paged.js is made available in [Quarto](https://quarto.org).
