#!/usr/bin/env bash
# ─────────────────────────────────────────────
#  kitty · terminal installer
# ─────────────────────────────────────────────
set -euo pipefail

# ── colors ───────────────────────────────────
R=$'\033[0;31m'   # red
G=$'\033[0;32m'   # green
Y=$'\033[0;33m'   # yellow
B=$'\033[0;34m'   # blue
M=$'\033[0;35m'   # magenta
C=$'\033[0;36m'   # cyan
W=$'\033[1;37m'   # white bold
DIM=$'\033[2m'
BOLD=$'\033[1m'
NC=$'\033[0m'

# ── symbols ──────────────────────────────────
SYM_OK="  ${G}✓${NC}"
SYM_FAIL="  ${R}✗${NC}"
SYM_SKIP="  ${DIM}–${NC}"
SYM_DOT="${DIM}·${NC}"
SYM_ARR="${C}›${NC}"

# ── spinner ──────────────────────────────────
_SPINNER_PID=""
_spinner_frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')

spinner_start() {
  local label="${1:-working}"
  (
    local i=0
    while true; do
      printf "\r  ${C}%s${NC}  %s " "${_spinner_frames[$i]}" "$label"
      i=$(( (i + 1) % ${#_spinner_frames[@]} ))
      sleep 0.08
    done
  ) &
  _SPINNER_PID=$!
  disown "$_SPINNER_PID"
}

spinner_stop() {
  if [[ -n "$_SPINNER_PID" ]]; then
    kill "$_SPINNER_PID" 2>/dev/null
    wait "$_SPINNER_PID" 2>/dev/null || true
    _SPINNER_PID=""
    printf "\r\033[2K"
  fi
}

# trap to clean up spinner on exit
trap 'spinner_stop' EXIT

# ── prompt ───────────────────────────────────
# ask_confirm <question>  →  0 = yes, 1 = no
ask_confirm() {
  local question="$1"
  while true; do
    printf "\n  ${C}?${NC}  ${W}%s${NC}  ${DIM}y/n${NC}  " "$question"
    read -r -n1 key </dev/tty
    echo
    case "$key" in
      y|Y) return 0 ;;
      n|N) return 1 ;;
      *)   printf "      ${DIM}enter y or n${NC}\n" ;;
    esac
  done
}

# ── status line printer ───────────────────────
# status_line <icon> <label> <value>
status_line() {
  local icon="$1" label="$2" value="$3"
  printf "  %s  ${DIM}%-18s${NC}  %s\n" "$icon" "$label" "$value"
}

# ── os detection ─────────────────────────────
detect_os() {
  if [[ "$OSTYPE" == darwin* ]]; then
    OS="macos"
  elif [[ -f /etc/os-release ]]; then
    # shellcheck disable=SC1091
    OS=$(. /etc/os-release && echo "${ID:-unknown}")
  else
    OS="unknown"
  fi
}

# ── header ───────────────────────────────────
clear
printf "\n"
printf "  ${DIM}╭──────────────────────────────────────╮${NC}\n"
printf "  ${DIM}│${NC}  ${C}≋${NC}  ${W}kitty${NC} ${DIM}terminal installer${NC}          ${DIM}│${NC}\n"
printf "  ${DIM}╰──────────────────────────────────────╯${NC}\n"
printf "\n"

# ── step 1: detect system ────────────────────
detect_os

if [[ "$OS" == "unknown" ]]; then
  status_line "$SYM_FAIL" "system" "unsupported OS"
  printf "\n  ${R}Aborted.${NC}\n\n"
  exit 1
fi

status_line "$SYM_OK" "system" "${DIM}${OS}${NC}"

# ── step 2: install kitty ────────────────────
if command -v kitty &>/dev/null; then
  KITTY_VER=$(kitty --version 2>/dev/null | awk '{print $2}')
  status_line "$SYM_OK" "kitty" "${DIM}v${KITTY_VER} — already installed${NC}"
else
  if ask_confirm "kitty not found — install it?"; then
    spinner_start "installing kitty"
    INSTALL_OK=0
    case "$OS" in
      arch|manjaro)    sudo pacman -S --noconfirm kitty &>/dev/null && INSTALL_OK=1 ;;
      ubuntu|debian|linuxmint) sudo apt-get update &>/dev/null && sudo apt-get install -y kitty &>/dev/null && INSTALL_OK=1 ;;
      fedora)          sudo dnf install -y kitty &>/dev/null && INSTALL_OK=1 ;;
      rhel|centos)     sudo yum install -y kitty &>/dev/null && INSTALL_OK=1 ;;
      macos)           brew install kitty &>/dev/null && INSTALL_OK=1 ;;
    esac
    spinner_stop
    if [[ $INSTALL_OK -eq 1 ]]; then
      status_line "$SYM_OK" "kitty" "${DIM}installed${NC}"
    else
      status_line "$SYM_FAIL" "kitty" "install failed"
      printf "\n  ${R}Aborted.${NC}\n\n"
      exit 1
    fi
  else
    status_line "$SYM_FAIL" "kitty" "required — aborting"
    printf "\n  ${R}Aborted.${NC}\n\n"
    exit 1
  fi
fi

# ── step 3: agave nerd font ──────────────────
if ask_confirm "install Agave Nerd Font?"; then
  spinner_start "downloading Agave Nerd Font"

  if [[ "$OS" == "macos" ]]; then
    FONT_DIR="$HOME/Library/Fonts"
  else
    FONT_DIR="$HOME/.local/share/fonts"
  fi

  mkdir -p "$FONT_DIR"
  TMPDIR=$(mktemp -d)

  FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Agave.zip"
  if curl -fsSL "$FONT_URL" -o "$TMPDIR/Agave.zip" 2>/dev/null; then
    unzip -q -o "$TMPDIR/Agave.zip" -d "$FONT_DIR"
    [[ "$OS" != "macos" ]] && fc-cache -f &>/dev/null
    rm -rf "$TMPDIR"
    spinner_stop
    status_line "$SYM_OK" "agave nerd font" "${DIM}installed → ${FONT_DIR}${NC}"
  else
    rm -rf "$TMPDIR"
    spinner_stop
    status_line "$SYM_FAIL" "agave nerd font" "download failed"
    printf "\n  ${R}Aborted.${NC}\n\n"
    exit 1
  fi
else
  status_line "$SYM_SKIP" "agave nerd font" "${DIM}skipped${NC}"
fi

# ── step 4: config ────────────────────────────
if ask_confirm "install kitty config?"; then
  mkdir -p "$HOME/.config/kitty"
  CONF="$HOME/.config/kitty/kitty.conf"

  if [[ -f "$CONF" ]]; then
    BACKUP="${CONF}.bak.$(date +%Y%m%d_%H%M%S)"
    cp "$CONF" "$BACKUP"
    printf "  ${DIM}   backup → %s${NC}\n" "$(basename "$BACKUP")"
  fi

  spinner_start "fetching config"
  CONF_URL="https://raw.githubusercontent.com/gitggaurav/kitty/main/kitty.conf"
  if curl -fsSL "$CONF_URL" -o "$CONF" 2>/dev/null; then
    spinner_stop
    status_line "$SYM_OK" "config" "${DIM}~/.config/kitty/kitty.conf${NC}"
  else
    spinner_stop
    status_line "$SYM_FAIL" "config" "download failed"
    printf "\n  ${R}Aborted.${NC}\n\n"
    exit 1
  fi
else
  status_line "$SYM_SKIP" "config" "${DIM}skipped${NC}"
fi

# ── done ─────────────────────────────────────
printf "\n"
printf "  ${DIM}──────────────────────────────────────────${NC}\n"
printf "  ${G}✓${NC}  ${W}all done${NC}\n"
printf "\n"
printf "  ${SYM_ARR}  run ${C}kitty${NC} to launch\n"
printf "  ${SYM_ARR}  config at ${DIM}~/.config/kitty/kitty.conf${NC}\n"
printf "\n"
