<div align="center">

```
≋  kitty
```

**a minimal terminal configuration**  
*warm colors · nerd fonts · powerline tabs*

</div>

---

### features

```
⠿  powerline tabs       slanted style, clean separators
⠿  cursor trail         smooth animation
⠿  scrollbar            interactive, minimal
⠿  mouse bindings       vim & nano friendly
⠿  opacity              98% — just enough blur
⠿  performance          gpu-accelerated rendering
```

---

### install

**one line**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/gitggaurav/kitty/main/install.sh)
```

detects your OS → installs kitty → installs Agave Nerd Font → drops the config.

<br>

**manual**

<details>
<summary>kitty</summary>

```bash
# arch
sudo pacman -S kitty

# ubuntu / debian
sudo apt install kitty

# fedora
sudo dnf install kitty

# macos
brew install kitty
```

</details>

<details>
<summary>font — ComicShannsMono Nerd Font</summary>

```bash
# linux
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/ComicShannsMono.zip
unzip ComicShannsMono.zip -d ~/.local/share/fonts/
fc-cache -f

# macos
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/ComicShannsMono.zip
unzip ComicShannsMono.zip -d ~/Library/Fonts/
```

</details>

<details>
<summary>config</summary>

```bash
mkdir -p ~/.config/kitty
curl -o ~/.config/kitty/kitty.conf \
  https://raw.githubusercontent.com/gitggaurav/kitty/main/kitty.conf
```

</details>

---

### palette

```
  #181c27   background     dark blue-gray
  #e8d5b0   foreground     warm parchment
  #7a9fc2   cursor         soft blue
  #2a2f3f   selection      muted indigo
```

---

### requirements

- kitty ≥ 0.32
- any [Nerd Font](https://www.nerdfonts.com)
- linux or macos

---

<div align="center">

`MIT` · made with care

</div>
