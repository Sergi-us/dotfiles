# 🚀 SARBS Dotfiles

**Suckless Auto-Rice Bootstrapping Scripts (SARBS) Konfigurationsdateien**

> **📦 Hauptprojekt**: [SARBS - Suckless Auto-Rice Bootstrapping Scripts](https://github.com/Sergi-us/SARBS)

Konfigurationen und Skripte für eine minimalistische, auf Suckless-Software basierende Linux-Desktop-Umgebung mit automatischem Tiling Window Management.

## 📋 Übersicht

Dieses Repository enthält meine Dotfiles für SARBS - ein vollständig konfiguriertes Linux-System, das auf Suckless-Software und minimalistischen Prinzipien basiert. Die Konfiguration bietet eine produktive, aesthetisch ansprechende Desktop-Umgebung mit effizienten Workflows.

### 🎯 Hauptkomponenten

- **🖥️ Window Manager**: dwm (Dynamic Window Manager)
- **🚀 Terminal**: st (Simple Terminal)
- **📁 Dateimanager**: lf (Terminal-basiert)
- **🎨 Themes**: pywal für dynamische Farbschemata
- **🔧 Shell**: [Zsh mit angepasster Konfiguration](.config/zsh/README.md)
- **📝 Editor**: Neovim mit umfangreicher Konfiguration
- **📰 RSS Reader**: Newsboat/Newsraft
- **🎨 UI Styling**: GTK & Qt Themes
- **📚 Dokumentation**: wikiman Integration
- **🖼️ X11**: Angepasste X11-Konfiguration

## 🗂️ Repository-Struktur

```
dotfiles/
├── .config/			# XDG-konforme Anwendungskonfigurationen
│   ├── nvim/			# Neovim-Konfiguration
│   ├── zsh/			# Zsh-Konfigurationsdateien
│   ├── lf/				# lf Dateimanager-Setup
│   ├── newsboat/		# RSS Reader-Konfiguration
│   └── ...				# Weitere App-Configs
├── .local/				# Lokale Benutzerdateien
│   ├── bin/			# Persönliche Skripte und Executables
│   │   ├── cron/		# Cronjob-Skripte und -Verwaltung
│   │   └── ...			# Weitere Skripte
│   └── share/			# Lokale Daten und Ressourcen
├── .x11/				# X11-bezogene Konfigurationen
└── README.md			# Diese Datei
```

## ⚡ Installation & Setup

### Automatische Installation mit SARBS

Die Dotfiles werden automatisch mit dem [SARBS-Installationsskript](https://github.com/Sergi-us/SARBS) installiert. SARBS übernimmt die komplette Systemkonfiguration inklusive aller Abhängigkeiten.

### Manuelle Installation

Für manuelle Updates oder Installation auf bereits bestehenden Systemen:

```bash
cd ~/.local/src
git clone https://github.com/Sergi-us/dotfiles.git
cd ~/dotfiles
./dotfiles-home  # erstellt Hardlinks zu $HOME (ich nutze kein Stow)
```
Für Updates (ignoriert deine Änderungen) wenn du mit Git nicht vertraut bist)
```bash
cd ~/.local/src/dotfiles
git fetch origin
git reset --hard origin/main
dotfiles-home
```

Das `dotfiles-home` Skript erstellt Hardlinks der Konfigurationsdateien in's Home-Verzeichnis und überschreibt die bestehende Konfigurationsdateien.

## 🛠️ Konfiguration

### Cronjob-Verwaltung

Das Repository enthält ein praktisches Skript zur Verwaltung von Cronjobs:

- **`crontog`**: Schaltet alle Cronjobs ein/aus mit sicherer Backup-Funktion
- **Cronjob-Skripte**: In `.local/bin/cron/` organisiert
- **Detaillierte Anleitung**: Siehe [Cron README](.local/bin/cron/README.md)

## 🛠️ Anpassungen

Die gesamte Konfiguration ist darauf ausgelegt, individuell angepasst zu werden. Jedes Skript und jede Konfigurationsdatei enthält ausführliche Kommentare, die die Funktionsweise und Anpassungsmöglichkeiten erklären.

**Wichtige Anpassungsbereiche:**
- **Persönliche Präferenzen**: Farben, Themes, Keybindings
- **Software-Alternativen**: Austausch von Standardprogrammen
- **Workflow-Optimierung**: Aliases, Funktionen, Automatisierungen
- **Hardware-spezifische Einstellungen**: Monitor-Setup, Audio, etc.

> 💡 **Tipp**: Für detaillierte Erklärungen zu spezifischen Konfigurationen besuche meinen [YouTube-Kanal](https://youtube.com/@SergiusYT) oder [kontaktiere mich](https://github.com/Sergi-us) bei Fragen!

### NeoVim 🚀

NeoVim ist das Herzstück der Entwicklungsumgebung und erhält besondere Aufmerksamkeit:

- **🔄 Lua-Konfiguration**: Kürzlich von VimScript auf Lua migriert
- **📦 Lazy Plugin-Management**: Umfangreiche Plugin-Suite für Entwicklung, LSP-Integration und Workflow-Optimierung
- **⚡ IDE-Features**: Code-Completion, Syntax-Highlighting, Git-Integration, Debugging-Support
- **🎨 Konsistente Themes**: Integration mit dem systemweiten pywal-Farbschema und Themeswitcher
- **Detaillierte Anleitung**: Siehe [NeoVim README](.config/nvim/README.md)

## 🔧 Verwendete Tools & Software

### Kern-Software
- `dwm` - Dynamic Window Manager
- `st` - Simple Terminal
- `dmenu` - Application Launcher
- `lf` - Terminal File Manager
- `zsh` - Erweiterte Shell ([Konfiguration & Zap Plugin Manager](.config/zsh/README.md))
- `neovim` - Moderner Text Editor

### Zusatz-Tools *(in aktiver Entwicklung)*
- `pywal` - Automatische Farbschema-Generierung
- `newsraft` - RSS Reader *(ersetzt newsboat)*
- `librewolf` - Privacy-fokussierter Browser *(wird qutebrowser ersetzen)*
- `cron` - Task Scheduler mit Custom-Scripts
- Verschiedene Mediaplayer *(regelmäßige Updates)*

> **📝 Hinweis**: Die Tool-Auswahl ist bewusst flexibel gehalten und wird kontinuierlich weiterentwickelt. Änderungen werden in den Release-Notes dokumentiert.

## 📖 Verwendung

### Cronjob-Verwaltung

Das Repository enthält ein praktisches Skript zur Verwaltung von Cronjobs:

- **`crontog`**: Schaltet alle Cronjobs ein/aus mit sicherer Backup-Funktion
- **Cronjob-Skripte**: In `.local/bin/cron/` organisiert
- **Detaillierte Anleitung**: Siehe [Cron README](.local/bin/cron/README.md)

### Shell-Features

- **Intelligente Autovervollständigung**
- **Git-Integration im Prompt**
- **Umfangreiche Alias-Sammlung**
- **Automatisches Directory-Jumping**

> **🔑 Keybindings & Workflows**: Alle wichtigen Tastenkombinationen und Workflows sind im [SARBS Hauptprojekt](https://github.com/Sergi-us/SARBS) dokumentiert.

## 🔄 Updates & Wartung

### Dotfiles aktualisieren

```bash
# Repository auf neuesten Stand bringen
cd ~/.dotfiles
git pull origin main

# Neue Dotfiles ins System übernehmen
./dotfiles-home
```

### Eigene Anpassungen vornehmen

**🔥 Wichtiger Workflow-Tipp**: Für eigene Anpassungen sollten Sie das Repository forken und Ihre Änderungen dort vornehmen:

```bash
# Dein geforktes Repository klonen
git clone https://github.com/Dein-Username/dotfiles.git ~/.dotfiles

# Anpassungen vornehmen und commiten
# Dann mit dotfiles-home aktualisieren
```

> **👀 Community-Vorteil**: Alle geclonten/geforkten Repositories sind für mich einsehbar. Ich schaue gerne in Ihre Anpassungen rein und lasse mich von kreativen Lösungen inspirieren!

## 🤝 Beitragen

1. Fork des Repositories erstellen
2. Feature-Branch erstellen (`git checkout -b feature/AmazingFeature`)
3. Änderungen committen (`git commit -m 'Add some AmazingFeature'`)
4. Branch pushen (`git push origin feature/AmazingFeature`)
5. Pull Request öffnen

## 📚 Weitere Ressourcen

- **[SARBS Hauptprojekt](https://github.com/Sergi-us/SARBS)** - Auto-Rice Bootstrapping Scripts
- **[dwm Build](https://github.com/Sergi-us/dwm)** - Angepasster Window Manager
- **[st Build](https://github.com/Sergi-us/st)** - Terminal-Konfiguration
- **[dmenu Build](https://github.com/Sergi-us/dmenu)** - Application Launcher

### 🔄 Bidirektionale Synchronisation mit Unison

Das Repository enthält ein vorkonfiguriertes Sync-Script für bidirektionale Datensynchronisation:

- **`sync-sarbs`**: Template-Script für Unison-basierte Synchronisation
- **Automatisches Setup**: Legt bei erster Ausführung alle benötigten Verzeichnisse an
- **Flexibel erweiterbar**: Review-Modus für manuelle Kontrolle

> **⚠️ Wichtig**: Benennene `sync-sarbs` für die eigenen Anwendungsfälle um (z.B. `sync-laptop`, `sync-nas`), um bei Updates des Repositories die eigene Konfiguration zu behalten!

**Features:**
- Peer-to-Peer Synchronisation ohne zentralen Server
- Konfliktauflösung (bevorzugt neuere Dateien)
- Interaktiver Review-Modus mit `--review` Flag
- Automatische Archivierung der Sync-States

### Inspirationen & Credits

- [Luke Smith](https://github.com/LukeSmithxyz) - Ursprüngliche LARBS-Inspiration
- [Suckless Software](https://suckless.org/) - Minimalistische Software-Philosophie
- [dotfiles.github.io](https://dotfiles.github.io/) - Dotfiles Best Practices

## 📄 Lizenz

Diese Konfiguration ist unter der [MIT Lizenz](LICENSE) verfügbar.

## ⚠️ Disclaimer

Diese Dotfiles sind für meine Nutzung optimiert. Bitte teste die Konfigurationen in einer sicheren Umgebung. Backups werden dringend empfohlen!

---

**📧 Kontakt**: [GitHub Issues](https://github.com/Sergi-us/dotfiles/issues) für Fragen und Feedback
