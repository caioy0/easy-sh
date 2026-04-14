# ML4W bashrc loader
# -----------------------------------------------------

# DON'T CHANGE THIS FILE

# You can define your custom configuration by adding
# files in ~/.config/bashrc 
# or by creating a folder ~/.config/bashrc/custom
# with copies of files from ~/.config/bashrc 
# You can also create a .bashrc_custom file in your home directory
# -----------------------------------------------------

# -----------------------------------------------------
# Load modular configuration
# -----------------------------------------------------

DOTFILES="$HOME/dotfiles"

for f in "$DOTFILES/.config/bashrc/"*; do 
    [ -d "$f" ] && continue

    c="${f/.config\/bashrc/.config\/bashrc\/custom}"

    if [ -f "$c" ]; then
        source "$c"
    else
        source "$f"
    fi
done

if [ -f "$DOTFILES/.bashrc_custom" ]; then
    source "$DOTFILES/.bashrc_custom"
fi