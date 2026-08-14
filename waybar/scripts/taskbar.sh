#!/bin/bash

apps=$(niri msg windows | awk -F'"' '/App ID:/ {print $2}')

for app in $apps; do
    case "$app" in
        # Browsers
        firefox) printf " " ;;
        google-chrome|chrome|chromium|brave|vivaldi|opera|microsoft-edge|zen) printf " " ;;

        # Terminals
        kitty|alacritty|Alacritty|wezterm|foot|gnome-terminal|konsole|xfce4-terminal|tilix) printf " " ;;

        # File Managers
        org.gnome.Nautilus|nautilus|thunar|pcmanfm|dolphin|nemo|caja) printf " " ;;

        # Editors / IDEs
        code|Code|codium|VSCodium) printf "󰨞 " ;;
        nvim|vim|emacs|kate|mousepad|gedit) printf "󰈙 " ;;

        # Music
        spotify|Spotify|rhythmbox|cmus|vlc) printf " " ;;

        # Chat
        discord|vesktop) printf " " ;;
        telegram-desktop|TelegramDesktop) printf " " ;;
        Signal) printf "󰭹 " ;;

        # Development
        github-desktop) printf " " ;;
        docker-desktop|docker) printf " " ;;

        # Utilities
        steam) printf " " ;;
        obs) printf "󰐾 " ;;
        gimp) printf " " ;;
        inkscape) printf " " ;;
        blender) printf "󰂫 " ;;
        libreoffice-*) printf "󰏆 " ;;

        # Default
        *) printf "󰣆 " ;;
    esac
done

echo
