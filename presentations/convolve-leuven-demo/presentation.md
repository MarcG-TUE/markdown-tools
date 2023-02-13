---
title-slide-attributes:
    background: convolve-title.html
slide-attributes:
    background: convolve-content.html
include-css: [
  "./styles/convolve.css"
  ]
macros:
  Nats: "\\mathbb{N}"
  Rationals: "\\mathbb{Q}"
  "actorname#1": "\\textsf{#1}"
  "mi": "{-\\infty}"
  period: "\\mu{}"
  "mpmatrix#1": "{\\textbf{#1}}"
  ri: "\\textbf{A}_{\\mathit{ri}}"
  cm: "\\textbf{A}_{\\mathit{cm}}"
  ro: "\\textbf{A}_{\\mathit{ro}}"
---

# Dataflow Performance Modeling Tutorial {.title}

Marc Geilen

Electronic Systems, Dept. Electrical Engineering,\
Eindhoven university of Technology

[m.c.w.geilen@tue.nl](m.c.w.geilen@tue.nl)

# Context & Objectives

WP6, compositional analysis methods for design space exploration

- Analysis techniques to assess performance of a proposed mapping
- Feedback about bottlenecks or critical paths
  - to support exploration

# Dataflow Models

- [**Dataflow**]{.hl-olive}: model of activities and dependencies

::: {.center}
![](./figures/dataflow.svg){.zoom-image style="width: 70%;"}
:::

# Example

::: {.center}
![](./figures/accelerator.svg){ .zoom-image}
![](./figures/dataflow-accelerator.svg){ .zoom-image}
:::

# Gantt chart (1)

- Maximum throughput ASAP execution

![](./figures/gantt-max-throughput.svg){ .zoom-image style="width:100%;"}

# Gantt chart (2)

- Input dependencies

![](./figures/gantt-irregular-input.svg){ .zoom-image style="width:100%;"}

# Gantt chart (3)

- Buffer capacity bottleneck

![](./figures/gantt-buffer-bottleneck.svg){ .zoom-image style="width:100%;"}


# Max-plus Algebra

- a [**linear algebra**]{.hl-olive} for logistics
  $$x \oplus y \otimes z = \max(x, y+z)$$
- Including [**matrix-vector calculus**]{.hl-olive}
- [**Linear system**]{.hl-olive} with state matrix
  $$
  A =
  \begin{pmatrix}
  2      & {{mi}} & 2      & {{mi}} & {{mi}} & {{mi}} \\
  8      & 2      & 8      & {{mi}} & {{mi}} & {{mi}} \\
  {{mi}} & {{mi}} & {{mi}} & 0      & {{mi}} & {{mi}} \\
  {{mi}} & {{mi}} & {{mi}} & {{mi}} & 0      & {{mi}} \\
  {{mi}} & {{mi}} & {{mi}} & {{mi}} & {{mi}} & 0      \\
  10     & 4      & 10     & {{mi}} & {{mi}} & {{mi}} \\
  \end{pmatrix}
  $$

# Performance analysis

- [**Throughput**]{.hl-olive} is $\frac{1}{\lambda}$ iff $\lambda$ is the [**largest eigenvalue**]{.hl-olive} of the matrix
- [**Latency**]{.hl-olive} can be computed from state space matrices
  $$\Lambda= {{mpmatrix{C}}} {\left( {-{{period}}}\otimes{}{{mpmatrix{A}}}\right)}^* {{mpmatrix{B}}} \oplus {{mpmatrix{D}}}$$

- Throughput (with buffer size 4) is $\frac{2}{5}$
- Latency for $i_A\rightarrow{}o$ is $10$
- Latency for $i_B\rightarrow{}o$ is $4$

# Analysis

- Analysis provides performance numbers
- Models allow (automatic) exploration of [**trade-offs**]{.hl-olive} between [**resource allocation**]{.hl-olive} and [**performance**]{.hl-olive}
  - e.g., buffer size vs throughput

- feedback about performance bottleneck may provide guidance for design-space exploration.

# Scaling and Dynamism

:::: {.columns}
::: {.column width="50%"}

- we need to go to millions (?) of neurons
- multi-rate
- varying delays
- modes / scenarios


 mode   rd   ii   l    wr
------ ---- ---- ---- ----
 ri     2    2    0    0
 cm     2    4    5    2
 ro     0    3    4    2

:::
::: {.column width="50%"}

![](./figures/cm.svg){ .zoom-image}
![](./figures/filter.svg){ .zoom-image style="width: 60%;"}
:::
::::

# Gantt chart

$$
ri^6\cdot{}
\left(ri \cdot{}{cm}^6 \cdot{}ro \right)^8
\cdot{}ro^6
$$

![](./figures/trace.svg){ .zoom-image style="width: 90%;"}

# Compositionality

- Computing the overall max-plus matrix is still efficient.

$$
{{ri}}^6
\left({{ri}} {{cm}}^6 {{ro}}\right)^8
{{ro}}^6
$$

- Tracking critical path still possible
- Repetition patterns can be compositionally computed from modules

::: footnote
van der Vlugt, S., Alizadeh Ara, H., de Jong, R. et al. Modeling and Analysis of FPGA Accelerators for Real-Time Streaming Video Processing in the Healthcare Domain. J Sign Process Syst 91, 75–91 (2019). <https://doi.org/10.1007/s11265-018-1414-3>
:::

# Demo

- <http://computationalmodeling.info/cmwb>
- <http://www.es.ele.tue.nl/sdf3>
- <https://github.com/Model-Based-Design-Lab/cmlib>
- <https://computationalmodeling.info/static/mpd/>

<!-- markdownlint-disable-file MD024 MD025 MD041 MD035 MD045 -->
