#import "../src/lib.typ": template, paper, appended-papers, bibliography-section

#let papers = (
  paper(
    "Title of the First Paper",
    [*A. Andersson*, S. O. Person, J. Whoever],
    [Some Journal 39 (May 2019), 133-144],
    doi: [doi goes here],
  ),
  paper(
    "The Second Paper",
    [*A. Andersson*],
    [Submitted, under review],
  ),
)

#show: template.with(
  kind: "phd",
  degree-type: "philosophy",
  date: datetime(year: 2026, month: 5, day: 1),
  title: "A Thesis on Computer Science",
  subtitle: "With some subtitle if you want it",
  authors: ("Anders Andersson",),
  division: "Software Engineering",
  research-group: "Some Research Group",
  isbn: "xxx-xx-xxxx-xxx-x",
  phd-series-number: "xxxx",
  technical-report-number: "XXXX",
  abstract: [
    The abstract of the thesis. Check the current Chalmers/GU instructions for
    the required maximum length before printing.
  ],
  keywords: ("Keyword 1", "Keyword 2"),
  publications: papers,
  authorship-statement: [
    The following statement summarizes my personal contribution to the papers
    included in this thesis. Where relevant, co-authors have agreed with it.

    #enum(
      [Title of the first paper. My contribution to this paper.],
      [Title of the second paper. My contribution to this paper.],
      numbering: n => [*Paper #numbering("I", n)*],
    )
  ],
  acknowledgements: [Acknowledgements.],
)

= Introduction

This chapter is the kappa.

== Some Padding

Here is a reference to the first appended paper.

= Summary of Included Papers

== Title of the First Paper

In this paper we present a method to do something.

=== Problem

Description of what we are trying to solve.

=== Scientific Contribution

What does the paper do to try to solve the problem?

=== Methodology

How is it implemented?

// Add a bibliography once `references.bib` exists:
// #bibliography-section("references.bib")

#appended-papers(papers)
