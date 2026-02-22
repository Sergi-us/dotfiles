## 2025-01-24 SARBS
# Alacritty Terminal-Emulator Konfiguration

## Übersicht
Alacritty-Konfiguration für SARBS, abgestimmt mit ST und Kitty Terminal-Einstellungen.

## Hauptmerkmale

### Schriftart
- **JetBrainsMono NF** (Nerd Font) - konsistent mit ST und Kitty
- Schriftgröße: 12pt
- Styles: Light, Bold, Light Italic, Bold Italic

### Transparenz
- Opazität: 0.85 (entspricht ST alpha und Kitty background_opacity)
- Keine Fenster-Innenabstände (padding = 0)

### Farben (hellwal)
- Dynamische Farbschemata über hellwal
- Template: `.config/hellwal/templates/colors-alacritty.toml`
- Symlink wird automatisch erstellt: `~/.config/alacritty/colors-alacritty.toml`
- Farben werden von hellwal/pywal generiert
- Import über `[general]` Sektion (Alacritty 0.13+)

## Tastenkombinationen

**Hinweis**: Alle Shortcuts entsprechen ST config.h - siehe `.config/README-Terminal-Shortcuts.md`

### Kopieren/Einfügen
- `Alt+Shift+C` / `Alt+C` - Kopieren
- `Alt+Shift+V` / `Alt+V` - Einfügen
- `Shift+Insert` - Einfügen

### Schriftgröße (Zoom)
- `Alt+Shift+PageUp` / `Alt+Shift+Up` / `Alt+Shift+K` - Vergrößern
- `Alt+Shift+PageDown` / `Alt+Shift+Down` / `Alt+Shift+J` - Verkleinern
- `Alt+Shift+Home` - Zurücksetzen
- `Alt+Shift+U` / `Alt+Shift+D` - Große Schritte

### Scrollen
- `Alt+PageUp/Down` - Seite hoch/runter
- `Alt+K/J` / `Alt+Up/Down` - Zeile hoch/runter
- `Alt+U/D` - Halbe Seite

### Fenster
- `Alt+Shift+Enter` - Neue Instanz

**Vollständige Übersicht**: `.config/README-Terminal-Shortcuts.md`

## Integration mit hellwal

Das hellwal postrun-Skript erstellt automatisch einen Symlink:
```sh
ln -sf "$waldir/colors-alacritty.toml" "$alacrittyconf"
```

Nach einem Wallpaper-Wechsel mit hellwal werden die Farben automatisch aktualisiert.

## XDG-Konformität
- Konfiguration: `${XDG_CONFIG_HOME}/alacritty/alacritty.toml`
- Farben: `${XDG_CACHE_HOME}/wal/colors-alacritty.toml` (symlinked)

## Siehe auch
- `.config/kitty/kitty.conf` - Kitty Terminal Konfiguration
- `.config/hellwal/` - Dynamische Farbschemata
- `.config/X11/xresources` - ST Terminal Konfiguration
