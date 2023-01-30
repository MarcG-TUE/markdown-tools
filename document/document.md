---
macros:
  MyNats: "\\mathbb{N}"
  myvar: p
...

# Title

This is an example document.

For all ${{myvar}}\in{{MyNats}}$

::::: {.lemma label="lem:something"}
This is an example lemma.
:::::

::::: {.theorem}
This is an example theorem using Lemma @lem:something.
:::::

![Example Image](figures/example.png){.inline scale=0.25}

This is a reference: [@Nor12]


<!-- markdownlint-disable-file MD041 -->