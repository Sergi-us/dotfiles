# Hellwal – Dynamische Farbverwaltung

Hellwal ist ein in C geschriebener Ersatz für `pywal`. Es extrahiert aus einem Hintergrundbild eine 16-Farben-Palette und generiert daraus Konfigurationsdateien für alle angebundenen Anwendungen.

---

## Architektur

```
setbg (Wallpaper-Wechsel)
  │
  ├── 1. Symlink auf Bild (~/.local/share/bg)
  ├── 2. xwallpaper --zoom       ← Bild sofort sichtbar (~30 ms)
  ├── 3. ImageMagick-Analyse      ← Helligkeit (mean) bestimmen
  ├── 4. hellwal -i <bild> ...    ← Palette extrahieren, Templates rendern
  │      │
  │      ├── Extrahiert 16 Farben aus dem Bild
  │      ├── Rendert alle Templates → ~/.cache/wal/
  │      └── Führt postrun aus
  │            │
  │            ├── xrdb -merge (Xresources)
  │            ├── Symlinks: dunstrc, zathurarc, kitty, alacritty
  │            ├── tut.toml kopieren
  │            ├── Terminal-Farbsequenzen (Indices 256/258/259)
  │            ├── dunst neustarten
  │            └── kitty @ set-colors (IPC)
  │
  ├── 5. kill -USR1 dwm           ← Xresources neu laden
  └── 6. notify-send              ← Benachrichtigung
```

---

## Verzeichnisstruktur

```
.config/hellwal/
├── README.md                 ← Diese Datei
├── postrun                   ← Aktionen nach dem Generieren
├── templates/                ← Vorlagen für alle Anwendungen (32 Dateien)
│   ├── colors.Xresources     ← X11-Ressourcen (st, xrdb)
│   ├── colors-alacritty.toml ← Alacritty-Farben
│   ├── colors-kitty.conf     ← Kitty-Farben
│   ├── colors.sh             ← Shell-Quellbar (sourcebar)
│   ├── colors.css            ← CSS-Variablen (:root)
│   ├── colors-waybar.css     ← Waybar-Farben
│   ├── colors-wal.vim        ← Vim/Neovim-Farben
│   ├── colors-json           ← JSON-Format
│   ├── colors.yml            ← YAML-Format
│   ├── colors.scss           ← Sass/SCSS-Variablen
│   ├── colors.hs             ← Haskell-Farben
│   ├── colors-oomox          ← GTK-Theme-Generator (Oomox)
│   ├── colors-speedcrunch.json ← SpeedCrunch-Theme
│   ├── colors-tty.sh         ← Linux-Console-Farben
│   ├── colors-konsole.colorscheme ← KDE-Konsole
│   ├── colors-putty.reg      ← PuTTY-Registry
│   ├── colors-rofi-dark.rasi ← Rofi (dunkel)
│   ├── colors-sway           ← Sway-WM-Farben
│   ├── colors-tmux.conf      ← tmux-Farben
│   ├── dunstrc               ← Dunst-Benachrichtigungen
│   ├── sequences             ← Escape-Sequenzen (Terminal)
│   ├── superfile.toml        ← Superfile-Dateimanager
│   ├── tmux.conf             ← tmux-Konfiguration (mit Bindings)
│   ├── tut.toml              ← Tut (Mastodon-Client)
│   ├── wal                   ← Symlink auf Wallpaper
│   ├── colors-wal-dwm.h      ← dwm sourceable Header
│   ├── colors-wal-st.h       ← st sourceable Header
│   ├── colors-wal-dmenu.h    ← dmenu sourceable Header
│   └── colors-wal-tabbed.h   ← tabbed sourceable Header
└── themes/                   ← Eigene Themes (optional)
```

---

## Stellschrauben für Anpassungen

### 1. Templates bearbeiten (`templates/`)

Jede Datei in `templates/` ist eine Vorlage. Hellwal ersetzt die Platzhalter durch die extrahierten Farben.
**Die mitgelieferten Templates bleiben original** – Farbmanipulation läuft über
`--dark-offset` und `--bright-offset` in `setbg`.

| Platzhalter | Bedeutung |
|---|---|
| `%%background%%` | Hintergrundfarbe |
| `%%foreground%%` | Vordergrund-/Textfarbe |
| `%%cursor%%` | Cursor-Farbe |
| `%%color0%%` – `%%color15%%` | 16-Farben-Palette (0–7 normal, 8–15 hell) |
| `%%wallpaper%%` | Pfad zum Hintergrundbild |

**Inline-Operationen** (ab v1.0.8) – optional für eigene Templates:
```
%%color1.saturate(0.2).lighten(0.1).hex%%
%%background.sepia(0.5).contrast(1.2).rgb alpha=0.8%%
%%color4.darken(0.15).hex%%
```

Verfügbare Operationen (verketten, links nach rechts):

| Operation | Effekt |
|---|---|
| `saturate(0.2)` | Sättigung +20 % |
| `desaturate(0.3)` | Sättigung −30 % |
| `lighten(0.1)` | Helligkeit +10 % |
| `darken(0.2)` | Helligkeit −20 % |
| `saturation(0.8)` | Sättigung auf 80 % setzen |
| `lightness(0.5)` | Helligkeit auf 50 % setzen |
| `rotate(30)` | Farbton um 30° drehen |
| `complement` | Komplementärfarbe |
| `grayscale` | Graustufen |
| `invert` | Farbe invertieren |
| `sepia(0.5)` | Sepia-Tönung 50 % |
| `contrast(1.2)` | Kontrast ×1,2 |
| `brightness(0.9)` | Helligkeit ×0,9 |

Alpha direkt anhängen: `%%color1.hex alpha=0.5%%`

Einzelne Farbkanäle: `%%color1.r%%`, `%%color1.g%%`, `%%color1.b%%`

### 2. Postrun-Skript anpassen (`.config/hellwal/postrun`)

Das postrun-Skript wird nach dem Generieren ausgeführt. Aktuelle Aktionen:

| Aktion | Zweck |
|---|---|
| `xrdb -merge` | Xresources aktualisieren (für st, xrdb-basierte Apps) |
| Symlinks setzen | dunstrc, zathurarc, kitty, alacritty verlinken |
| tut.toml kopieren | Mastodon-Client-Theme aktualisieren |
| `fix_sequences` | Custom Terminal-Indices (256/258/259) setzen |
| `pkill dunst` + `setsid -f dunst` | Dunst neustarten (neue Geometrie) |
| `kitty @ set-colors` | Kitty-Farben per IPC aktualisieren |

**Anpassungen:** Weitere Symlinks hinzufügen, eigene Dienste neustarten, zusätzliche Aktionen einbauen.

### 3. Farbschema-Optionen in `setbg`

In `~/.local/bin/setbg` werden die hellwal-Parameter gesteuert:

| Option | Standard | Beschreibung |
|---|---|---|
| `--dark` | immer | Dunkles Farbschema erzwingen |
| `--check-contrast` | immer | Mindestkontrast für Lesbarkeit prüfen |
| `--dark-offset 0.35` | lum > 0.40 | Akzentfarben um 35 % abdunkeln (helle Bilder) |
| `--bright-offset 0.25` | lum ≤ 0.40 | Akzentfarben um 25 % aufhellen (dunkle Bilder) |
| `-o ~/.cache/wal/` | fest | Ausgabeverzeichnis |
| `-s <postrun>` | fest | Postrun-Skript-Pfad |
| `-q` | fest | Quiet-Modus (weniger Ausgabe) |

**Helligkeitsbestimmung:** Relative Luminanz (ITU-R BT.709) aus der
Hintergrundfarbe via `hellwal --json` Pre-Flight. Kein ImageMagick mehr.

**Experimentelle Optionen** (in setbg einfügbar):

| Option | Zweck |
|---|---|
| `--dominant-background` | Hintergrundfarbe aus häufigster Bildfarbe |
| `--override-colors color1,color2,background` | Bestimmte Slots mit Wallpaper-Farben überschreiben |
| `--skip-term-colors` | Keine Escape-Sequenzen an Terminals senden |
| `--skip-luminance-sort` | Palette pywal-ähnlicher (weniger vorhersagbar) |
| `--preview` | Farbpalette in Konsole anzeigen |
| `--no-cache` | Cache umgehen (bei Problemen) |

### 4. Eigene Themes verwenden (`themes/`)

Das `themes/`-Verzeichnis ist bereit für vorgefertigte Themes:
```
hellwal -i wallpaper.jpg -t gruvbox.hellwal
```

Mit `--override-colors` lassen sich ausgewählte Slots eines Themes mit Wallpaper-Farben mischen:
```
hellwal -i wallpaper.jpg -t gruvbox.hellwal --override-colors color1,color2,background
```

### 5. Template aktivieren/deaktivieren

Nur Templates, die im `templates/`-Verzeichnis liegen, werden gerendert. Um ein Template zu **deaktivieren**, verschiebe es aus dem Verzeichnis oder benenne es um (z.B. `.disabled`-Endung). Um ein Template **hinzuzufügen**, lege es in `templates/` ab.

### 6. Helligkeitsschwellen anpassen

In `setbg` wird die Helligkeit über eine JSON-Pre-Flight-Analyse bestimmt.
hellwal extrahiert die Palette, daraus wird die relative Luminanz der
Hintergrundfarbe berechnet (ITU-R BT.709):

```sh
# Pre-Flight: JSON-Palette zur Helligkeitsbestimmung
json=$(hellwal -i "$bgloc" --json 2>/dev/null)
bg_color=$(... grep background ...)

# Relative Luminanz (ITU-R BT.709)
lum = 0.2126*R + 0.7152*G + 0.0722*B  (normiert auf 0–1)

if lum > 0.40:  --dark-offset 0.35     # helles Bild
else:           --bright-offset 0.25    # dunkles Bild
```

Schwellenwert (`0.40`) und Offset-Werte (`0.35`, `0.25`) nach Bedarf anpassen.
Kein ImageMagick mehr nötig – alles läuft über hellwals eigene JSON-Ausgabe.

---

## Farbzuordnung

```
color0  = Schwarz (dunkel)        color8  = Hell-Schwarz
color1  = Rot                     color9  = Hell-Rot
color2  = Grün                    color10 = Hell-Grün
color3  = Gelb                    color11 = Hell-Gelb
color4  = Blau                    color12 = Hell-Blau
color5  = Magenta                 color13 = Hell-Magenta
color6  = Cyan                    color14 = Hell-Cyan
color7  = Weiß (hell)             color15 = Hell-Weiß
```

---

## Automatische Helligkeitsanpassung

`setbg` analysiert jedes Bild vorab über `hellwal --json`:

1. **Pre-Flight**: JSON-Ausgabe der 16 Farben ohne Template-Rendering
2. **Luminanz-Berechnung**: ITU-R BT.709 aus der Hintergrundfarbe
3. **Zweistufige Offset-Setzung**:
   - `lum > 0.40` → `--dark-offset 0.35` (helles Bild abdunkeln)
   - `lum ≤ 0.40` → `--bright-offset 0.25` (dunkles Bild aufhellen)

**Kein ImageMagick mehr nötig** – die Konvertierung wurde entfernt.
**Keine Template-Modifikationen** – alle Templates bleiben original.

---

## Fehlerbehebung

| Problem | Lösung |
|---|---|
| Farben erscheinen nicht | `xrdb -merge ~/.cache/wal/colors.Xresources` manuell ausführen |
| Kitty aktualisiert nicht | `kitty @ set-colors ~/.cache/wal/colors-kitty.conf` prüfen |
| Template wird ignoriert | Datei muss in `templates/` liegen, Symlinks sind seit v1.0.8 unterstützt |
| Terminal hängt beim Update | `--skip-term-colors` verwenden |
| Alte Palette bleibt | `~/.cache/hellwal/cache` löschen oder `--no-cache` nutzen |
| Dunst startet nicht | Log prüfen: `${XDG_STATE_HOME}/xsession/dunst.log` |
| Helle Bilder: Text unlesbar | `--dark-offset` erhöhen (z.B. `0.45`) oder Schwellenwert senken |
| Dunkle Bilder: Farben zu dunkel | `--bright-offset` erhöhen (z.B. `0.35`) oder Schwellenwert erhöhen |
| Übergangsbilder kippen falsch | Schwellenwert in `setbg` anpassen (Standard: `0.40`) |

---

## Version

Genutzte Hellwal-Version: **v1.0.8** (September 2026)

Changelog: <https://github.com/danihek/hellwal/releases>
