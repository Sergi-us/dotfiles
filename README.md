# 🚀 SARBS Dotfiles

**Suckless Auto-Rice Bootstrapping Scripts - Konfigurationsdateien**

> **📦 Hauptprojekt**: [SARBS](https://github.com/Sergi-us/SARBS)

Minimalistische Linux-Desktop-Umgebung auf Suckless-Basis mit automatischem Tiling Window Management.

## 🎯 Kernkomponenten

- **dwm** - Dynamic Window Manager
- **st** - Simple Terminal  
- **lf** - Terminal File Manager
- **zsh** - Shell mit [Konfiguration](.config/zsh/README.md)
- **neovim** - Editor mit [Lua-Setup](.config/nvim/README.md)
- **pywal** - Dynamische Farbschemata
- **polybar** - Statusleiste mit 30+ Modulen
- **rmpc** - MPD Client mit Cava-Visualisierung

## 📁 Repository-Struktur

```
dotfiles/
├── .config/     # XDG-konforme Anwendungskonfigurationen
│   ├── nvim/    # Neovim-Konfiguration
│   ├── zsh/     # Zsh-Konfigurationsdateien
│   ├── lf/      # lf Dateimanager-Setup
│   └── ...      # Weitere App-Configs
├── .local/      # Lokale Benutzerdateien
│   ├── bin/     # Eigene Skripte und Executables
│   │   ├── cron/    # Cronjob-Skripte
│   │   └── polybar/ # Polybar Module
│   └── share/   # Lokale Daten und Ressourcen
├── .x11/        # X11-bezogene Konfigurationen
└── README.md    # Diese Datei
```

## ⚡ Installation & Updates

### Automatisch mit SARBS (empfohlen)
Die Dotfiles werden durch das [SARBS-Installationsskript](https://github.com/Sergi-us/SARBS) automatisch eingerichtet.

### Manuelles Update
```bash
cd ~/.local/src/dotfiles
git pull
dotfiles-home
```

### Manuelles Setup
```bash
cd ~/.local/src
git clone https://github.com/Sergi-us/dotfiles.git
cd dotfiles
dotfiles-home  # Erstellt Hardlinks zu $HOME
```

**Hinweis**: `dotfiles-home` erstellt Hardlinks und überschreibt bestehende Konfigurationen.

## 🛠️ Features & Anpassungen

### Wichtige Features
- **Cronjob-Verwaltung**: `crontog` zum Ein/Ausschalten aller Cronjobs
- **Hardlink-Management**: `dotfiles-home` für einfache Updates
- **XDG-Konformität**: Alle Konfigurationen folgen Standards
- **Skripte**: Alle `.local/bin/` Skripte enthalten detaillierte Kommentare

### Eigene Anpassungen
```bash
# Fork für eigene Änderungen
git clone https://github.com/Dein-Username/dotfiles.git ~/.dotfiles
dotfiles-home
```

**Tipp**: Alle Skripte und Konfigurationsdateien enthalten ausführliche Kommentare zur Funktionsweise und Anpassung.

## 📚 Weitere Ressourcen

- **[SARBS Hauptprojekt](https://github.com/Sergi-us/SARBS)** - Auto-Rice Bootstrapping Scripts
- **[dwm Build](https://github.com/Sergi-us/dwm)** - Angepasster Window Manager
- **[st Build](https://github.com/Sergi-us/st)** - Terminal-Konfiguration
- **[dmenu Build](https://github.com/Sergi-us/dmenu)** - Application Launcher

## 🤝 Credits & Inspiration

- **[Luke Smith](https://github.com/LukeSmithxyz)** - Ursprüngliche LARBS-Inspiration
- **[Suckless Software](https://suckless.org/)** - Minimalistische Software-Philosophie
- **[dotfiles.github.io](https://dotfiles.github.io/)** - Dotfiles Best Practices

## 📄 Lizenz

Diese Konfiguration ist unter der [MIT Lizenz](LICENSE) verfügbar.

---

**📧 Kontakt**: 
- [GitHub Issues](https://github.com/Sergi-us/dotfiles/issues) für Fragen und Feedback
- [Sarbs Homepage/Kontakt](https://sarbs.xyz/kontakt/)
