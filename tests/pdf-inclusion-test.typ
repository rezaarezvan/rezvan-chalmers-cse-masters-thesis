#import "../src/lib.typ": template, paper, appended-papers

#let papers = (
  paper(
    "Included PDF Paper",
    [A. Andersson],
    [Smoke-test venue],
    pdf: "/tests/fixtures/dummy-paper.pdf",
    pages: (1,),
  ),
)

#show: template.with(
  kind: "phd",
  title: "PDF Inclusion Test",
  authors: ("A. Andersson",),
  division: "Software Engineering",
  abstract: [Short abstract.],
  publications: papers,
  acknowledgements: [Acknowledgements.],
)

= Introduction

This document checks that appended paper PDFs can be included.

#appended-papers(papers)
