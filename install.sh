#!/bin/sh
# SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>
# SPDX-License-Identifier: AGPL-3.0-or-later
# Install dotfiles on Fedora Sway Atomic. HOME-only, except sddm (/etc).
# Usage: ./install.sh [--all] [--list] [-h|--help] [COMPONENT...]
# With no arguments, shows an interactive numbered menu (POSIX, no deps).
set -eu
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
COMPONENTS="git gtk mutt net pgp rofi sddm sh ssh sway swaylock tmux vim waybar"

usage() {
  printf '%s\n' "Usage: ${0##*/} [--all] [--list] [-h|--help] [COMPONENT...]"
  printf '%s\n' "Example: ${0##*/} --all"
  printf '%s\n' "Example: ${0##*/} sh vim sway"
  printf '%s\n' "Example: ${0##*/}            # interactive menu"
  printf '%s\n' "Components: ${COMPONENTS}"
}

list_components() {
  for c in $COMPONENTS; do
    printf '%s\n' "$c"
  done
}

is_valid() {
  for c in $COMPONENTS; do
    test "$c" = "$1" && return 0
  done
  return 1
}

if test "${1-}" = "-h" || test "${1-}" = "--help"; then
  usage
  exit 0
fi
if test "${1-}" = "--list"; then
  list_components
  exit 0
fi

SELECT=""
for arg in "${@-}"; do
  case "$arg" in
    --all) SELECT="$COMPONENTS"; break ;;
    -*)
      printf '%s\n' "${0##*/}: unknown option '${arg}'" >&2
      usage >&2
      exit 1
      ;;
    *)
      if is_valid "$arg"; then
        SELECT="${SELECT} ${arg}"
      else
        printf '%s\n' "${0##*/}: unknown component '${arg}'" >&2
        printf '%s\n' "Valid: ${COMPONENTS}" >&2
        exit 1
      fi
      ;;
  esac
done

if test $# -eq 0; then
  i=0
  for c in $COMPONENTS; do
    i=$((i + 1))
    printf '%s\n' "  ${i}) ${c}"
  done
  printf '%s' "Select components [1-${i}, e.g. '1 3'] or Enter for all: " >&2
  ans=""
  IFS= read -r ans < /dev/tty || {
    printf '%s\n' "${0##*/}: no input, aborting." >&2
    exit 1
  }
  case "$ans" in
    ""|all|ALL) SELECT="$COMPONENTS" ;;
    *)
      SELECT=""
      for tok in $ans; do
        case "$tok" in
          ""|*[!0-9]*)
            printf '%s\n' "${0##*/}: invalid selection '${tok}'" >&2
            exit 1
            ;;
        esac
        j=0
        match=""
        for c in $COMPONENTS; do
          j=$((j + 1))
          if test "$j" -eq "$tok"; then
            match="$c"
            break
          fi
        done
        if test -z "$match"; then
          printf '%s\n' "${0##*/}: out of range '${tok}'" >&2
          exit 1
        fi
        case " ${SELECT} " in
          *" ${match} "*) ;;
          *) SELECT="${SELECT} ${match}" ;;
        esac
      done
      ;;
  esac
fi

if test -z "$SELECT"; then
  usage >&2
  exit 1
fi

# Deduplicate while preserving order.
DEDUP=""
for c in $SELECT; do
  case " ${DEDUP} " in
    *" ${c} "*) ;;
    *) DEDUP="${DEDUP} ${c}" ;;
  esac
done
SELECT="$DEDUP"

for c in $SELECT; do
  installer="${ROOT}/files/${c}/install.sh"
  if test ! -x "$installer"; then
    printf '%s\n' "${0##*/}: missing installer ${installer}" >&2
    exit 1
  fi
  sh -- "$installer"
done
printf '%s\n' "Done:${SELECT}."
