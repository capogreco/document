# Document Build System

# Build configuration
BIBLIOGRAPHY = bibliography.bib
CSL = apa.csl
METADATA = metadata.yaml

# Auto-discover .md files in the project root. README.md and other meta
# files are excluded by name; everything else builds to a same-named .pdf.
SOURCES := $(wildcard *.md)
EXCLUDE := README.md CHANGELOG.md CONTRIBUTING.md LICENSE.md
DOCS := $(filter-out $(EXCLUDE), $(SOURCES))
PDFS := $(DOCS:.md=.pdf)
DOCXS := $(DOCS:.md=.docx)

# Optional Word styling: if a reference.docx exists, use it; otherwise
# pandoc falls back to its clean default styles.
REFERENCE_DOC := $(wildcard reference.docx)

PANDOC_FLAGS = \
	--bibliography=$(BIBLIOGRAPHY) \
	--csl=$(CSL) \
	--pdf-engine=xelatex \
	--number-sections \
	--toc \
	--citeproc \
	--lua-filter=epigraph.lua \
	--metadata-file=$(METADATA)

# Default target: build every discovered document
all: $(PDFS)

# Backwards-compat alias
pdf: all

# Build every discovered document as Word .docx
docx: $(DOCXS)

# Generic pattern rule: any .md becomes its same-named .pdf
%.pdf: %.md $(BIBLIOGRAPHY) $(CSL) $(METADATA) epigraph.lua
	pandoc $< -o $@ $(PANDOC_FLAGS) 2>/dev/null || \
	pandoc $< -o $@ $(PANDOC_FLAGS)

# Word .docx output: same content pipeline as PDF, minus the LaTeX engine.
# The epigraph filter no-ops for non-LaTeX, so epigraph divs degrade to
# plain quote + attribution paragraphs.
%.docx: %.md $(BIBLIOGRAPHY) $(CSL) $(METADATA) epigraph.lua
	pandoc $< -o $@ \
		--bibliography=$(BIBLIOGRAPHY) \
		--csl=$(CSL) \
		--number-sections \
		--toc \
		--citeproc \
		--lua-filter=epigraph.lua \
		--metadata-file=$(METADATA) \
		$(if $(REFERENCE_DOC),--reference-doc=$(REFERENCE_DOC),)

# Clean only generated PDFs and DOCX (leaves source/reference files untouched)
clean:
	rm -f $(PDFS) $(DOCXS)

# Open the first generated PDF (macOS)
open: all
	@first_pdf=$$(echo $(PDFS) | awk '{print $$1}'); \
	open "$$first_pdf"

# Watch for changes and rebuild (requires entr: brew install entr)
watch:
	echo $(DOCS) $(BIBLIOGRAPHY) $(METADATA) epigraph.lua | tr ' ' '\n' | entr make all

.PHONY: all pdf docx clean open watch
