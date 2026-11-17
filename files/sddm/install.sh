#!/bin/sh
# SPDX-FileCopyrightText: 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>
# SPDX-License-Identifier: AGPL-3.0-or-later
# Install the suckless SDDM theme to /etc. Requires root for /etc writes.
# User dotfiles are untouched by this component.
set -eu
SRC="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)"
THEME=suckless
THEME_DIR=/etc/sddm/themes/${THEME}
CONF_DIR=/etc/sddm.conf.d
for f in Main.qml theme.conf metadata.desktop; do
  test -f "${SRC}/${f}" || {
    printf '%s\n' "sddm: missing ${SRC}/${f}" >&2
    exit 1
  }
done
if test "$(id -u)" -ne 0; then
  if ! command -v sudo >/dev/null 2>&1; then
    printf '%s\n' "sddm: need root (run as root or install sudo)" >&2
    exit 1
  fi
  SUDO=sudo
else
  SUDO=
fi
if test -z "${SUDO}"; then
  mkdir -p -- "$THEME_DIR" "$CONF_DIR"
  cp -af -- "${SRC}/Main.qml" "${SRC}/theme.conf" \
    "${SRC}/metadata.desktop" "$THEME_DIR/"
  chmod 644 -- "$THEME_DIR/Main.qml" \
    "$THEME_DIR/theme.conf" "$THEME_DIR/metadata.desktop"
  chmod 755 -- "$THEME_DIR"
  printf '%s\n' "[Theme]" "Current=${THEME}" "ThemeDir=/etc/sddm/themes" > \
    "${CONF_DIR}/${THEME}.conf"
  chmod 644 -- "${CONF_DIR}/${THEME}.conf"
else
  sudo mkdir -p -- "$THEME_DIR" "$CONF_DIR"
  sudo cp -af -- "${SRC}/Main.qml" "${SRC}/theme.conf" \
    "${SRC}/metadata.desktop" "$THEME_DIR/"
  sudo chmod 644 -- "$THEME_DIR/Main.qml" \
    "$THEME_DIR/theme.conf" "$THEME_DIR/metadata.desktop"
  sudo chmod 755 -- "$THEME_DIR"
  printf '%s\n' "[Theme]" "Current=${THEME}" "ThemeDir=/etc/sddm/themes" | \
    sudo tee "${CONF_DIR}/${THEME}.conf" >/dev/null
  sudo chmod 644 -- "${CONF_DIR}/${THEME}.conf"
fi
printf '%s\n' "sddm: theme '${THEME}' installed to ${THEME_DIR}."
printf '%s\n' "sddm: test with: sddm-greeter --test-mode --theme ${THEME_DIR}"
