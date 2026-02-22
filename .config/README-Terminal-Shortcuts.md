## 2025-01-24 SARBS
# Terminal Tastenkombinationen Übersicht

Einheitliche Shortcuts für ST, Kitty und Alacritty basierend auf ST config.h

## Modifier-Tasten

- **MODKEY** = `Alt` (Mod1)
- **TERMMOD** = `Alt+Shift` (Mod1+Shift)

## Kopieren & Einfügen

| Funktion | Tastenkombination | ST | Kitty | Alacritty |
|----------|-------------------|----|----|-----------|
| Kopieren | `Alt+Shift+C` | ✓ | ✓ | ✓ |
| Kopieren | `Alt+C` | ✓ | ✓ | ✓ |
| Einfügen | `Alt+Shift+V` | ✓ | ✓ | ✓ |
| Einfügen | `Alt+V` | ✓ | ✓ | ✓ |
| Einfügen | `Shift+Insert` | ✓ | ✓ | ✓ |

## Zoom (Schriftgröße)

| Funktion | Tastenkombination | ST | Kitty | Alacritty |
|----------|-------------------|----|----|-----------|
| Vergrößern | `Alt+Shift+PageUp` | ✓ | ✓ | ✓ |
| Verkleinern | `Alt+Shift+PageDown` | ✓ | ✓ | ✓ |
| Zurücksetzen | `Alt+Shift+Home` | ✓ | ✓ | ✓ |
| Vergrößern | `Alt+Shift+Up` | ✓ | ✓ | ✓ |
| Verkleinern | `Alt+Shift+Down` | ✓ | ✓ | ✓ |
| Vergrößern | `Alt+Shift+K` | ✓ | ✓ | ✓ |
| Verkleinern | `Alt+Shift+J` | ✓ | ✓ | ✓ |
| Vergrößern (+2) | `Alt+Shift+U` | ✓ | ✓ | ✓* |
| Verkleinern (-2) | `Alt+Shift+D` | ✓ | ✓ | ✓* |

*Alacritty: Schrittweite nicht konfigurierbar, nutzt Standard-Inkrement

## Scrollen

| Funktion | Tastenkombination | ST | Kitty | Alacritty |
|----------|-------------------|----|----|-----------|
| Seite hoch | `Alt+PageUp` | ✓ | ✓ | ✓ |
| Seite runter | `Alt+PageDown` | ✓ | ✓ | ✓ |
| Zeile hoch | `Alt+K` | ✓ | ✓ | ✓ |
| Zeile runter | `Alt+J` | ✓ | ✓ | ✓ |
| Zeile hoch | `Alt+Up` | ✓ | ✓ | ✓ |
| Zeile runter | `Alt+Down` | ✓ | ✓ | ✓ |
| Halbe Seite hoch | `Alt+U` | ✓ | ✓ | ✓ |
| Halbe Seite runter | `Alt+D` | ✓ | ✓ | ✓ |

## Transparenz

| Funktion | Tastenkombination | ST | Kitty | Alacritty |
|----------|-------------------|----|----|-----------|
| Weniger transparent | `Alt+S` | ✓ | ✓ | ✗ |
| Mehr transparent | `Alt+A` | ✓ | ✓ | ✗ |

*Alacritty: Dynamische Transparenz-Anpassung zur Laufzeit nicht unterstützt

## Fenster & Tabs

| Funktion | Tastenkombination | ST | Kitty | Alacritty |
|----------|-------------------|----|----|-----------|
| Neue Instanz | `Alt+Shift+Enter` | ✓ (tabbed) | ✓ | ✓ |
| Neuer Tab | `Ctrl+Shift+T` | - | ✓ | - |
| Fenster schließen | `Ctrl+Shift+W` | - | ✓ | - |
| Nächster Tab | `Ctrl+Shift+→` | - | ✓ | - |
| Voriger Tab | `Ctrl+Shift+←` | - | ✓ | - |

## Externe Befehle (nur ST)

| Funktion | Tastenkombination | Beschreibung |
|----------|-------------------|--------------|
| URL öffnen | `Alt+L` | Öffnet URLs aus Terminal |
| URL kopieren | `Alt+Y` | Kopiert URLs in Zwischenablage |
| Output kopieren | `Alt+O` | Kopiert Terminal-Output |

## Implementierung

- **ST**: `/home/sergi/.local/src/st/config.h` (Zeilen 250-286)
- **Kitty**: `~/.config/kitty/kitty.conf`
- **Alacritty**: `~/.config/alacritty/alacritty.toml`

## Hinweise

1. ST gibt die Shortcuts vor - alle anderen Terminals folgen diesem Schema
2. Einige ST-spezifische Features (externe Pipes) sind in Kitty/Alacritty nicht verfügbar
3. Kitty hat erweiterte Tab-Verwaltung, die ST/Alacritty nicht haben
4. Alle Terminals nutzen die gleiche Schriftart: **JetBrainsMono NF**
5. Transparenz: ST=0.85, Kitty=0.85, Alacritty=0.85
