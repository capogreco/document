# Academic Document Template

A markdown-based workflow for generating academic PDF documents with bibliography support, automated builds, and citation management.

## Quick Start

1. Edit `metadata.yaml` with your document details (title, author, institution, etc.)
2. Write your content in `document.md`
3. Add bibliography entries to `bibliography.bib` (export from Zotero or add manually)
4. Run `make pdf` to generate the PDF

## Setup

### Required Dependencies

1. **Pandoc**: `brew install pandoc` (macOS) or equivalent
2. **LaTeX**: `brew install --cask mactex` (macOS) or equivalent
3. **Deno** (optional, for citation picker and file watcher): `brew install deno`
4. **fzf** (optional, for citation picker): `brew install fzf`

### Optional Tools

- **entr** (for `make watch`): `brew install entr`

## Building the PDF

### Basic Build

```bash
make pdf
```

Or manually:

```bash
pandoc document.md -o document.pdf --bibliography=bibliography.bib --csl=apa.csl --pdf-engine=xelatex --metadata-file=metadata.yaml
```

### Other Make Commands

```bash
make clean    # Remove generated PDF
make open     # Build and open PDF (macOS)
make watch    # Watch for changes and auto-rebuild (requires entr)
```

## File Structure

- `document.md` - Your main document content (markdown)
- `metadata.yaml` - Document metadata and configuration
- `bibliography.bib` - Bibliography entries (BibTeX format)
- `Makefile` - Build automation
- `cite.ts` - Citation picker script (Deno)
- `watch.ts` - File watcher script (Deno)
- `search.ts` - Search & Zotero integration script (Deno)
- `deno.json` - Deno task configuration
- `.env` - API keys for `deno task search` (gitignored — see *Search & Discovery*)
- `*.csl` - Citation style files (APA, Chicago variants)
- `document.pdf` - Generated output
- `.zed/settings.json` - Project-local Zed settings (Markdown autocomplete disabled)

## Managing Bibliography

### From Zotero

1. In Zotero, select the items you want to cite
2. Right-click and choose "Export Items..."
3. Select "Better BibLaTeX" (or "BibTeX") format
4. Save as `bibliography.bib` (overwrite the template file)

For a frictionless workflow, install the **Better BibTeX** plugin and use its *Keep updated* feature — point an automatic export at `bibliography.bib` and Zotero will rewrite the file every time you add or edit an item. With Zotero 9+ you need **Better BibTeX 9.0 or later** (the 7.x series is blocklisted on Zotero 9 and will produce silent export failures that truncate the target file).

### Manual Entry

Add BibTeX entries directly to `bibliography.bib`:

```bibtex
@article{author2024,
  title = {Article Title},
  author = {Author, First and Second, Author},
  journal = {Journal Name},
  year = {2024},
  volume = {1},
  pages = {1--10}
}
```

## Citation Picker (Deno Task)

Quickly insert citations using fuzzy search:

```bash
deno task cite
```

### Features

- Fuzzy search by author, year, title, or citation key
- Multi-select with Tab
- Select all with Ctrl-A
- Add locators (e.g., "p. 42")
- Copies Pandoc citation syntax to clipboard

### Usage

1. Run `deno task cite`
2. Search and select citation(s)
3. Optionally add a locator (e.g., `p. 42`)
4. Paste the clipboard content into your markdown

### Citation Examples

- Single: `[@key]` or `[@key, p. 42]`
- Multiple: `[@key1; @key2]`
- Multiple with locator: `[@key1, p. 10; @key2, p. 10]`

## Search & Discovery (Deno Task)

Search academic and informal sources, and add items to your Zotero library by DOI:

```bash
deno task search scholar "distributed synthesis"
deno task search openalex "critical posthumanism sound"
deno task search lines "norns webrtc"            # llllllll.co forum
deno task search web "createCanvas distributed audio"

# Add a paper to Zotero by DOI (or URL):
deno task search zotero add 10.1234/example

# Search your existing Zotero library, download PDFs, export collections:
deno task search zotero search "modular synthesis"
deno task search zotero pdf --all
deno task search zotero export --collection=my-collection
```

### Zotero Configuration

Create a `.env` file (gitignored) at the project root with your Zotero credentials:

```bash
ZOTERO_API_KEY=<your-api-key>
ZOTERO_USER_ID=<your-numeric-user-id>
ZOTERO_GROUP_ID=<optional-numeric-group-id>
```

- Create an API key at <https://www.zotero.org/settings/keys> with read + write permissions
- Find your `ZOTERO_USER_ID` on the same page (numeric "Your userID for use in API calls")
- If `ZOTERO_GROUP_ID` is set, `zotero add` writes to that **group library**; otherwise it writes to your personal library

## File Watcher (Deno Task)

Auto-rebuild PDF when markdown changes:

```bash
deno task watch
```

Features:
- Builds PDF on file save
- Also triggers a rebuild when shared files (`metadata.yaml`, `bibliography.bib`) change
- Supports Skim PDF auto-refresh (macOS)
- Displays build status in terminal

## Document Configuration

Edit `metadata.yaml` to customize:

- Document metadata (title, author, date, abstract, keywords)
- PDF formatting (margins, fonts, line spacing)
- Section numbering style
- Bibliography and citation style
- LaTeX customizations

### Available Citation Styles

- `apa.csl` - APA (default)
- `chicago-note-bibliography.csl` - Chicago notes
- `chicago-notes-bibliography.csl` - Chicago notes (variant)
- `chicago-shortened-notes-bibliography.csl` - Chicago shortened notes

To change styles, edit the `csl` field in `metadata.yaml`.

## Paragraph Style

By default, paragraphs are indented (1.5em) with no space between them, except the first paragraph after a section heading is not indented (classic academic style).

To change this, edit the `header-includes` section in `metadata.yaml`.

## Editor Settings

`.zed/settings.json` disables Markdown autocomplete (`show_completions_on_input`) and AI edit predictions (`show_edit_predictions`) for this project. This keeps prose writing free of code-style popups while leaving manual completions (Ctrl-Space) available if you want them. Project-level settings merge with your user settings — other Zed preferences are unaffected.

## Epigraphs

The template loads the `epigraph` LaTeX package for section-opener quotes with right-flush attribution. Use raw LaTeX directly in your markdown:

```markdown
## Section Title

\epigraph{The quote text goes here, italicised automatically by the package.}{--- Author Name, \emph{Source Title} (Year)}

Body text begins here…
```

For an inline blockquote that sits inside the argument's flow (rather than above it as an epigraph), use standard markdown:

```markdown
> A quote that lives inside the paragraph.
>
> — Author, *Source*
```

Epigraph styling (width, flush, font size, spacing) is configured in `metadata.yaml`.

## Citations in Markdown

Use Pandoc citation syntax:

```markdown
According to @author2024, this is true.

This is a fact [@author2024].

This is a fact with a page number [@author2024, p. 42].

Multiple sources [@author2024; @another2023].
```

## References Section

Add this at the end of your markdown to generate the bibliography:

```markdown
# References

::: {#refs}
:::
```

## Tips

1. Use `deno task watch` during writing for live PDF updates
2. Use `deno task cite` for quick citation insertion
3. Keep your Zotero library organized and export regularly
4. Check `document.pdf` with a PDF viewer that auto-refreshes (e.g., Skim on macOS)
5. Use `make clean` if you need to force a fresh build

## Troubleshooting

### PDF Generation Fails

- Ensure Pandoc and LaTeX are installed
- Check that all files referenced in `metadata.yaml` exist
- Review error messages for missing packages or syntax errors

### Citation Picker Not Working

- Install Deno: `brew install deno`
- Install fzf: `brew install fzf`
- Ensure `bibliography.bib` exists and has valid BibTeX entries

### File Watcher Not Working

- Install Deno: `brew install deno`
- Check that `document.md` exists
- Ensure Makefile is present and `make pdf` works manually

### Zotero Export Truncates `bibliography.bib` to 0 Bytes

Almost always caused by the **Better BibTeX 7.x → Zotero 9.x** version mismatch: Zotero 9 blocklists BBT 7, the export starts (truncating the target file), then fails because the BBT API is unavailable. Fix: install Better BibTeX **9.0 or later** from <https://github.com/retorquere/zotero-better-bibtex/releases>, then fully quit and relaunch Zotero before retrying the export.

If the BibTeX side of `bibliography.bib` is under version control, you can recover with `git restore bibliography.bib`.

### `deno task search` Fails with "ZOTERO_API_KEY must be set"

- Create `.env` at the project root and add the variables documented in *Zotero Configuration*
- The `.env` file is gitignored; never commit credentials

### `deno task search zotero add` Fails with "Invalid user ID"

- Either `ZOTERO_USER_ID` or `ZOTERO_GROUP_ID` must be set in `.env`
- If you want items to land in a **group library**, set `ZOTERO_GROUP_ID` (numeric) — the script prefers group ID over user ID
