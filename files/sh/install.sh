#!/bin/sh
# SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>
# SPDX-License-Identifier: AGPL-3.0-or-later
# Install sh dotfiles to $HOME. Idempotent, touches only shipped paths.
# Provides modular ~/.bashrc.d/ sourced by ~/.config/bash/bashrc.
set -eu
SRC="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
DST="${HOME:?HOME is not set}"
FMODE=644
DMODE=700
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
if test -f "$DST/.config/less/lessfilter"; then
  chmod 755 -- "$DST/.config/less/lessfilter"
fi
printf '%s\n' "sh: installed to ${DST}."
