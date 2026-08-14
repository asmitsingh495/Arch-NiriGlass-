# Arch-NiriGlass-
# 🌌 NiriGlass Desktop Configuration Suite

NiriGlass is an automated terminal-GUI installation framework designed to deploy an elegant, frosted-glass style desktop experience built over the scrollable tiling [Niri Window Manager](https://github.com) on Arch Linux. 

---

## 🚀 Architectural Blueprint

The setup seamlessly provisions and links the following system endpoints:
* **Compositor Engine**: `Niri` (Dynamic infinite-scrolling canvas tiling pipeline)
* **Status Panels**: `Waybar` (Configured transparency levels and systemic telemetry modules)
* **Terminal Interface**: `Alacritty` (Injected transparency styling matrix)
* **Shell Layer**: `Zsh` + `Oh-My-Zsh` (Autosuggestions and modern syntax bindings)
* **Launcher Engine**: `Fuzzel` (Wayland native launcher interface overlays)

---

## 🛠️ Automated Deployment Sequence

To pull down the configuration arrays and synchronize your environment workspace instantly, execute the bootstrap controller sequence:

```bash
git clone https://github.com/asmitsingh495/Arch-NiriGlass-
cd NiriGlass
chmod +x install.sh
./install.sh
```

### 🔒 Deployment Pipeline Safety Logic
1. **Dynamic Dependencies Sync**: Reads selection manifests via an interactive TUI checkpoint panel built on `dialog`.
2. **Conflict Prevention Engine**: Scans existing configurations inside `~/.config/` and maps pre-existing directories into automated, timestamped recovery layers (`~/.config_backup_*`) prior to data injection.
3. **Configuration Mirroring**: Rewrites default system settings with your custom glass UI theme matrices automatically.

---

## 🧑‍💻 Isolation & Nested Profile Testing

To run or debug your configuration structures dynamically without disrupting or affecting your current running display manager (GNOME, Hyprland, KDE), execute a secure nested environment sub-shell directly from your target workstation:

```bash
niri --config ./config/niri/config.kdl
```

---

## 📄 License
Distributed under the terms of the open-source MIT License. Review the accompanying `LICENSE` file for extended validation rules.
