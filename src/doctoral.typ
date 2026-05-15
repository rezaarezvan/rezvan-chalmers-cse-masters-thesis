#let chalmers-blue = rgb("#004b87")
#let link-blue = rgb("#005aa0")

#let default-school = ("Chalmers University of Technology", "University of Gothenburg")
#let default-department = "Department of Computer Science and Engineering"
#let default-address = [SE-412 96 Gothenburg,\ Sweden]

#let _join(items, sep) = {
  let out = ()
  for (i, item) in items.enumerate() {
    if i > 0 {
      out.push(sep)
    }
    out.push(item)
  }
  out.join()
}

#let _school-line(school, sep: [ | ]) = if type(school) == array {
  _join(school, sep)
} else {
  school
}

#let _subtitle-line(subtitle, size: 12pt) = {
  if subtitle != none {
    [#v(4mm)#text(size: size, style: "italic")[#subtitle]]
  }
}

#let _degree-title(kind, degree-type) = {
  let prefix = if kind == "phd" {
    "Doctor"
  } else if kind == "licentiate" {
    "Licentiate"
  } else {
    panic("doctoral template kind must be \"phd\" or \"licentiate\"")
  }

  let suffix = if degree-type == "philosophy" {
    "Philosophy"
  } else if degree-type == "engineering" {
    "Engineering"
  } else {
    panic("degree-type must be \"philosophy\" or \"engineering\"")
  }

  prefix + " of " + suffix
}

#let _pagebreak-next(oneside: false, weak: false) = {
  if oneside {
    pagebreak(weak: weak)
  } else {
    pagebreak(to: "odd", weak: weak)
  }
}

#let _footer(numbering: "1", oneside: false) = context {
  let n = counter(page).get().first()
  if oneside {
    align(center, counter(page).display(numbering))
  } else if calc.even(n) {
    align(left, counter(page).display(numbering))
  } else {
    align(right, counter(page).display(numbering))
  }
}

#let _header(oneside: false) = context {
  let next = query(selector(heading.where(level: 1)).after(here()))
  if next.len() > 0 and next.first().location().page() == here().page() {
    return
  }

  let prev = query(selector(heading.where(level: 1)).before(here()))
  if prev.len() > 0 {
    let h = prev.last()
    let marker = if counter(heading).get().first() == 0 {
      h.body
    } else {
      [#counter(heading).display() #h.body]
    }

    if oneside {
      align(center, marker)
    } else if calc.even(counter(page).get().first()) {
      align(left, marker)
    } else {
      align(right, marker)
    }
    v(-0.75em)
    line(length: 100%, stroke: 0.3pt)
  }
}

#let _identifier-text(
  kind,
  isbn,
  phd-series-number,
  technical-report-number,
  lic-issn,
  phd-issn,
) = {
  if kind == "phd" {
    [
      ISBN #isbn\
      Doktorsavhandlingar vid Chalmers tekniska högskola, Ny serie nr #phd-series-number.\
      ISSN #phd-issn\
      Technical Report No. #technical-report-number\
      #v(1.5cm)
    ]
  } else {
    [
      ISSN #lic-issn\
    ]
  }
}

#let _paper-label(n) = numbering("I", n)

#let paper(
  title,
  authors,
  venue,
  doi: none,
  pdf: none,
  pages: (),
  appended: true,
  contribution: none,
) = (
  title: title,
  authors: authors,
  venue: venue,
  doi: doi,
  pdf: pdf,
  pages: pages,
  appended: appended,
  contribution: contribution,
)

#let _publication-item(idx, publication) = [
  #publication.authors,\
  #emph(publication.title)\
  #publication.venue.
]

#let _publication-list(publications) = {
  let appended = publications.filter(p => p.appended)
  let other = publications.filter(p => not p.appended)

  heading(level: 1, numbering: none, outlined: false)[List of Publications]
  heading(level: 2, numbering: none, outlined: false)[Appended publications]
  [This thesis is based on the following publications:]

  enum(
    ..appended.enumerate().map(((i, p)) => _publication-item(i + 1, p)),
    numbering: n => [*Paper #_paper-label(n)*],
  )

  if other.len() > 0 {
    pagebreak()
    heading(level: 2, numbering: none, outlined: false)[Other publications]
    [
      The following publications were published during my PhD studies, or are currently in submission or revision.
      They are not appended to this thesis.
    ]
    enum(
      ..other.map(p => [#p.authors, #emph(p.title)\ #p.venue.]),
      numbering: "a",
    )
  }
}

#let _abstract-page(title, subtitle, author, department, school, abstract, keywords) = {
  align(left)[
    #text(size: 12pt, weight: "bold")[#title]\
    #if subtitle != none {
      text(size: 9pt, style: "italic")[#subtitle]
      linebreak()
    }
    #smallcaps(author)\
    #v(1mm)
    #emph(department)\
    #emph(_school-line(school))
  ]

  v(8mm)
  heading(level: 1, numbering: none, outlined: false)[Abstract]
  abstract

  if keywords.len() > 0 {
    v(10mm)
    text(weight: "bold")[Keywords]
    v(3mm)
    keywords.join(", ")
  }
}

#let _first-page(
  degree-title,
  kind,
  year,
  title,
  subtitle,
  author,
  department,
  division,
  research-group,
  school,
  city,
  address,
  isbn,
  phd-series-number,
  technical-report-number,
  lic-issn,
  phd-issn,
) = {
  set page(header: none, footer: none)
  align(center)[#smallcaps[Thesis for the Degree of #degree-title]]

  v(4cm)
  align(center)[
    #text(size: 17pt, weight: "bold")[#title]
    #_subtitle-line(subtitle, size: 12pt)
  ]

  v(if subtitle == none { 5mm } else { 2mm })
  align(center)[#smallcaps(text(size: 12pt)[#author])]

  v(1fr)
  align(center)[
    #emph(department)\
    #smallcaps(_school-line(school))\
    #city, #year
  ]

  pagebreak()

  v(2cm)
  align(left)[
    #text(weight: "bold")[#title]\
    #if subtitle != none {
      text(size: 9pt, style: "italic")[#subtitle]
      linebreak()
    }
    #smallcaps(author)
  ]

  v(0.5cm)
  [#sym.copyright #author, #year\ except where otherwise stated.\ All rights reserved.]

  v(1fr)
  _identifier-text(
    kind,
    isbn,
    phd-series-number,
    technical-report-number,
    lic-issn,
    phd-issn,
  )

  [
    #department\
    Division of #division\
    #if research-group != none { [#research-group #linebreak()] }
    #_school-line(school)\
    #address\
    Phone: +46(0)31 772 1000
  ]

  v(1.5cm)
  [Printed by Chalmers Digitaltryck,\ Gothenburg, Sweden #year.]
}

#let _frontmatter(
  degree-title,
  kind,
  year,
  title,
  subtitle,
  author,
  department,
  division,
  research-group,
  school,
  city,
  address,
  isbn,
  phd-series-number,
  technical-report-number,
  lic-issn,
  phd-issn,
  dedication,
  abstract,
  keywords,
  publications,
  authorship-statement,
  acknowledgements,
  include-publication-list,
  oneside,
) = {
  _first-page(
    degree-title,
    kind,
    year,
    title,
    subtitle,
    author,
    department,
    division,
    research-group,
    school,
    city,
    address,
    isbn,
    phd-series-number,
    technical-report-number,
    lic-issn,
    phd-issn,
  )

  counter(page).update(1)
  set page(numbering: "i", footer: context align(center, counter(page).display("i")))
  pagebreak()

  if dedication != none {
    dedication
    pagebreak()
  }

  _abstract-page(title, subtitle, author, department, school, abstract, keywords)
  pagebreak()

  if include-publication-list and publications.len() > 0 {
    _publication-list(publications)
    pagebreak()
  }

  if authorship-statement != none {
    heading(level: 1, numbering: none, outlined: false)[Authorship Statement]
    authorship-statement
    pagebreak()
  }

  heading(level: 1, numbering: none, outlined: false)[Acknowledgment]
  acknowledgements
  pagebreak()

  outline(title: [Contents], depth: 3)
  pagebreak()
}

#let thesis-part(title, oneside: false) = {
  _pagebreak-next(oneside: oneside)
  set page(header: none, footer: none)
  align(center)[
    #v(40%)
    #text(size: 24pt, weight: "regular")[#title]
  ]
  _pagebreak-next(oneside: oneside)
}

#let bibliography-section(path, style: "ieee", title: "Bibliography", oneside: false) = {
  _pagebreak-next(oneside: oneside)
  heading(level: 1, numbering: none)[#title]
  bibliography(path, style: style, title: none)
}

#let doctoral-template(
  kind: "phd",
  font: "Libertinus Serif",
  heading-font: "Libertinus Serif",
  degree-type: "philosophy",
  date: datetime.today(),
  title: "A Thesis on Computer Science",
  subtitle: none,
  author: "Anders Andersson",
  department: default-department,
  division: "Software Engineering",
  research-group: none,
  school: default-school,
  city: "Gothenburg, Sweden",
  address: default-address,
  isbn: "xxx-xx-xxxx-xxx-x",
  phd-series-number: "xxxx",
  technical-report-number: "XXXX",
  lic-issn: "1652-876X",
  phd-issn: "0346-718X",
  dedication: none,
  abstract: [The abstract of the thesis.],
  keywords: (),
  publications: (),
  authorship-statement: none,
  acknowledgements: [Acknowledgements.],
  include-publication-list: true,
  figures: false,
  tables: false,
  oneside: false,
  draft: false,
  content,
) = {
  let year = date.year()
  let degree-title = _degree-title(kind, degree-type)

  set document(
    title: title,
    author: author,
    keywords: keywords,
  )

  set page(
    width: 169mm,
    height: 239mm,
    margin: (inside: 28mm, outside: 22mm, top: 22mm, bottom: 18mm),
    numbering: "i",
    header: none,
    footer: none,
  )
  set text(font: font, size: 10pt, lang: "en")
  set par(justify: true, leading: 0.62em)
  set heading(supplement: [Chapter])
  set heading(numbering: "1.1")
  show heading: set text(font: heading-font, weight: "semibold")
  show heading.where(level: 1): set text(size: 20pt)
  show heading.where(level: 2): set text(size: 14pt)
  show heading.where(level: 3): set text(size: 11pt)
  show link: set text(fill: link-blue)
  show cite: set text(fill: link-blue)
  show ref: set text(fill: link-blue)

  if draft {
    show image: it => block(
      width: 100%,
      inset: 8pt,
      stroke: (paint: gray, thickness: 0.7pt, dash: "dashed"),
      fill: luma(96%),
      [DRAFT IMAGE PLACEHOLDER],
    )
  }

  _frontmatter(
    degree-title,
    kind,
    year,
    title,
    subtitle,
    author,
    department,
    division,
    research-group,
    school,
    city,
    address,
    isbn,
    phd-series-number,
    technical-report-number,
    lic-issn,
    phd-issn,
    dedication,
    abstract,
    keywords,
    publications,
    authorship-statement,
    acknowledgements,
    include-publication-list,
    oneside,
  )

  show heading.where(level: 1): it => {
    _pagebreak-next(oneside: oneside, weak: true)
    align(center)[
      #v(38pt)
      #text(size: 42pt, weight: "regular")[#counter(heading).display()]
      #v(-22pt)
      #text(size: 20pt)[#it.body]
      #v(24pt)
    ]
  }

  show figure.where(kind: table): set figure.caption(position: top)
  show figure.caption: it => block[
    #text(weight: "bold")[#it.supplement #context it.counter.display(it.numbering):]
    #h(0.35em)
    #it.body
  ]

  thesis-part("Summary", oneside: oneside)
  set page(
    width: 169mm,
    height: 239mm,
    margin: (inside: 28mm, outside: 22mm, top: 22mm, bottom: 18mm),
    numbering: "1",
    footer: _footer(numbering: "1", oneside: oneside),
    header: _header(oneside: oneside),
    header-ascent: 10%,
  )
  counter(page).update(1)
  counter(heading).update(0)

  content
}

#let paper-divider(idx, paper, oneside: false) = {
  _pagebreak-next(oneside: oneside)
  set page(header: none, footer: none)
  align(right)[#text(size: 15pt, weight: "bold")[Paper #_paper-label(idx)]]
  v(1fr)
  align(center)[
    #text(size: 15pt, weight: "bold")[#paper.title]\
    #v(0.5cm)
    #paper.authors\
    #v(0.5cm)
    #paper.venue
  ]
  v(1fr)
  if paper.doi != none {
    paper.doi
  }
}

#let _include-pdf-pages(pdf, pages, idx) = {
  for page-number in pages {
    pagebreak()
    set page(
      margin: 0pt,
      header: none,
      footer: context align(center, [#counter(page).display("1") (#_paper-label(idx))]),
    )
    align(center + horizon, image(pdf, page: page-number, width: 100%, height: 100%, fit: "contain"))
    counter(page).step()
  }
}

#let appended-papers(papers, oneside: false, include-pdfs: true) = {
  _pagebreak-next(oneside: oneside)
  set page(header: none, footer: none)
  align(center)[
    #v(40%)
    #text(size: 24pt)[Appended Papers]
  ]

  let idx = 0
  for p in papers {
    if p.appended {
      idx += 1
      counter(page).update(1)
      counter(heading).update(0)
      counter(figure.where(kind: image)).update(0)
      counter(figure.where(kind: table)).update(0)
      counter(math.equation).update(0)
      paper-divider(idx, p, oneside: oneside)
      if include-pdfs and p.pdf != none and p.pages.len() > 0 {
        counter(page).update(1)
        _include-pdf-pages(p.pdf, p.pages, idx)
      }
    }
  }
}

#let presentation-sheet(
  font: "Libertinus Serif",
  kind: "phd",
  degree-type: "philosophy",
  date: datetime.today(),
  title: "A Thesis on Computer Science",
  subtitle: none,
  author: "Anders Andersson",
  department: default-department,
  division: "Software Engineering",
  school: default-school,
  city: "Gothenburg, Sweden",
  room: [Room 520, Jupiter Building\ Horselgangen 5,\ Chalmers University of Technology, Campus Lindholmen],
  seminar-date: [February 29th, 2018, 13:30],
  discussion-leader: [Prof. Peter Pan\ Excellent University, United States of America],
  abstract: [The abstract of the thesis.],
  keywords: (),
) = {
  set document(title: title, author: author)
  set page(width: 148mm, height: 210mm, margin: (left: 25mm, right: 25mm, top: 22mm, bottom: 18mm), header: none, footer: none)
  set text(font: font, size: 10pt, lang: "en")

  v(18mm)
  align(center)[
    #text(size: 17pt, weight: "bold")[#title]
    #_subtitle-line(subtitle, size: 12pt)
  ]
  v(5mm)
  align(center)[#smallcaps(text(size: 12pt)[#author])]
  v(5mm)
  align(center)[
    #emph[The seminar will be held in]\
    #v(2mm)
    #room\
    #v(1mm)
    #emph[on]\
    #v(1mm)
    #seminar-date\
    #v(1cm)
    Discussion leader:\
    #discussion-leader
  ]

  v(1cm)
  align(center)[
    The thesis is available at:\
    #department\
    #_school-line(school)\
    #city, #date.year()\
    #v(1cm)
    Phone: +46 (0)31 772 1000
  ]

  v(1fr)
  align(center, image("img/logos-horizontal.svg", width: 95mm))

  pagebreak()
  _abstract-page(title, subtitle, author, department, school, abstract, keywords)
}

#let erratum(location, before, after) = (
  location: location,
  before: before,
  after: after,
)

#let errata(
  font: "Libertinus Serif",
  date: datetime.today(),
  title: "A Thesis on Computer Science",
  subtitle: none,
  author: "Anders Andersson",
  department: default-department,
  division: "Software Engineering",
  school: default-school,
  city: "Gothenburg, Sweden",
  entries: (),
) = {
  set document(title: title, author: author)
  set page(width: 169mm, height: 239mm, margin: (inside: 28mm, outside: 22mm, top: 22mm, bottom: 18mm), header: none, footer: none)
  set text(font: font, size: 10pt, lang: "en")

  align(center)[
    #text(size: 17pt)[#title]\
    #if subtitle != none { text(size: 9pt, style: "italic")[#subtitle] }
    #v(5mm)
    #smallcaps(text(size: 12pt)[#author])
  ]

  [
    #department\
    Division of #division\
    #_school-line(school, sep: [ and ])\
    #city, #date.year()
  ]

  heading(level: 1, numbering: none, outlined: false)[Errata]
  v(3cm)

  for entry in entries [
    #entry.location:\
    #h(16pt)#entry.before\
    #h(16pt)#sym.arrow.r #h(0.5em)#entry.after
    #v(2mm)
  ]
}
