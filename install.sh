#!/usr/bin/env bash
# install.sh — setup script for linux_themeings
# Detects distro, installs missing dependencies, and sets up configs.

set -e

REPO_DIR="$(pwd)"
CONFIG_DIR="$HOME/.config"
ASK_CONFIRM=true

# --- Parse arguments ---
for arg in "$@"; do
    case $arg in
        --auto)
            ASK_CONFIRM=false
            ;;
    esac
done

# --- Required programs ---
REQUIRED_PKGS=(hyprland waybar kitty fastfetch zsh)

# --- Detect Linux distro ---
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    else
        DISTRO="unknown"
    fi
}

# --- Detect package manager ---
detect_pkgmgr() {
    case "$DISTRO" in
        arch|endeavouros|manjaro)
            PKG_INSTALL="sudo pacman -S --needed"
            ;;
        debian|ubuntu|pop)
            PKG_INSTALL="sudo apt install -y"
            ;;
        fedora)
            PKG_INSTALL="sudo dnf install -y"
            ;;
        opensuse*|tumbleweed)
            PKG_INSTALL="sudo zypper install -y"
            ;;
        *)
            PKG_INSTALL=""
            ;;
    esac
}

# --- Check and install dependencies ---
check_dependencies() {
    echo "🔍 Checking dependencies..."
    MISSING=()
    for pkg in "${REQUIRED_PKGS[@]}"; do
        if ! command -v "$pkg" &>/dev/null; then
            MISSING+=("$pkg")
        fi
    done

    if [ ${#MISSING[@]} -eq 0 ]; then
        echo "✅ All required programs are installed!"
    else
        echo "⚠️ Missing programs:"
        printf '   - %s\n' "${MISSING[@]}"

        if [ -n "$PKG_INSTALL" ]; then
            if $ASK_CONFIRM; then
                read -rp "Install them now? (y/N): " reply
                if [[ "$reply" =~ ^[Yy]$ ]]; then
                    echo "📦 Installing missing dependencies..."
                    $PKG_INSTALL "${MISSING[@]}"
                else
                    echo "Skipping installation."
                fi
            else
                echo "📦 Installing missing dependencies (no prompt)..."
                $PKG_INSTALL "${MISSING[@]}"
            fi
        else
            echo "⚠️ Could not detect package manager — please install manually."
        fi
    fi
}

# --- Copy configs safely ---
copy_config() {
    local name="$1"
    local src="$REPO_DIR/$name"
    local dest="$CONFIG_DIR/$name"

    if [ -d "$dest" ]; then
        echo "📦 Backing up existing $name → $dest.bak"
        mv "$dest" "$dest.bak"
    fi

    echo "📁 Copying $name → $CONFIG_DIR/"
    mkdir -p "$CONFIG_DIR"
    cp -r "$src" "$dest"
}

# --- Copy .zshrc ---
copy_zshrc() {
    local src="$REPO_DIR/.zshrc"
    local dest="$HOME/.zshrc"

    if [ -f "$dest" ]; then
        echo "📦 Backing up existing .zshrc → ~/.zshrc.bak"
        mv "$dest" "$dest.bak"
    fi

    echo "📁 Copying .zshrc → $HOME/"
    cp "$src" "$dest"
}

# --- Main ---
echo "🎨 Setting up linux_themeings..."
detect_distro
detect_pkgmgr

echo "💻 Detected distro: ${DISTRO:-unknown}"
[ -z "$PKG_INSTALL" ] && echo "⚠️ Package manager not recognized — skipping installs."

check_dependencies

copy_config "fastfetch"
copy_config "hypr"
copy_config "kitty"
copy_config "waybar"
copy_zshrc

echo
echo "✅ Setup complete!"
echo "Your configs are now in ~/.config and .zshrc is in your home directory."
echo "Restart your shell or run 'source ~/.zshrc' to enable theme switching."
