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

The Rocky Branches logo, icons and design tokens live in `static/brand/` and are served at `/brand/`:

| File | Use |
| --- | --- |
| `mark.svg`, `mark-mono.svg`, `logo.svg` | The mark, a one-colour version, and the mark with the name |
| `favicon.svg`, `favicon-*.png`, `apple-touch-icon.png`, `icon-512.png` | App and browser icons |
| `icons.svg` | Icon sprite: `<svg><use href="/brand/icons.svg#rb-search"/></svg>` |
| `tokens.css` | Colours, type, spacing, radii and layout widths as `--rb-*` variables |

`assets/css/extended/rb-theme.css` maps the tokens onto PaperMod. The other Rocky Branches apps
(rockybranches-auth, rb-assay, rb-road-network) embed the same values, so change `tokens.css` first
and copy the change across.
