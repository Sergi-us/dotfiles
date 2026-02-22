# X11 Konfiguration & DPI-Management

**Zentrale Konfiguration fuer X11-Session, Display-Skalierung und Framework-Integration**

> **Hauptprojekt**: [SARBS - Suckless Auto-Rice Bootstrapping Scripts](https://codeberg.org/Sergius/SARBS)

> **Dotfiles**: [SARBS Dotfiles](https://codeberg.org/Sergius/dotfiles)

## Uebersicht

Die X11-Konfiguration verwaltet automatische DPI-Erkennung, Skalierung und
Mauszeiger-Groesse. Alle Werte werden aus der physischen Display-Hardware
abgeleitet und koennen ueber einen einzigen Prozent-Regler nachjustiert werden.

### Dateien

| Datei        | Zweck                                         |
|--------------|-----------------------------------------------|
| `xinitrc`    | Startpunkt fuer X11-Sessions via `startx`     |
| `xprofile`   | DPI-Erkennung, Skalierung, Umgebungsvariablen |
| `xresources` | Farbschema, Schriftart, Transparenz           |

### Abhaengigkeiten

- **bc** - Fuer DPI-Berechnung und Fliesskomma-Arithmetik
- **xrandr** - Display-Erkennung und DPI-Anwendung

## Architektur

### Berechnungskette

```
Hardware (xrandr)
      |
      v
calculate_raw_dpi()          Pixel / Millimeter -> Roh-DPI (z.B. 163)
      |
      +-- DISPLAY_ADJUST     Prozent-Offset (z.B. +25 -> 203)
      |
      v
round_to_dpi_step()          Rundet auf naechste Stufe (z.B. 192)
      |
      v
MASTER_DPI                   Basis fuer alles Weitere
      |
      v
calculate_scale_factor()     DPI -> Scale-Faktor (z.B. 1.25)
      |
      +-----> GDK_DPI_SCALE, QT_SCALE_FACTOR     (Umgebungsvariablen)
      +-----> XCURSOR_SIZE = 24 * SCALE_FACTOR    (Mauszeiger)
      +-----> State-Dateien                        (fuer Wrapper-Skripte)
      +-----> gtk-cursor-theme-size                (GTK-Settings)
      +-----> fontconfig dpi                       (fonts.conf)
      +-----> xrandr --dpi                         (X11-Server)
```

### Override-Hierarchie

Absteigend nach Prioritaet:

1. `FORCE_DPI` - Ueberspringt Auto-Erkennung + Adjust komplett
2. `DISPLAY_ADJUST` - Justiert die Auto-Erkennung prozentual
3. Auto-Erkennung - Default (basierend auf physischer Display-Groesse)

Scale-Faktor separat:

1. `FORCE_SCALE` - Ueberspringt die Scale-Ableitung
2. Automatisch aus MASTER_DPI abgeleitet

## Stellschrauben

### DISPLAY_ADJUST (Globale Justierung)

Prozent-Offset auf die automatisch erkannte DPI. Wirkt **vor** der Rundung
auf DPI-Stufen - dadurch keine Multiplikator-Kaskade.

```sh
# In ~/.zprofile oder direkt in xprofile setzen:
export DISPLAY_ADJUST=25     # Alles 25% groesser als Auto-Erkennung
export DISPLAY_ADJUST=-10    # Etwas kleiner
export DISPLAY_ADJUST=0      # Nur Auto-Erkennung (Default)
```

Beispiele mit einem Display das 163 Roh-DPI liefert:

| DISPLAY_ADJUST | Berechnung       | Gerundet | SCALE_FACTOR |
|----------------|------------------|----------|--------------|
| `0`            | 163              | 168      | 1.25         |
| `+25`          | 163 * 1.25 = 203 | 192      | 1.25         |
| `-15`          | 163 * 0.85 = 138 | 144      | 1            |
| `+50`          | 163 * 1.50 = 244 | 240      | 1.5          |

### FORCE_DPI (Direkte DPI-Vorgabe)

Umgeht die gesamte Berechnungskette. Nuetzlich wenn die Hardware falsche
physische Groessen meldet.

```sh
export FORCE_DPI=192    # Fest auf 192 DPI
```

### FORCE_SCALE (Direkte Scale-Vorgabe)

Ueberschreibt nur den abgeleiteten Scale-Faktor, nicht die DPI.

```sh
export FORCE_SCALE=1.5  # Fest auf 1.5x Skalierung
```

## DPI-Stufen

| DPI | Faktor | Beschreibung                                   |
|-----|--------|------------------------------------------------|
| 96  | 1.0x   | Standard (Low-DPI)                             |
| 120 | 1.25x  | Leicht vergroessert                            |
| 144 | 1.5x   | Guter Kompromiss fuer FullHD auf 14"           |
| 168 | 1.75x  | Selten genutzt                                 |
| 192 | 2.0x   | Ideal fuer WQHD auf 14", beste Kompatibilitaet |
| 240 | 2.5x   | Fuer 4K auf kleineren Displays                 |
| 288 | 3.0x   | Fuer sehr hohe DPI Displays                    |

### Scale-Faktor-Tabelle

| MASTER_DPI | SCALE_FACTOR | XCURSOR_SIZE |
|------------|--------------|--------------|
| 96-144     | 1            | 24px         |
| 168-192    | 1.25         | 30px         |
| 240        | 1.5          | 36px         |
| 288+       | 2            | 48px         |

## State-Dateien

Berechnete Werte werden in `~/.local/state/xsession/` gespeichert, damit
Wrapper-Skripte und andere Tools darauf zugreifen koennen ohne die
Berechnung zu wiederholen.

| Datei    | Inhalt         | Beispiel |
|----------|----------------|----------|
| `dpi`    | MASTER_DPI     | `192`    |
| `scale`  | SCALE_FACTOR   | `1.25`   |
| `cursor` | XCURSOR_SIZE   | `30`     |
| `adjust` | DISPLAY_ADJUST | `0`      |

## Synchronisierte Konfigurationen

Das xprofile aktualisiert beim Start automatisch:

| Ziel                    | Was                     | Wie                  |
|-------------------------|-------------------------|----------------------|
| `gtk-3.0/settings.ini`  | `gtk-cursor-theme-size` | sed auf XCURSOR_SIZE |
| `gtk-2.0/gtkrc-2.0`     | `gtk-cursor-theme-size` | sed auf XCURSOR_SIZE |
| `fontconfig/fonts.conf` | `<dpi>`                 | sed auf MASTER_DPI   |

Zusaetzlich via Neovim-Autocmd (bei Speichern von xprofile):

| Ziel                   | Was           | Wie               |
|------------------------|---------------|-------------------|
| `gtk-3.0/settings.ini` | `gtk-xft-dpi` | MASTER_DPI * 1024 |
| `rofi/config.rasi`     | `dpi:`        | MASTER_DPI        |

## Wrapper-Skripte

Unter `~/.local/bin/wrapper/` liegen App-spezifische Wrapper die den
SCALE_FACTOR aus der State-Datei lesen und per-App anwenden.

| App                      | Methode                                                  |
|--------------------------|----------------------------------------------------------|
| Chromium, Brave, Vivaldi | `--force-device-scale-factor=$SCALE_FACTOR`              |
| Firefox, Librewolf       | `GDK_SCALE` + `GDK_DPI_SCALE`                            |
| Qutebrowser              | Hardcoded `SCALE_FACTOR=1` (nutzt interne pt-Skalierung) |
| Telegram                 | Hardcoded `SCALE_FACTOR=1` (interner Schieberegler)      |
| KeePassXC                | Hardcoded `SCALE_FACTOR=1`, `QT_FONT_DPI=144`            |

## Display-Wechsel (displayselect)

Das Skript `displayselect` (dmenu-basiert) erkennt angeschlossene Displays
und bietet Einzel-/Multi-Monitor-Konfiguration. Nach jedem Display-Wechsel
wird die DPI-Kette automatisch neu berechnet:

1. Roh-DPI aus dem neuen Primary Display
2. DISPLAY_ADJUST aus State-Datei anwenden
3. Rundung auf DPI-Stufe
4. Scale-Factor + Cursor-Groesse ableiten
5. State-Dateien aktualisieren
6. `xrandr --dpi` neu setzen
7. Benachrichtigung mit den neuen Werten

## Umgebungsvariablen

### GTK

| Variable        | Wert                             | Zweck                   |
|-----------------|----------------------------------|-------------------------|
| `GTK_THEME`     | `Breeze-Dark`                    | Ueberschreibt gsettings |
| `GTK3_RC_FILES` | `~/.config/gtk-3.0/settings.ini` | GTK3 Einstellungen      |
| `GDK_DPI_SCALE` | `$SCALE_FACTOR`                  | GTK DPI-Skalierung      |

`GDK_SCALE` wird bewusst **nicht** gesetzt (Integer-Only).

### Qt

| Variable                          | Wert            | Zweck                               |
|-----------------------------------|-----------------|-------------------------------------|
| `QT_QPA_PLATFORMTHEME`            | `qt6ct`         | Qt6 Theme-Integration               |
| `QT5_QPA_PLATFORMTHEME`           | `qt5ct`         | Qt5 Theme-Integration               |
| `QT_FONT_DPI`                     | `$MASTER_DPI`   | Qt Font-DPI                         |
| `QT_SCALE_FACTOR`                 | `$SCALE_FACTOR` | Qt UI-Skalierung                    |
| `QT_SCALE_FACTOR_ROUNDING_POLICY` | `PassThrough`   | Nicht-ganzzahlige Faktoren erlauben |

### Cursor

| Variable       | Wert                | Zweck                       |
|----------------|---------------------|-----------------------------|
| `XCURSOR_SIZE` | `24 * SCALE_FACTOR` | Mauszeiger-Groesse in Pixel |

## Sonstige X11-Einstellungen

| Einstellung                                    | Zweck                                           |
|------------------------------------------------|-------------------------------------------------|
| `xset s off` / `xset -dpms` / `xset s noblank` | Bildschirmschoner/Energiesparmodus deaktivieren |
| `setbg`                                        | Hintergrundbild setzen                          |
| `xbanish`                                      | Mauszeiger beim Tippen ausblenden               |
| `unclutter`                                    | Mauszeiger bei Inaktivitaet ausblenden          |

## DPI ermitteln

### Mit check-DPI Skript

```sh
check-DPI
# Fragt nach Pixel-Breite, Hoehe und Diagonale in Zoll
# Berechnet physische Groesse und DPI
```

### Mit set-dpi Skript

```sh
set-dpi           # Interaktiv: zeigt Vergleich, fragt vor Anwendung
set-dpi -d        # Dry-Run: zeigt nur berechnete Werte
set-dpi -a        # Apply: wendet sofort an (fuer Skripte)
set-dpi -s        # Silent: fuer xprofile (keine Ausgabe)
```

### Manuelle Berechnung

```
DPI = Pixel / (Millimeter / 25.4)

Beispiel 14" Display mit 2560x1440 (309mm breit):
  2560 / (309 / 25.4) = 210 DPI
  -> gerundet auf Stufe 192
```

## Skalierungs-Matrix (Referenz)

**Testsystem T480, 2560x1440 @ 14" (rechnerisch 210 DPI)**

| Anwendung      | Framework    | DPI-Quelle    | Scale-Quelle                          | Schrift-Konfig       |
|----------------|--------------|---------------|---------------------------------------|----------------------|
| DWM, ST, dmenu | X11/Suckless | xrandr --dpi  | -                                     | config.h (pixelsize) |
| Dunst          | X11          | xrandr --dpi  | -                                     | dunstrc              |
| Firefox        | GTK          | xrandr + GDK  | Wrapper                               | settings.ini         |
| Chromium/Brave | GTK          | xrandr + GDK  | Wrapper (--force-device-scale-factor) | settings.ini         |
| Qutebrowser    | Qt           | QT_FONT_DPI   | Intern (pt)                           | config.py            |
| KeePassXC      | Qt           | Hardcoded 144 | Hardcoded 1                           | keepassxc.ini        |
| Telegram       | Qt           | QT_FONT_DPI   | Hardcoded 1 + interner Regler         | qt5ct.conf           |
| qt5ct/qt6ct    | Qt           | QT_FONT_DPI   | QT_SCALE_FACTOR                       | qt5ct/qt6ct.conf     |
| GIMP           | GTK          | xrandr + GDK  | GDK_DPI_SCALE                         | settings.ini         |

## Troubleshooting

### Aktive Werte pruefen

```sh
# State-Dateien lesen
cat ~/.local/state/xsession/dpi
cat ~/.local/state/xsession/scale
cat ~/.local/state/xsession/cursor
cat ~/.local/state/xsession/adjust

# Umgebungsvariablen pruefen
echo "GDK_DPI_SCALE: $GDK_DPI_SCALE"
echo "QT_FONT_DPI: $QT_FONT_DPI"
echo "QT_SCALE_FACTOR: $QT_SCALE_FACTOR"
echo "XCURSOR_SIZE: $XCURSOR_SIZE"

# Oder mit set-dpi fuer vollstaendige Uebersicht
set-dpi -d
```

### Apps sind zu gross/klein

1. `DISPLAY_ADJUST` in `~/.zprofile` anpassen
2. X11-Session neustarten (`Mod+Shift+Q` oder `pkill dwm`)
3. Fuer einzelne Apps: Wrapper-Skript in `~/.local/bin/wrapper/` anpassen

### Inkonsistente Skalierung

- **Problem**: Mehrere DPI-Quellen multiplizieren sich
- **Loesung**: Nur EINEN Skalierungsmechanismus pro Framework verwenden
- **Schriftgroesse** ist auch ein Skalierungsfaktor - nicht gleichzeitig
  Schriftgroesse und DPI/Scale aendern

### Mauszeiger zu klein/gross

```sh
# Aktuellen Wert pruefen
echo $XCURSOR_SIZE

# Falls die automatische Berechnung nicht passt:
# DISPLAY_ADJUST anpassen (beeinflusst auch Cursor-Groesse)
# Oder FORCE_SCALE fuer unabhaengige Cursor-Kontrolle
```

### Firefox/Chromium ignoriert Settings

- **Firefox**: `about:config` -> `layout.css.devPixelsPerPx`
- **Chromium**: Wrapper-Script mit `--force-device-scale-factor`

## Hinweise

- **X11 only**: Diese Konfiguration funktioniert nicht unter Wayland
- **bc erforderlich**: Fuer Fliesskomma-Berechnungen (DPI, Scale, Cursor)
- **Code-Duplizierung**: Die DPI-Rundungs- und Scale-Logik ist in `displayselect`
  dupliziert, da das xprofile nicht gefahrlos gesourced werden kann (startet Programme).
  Ein zukuenftiger Refactoring-Schritt waere die Auslagerung in ein gemeinsames
  `~/.local/lib/dpi-functions.sh`.
