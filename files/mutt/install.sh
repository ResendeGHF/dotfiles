#!/bin/sh
# SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>
# SPDX-License-Identifier: AGPL-3.0-or-later
# Install mutt dotfiles to $HOME. Idempotent, touches only shipped paths.
set -eu
SRC="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
DST="${HOME:?HOME is not set}"
FMODE=644
DMODE=755
cd -- "$SRC"
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
if test -d "$DST/.local/bin"; then
  find "$DST/.local/bin" -type f -exec chmod 755 {} +
fi
printf '%s\n' "mutt: installed to ${DST}."
