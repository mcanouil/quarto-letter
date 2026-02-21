# Letter Format Template

This is a Quarto template that assists you in creating a manuscript using the letter format.

## Creating a New Letter

You can use this as a template to create a letter.
To do this, use the following command:

```bash
quarto use template mcanouil/quarto-letter@1.1.0
```

This will install the extension and create an example qmd file and bibliography that you can use as a starting place for your article.

## Installation For Existing Document

You may also use this format with an existing Quarto project or document.
From the quarto project or document directory, run the following command to install this format:

```bash
quarto add mcanouil/quarto-letter@1.1.0
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

It's possible to change the subject title and the subject suffix, e.g., for a French letter:

```yaml
subject-title: Objet
subject-suffix: "&nbsp;:"
```

You can view a preview of the rendered template at <https://m.canouil.dev/quarto-letter/index.pdf>.

[^1]: Currently only PDF is supported but HTML support will be added as soon as Paged.js is made available in [Quarto](https://quarto.org).
