# rockybranches.github.io

Rocky Branches organizational website, built with [Hugo](https://gohugo.io) and the [PaperMod](https://github.com/adityatelange/hugo-PaperMod) theme.

## Development

```shell
hugo server --buildDrafts
```

## Build

```shell
hugo --minify
```

## Brand

The logo, icons and design tokens are inherited from [rb-brand](https://github.com/rockybranches/rb-brand), the single
source for Rocky Branches branding. Do not edit them here.

- `static/brand/` holds copies of the rb-brand files, served at `/brand/`. Refresh them with
  `scripts/sync-brand.sh <path to an rb-brand checkout>` (default `../rb-brand`).
- `assets/css/extended/rb-theme.css` maps the rb-brand token values onto PaperMod. If a token
  changes in rb-brand, update the matching value there.
- The header logo in `hugo.toml` and `layouts/partials/rb_mark.html` are inline copies of
  `logo/mark.svg`.
- Copy follows the writing rules in the rb-brand README.
