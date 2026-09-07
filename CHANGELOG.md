# Changelog

## Unreleased

### Documentation

- docs: Serve the extension's social card as the Open Graph image, so a shared link shows the card rather than the first image on the page. (#45)

### Refactoring

- build: Update the vendored Lua modules to 2.3.0. A module no longer carries a version line in its header, so its checksum changes only when its code changes. (#46)

## 1.2.1 (2026-08-01)

### Documentation

- docs: Add a documentation website under `docs/`, built on the `atelier` project type and published to <https://m.canouil.dev/quarto-letter/>, rendering a letter with the format itself.
- docs: Trim `README.md` to a landing page pointing at the website.
- docs: Add the Pages workflow, which renders `docs/` on pull requests and deploys it from the release tag.
- docs: Add the Quarto Extensions Updates workflow, scanning `docs` for the website's own dependencies.

## 1.2.0 (2026-05-31)

### New Features

- feat: Add `signature-image` (and `signature-image-width`) for inserting a digital signature image between the closing and the printed name.
- feat: Add `header-image` (and `header-image-width`) for letterhead images inserted above the opening salutation.
- feat: Add a French bilingual snippet (`meta-fr`) and a signature-image snippet (`meta-sig`).
- feat: Add a Lua filter that validates the required `address` field and warns on raw HTML tokens in `subject` or `subject-title`.

### Documentation

- docs: Document the new image options and the French (bilingual) example in the README.

## 1.1.0 (2026-02-21)

### New Features

- feat: Add extension-provided code snippets (#29).
- feat: Add _schema.yml for configuration validation and IDE support (#27).

## 1.0.3 (2026-02-11)

### Bug Fixes

- fix: Update copyright year.

## 1.0.2 (2025-04-05)

### Bug Fixes

- fix: Set output-file option.

## 1.0.1 (2025-04-05)

### New Features

- feat: Add CITATION file for project citation.

### Bug Fixes

- fix: Switch to deploy from GitHub Actions (#17).
- fix: Updated quarto install command (#14).
- fix: Add "subject-title" in example.

### Documentation

- docs: Update link to pdf.

## 1.0.0 (2022-12-27)

### Bug Fixes

- fix: Update/Release for Quarto v1.2 (#6).
- fix: Add translation feature for "Subject" (#5).
- fix: Typo and add note for HTML.

## 0.1.0 (2022-08-21)

### New Features

- feat: Add ps, encl, cc fields.
