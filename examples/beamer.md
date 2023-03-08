---
title: Test Presentation
subtitle: It has a subtitle!
lang: de-DE
date: 2023-03-08
author:
  - nzbr
description: This is a test presentation
keywords:
  - test
  - copperflame
  - pandoc
bibliography:
  - example.bib
---

---

#### TS:
```typescript
const f = (a: string | number) => (b: string | number) => {
    return a != b;
}
```
#### Nix
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

---

# Dragons!

:::arson
Hallo!
:::

---

# Umlaute

ÄÖÜß!

---

LaTeX [@latex]

BibTeX [@bibtex]

Both [@latex; @bibtex]
