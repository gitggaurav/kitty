# Kitty Terminal Config

Minimal, modern Kitty configuration for Linux and macOS. Features Agave Nerd Font with a custom warm color scheme.

## Features

- Clean powerline tabs with slanted style
- Smooth cursor trail animation
- Interactive scrollbar
- Vim/Nano friendly mouse bindings
- 98% background opacity
- Optimized performance settings

## Installation

### Single Command Installer

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/gitggaurav/kitty/main/install.sh)
```

The installer will:
1. Detect your operating system
2. Install Kitty terminal
3. Download and install Agave Nerd Font
4. Set up the configuration file

### Manual Installation

**Install Kitty:**

```bash
# Arch Linux
sudo pacman -S kitty

# Ubuntu/Debian
sudo apt install kitty

# Fedora
sudo dnf install kitty

# RHEL/CentOS
sudo yum install kitty

# macOS
brew install kitty
```

**Install ComicShannsMono Nerd Font:**

```bash
# Linux
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/ComicShannsMono.zip
fc-cache -f

# macOS
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/ComicShannsMono.zip
unzip ComicShannsMono.zip -d ~/Library/Fonts/
```

**Install Config:**

```bash
mkdir -p ~/.config/kitty
curl -o ~/.config/kitty/kitty.conf https://raw.githubusercontent.com/gitggaurav/kitty/main/kitty.conf
```

## Color Scheme

Custom warm palette with dark background (`#181c27`) and muted earth tones. Cursor highlights in soft blue.

## Requirements

- Kitty terminal emulator
- Agave Nerd Font or any Nerd Font
- Linux or macOS

## License

MIT
