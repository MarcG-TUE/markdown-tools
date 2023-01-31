---
macros:
  Nats: "\\mathbb{N}"
  var: p
...

# Title

This is an example document.

Some math and macro definitions:
For all ${{var}}\in{{Nats}}$

A lemma and a theorem with cross referencing

::::: {.lemma label="lem:something"}
This is an example lemma.
:::::

::::: {.theorem label="thm:athm"}
This is an example theorem using Lemma @lem:something.
:::::

A figure.

![Example Image](figures/example.png){.inline scale=0.25}

A table:

 A   B
--- ---
 0   1
 2   3
 4   5

This is a reference: [@Nor12]

<!-- markdownlint-disable-file MD041 MD035 -->