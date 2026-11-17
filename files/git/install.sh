#!/bin/sh
# SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>
# SPDX-License-Identifier: AGPL-3.0-or-later
# Install git dotfiles to $HOME. Idempotent, touches only shipped paths.
set -eu
SRC="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
DST="${HOME:?HOME is not set}"
FMODE=644
DMODE=700
cd -- "$SRC"
# shellcheck disable=SC2016
find . -mindepth 1 \( -type d -o -type f -o -type l \) \
  ! -path './install.sh' ! -name 'install.sh' -print | sort | \
while IFS= read -r p; do
  src="${SRC}/${p#./}"
  dst="${DST}/${p#./}"
  if test -L "$src"; then
    mkdir -p -- "$(dirname -- "$dst")"
    cp -af -- "$src" "$dst"
  elif test -d "$src"; then
    if test ! -d "$dst"; then
      mkdir -p -- "$dst"
      chmod "$DMODE" -- "$dst"
    fi
  else
    mkdir -p -- "$(dirname -- "$dst")"
    cp -af -- "$src" "$dst"
    chmod "$FMODE" -- "$dst"
  fi
done
for d in "$DST/.local/bin" "$DST/.config/git/template/hooks" \
  "$DST/.config/git/shell"; do
  test -d "$d" || continue
  find "$d" -type f -exec chmod 755 {} +
done
printf '%s\n' "git: installed to ${DST}."
