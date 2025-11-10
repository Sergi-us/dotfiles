# ⚡ Zsh Konfiguration mit Zap Plugin Manager

> **📦 Teil von**: [SARBS Dotfiles](https://github.com/Sergi-us/dotfiles)

Eine moderne, minimalistische Zsh-Konfiguration mit intelligenter Plugin-Verwaltung durch [Zap](https://github.com/zap-zsh/zap) - schnell, modular und erweiterbar.

## 🎯 Features

- **🚀 Blitzschneller Start** - Optimiert für minimale Ladezeiten
- **📦 Zap Plugin Manager** - Einfache, deklarative Plugin-Verwaltung
- **🎨 Flexibles Prompt-System** - Wähle zwischen verschiedenen Prompts oder nutze den Fallback
- **⌨️ Vi-Mode** - Vollständige Vi-Keybindings mit visuellen Cursor-Änderungen
- **🔍 FZF Integration** - Fuzzy-Finding für History und Dateien
- **📝 Git Integration** - Detaillierte Git-Status-Anzeige mit Nerd Font Icons
- **🛡️ Intelligent Fallbacks** - Funktioniert auch ohne Plugins im TTY

## 📁 Struktur

```
~/.config/zsh/
├── .zshrc				# Hauptkonfiguration
├── plugins/			# Zap Plugin-Verzeichnis (automatisch verwaltet)
└── README.md			# Diese Datei
~/.local/state/history	# Command-History
```

## ⚡ Zap Plugin Manager

### Was ist Zap?

Zap ist ein minimalistischer, schneller Plugin-Manager für Zsh. Er lädt Plugins on-demand und hält deine Shell reaktionsschnell.

### Installation

Die Installation erfolgt **automatisch** beim ersten Start der neuen `.zshrc`:

```bash
# Zap installiert sich selbst in:
~/.local/share/zap/
```

### Plugin-Verwaltung

#### Plugins aktivieren/deaktivieren

In der `.zshrc` einfach die entsprechende Zeile auskommentieren:

```bash
# Aktive Plugins
plug "zsh-users/zsh-syntax-highlighting"    # Syntax-Highlighting
plug "zsh-users/zsh-autosuggestions"       # Fish-like Autosuggestions
plug "jeffreytse/zsh-vi-mode"              # Besserer Vi-Mode

# Inaktive Plugins (auskommentiert)
# plug "sindresorhus/pure"                 # Minimalistischer Prompt
```

#### Zap Befehle

```bash
zap update              # Alle Plugins aktualisieren
zap update <plugin>     # Einzelnes Plugin aktualisieren
zap update self         # Zap selbst aktualisieren
zap list               # Installierte Plugins anzeigen
zap clean              # Nicht verwendete Plugins entfernen
zap help               # Hilfe anzeigen
```

## 🎨 Prompt-System

### Verfügbare Prompts

Die Konfiguration unterstützt verschiedene Prompt-Plugins:

| Prompt | Beschreibung | Aktivierung |
|--------|--------------|-------------|
| **Eigener Prompt** | Minimalistisch mit Git-Integration | Standard (Fallback) |
| **git-prompt.zsh** | Erweiterte Git-Infos mit Nerd Fonts | `plug "woefe/git-prompt.zsh"` |
| **Pure** | Elegant & minimalistisch | `plug "mafredri/zsh-async"`<br>`plug "sindresorhus/pure"` |
| **Spaceship** | Feature-reich, informativ | `plug "spaceship-prompt/spaceship-prompt"` |
| **Powerlevel10k** | Ultra-konfigurierbar | `plug "romkatv/powerlevel10k"` |
| **Starship** | Rust-basiert, cross-shell | [Separate Installation](https://starship.rs) |
| **Agkozak** | Async, minimalistisch | `plug "agkozak/agkozak-zsh-prompt"` |

### Git-Symbole (mit git-prompt.zsh)

| Symbol | Bedeutung |
|--------|-----------|
| ⎇ | Git Branch |
| ✓ | Staged changes |
| ✚ | Modified files |
| … | Untracked files |
| ⚑ | Stashed changes |
| ↑ | Ahead of remote |
| ↓ | Behind remote |

## ⌨️ Keybindings

### Standard-Keybindings

| Kombination | Funktion |
|-------------|----------|
| `Ctrl+O` | lf Dateimanager öffnen |
| `Ctrl+R` | FZF History-Suche |
| `Ctrl+F` | FZF Datei-Suche |
| `Ctrl+E` | Aktuelle Zeile in Neovim bearbeiten |
| `Ctrl+A` | Taschenrechner (bc) |
| `ESC` | Vi-Mode aktivieren |

### Vi-Mode Navigation

| Modus | Taste | Funktion |
|-------|-------|----------|
| Normal | `h/j/k/l` | Links/Unten/Oben/Rechts |
| Normal | `w/b` | Wort vor/zurück |
| Normal | `0/$` | Zeilenanfang/Ende |
| Normal | `i/a` | Insert-Mode vor/nach Cursor |
| Normal | `v` | Visual Mode |
| Insert | `ESC` | Zurück zu Normal Mode |

## 🔧 Wichtige Einstellungen

### History-Konfiguration

```bash
HISTSIZE=10000000              # Maximale History-Größe im Speicher
SAVEHIST=10000000              # Maximale History-Größe auf Disk
HISTFILE=~/.config/zsh/history # XDG-konformer Speicherort
```

**Features:**
- Duplikate werden ignoriert
- Befehle mit führendem Leerzeichen werden nicht gespeichert
- Sensitive Befehle (pass, tomb) werden gefiltert

### Shell-Optionen

| Option | Beschreibung |
|--------|--------------|
| `autocd` | Verzeichniswechsel ohne `cd` |
| `interactive_comments` | Kommentare in interaktiver Shell |
| `prompt_subst` | Variable Substitution im Prompt |
| `inc_append_history` | History sofort schreiben |
| `globdots` | Versteckte Dateien in Completion |

## 🔌 Empfohlene Plugins

### Produktivität
- `plug "Aloxaf/fzf-tab"` - Tab-Completion mit FZF
- `plug "agkozak/zsh-z"` - Intelligente Verzeichnis-Navigation
- `plug "wfxr/forgit"` - Interaktives Git mit FZF

### Development
- `plug "hlissner/zsh-autopair"` - Auto-schließende Klammern
- `plug "zsh-users/zsh-completions"` - Erweiterte Completions

### Utilities
- `plug "MichaelAquilina/zsh-you-should-use"` - Alias-Erinnerungen
- `plug "zsh-users/zsh-history-substring-search"` - Bessere History-Suche

## 🛠️ Troubleshooting

### Plugin funktioniert nicht

1. Plugins aktualisieren: `zap update`
2. Shell neu starten: `exec zsh`
3. Cache löschen: `rm -rf ~/.config/zsh/plugins && exec zsh`

### Langsamer Shell-Start

1. Unnötige Plugins deaktivieren
2. `plug "romkatv/powerlevel10k"` durch leichtgewichtige Alternative ersetzen
3. Kompilierte Dateien löschen: `rm ~/.config/zsh/*.zwc`

### TTY-Kompatibilität

Die Konfiguration erkennt automatisch TTY-Sessions und fällt auf kompatible Alternativen zurück:
- Nerd Fonts → ASCII-Symbole
- git-prompt.zsh → vcs_info
- Farbige Prompts → Monochrom

## 📚 Weitere Ressourcen

- **[Zap Dokumentation](https://github.com/zap-zsh/zap)** - Plugin Manager Details
- **[SARBS Hauptprojekt](https://github.com/Sergi-us/SARBS)** - Komplettes System-Setup
- **[Zsh Dokumentation](https://zsh.sourceforge.io/Doc/)** - Offizielle Zsh Docs

## 🤝 Anpassungen & Beiträge

Diese Konfiguration ist darauf ausgelegt, angepasst zu werden! Forke das [Dotfiles Repository](https://github.com/Sergi-us/dotfiles) und experimentiere mit eigenen Plugins und Einstellungen.

### Eigene Plugins hinzufügen

1. Plugin-Zeile in `.zshrc` hinzufügen:
   ```bash
   plug "username/repository"
   ```

2. Shell neu starten oder `source ~/.config/zsh/.zshrc`

3. Optional: Nicht verwendete Plugins aufräumen:
   ```bash
   zap clean
   ```

---

**💡 Tipp**: Teste neue Plugins erst einzeln, um Konflikte zu vermeiden!

**🐛 Probleme?** [Issue erstellen](https://github.com/Sergi-us/dotfiles/issues) im Dotfiles Repository
