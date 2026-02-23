# LaTeX Book Template

A complete, working LaTeX book project with Makefile automation.

## Quick Start

1. Clone or download this project
2. Run `make` to compile the PDF
3. Run `make view` to open the PDF

## Project Structure
latex-book/
 - Makefile # Build automation
 - main.tex # Main document
 - references.bib # Bibliography
 - src/ # Chapter files
 - figures/ # Images and graphics
 - preamble/ # Custom commands and packages
 - build/ # Build directory (auto-created)

## Makefile Commands

- `make` or `make pdf` - Compile complete PDF with bibliography
- `make quick` - Quick compilation (no bibliography)
- `make watch` - Continuous compilation (watch for changes)
- `make clean` - Remove build artifacts
- `make view` - Open PDF in default viewer
- `make wordcount` - Count words in PDF
- `make pagecount` - Count pages in PDF
- `make help` - Show all available commands

## Customization

1. Edit `main.tex` to change document metadata
2. Add chapters in `src/` directory
3. Add references to `references.bib`
4. Update `Makefile` variables as needed

## Dependencies

- LaTeX distribution (TeX Live, MikTeX, or MacTeX)
- `latexmk` (for automatic compilation)
- Optional: `aspell`, `chktex`, `graphviz` for additional features

## License

MIT License - Feel free to use this template for your own projects.
