#brave
curl -fsS https://dl.brave.com/install.sh | sh

# package tracer install
printf "Install package tracer?"
read -r choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    zsh ./packtracer.sh
fi