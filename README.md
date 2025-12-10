# 🚀 SARBS Dotfiles

**Suckless Auto-Rice Bootstrapping Scripts - Konfigurationsdateien**

> **🔄 Umzug zu Codeberg**: Die aktive Entwicklung und Kollaboration findet jetzt auf [Codeberg](https://codeberg.org/Sergius/dotfiles) statt. GitHub dient nur als Mirror.
> 
> **📦 Hauptprojekt**: [SARBS](https://codeberg.org/Sergius/SARBS) hier zur [Homepage](https://sarbs.xyz/sarbs/)

Minimalistische Linux-Desktop-Umgebung auf Suckless-Basis mit automatischem Tiling Window Management.

## 🎯 Kernkomponenten

- **dwm** - Dynamic Window Manager [auf Codeberg,](https://codeberg.org/Sergius/DWM) [auf GitHub](https://github.com/Sergi-us/dwm)
- **st** - Simple Terminal [auf Codeberg,](https://codeberg.org/Sergius/st) [auf GitHub](https://github.com/Sergi-us/st)
- **lf** - Terminal File Manager
- **zsh** - Shell mit [Konfiguration](.config/zsh/README.md)
- **neovim** - Editor mit [Lua-Setup](.config/nvim/README.md)
- **pywal** - Dynamische Farbschemata
- **rmpc** - MPD Client mit Cava-Visualisierung

## 📁 Repository-Struktur

```bash
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
git clone https://codeberg.org/Sergius/dotfiles.git
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
# Fork für eigene Änderungen (auf Codeberg)
git clone https://codeberg.org/Dein-Username/dotfiles.git ~/.dotfiles
dotfiles-home
```

**Tipp**: Alle Skripte und Konfigurationsdateien enthalten ausführliche Kommentare zur Funktionsweise und Anpassung.

## 📚 Weitere Ressourcen

- **[SARBS Hauptprojekt](https://codeberg.org/Sergius/SARBS)** - Auto-Rice Bootstrapping Scripts
- **[dwm Build](https://codeberg.org/Sergius/DWM)** - Angepasster Window Manager
- **[st Build](https://codeberg.org/Sergius/st)** - Terminal-Konfiguration
- **[dmenu Build](https://github.com/Sergi-us/dmenu)** - Application Launcher

## 🤝 Credits & Inspiration

- **[Luke Smith](https://github.com/LukeSmithxyz)** - Ursprüngliche LARBS-Inspiration
- **[Suckless Software](https://suckless.org/)** - Minimalistische Software-Philosophie
- **[dotfiles.github.io](https://dotfiles.github.io/)** - Dotfiles Best Practices

## 📄 Lizenz

Diese Konfiguration ist unter der [MIT Lizenz](LICENSE) verfügbar...

---

**📧 Kontakt**:
- [Codeberg Issues](https://codeberg.org/Sergius/dotfiles/issues) für Fragen und Feedback
- [GitHub Issues](https://github.com/Sergi-us/dotfiles/issues) (Mirror)
- [Sarbs Homepage/Kontakt](https://sarbs.xyz/kontakt/)
