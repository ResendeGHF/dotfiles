# dotfiles

<!--
SPDX-FileCopyrightText: 2023 - 2025 Benjamin Grande M. S. <ben.grande.b@gmail.com>
SPDX-FileCopyrightText: 2024 seven-beep <ebn@entreparentheses.xyz>

SPDX-License-Identifier: CC-BY-SA-4.0
-->

Dotfiles for Fedora Sway Atomic (Wayland).

## Table of Contents

*   [Description](#description)
*   [Installation](#installation)
    *   [Interactive](#interactive)
    *   [Non-interactive](#non-interactive)
    *   [Per-component](#per-component)
*   [Usage](#usage)
*   [License](#license)

## Description

Configuration and scripts targeting:

*   Usability:
    *   Vi keybindings for application movement
    *   Emacs keybindings for command-line editing
    *   XDG Specification to not clutter $HOME
*   Portability:
    *   POSIX compliant shell code, no network fetches
    *   Drop-in configuration files
    *   Tested on Fedora Sway Atomic (Wayland)
*   Tasks:
    *   GUI: sway, waybar, rofi, swaylock, sddm theme, gtk
    *   SCM: git, tig, git-shell
    *   Keys: gpg, ssh
    *   Networking: curl, urlview, wget, w3m
    *   Productivity: tmux, vim
    *   Shell: sh, bash, zsh, less, dircolors

Principles (suckless): minimal, secure, explicit. Installers only touch
paths they ship, set strict modes (`0600`/`0700` for pgp and ssh,
`0644` plus `0700`/`0755` dirs elsewhere), preserve symlinks, never
follow them for chmod, and back up a differing `~/.ssh/config` instead
of silently overwriting it. No `curl | sh`, no package installation.

## Installation

Installers live per component at `files/<component>/install.sh`.
The global installer at `./install.sh` calls them. Everything installs
to `$HOME`, except `sddm` which installs a system theme to
`/etc/sddm/themes/suckless` and `/etc/sddm.conf.d/` (the only component
that needs root, via `sudo` or a root shell).

### Interactive

With no arguments, `./install.sh` prints a numbered menu and lets you
pick components (empty input installs all):

```sh
./install.sh
```

### Non-interactive

Install everything:

```sh
./install.sh --all
```

Install a subset:

```sh
./install.sh sh git ssh vim sway waybar
```

List components:

```sh
./install.sh --list
```

Note that some files depend on other directories, specially `sh` which
is a base for `bash` and `zsh` but also sets environment variables for
`net` and `vim`. It adds `$HOME/.local/bin` and
`$HOME/.local/bin/$HOSTNAME` to `$PATH`, so install `sh` if you use
any shipped script. `bash` reads modular snippets from `~/.bashrc.d/`
(sourced before `~/.bashrc.local`).

Reload your shell:

```sh
exec $SHELL
```

Reload sway after changing its configuration:

```sh
swaymsg reload
```

You need to logout and login again for some changes to take effect.

### Per-component

Each component is standalone (no shared framework to audit):

```sh
sh files/sh/install.sh
sh files/sway/install.sh
sh files/waybar/install.sh
sh files/sddm/install.sh   # needs root for /etc writes
```

## Usage

The deployment replaces managed files and that is the goal, to make sure
that we have the same configuration on every machine. Support for local
configuration is implemented by including a local file per application;
installers never delete these.

Supported programs and the expected file names in `$HOME`:

*   **bash**: .bashrc.d/ (modular snippets), .bashrc.local
*   **git**:  .gitconfig.local
*   **sh**:   .profile.local, .shrc.local, .config/sh/profile.d/ (.sh suffix)
*   **ssh**:  .ssh/config.d/ (.conf suffix), .ssh/known_hosts.d/ (.host suffix)
*   **tmux**: .tmux.conf.local
*   **vim**:  .vimrc.local
*   **zsh**:  .zshrc.local

## License

This project is [REUSE-compliant](https://reuse.software). It is difficult to
list all licenses and copyrights and keep them up-to-date here.

The easiest way to get the copyright and license of the project with the reuse
tool:

```sh
reuse spdx
```

You can also check these information manually by checking in the file header,
a companion `.license` or in `.reuse/dep5`.
