# Skalierung unter X11

# 🖥️ X11 Konfiguration & DPI-Management

**Zentrale Konfiguration für X11-Session, Display-Skalierung und Framework-Integration**

> **📦 Teil von**: [SARBS Dotfiles](https://github.com/Sergi-us/dotfiles)

> **📦 Hauptprojekt**: [SARBS - Suckless Auto-Rice Bootstrapping Scripts](https://github.com/Sergi-us/SARBS)

Diese Konfiguration regelt die Display-Skalierung für hochauflösende Bildschirme unter X11 mit getrennter Verwaltung von Terminal- und GUI-Anwendungen.

## 📋 Übersicht

Die X11-Konfiguration trennt bewusst zwischen TUI (Terminal UI) und GUI-Skalierung, um konsistente Darstellung über verschiedene Frameworks (GTK, Qt, Suckless) zu erreichen.

### 🎯 Hauptkomponenten

- **`xinitrc`**: Startpunkt für X11-Sessions via `startx`
- **`xprofile`**: Zentrale Umgebungsvariablen und DPI-Einstellungen
- **`check-dpi`**: Hilfsskript zur DPI-Berechnung
- **Autocmd Integration**: Automatische GTK-Konfiguration via Neovim

## 🔍 DPI-Werte ermitteln

### Mit dem check-dpi Skript

```bash
# DPI für dein Display berechnen
check-dpi

# Beispiel-Ausgabe für 14" mit 2560x1440:
# Physische Größe: 12.21" × 6.86"
# DPI: 210 (horizontal) × 210 (vertikal)
# Empfohlene Werte: 96, 144, 168, 192
```

### Manuelle Berechnung

```
DPI = Pixel / Physische Größe in Zoll

Beispiel 14" Display mit 2560×1440:
- Breite: 12.21 Zoll → 2560 / 12.21 = 210 DPI
- Höhe: 6.86 Zoll → 1440 / 6.86 = 210 DPI
```

### Praktische DPI-Werte

| DPI | Faktor | Beschreibung                          |
|-----|--------|---------------------------------------|
| 96  | 1.0×   | Standard (Windows 95 Legacy)          |
| 120 | 1.25×  | Leicht vergrößert                     |
| 144 | 1.5×   | Gut lesbar, Fractional Scaling        |
| 168 | 1.75×  | Größer, manche Apps problematisch     |
| 192 | 2.0×   | Integer Scaling, beste Kompatibilität |

## 📁 Datei-Struktur

### xinitrc
**Zweck**: Startet die X11-Session und lädt die xprofile

```bash
#!/bin/sh
# Lädt Umgebungsvariablen aus xprofile
. "${XDG_CONFIG_HOME:-$HOME/.config}/x11/xprofile"

# Startet Window Manager mit dbus
dbus-launch ssh-agent dwm
```

### xprofile
**Zweck**: Setzt Umgebungsvariablen und DPI-Einstellungen für alle X11-Programme

## ⚙️ Wichtige Variablen

### DPI-Einstellungen

```bash
# Getrennte DPI für TUI und GUI
XRANDR_DPI=192      # Terminal-Programme (DWM, ST, dmenu)
MASTER_DPI=144      # GUI-Programme (GTK, Qt)
SCALE_FACTOR=1.25   # Skalierungsfaktor für spezielle Apps

# Anwendung
xrandr --dpi $XRANDR_DPI        # System-DPI
export QT_FONT_DPI=$MASTER_DPI  # Qt-Skalierung
export GDK_DPI_SCALE=$SCALE_FACTOR  # GTK-Skalierung
```

### Framework-Konfiguration

| Variable               | Zweck                   | Beispielwert  |
|------------------------|-------------------------|---------------|
| `GTK_THEME`            | GTK-Theme               | `Breeze-Dark` |
| `QT_QPA_PLATFORMTHEME` | Qt-Platform Integration | `qt6ct`       |
| `QT_FONT_DPI`          | Qt Font-DPI             | `144`         |
| `GDK_DPI_SCALE`        | GTK DPI-Skalierung      | `1.25`        |
| `QT_SCALE_FACTOR`      | Qt UI-Skalierung        | `1.25`        |

## 🔄 Automatische Synchronisation

Die GTK-Konfiguration wird automatisch via Neovim-Autocmd aktualisiert:

```lua
-- Bei Änderung von MASTER_DPI in xprofile:
-- gtk-xft-dpi = MASTER_DPI * 1024
-- Beispiel: 144 * 1024 = 147456
```

## 🎨 Theme-Integration

- **GTK**: Breeze-Dark via `settings.ini`
- **Qt**: Konfiguration via `qt5ct`/`qt6ct`
- **Farben**: Pywal für dynamische Farbschemata

## 🚀 Verwendung

### DPI anpassen

1. **Display-Info ermitteln**:
   ```bash
   check-dpi  # oder xrandr
   ```

2. **xprofile editieren**:
   ```bash
   nvim ~/.config/x11/xprofile
   
   # Werte anpassen:
   XRANDR_DPI=192  # Für Terminals
   MASTER_DPI=144  # Für GUI-Apps
   ```

3. **X11 neustarten**:
   ```bash
   # DWM: Mod+Shift+Q
   # Oder: pkill dwm
   ```

### Wrapper-Scripts für problematische Apps

Chromium-basierte Browser ignorieren GTK-Settings:

```bash
# ~/.local/bin/chromium
#!/bin/sh
SCALE=$(grep "^SCALE_FACTOR=" ~/.xprofile | cut -d= -f2)
exec /usr/bin/chromium --force-device-scale-factor=${SCALE:-1.25} "$@"
```

## 📊 Skalierungs-Matrix

**Testsystem T480, 2560x1440 @ 14" (Rechnerisch 209DPI)**

| Anwendung           |     | X11 | Mstr | Mstr | Schriftart    | Gese-  | Set  | Wra- | 800% | Notiz          |
|                     |     | DPI | DPI  | Fakt | und Größe     | tzt    | 800% | per  |      |                |
|---------------------|-----|:---:|:----:|:----:|---------------|--------|:----:|:----:|------|----------------|
| xrandr --dpi        | x11 | 192 | 120  | 1.25 | xprofile      |        |      | auto |      |                |
| DWM                 | x11 |    |  X   |  X   | config.h      | 8      | 16mm |      | 16mm |                |
| DMENU               | x11 |    |  X   |  X   | config.h      | 10     | 19mm |      | 19mm |                |
| ST                  | x11 |    |  X   |  X   | config.h      | 10     | 24mm |      | 22mm |                |
| Notify              | x11 |    |  X   |  X   | dunstrc       | 9      | 18mm |      | 19mm |                |
| pinentry (welche?)  | QT  |  X  |  X   |     |               |        | 9cm  |      | 9cm  |                |
| KeepassXC UI        | GTK |  X  |     |     | keepassxc.ini | Medium | 15mm |      | 25mm |                |
| KeepassXC Inhalt    | GTK |  X  |     |     | settings.ini  | 12     | 17mm |      | 25mm |                |
| qutebrowser UI      | QT  |  X  |     |     | config.py     | 12     | 15mm |      | 19mm |                |
| qutebrowser inhalt  | QT  |  X  |     |     | qt6ct.conf    | 10     | 15mm |      | 29mm | testen         |
| Firefox UI          | GTK |  X  |  X   |     | settings.ini  | 12     | 16mm |      |      |                |
| Firefox inhalt      | GTK |  X  |  X   |     |               | 100%   | 15mm |      | 14mm | Pers. Dotfiles |
| Gimp                | GTK |     |      |     | settings.ini  | 12     | 15mm |      |      |                |
| Chromium UI         | GTK |  X  |      |  X   | settings.ini  | 12     |  mm  | auto | 9mm  |                |
| Chromium inhalt     | GTK |  X  |      |  X   |               | 100%   | 15mm | auto | 11mm |                |
| Brave UI            | GTK |  X  |      |  X   | settings.ini  | 12     |  mm  | auto | mm   |                |
| Brave inhalt        | GTK |  X  |      |  X   |               | 100%   | 15mm | auto | mm   |                |
| Vivaldi UI          |     |     |      |      |               |        | 14mm | auto |      |                |
| Vivaldi inhalt      |     |     |      |      |               | 100%   | 18mm |      |      |                |
| qt5ct UI            | QT  |    |      |     | qt5ct.conf    | 10     | 12mm |      | 21mm |                |
| qt6ct UI            | QT  |    |      |     | qt6ct.conf    | 10     | 12mm |      | 20mm |                |
| Telegramm UI        | QT  |     |      |      | qt5ct.conf    | 100%   | 10mm |      | mm   |                |
| qalculate-qt UI     | QT  |    |      |     | qt6ct.conf    | 10     | 13mm |      | 21mm |                |
| qalculate-qt inhalt | QT  |    |      |     | qt6ct.conf    |        | 17mm |      | 26mm |                |
| Kdenlive UI         | QT  |     |      |      | qt5ct.conf    | 10     |  mm  |      | mm   |                |
| OBS Studio UI       |     |     |      |      |               |        |      |      |      |                |
| Discord             |     |     |      |      |               |        |      |      |      |                |
| VS Code             |     |     |      |      |               |        |      |      |      |                |
| Spotify             |     |     |      |      |               |        |      |      |      |                |
| Steam               |     |     |      |      |               |        |      |      |      |                |
| Blender             |     |     |      |      |               |        |      |      |      |                |
| DaVinci Resolve     |     |     |      |      |               |        |      |      |      |                |

## 🔧 Troubleshooting

### Apps sind zu groß/klein

```bash
# Check aktive DPI-Settings
echo "xrandr: $(xrandr --query | grep -o '[0-9]*x[0-9]* mm')"
echo "MASTER_DPI: $MASTER_DPI"
echo "GDK_DPI_SCALE: $GDK_DPI_SCALE"
echo "QT_FONT_DPI: $QT_FONT_DPI"
```

### Inkonsistente Skalierung

- **Problem**: Multiplikation von DPI-Settings
- **Lösung**: Nur EINEN Skalierungsmechanismus pro Framework verwenden.
- **Schriftgröße:** die Schriftgröße ist auch ein Skalierungsfaktor

### Firefox/Chromium ignoriert Settings

- **Firefox**: `about:config` → `layout.css.devPixelsPerPx`
- **Chromium**: Wrapper-Script mit `--force-device-scale-factor`

## 📚 Weiterführende Dokumentation

- **[GTK Konfiguration](../gtk-3.0/README.md)** - GTK3 settings.ini
- **[Qt Konfiguration](../qt5ct/README.md)** - Qt5/6 Themes
- **[Suckless Builds](https://github.com/Sergi-us)** - DWM, ST, dmenu

## 🤝 Beitragen

Verbesserungen und Anpassungen sind willkommen! Fork das Repository und teile deine Skalierungs-Lösungen.

## ⚠️ Hinweise

- **X11 only**: Diese Konfiguration funktioniert nicht unter Wayland
- **Display-spezifisch**: DPI-Werte müssen für jedes Display angepasst werden
- **Framework-Chaos**: Jedes GUI-Framework hat eigene Skalierungs-Mechanismen

---

**📧 Kontakt**: [GitHub Issues](https://github.com/Sergi-us/dotfiles/issues) für Fragen zur DPI-Konfiguration

