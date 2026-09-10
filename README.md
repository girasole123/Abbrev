# Abbrev

**Abbrev** is a lightweight and language-independent Typst package for defining, using, and organizing abbreviations, glossary terms, symbols, acronyms, and initialisms.

It provides a simple interface for common use cases, while also supporting more advanced uses:

- abbreviations and initialisms;
- acronyms;
- glossary terms;
- chemical, mathematical, and currency symbols;
- custom categories;
- styled short and long forms;
- separate catalogs and outlines for each category;
- customizable headings, separators, fillers, and spacing.

Abbrev does not impose a specific language or terminology system. You can customize headings and definitions to suit English, French, German, and many other languages.

## Installation

### Import from Typst Universe

Add the following import to your Typst document:

```typst
#import "@preview/abbrev:0.2.0": *
```

### Local use

Download `lib.typ` and place it in your document's directory, or in another directory of your choice.

Then import it locally:

```typst
#import "./lib.typ": *
```

## Defining entries

Version 0.2.0 provides specialized definition functions for different types of entries:

| Function | Default category | Intended use |
|----------|------------------|--------------|
| `abbrev-def` | `"abbrev"` | Abbreviations and initialisms |
| `term-def` | `"term"` | Glossary terms |
| `symbol-def` | `"symbol"` | Chemical, mathematical, or currency symbols |
| `acronym-def` | `"acronym"` | Acronyms and initialisms |

Each function accepts a key and either a string or a dictionary containing `short` and `long` forms.

### Abbreviations and initialisms

Define a single abbreviation:

```typst
#abbrev-def("GPU", "Graphics Processing Unit")
```

You can also define several abbreviations at once:

```typst
#abbrev-def((
  "CPU": "Central Processing Unit",
  "XML": "Extensible Markup Language",
))
```

For more control, provide separate short and long forms. The `to-nnbsp` function replaces ordinary spaces with narrow non-breaking spaces. This is useful for abbreviations whose parts should remain together and should not be separated by a line break.

For example:

```typst
#abbrev-def(
  "ie",
  (
    short: to-nnbsp("i. e."),
    long: "id est",
  ),
)

#abbrev-def(
  "etc",
  (
    short: "etc.",
    long: "et cætera",
  ),
)
```

The `short` and `long` values can contain either plain strings or styled Typst content.

### Glossary terms

Use `term-def` for glossary entries:

```typst
#term-def(
  "API",
  "Application Programming Interface",
)
```

Definitions can contain styled content:

```typst
#term-def(
  "Typst",
  (
    short: [#text(
        "Typst",
        size: 1.05em,
        weight: "bold",
        fill: rgb("#239dad"),
      )],
    long: [A *language* for _typesetting_ documents],
  ),
)
```

### Symbols

Use `symbol-def` for chemical, mathematical, or other symbols:

```typst
#symbol-def(
  "H2O",
  (
    short: [H#sub("2")O],
    long: [water],
  ),
)

#symbol-def("NaCl", "sodium chloride")
#symbol-def("$", "Canadian dollar")
#symbol-def("€", "Euro")
```

### Acronyms and initialisms

Use `acronym-def` for acronyms and initialisms:

```typst
#acronym-def(
  "NASA",
  "National Aeronautics and Space Administration",
)

#acronym-def(
  "laser",
  "light amplification by stimulated emission of radiation",
)
```
### Define terms from a CSV or JSON file

Instead of passing two parameters, you can pass a single parameter containing either a string or a path representing a file. The file must be in CSV or JSON format and define your terms and abbreviations.

Because definitions are loaded from a text file, only plain strings are supported. Styled Typst content cannot be used.

- **CSV:** Both terms and definitions must be plain text. Custom `short` and `long` forms are not supported.
- **JSON:** Supports custom `short` and `long` forms, but all values must be plain strings.

Alternatively, you can include a Typst file containing your definitions. This allows the use of styled text in the `short`and `long` fields. When doing so, import `Abbrev` in both your main document and the definitions file.

`abbrevs.csv`:
```CSV
EU,European Union
UK,United Kingdom
```

`acronyms.json`:
```json
{
  "NASA": "National Aeronautics and Space Administration",
  "SCUBA": {
    "short": "Scuba",
    "long": "Self-Contained Underwater Breathing Apparatus"
  }
}
```

`glossary.typ`:
```typst title="file.typ"
#import "@preview/abbrev:0.2.0": *
#term-def((
  "adjective": (short: "Adjective", long: [A word that *modifies* or *describes* a *noun* by naming an attribute.]),
  "noun": (short: [Noun], long: [A word that represents a *person*, *place*, *thing*, or *idea*.])
))
```

`document.typ`:
```typst
#import "@preview/abbrev:0.2.0": *
#abbrev-def("abbrevs.csv")
#acronym-def("acronyms.json")
#include "glossary.typ"
```

## Using entries

### Abbreviations

Use `abbrev` for entries in the default `"abbrev"` category:

```typst
#abbrev("GPU")
```

Output:

> GPU

To display the long form:

```typst
#abbrev("GPU", form: "long")
```

Output:

> Graphics Processing Unit

To display both forms:

```typst
#abbrev("GPU", form: "full")
```

Output:

> Graphics Processing Unit (GPU)

The available forms are:

- `short` — the short form only;
- `long` — the long form only;
- `full` — the long form followed by the short form in parentheses.

### Suffixes

Use `suffix` to add a suffix to both forms. This is useful for plural or grammatical forms:

```typst
#abbrev("CPU", suffix: "s")
```

Output:

> CPUs

The suffix is also applied to the long form:

```typst
#abbrev("CPU", form: "full", suffix: "s")
```

Output:

> Central Processing Units (CPUs)

### Alternative long forms

Use `alt-long` to replace the long form for a particular occurrence:

```typst
#abbrev(
  "GPU",
  form: "long",
  alt-long: [Processeur graphique],
)
```

This is useful when translating a term or using a different grammatical form:

```typst
#abbrev("GPU", form: "full")
```

Output:

> Graphics Processing Unit (GPU)

```typst
#abbrev(
  "GPU",
  form: "long",
  alt-long: [Processeur graphique],
)
```

Output:

> Processeur graphique

The alternative long form only affects that particular use. It does not modify the original definition.

### Glossary terms

Use `term-entry` to reference entries in the `term` category:

```typst
#term-entry("API")
#term-entry("API", form: "long")
#term-entry("API", form: "full")
```

Styled definitions are preserved:

```typst
#term-entry("Typst", form: "full")
```

### Symbols

Use `symbol-entry` to reference entries in the `symbol` category:

```typst
#symbol-entry("H2O")
#symbol-entry("H2O", form: "long")
#symbol-entry("H2O", form: "full")
```

Other examples:

```typst
#symbol-entry("NaCl", form: "full")
#symbol-entry("$", form: "full")
#symbol-entry("€", form: "full")
```

### Acronyms and initialisms

Use `acronym-entry` to reference entries in the `acronym` category:

```typst
#acronym-entry("NASA")
#acronym-entry("NASA", form: "long")
#acronym-entry("laser", form: "full")
```

## Custom categories

You can create your own categories with `add-category`.

For example, define a category for units:

```typst
#add-category("unit", title: "Units")
```

Then define entries in that category:

```typst
#abbrev-def(
  "km",
  "kilometre",
  category: "unit",
)

#abbrev-def(
  "kg",
  "kilogram",
  category: "unit",
)
```

Use the regular `abbrev` function with the `category` parameter:

```typst
#abbrev("km", category: "unit")
#abbrev("kg", form: "long", category: "unit")
#abbrev("km", form: "full", category: "unit")
```

Or make your own function:
```typst
#let unit(
  key,
  form: "short",
  suffix: none,
  alt-long: none,
) = abbrev(
  key,
  category: "unit",
  form: form,
  suffix: suffix,
  alt-long: alt-long,
)
#unit("kg")
```

Custom categories can be used for units, mathematical notation, technical terminology, or any other group of entries.

## Category outlines

Use `abbrev-outline` to generate an outline for a category.

### Abbreviation outline

```typst
#abbrev-outline(
  title: [Abbreviations and initialisms],
  category: "abbrev",
  level: 3,
)
```

### Glossary outline

```typst
#abbrev-outline(
  title: [Glossary],
  category: "term",
  level: 3,
)
```

### Symbol outline

```typst
#abbrev-outline(
  title: [Symbols],
  category: "symbol",
  level: 3,
)
```

### Acronym outline

```typst
#abbrev-outline(
  title: [Acronyms and initialisms],
  category: "acronym",
  level: 3,
)
```

### Custom-category outline

```typst
#abbrev-outline(
  title: [Units],
  category: "unit",
  level: 3,
)
```

Only entries that are used in the document are included in an outline. The page numbers link back to the corresponding occurrences.

## Customizing outlines

The outline supports the following parameters:

| Parameter | Default | Description |
|-----------|---------|-------------|
| `title` | Category `name` (or `category` capitalised, e.g. `[Abbreviations]`) | Heading displayed above the outline. |
| `category` | `"abbrev"` | Category whose entries are listed. |
| `level` | `1` | Heading level. |
| `numbering` | `none` | Heading numbering format (e.g. `"1."`). |
| `outlined` | `false` | Whether the heading appears in the document outline. |
| `empty` | `[No abbreviations used.]` (replace `abbreviations` with other categories) | Message shown when the outline is empty. |
| `fill` | `repeat([.], gap: 0.15em)` | Filler between the long form and page numbers. |
| `gutter` | `auto` | Default spacing between rows and columns (if set to `auto`, defaults to `0.65em`). Overrides any individually specified values of `row-gutter` and `column-gutter`.|
| `row-gutter` | `auto` | Spacing between rows (if set to `auto`, defaults to `0.65em`). |
| `column-gutter` | `auto` | Spacing between columns (if set to `auto`, defaults to `0.65em`). |
| `separator` | `none` | Content inserted after the short form. |

### Custom headings

```typst
#abbrev-outline(
  title: [Liste des abréviations],
  category: "abbrev",
)
```

### Empty outlines

```typst
#abbrev-outline(
  title: [Glossary],
  category: "term",
  empty: [No glossary terms were used.],
)
```

### Separators

Use `separator` to insert content after the short form:

```typst
#abbrev-outline(
  title: [Abbreviations],
  separator: [:],
)
```

For French typography, you may want a non-breaking space before the colon:

```typst
#abbrev-outline(
  title: [Liste des abréviations],
  separator: [~:],
)
```

### Fillers and spacing

The default filler is a series of spaced dots:

```typst
repeat([.], gap: 0.15em)
```

You can replace it with a line:

```typst
#abbrev-outline(
  fill: line(
    length: 100%,
    start: (0%, 0.65em),
  ),
)
```

Set the spacing between rows and columns with `gutter`:

```typst
#abbrev-outline(
  gutter: 1em,
)
```

Or set each value independently:

```typst
#abbrev-outline(
  row-gutter: 0.5em,
  column-gutter: 1em,
)
```

When `gutter`, `row-gutter`, and `column-gutter` are set to `auto`, the spacing defaults to `0.65em`.

## Backward compatibility

The older v0.1.x API remains available:

```typst
#define-abbreviations((
  "GPU": "Graphics Processing Unit",
  "XML": "Extensible Markup Language",
))

#abbreviation-outline(
  title: [Abbreviations],
)

#abbr("GPU", form: "full")
```

This makes it possible to update the package without immediately rewriting existing documents. New documents can use the category-based v0.2.0 API.

## Local compilation

To compile an example using the Typst Universe package:

```bash
typst compile example.typ
```

Make sure the import is:

```typst
#import "@preview/abbrev:0.2.0": *
```

To compile a local copy, place `lib.typ` in the same directory as the example and use:

```typst
#import "./lib.typ": *
```

Then run:

```bash
typst compile example.typ
```

## Examples and compiled PDFs

The repository contains example documents demonstrating both the backward-compatible API (file `example.typ`) and the new v0.2.0 functionality (file `example2.typ`).

To view the compiled PDFs without installing Typst:

1. Open the [Actions page](https://github.com/girasole123/Abbrev/actions).
2. Select a successful compilation workflow run.
3. Scroll down to the **Artifacts** section.
4. Download the `pdf-output` artifact.
5. Extract the downloaded ZIP file to access the PDFs generated from the examples.

The artifact is a ZIP archive containing the PDFs produced by the GitHub Actions compilation workflow.

## License

Abbrev is distributed under the GPL-3.0-or-later license.
