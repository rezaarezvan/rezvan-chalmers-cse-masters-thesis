# rezvan-chalmers-cse-thesis
Unofficial Typst package for master, PhD, and licentiate theses at Chalmers
University of Technology and University of Gothenburg CSE.

This package is based on the Chalmers/GU CSE master's thesis layout, CMDJojo's
`mastery-chs`, and the CSE PhD council thesis template. It is not an official
Chalmers or University of Gothenburg package.

## Features
- Master thesis prelude pages: cover, title page, imprint, abstract,
  acknowledgements, TOC, and optional lists.
- PhD and licentiate kappa pages: first pages, abstract, publication list,
  authorship statement, acknowledgements, TOC, summary, and appended papers.
- Presentation-sheet and errata helpers for doctoral theses.
- Shared running headers/footers, caption styling, one-sided/two-sided page
  behavior, and appendix helper.

## Install / Init
```sh
typst init @preview/rezvan-chalmers-cse-thesis:0.3.0
```

## Master Usage
```typst
#import "@preview/rezvan-chalmers-cse-thesis:0.3.0": template, appendices, cover-background

#let department = "Department of Computer Science and Engineering"
#let cover = cover-background(
  image("cover.svg", width: 45%),
)

#show: template.with(
  kind: "master",
  title: "Your Thesis Title",
  subtitle: "Optional subtitle",
  authors: ("Your Name",),
  department: department,
  subject: "Computer Science and Engineering",
  supervisor: ("Supervisor Name", department),
  advisor: none,
  examiner: ("Examiner Name", department),
  abstract: [Write your abstract here.],
  acknowledgements: [Write your acknowledgements here.],
  keywords: ("keyword-1", "keyword-2"),
  series: none,
  cover-background: cover,
  cover-caption: [Caption for the cover illustration, if used.],
  printed-by: none,
)

= Introduction

Your content.

#show: appendices
= Appendix
```

## Doctoral Usage
```typst
#import "@preview/rezvan-chalmers-cse-thesis:0.3.0": template, paper, appended-papers

#let papers = (
  paper(
    "Title of the First Paper",
    [*A. Andersson*, S. O. Person],
    [Some Journal 39 (May 2019), 133-144],
    doi: [doi goes here],
  ),
)

#show: template.with(
  kind: "phd", // or "licentiate"
  degree-type: "philosophy", // or "engineering"
  title: "A Thesis on Computer Science",
  authors: ("Anders Andersson",),
  division: "Software Engineering",
  isbn: "xxx-xx-xxxx-xxx-x",
  phd-series-number: "xxxx",
  technical-report-number: "XXXX",
  abstract: [Write your abstract here.],
  publications: papers,
  authorship-statement: [Summarize your contributions here.],
  acknowledgements: [Acknowledgements.],
)

= Introduction

Your kappa starts here.

#appended-papers(papers)
```

## CSE / Chalmers Notes
- The report is expected to be written in English for master's theses.
- The abstract should be concise and 250-350 words.
- Use at most 10 keywords at the end of the abstract page.
- Produce an A4, ODR-ready PDF with Roman front-matter numbering and Arabic
  numbering starting at the first chapter.
- CSE theses normally use the combined Chalmers University of Technology and
  University of Gothenburg identity.
- Doctoral layout, ISBN/ISSN, series, cover, abstract, and presentation-sheet
  requirements should be checked against current Chalmers/GU instructions
  before printing.

## Build
```sh
typst compile --root . examples/thesis-example.typ
typst compile --root . examples/phd-example.typ
typst compile --root . examples/licentiate-example.typ
typst compile --root . examples/presentation-sheet-example.typ
typst compile --root . examples/errata-example.typ
mkdir -p tests/fixtures build
typst compile --root . examples/papers/dummy-paper.typ tests/fixtures/dummy-paper.pdf
typst compile --root . tests/pdf-inclusion-test.typ build/pdf-inclusion-test.pdf
```

## Repository Structure
- `src/lib.typ`: package entrypoint and public API.
- `src/doctoral.typ`: PhD/licentiate front matter, appended papers,
  presentation sheets, and errata.
- `src/pages/`: prelude page components.
- `src/img/`: default logos.
- `examples/`: standalone local examples.
- `template/`: `typst init` scaffold.

## Credits
Credits go to [CMDJojo's mastery-chs repository](https://github.com/CMDJojo/mastery-chs)
and the [CSE PhD council thesis template](https://github.com/CSEPhd-council/thesis-template).

## License
MIT. See `LICENSE` for details.

The included Chalmers and University of Gothenburg SVG logo assets are derived
from the current Chalmers/GU Word cover templates. Their use is subject to the
universities' own visual identity and logo rules.
