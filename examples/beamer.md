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

---

## hbs

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

---

### JSON

```json
{
  "Alert": {
      "text-color": "#ffffff",
      "background-color": null,
      "bold": true,
      "italic": false,
      "underline": false
    },
}
```

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

---

# H1

## H2

### H3

#### H4

##### H5

###### H6

---

# TODO

- [x] Basic theme
- [ ] page numbers
