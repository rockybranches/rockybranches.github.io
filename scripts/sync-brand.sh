#!/usr/bin/env bash
# Copies the Rocky Branches brand files from a checkout of
# github.com/rockybranches/rb-brand into static/brand/.
# Usage: scripts/sync-brand.sh [path to rb-brand]   (default: ../rb-brand)
set -euo pipefail

src="${1:-../rb-brand}"
dest="$(cd "$(dirname "$0")/.." && pwd)/static/brand"

if [[ ! -f "${src}/tokens.css" ]]; then
    echo "No rb-brand checkout at ${src}" >&2
    exit 1
fi

mkdir -p "${dest}"
cp "${src}/tokens.css" "${src}/icons/icons.svg" "${dest}/"
cp "${src}"/logo/* "${dest}/"
echo "Copied brand files from ${src} to ${dest}"
