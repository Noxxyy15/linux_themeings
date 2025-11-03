eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

#nvim for editor in ranger
export EDITOR=nvim
export VISUAL=nvim

#better defaults
alias ls='eza --icons'
alias ll='eza -la --icons'
alias lt='eza --tree --level=2 --icons'
alias neofetch='fastfetch'
alias img='kitty +kitten icat'

# add encrypted notes
alias cryptonote="python3 /home/nox/.cryptonote/cryptonote_cli.py"

#easy move to external hdd
alias goext='cd /run/media/nox/slow-hdd/'

#cli music player
alias music='ncmpcpp'

#see battery %
alias battery%='upower -i $(upower -e | grep BAT) | grep --color=never -E "state|to\\ full|to\\ empty|percentage"'

#easy src
alias src='source ~/.zshrc'

#config edits made easy
alias ezsh='nvim ~/.zshrc'
alias ekitty='nvim ~/.config/kitty/kitty.conf'
alias estarship='nvim ~/.config/starship.toml'
alias ehypr='nvim ~/.config/hypr/hyprland.conf'

#easy move to cong
alias goconf='cd ~/.config'

#pacman things
alias p-update='sudo pacman -Syu'
alias p-install='sudo pacman -S'
alias p-remove='sudo pacman -Rns'
alias p-search='pacman -Ss'
alias p-cleanup='sudo pacman -Rns $(pacman -Qtdq) 2>/dev/null || echo "Nothing to clean"'


# Zsh plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# theme switcher
theme() {
    local theme_dir="$HOME/.config/hypr/themes"
    local current="$theme_dir/current"
    local kitty_theme_link="$HOME/.config/kitty/current-theme.conf"
    local waybar_style_link="$HOME/.config/waybar/style.css"
    local wofi_style_link="$HOME/.config/wofi/style.css"
    
    # If no argument, show current theme
    if [ -z "$1" ]; then
        echo "Current theme: $(readlink -f $current 2>/dev/null | xargs basename)"
        echo "Available themes:"
        ls -1 "$theme_dir" | grep -v "^current$"
        return 0
    fi
    
    local selected="$theme_dir/$1"
    
    # Check if theme exists
    if [ ! -d "$selected" ]; then
        echo "Theme '$1' not found!"
        echo "Available themes:"
        ls -1 "$theme_dir" | grep -v "^current$"
        return 1
    fi
    
    # Switch theme
    rm -rf "$current"
    ln -sf "$selected" "$current"
    
    # Change wallpaper if it exists
    if [ -f "$selected/wallpaper.jpg" ]; then
        swww img "$selected/wallpaper.jpg" --transition-type fade --transition-duration 2
        echo "Changed wallpaper"
    elif [ -f "$selected/wallpaper.png" ]; then
        swww img "$selected/wallpaper.png" --transition-type fade --transition-duration 2
        echo "Changed wallpaper"
    else
        echo "Warning: No wallpaper found for theme $1"
    fi
    
    # Change kitty theme if it exists
    if [ -f "$selected/kitty.conf" ]; then
        rm -f "$kitty_theme_link"
        ln -sf "$selected/kitty.conf" "$kitty_theme_link"
        killall -SIGUSR1 kitty
        echo "Changed kitty theme"
    else
        echo "Warning: No kitty config found for theme $1"
    fi
    
    # Change waybar theme if it exists
    if [ -f "$selected/waybar.css" ]; then
        rm -f "$waybar_style_link"
        ln -sf "$selected/waybar.css" "$waybar_style_link"
        killall -SIGUSR2 waybar
        echo "Changed waybar theme"
    else
        echo "Warning: No waybar style found for theme $1"
    fi
    
    # Change wofi theme if it exists
    if [ -f "$selected/wofi.css" ]; then
        rm -f "$wofi_style_link"
        ln -sf "$selected/wofi.css" "$wofi_style_link"
        echo "Changed wofi theme"
    else
        echo "Warning: No wofi style found for theme $1"
    fi
    
    # Reload Hyprland
    hyprctl reload
    
    echo "Switched to theme: $1"
}
