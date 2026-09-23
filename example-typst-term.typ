#import "@preview/abbrev:0.2.0": *

#show terms.item: it => {
  // Save the term in the Abbrev state.
  term-def(it.term.text, (short: it.term, long: it.description))

  // Keep the term displayed in its normal Typst format.
  stack(dir: ltr, it, term-entry(
    it.term.text,
    form: "long",
    alt-long: "",
  ))
}

// Dedicated syntax
/ def: Définition

#term-outline()

// Functional syntax
#terms.item([ess], [Essai])

// This won't work with Abbrev.
#terms(
  terms.item([T1], [Term 1]),
  terms.item([T2], [Term 2]),
)
