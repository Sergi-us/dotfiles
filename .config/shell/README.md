# Shell-Konfiguration

**SARBS Shell-Konfigurationsdateien für zsh und POSIX-kompatible Shells**

## Dateien

| Datei | Beschreibung |
|-------|-------------|
| `profile` | Login-Shell Konfiguration, setzt Umgebungsvariablen und XDG-Pfade |
| `aliasrc` | Shell-Aliases für zsh (und andere Shells) |
| `inputrc` | Readline-Konfiguration für Tastenbindungen |
| `bm-dirs` | Bookmark-Verzeichnisse für schnelle Navigation |
| `bm-files` | Bookmark-Dateien für schnellen Zugriff auf Konfigurationen |

## Bookmark-System (bm-dirs / bm-files)

Die Bookmark-Dateien ermöglichen schnellen Zugriff auf häufig genutzte Verzeichnisse und Dateien. Sie werden von `lf`, `nvim` und Shell-Skripten genutzt.

### Format

```
# Kommentar
key		pfad		# optionale Beschreibung
```

### Namenskonvention (bm-files)

- **`bf` / `bd`** - Bookmark-Dateien selbst
- **`nu-*`** - Nutzerdaten (xresources, snippets, etc.)
- **`cf-*`** - Konfigurationsdateien nach Kategorie

### XDG-Konformität

Alle Pfade nutzen XDG-Variablen mit Fallback-Werten:

```bash
${XDG_CONFIG_HOME:-$HOME/.config}/...    # Konfigurationen
${XDG_DATA_HOME:-$HOME/.local/share}/... # Anwendungsdaten
${XDG_CACHE_HOME:-$HOME/.cache}/...      # Cache-Dateien
```

**Syntax**: `${VAR:-fallback}` - Wenn `VAR` nicht gesetzt ist, wird `fallback` verwendet.

### Kategorien in bm-files

| Präfix | Kategorie |
|--------|-----------|
| `cf-zsh`, `cf-aliasrc`, etc. | Shell & Terminal |
| `cf-nvim` | Editor |
| `cf-lf`, `cf-zathura`, etc. | Dateimanager & Viewer |
| `cf-mpd`, `cf-mpv`, etc. | Media |
| `cf-qutebrowser`, `cf-newsraft`, etc. | Internet & Kommunikation |
| `cf-picom`, `cf-polybar`, etc. | Desktop & Appearance |
| `cf-fastfetch`, `cf-wget`, etc. | System & Tools |

## Verwendung

Die Bookmarks werden automatisch von verschiedenen Tools eingelesen:

- **lf**: Schnellnavigation mit Tastenkürzel
- **nvim**: Integration über Plugins
- **Shell-Skripte**: Direkte Nutzung der Pfade

## Hinweise

- Änderungen an `profile` erfordern einen Neustart der Login-Shell
- Änderungen an `aliasrc` werden beim nächsten Shell-Start aktiv
- Bookmark-Dateien werden bei Bearbeitung in Vim automatisch aktualisiert
