---
title: Test Presentation
subtitle: A demonstation of the copperflame beamer theme
lang: en-US
date: \DTMDate{2023-03-20}
author: [ nzbr ]
institute: An Institute
description: This is a test presentation
keywords: [test, copperflame, pandoc]
bibliography: [ example.bib ]
bibliographystyle: plain
pagenumbers: true
isodate: true
---

\section{Syntax Highlighting}

\subsection{Subsection}

\mksectiontitle

---

# TypeScript:

```typescript
const f = (a: string | number) => (b: string | number) => {
  if (a != b) {
    return "a";
  } else {
    return "b";
  }
}
```

---

# Nix

```nix
{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    nodejs
    nodejs.packages.pnpm
    pandoc
  ];
}
```

----

## YAML

```yaml
# A comment
a: &a
  - "String"
b:
  c: 2
  d:
    - e
    - f: *a
```

----

## Handlebars

```hbs
{{#> Layout lang="en-US" title="Home"}}
  {{#*inline "head"}}
  {{/inline}}
  {{#*inline "content"}}
    <a href="./posts/index.hbs">Posts</a>
    <a href="./legal/index.md">Impressum (Deutsch)</a>
    <a href="./legal/english.md">Impressum (English)</a>
  {{/inline}}
{{/Layout}}
```

----

### JSON

```json
{
  "Alert": {
    "text-color": "#ffffff",
    "background-color": null,
    "bold": true,
    "italic": false,
    "underline": false
  }
}
```

----

## Java

```java
import java.lang.*;

public class Main {
    // Regular comment
    // TODO: Task comment

    /**
     * Prints "Hello World!" to the standard output.
     * @param args command-line arguments (not used)
     */
    @SuppressWarnings("unused")
    public static void main(String[] args) {
        System.out.println("\nHello World!\n");
    }
}
```

----

## C\#

```csharp
public class Main {
    [SuppressWarnings("unused")]
    var x = 10;
    var y = 0xFF;
    public static void main(String[] args) {
        Console.WriteLine(str());
    }
}
```

----

# LaTeX

```latex
\documentclass{article}

\begin{document}
    \title{Hello World!}
    \author{nzbr}
    \date{Today}

    \maketitle


    \section{Introduction}
    Lorem ipsum dolor sit amet, consectetur adipiscing elit.


    \section{Conclusion}
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam
    sagittis, nunc sit amet gravida varius, magna odio ornare mi,
    eget lacinia dolor mauris eu est. Nullam ut nulla in ligula
    vehicula bibendum.
\end{document}
```

----

## Markdown

```markdown
# Hello World!

This is a test.

## Subtitle

This is a test.

### Subsubtitle

This is a test.
```

---

# Lists

- This
- Is
- A
- List
    - two
        - three

---

# Text styles

_emph_

**bold**

~~strikethrough~~

\alert{highlighted}

\textit{italic}

---

# Minipages

:::{.minipage width=0.5}
```latex
Some \LaTeX code
```
:::
:::{.minipage width=0.5}
Some \LaTeX code
:::

:::{.minipage width=0.4}
```latex
$\frac{4}{10}$
```
:::
:::{.minipage width=0.6}
$\frac{4}{10}$
:::

:::{.minipage width=0.9}
```latex
$\frac{9}{10}$
```
:::
:::{.minipage width=0.1}
$\frac{9}{10}$
:::

---

# Dragons!

:::arson
Hallo!
:::

---

# Umlaute ÄÖÜß

ÄÖÜß

---

LaTeX [@latex]

BibTeX [@bibtex]

Both [@latex; @bibtex]

This theme looks awesome! \citationneeded

---

# H1

## H2

### H3

#### H4

##### H5

###### H6

---

> This is a direct quote

---

# TODO

- [x] Syntax highlighting theme
- [x] page numbers
- [x] Bullet points
- [x] Title Slide
- [x] Section Title Slide
- [x] Bibliography colors

Maybe later:

- [ ] Speechbubbles
- [ ] Logo command
