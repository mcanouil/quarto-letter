# Letter Format Template

This is a Quarto template that assists you in creating a manuscript using the letter format.

## Creating a New Letter

You can use this as a template to create a letter.
To do this, use the following command:

```bash
quarto use template mcanouil/quarto-letter
```

This will install the extension and create an example qmd file and bibliography that you can use as a starting place for your article.

## Installation For Existing Document

You may also use this format with an existing Quarto project or document.
From the quarto project or document directory, run the following command to install this format:

```bash
quarto install extension mcanouil/quarto-letter
```

## Usage

To use the format, you can use the format names `letter-pdf`.
For example:

```bash
quarto render template.qmd --to letter-pdf
```

or in your document yaml

```yaml
format:
  letter-pdf:
    keep-tex: true    
```

You can view a preview of the rendered template at <https://mcanouil.github.io/quarto-letter/>.
