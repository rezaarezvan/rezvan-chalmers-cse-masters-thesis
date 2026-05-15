#import "../src/lib.typ": template, appendices

#let department = "Department of Computer Science and Engineering"

#show: template.with(
  kind: "master",
  school: ("Chalmers University of Technology", "University of Gothenburg"),
  title: "Title",
  subtitle: "Subtitle",
  authors: ("Author1", "Author2"),
  department: department,
  subject: "Computer Science and Engineering",
  supervisor: ("Supervisor", department),
  advisor: ("Advisor", department),
  examiner: ("Examiner", department),
  abstract: [
    This is a minimal standalone example for the package repository.
    It demonstrates page layout, prelude pages, chapter headings, and appendices.
  ],
  acknowledgements: [
    We thank everyone who helped validate the migration from LaTeX to Typst.
  ],
  keywords: ("Typst", "Thesis"),
  series: none,
  figures: true,
  tables: true,
  listings: false,
  draft: false,
  oneside: false,
)

= Introduction <intro>

This example intentionally keeps content brief and self-contained.

== A Section <section>

The template provides a thesis prelude, page styles, heading numbering, and appendix handling.
Heading references distinguish @intro from @section.

#show: appendices
= Appendix <appendix>

Appendix placeholder text. Appendix references use @appendix.

== Appendix Section <appendix-section>

Lower appendix headings reference as @appendix-section.
