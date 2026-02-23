# LaTeX Book Makefile
BOOK_NAME = latex-book
MAIN_TEX = main.tex
OUTPUT_DIR = build
SOURCE_DIR = src

LATEX = pdflatex
BIBTEX = bibtex
LATEXMK = latexmk
LATEX_FLAGS = -shell-escape -file-line-error -interaction=nonstopmode
LATEXMK_FLAGS = -pdf -pdflatex="$(LATEX) $(LATEX_FLAGS)" -bibtex -interaction=nonstopmode -output-directory=$(OUTPUT_DIR) -jobname=$(BOOK_NAME)

TEX_FILES = $(wildcard $(SOURCE_DIR)/*.tex) $(wildcard preamble/*.tex) $(wildcard *.tex)
BIB_FILES = $(wildcard *.bib)

PDF_OUTPUT = $(OUTPUT_DIR)/$(BOOK_NAME).pdf
AUX_FILES = $(OUTPUT_DIR)/*.aux $(OUTPUT_DIR)/*.log $(OUTPUT_DIR)/*.out \
            $(OUTPUT_DIR)/*.toc $(OUTPUT_DIR)/*.lof $(OUTPUT_DIR)/*.lot \
            $(OUTPUT_DIR)/*.bbl $(OUTPUT_DIR)/*.blg $(OUTPUT_DIR)/*.run.xml \
            $(OUTPUT_DIR)/*.bcf $(OUTPUT_DIR)/*.fdb_latexmk $(OUTPUT_DIR)/*.fls \
            $(OUTPUT_DIR)/*.synctex.gz

all: pdf

pdf: $(OUTPUT_DIR) $(PDF_OUTPUT)

$(PDF_OUTPUT): $(TEX_FILES) $(BIB_FILES)
	@echo "Compiling LaTeX document..."
	@mkdir -p $(OUTPUT_DIR)
	@$(LATEXMK) $(LATEXMK_FLAGS) -f $(MAIN_TEX)
	@echo "PDF created: $(PDF_OUTPUT)"

quick: $(OUTPUT_DIR)
	@echo "Quick compilation (no bibliography)..."
	@$(LATEX) $(LATEX_FLAGS) -output-directory=$(OUTPUT_DIR) $(MAIN_TEX)
	@cp $(OUTPUT_DIR)/$(notdir $(basename $(MAIN_TEX))).pdf $(PDF_OUTPUT)

watch:
	@echo "Watching for changes in LaTeX files..."
	@$(LATEXMK) $(LATEXMK_FLAGS) -pvc $(MAIN_TEX)

$(OUTPUT_DIR):
	@mkdir -p $(OUTPUT_DIR)

clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(OUTPUT_DIR)
	@$(LATEXMK) -C 2>/dev/null || true
	@rm -f *.aux *.log *.out *.toc *.lof *.lot *.bbl *.blg *.run.xml \
	      *.bcf *.nav *.snm *.vrb *.fdb_latexmk *.fls *.synctex.gz

view: pdf
	@echo "Opening PDF..."
	@if command -v xdg-open > /dev/null; then \
		xdg-open $(PDF_OUTPUT); \
	elif command -v open > /dev/null; then \
		open $(PDF_OUTPUT); \
	else \
		echo "Please open $(PDF_OUTPUT) manually"; \
	fi

spell:
	@echo "Running spell check..."
	@aspell --lang=en --mode=tex check $(MAIN_TEX)

wordcount: pdf
	@echo "Word count:"
	@pdftotext $(PDF_OUTPUT) - | wc -w

pagecount: pdf
	@echo "Page count:"
	@pdfinfo $(PDF_OUTPUT) | grep Pages | awk '{print $$2}'

lint:
	@echo "Linting LaTeX files..."
	@chktex -q $(TEX_FILES) 2>/dev/null || true

archive: clean
	@echo "Creating archive..."
	@tar -czf $(BOOK_NAME)-source-$(shell date +%Y%m%d).tar.gz \
		--exclude='*.pdf' \
		--exclude='*.zip' \
		--exclude='*.tar.gz' \
		--exclude='*.git' \
		--exclude='build' \
		--exclude='*.aux' \
		--exclude='*.log' \
		.

deps:
	@echo "Generating dependency graph..."
	@$(LATEXMK) -graphviz -pdf $(MAIN_TEX) 2>/dev/null || true
	@if [ -f $(notdir $(basename $(MAIN_TEX))).dot ]; then \
		dot -Tpdf $(notdir $(basename $(MAIN_TEX))).dot -o $(OUTPUT_DIR)/dependencies.pdf; \
		echo "Dependency graph: $(OUTPUT_DIR)/dependencies.pdf"; \
	fi

help:
	@echo "LaTeX Book Makefile"
	@echo "==================="
	@echo "Available targets:"
	@echo "  all/pdf     - Compile complete PDF with bibliography"
	@echo "  quick       - Quick compilation (no bibliography)"
	@echo "  watch       - Continuous compilation (watch for changes)"
	@echo "  view        - Open PDF in default viewer"
	@echo "  clean       - Remove build artifacts"
	@echo "  spell       - Spell check main file (requires aspell)"
	@echo "  wordcount   - Count words in PDF"
	@echo "  pagecount   - Count pages in PDF"
	@echo "  lint        - Lint LaTeX files (requires chktex)"
	@echo "  deps        - Generate dependency graph (requires graphviz)"
	@echo "  archive     - Create source archive"
	@echo "  help        - Show this help"

.PHONY: all pdf quick watch clean view spell wordcount pagecount lint deps archive help