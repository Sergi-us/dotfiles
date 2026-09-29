# Hellwal – Dynamische Farbverwaltung
## 2026-09-29
# TODO Original Hellwall vorlagen einpflegen

Hellwal ist ein in C geschriebener Ersatz für `pywal`. Es extrahiert aus einem
Hintergrundbild eine 16-Farben-Palette und generiert daraus
Konfigurationsdateien für alle angebundenen Anwendungen.

---

## Architektur

```
setbg (Wallpaper-Wechsel)
  │
  ├── 1. Symlink auf Bild (~/.local/share/bg)
  ├── 2. xwallpaper --zoom       ← Bild sofort sichtbar (~30 ms)
  ├── 3. hellwal -i <bild>       ← Palette extrahieren, Templates rendern
  │      │   (--dark --check-contrast, keine Helligkeitserkennung)
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
  ├── 4. kill -USR1 dwm           ← Xresources neu laden
  └── 5. notify-send              ← Benachrichtigung
```

---

## Verzeichnisstruktur

```
.config/hellwal/
├── README.md						← Diese Datei
├── postrun							← Aktionen nach dem Generieren
├── templates/						← Vorlagen für alle Anwendungen (32 Dateien)
│   ├── colors.Xresources			← X11-Ressourcen (st, xrdb)
│   ├── colors-alacritty.toml		← Alacritty-Farben
│   ├── colors-kitty.conf			← Kitty-Farben
│   ├── colors.sh					← Shell-Quellbar (sourcebar)
│   ├── colors.css					← CSS-Variablen (:root)
│   ├── colors-waybar.css			← Waybar-Farben
│   ├── colors-wal.vim				← Vim/Neovim-Farben
│   ├── colors-json					← JSON-Format
│   ├── colors.yml					← YAML-Format
│   ├── colors.scss					← Sass/SCSS-Variablen
│   ├── colors.hs					← Haskell-Farben
│   ├── colors-oomox				← GTK-Theme-Generator (Oomox)
│   ├── colors-speedcrunch.json		← SpeedCrunch-Theme
│   ├── colors-tty.sh				← Linux-Console-Farben
│   ├── colors-konsole.colorscheme	← KDE-Konsole
│   ├── colors-putty.reg			← PuTTY-Registry
│   ├── colors-rofi-dark.rasi		← Rofi (dunkel)
│   ├── colors-rofi-light.rasi		← Rofi (dunkel)
│   ├── colors-sway					← Sway-WM-Farben
│   ├── colors-tmux.conf			← tmux-Farben
│   ├── dunstrc						← Dunst-Benachrichtigungen
│   ├── sequences					← Escape-Sequenzen (Terminal)
│   ├── superfile.toml				← Superfile-Dateimanager
│   ├── tmux.conf					← tmux-Konfiguration (mit Bindings)
│   ├── tut.toml					← Tut (Mastodon-Client)
│   ├── wal							← Symlink auf Wallpaper
│   ├── colors-wal-dwm.h			← dwm sourceable Header
│   ├── colors-wal-st.h				← st sourceable Header
│   ├── colors-wal-dmenu.h			← dmenu sourceable Header
│   └── colors-wal-tabbed.h			← tabbed sourceable Header
└── themes/							← Eigene Themes (optional)
```

---

## Stellschrauben für Anpassungen

### 1. Templates bearbeiten (`templates/`)

Jede Datei in `templates/` ist eine Vorlage. Hellwal ersetzt die Platzhalter
durch die extrahierten Farben.
**Die mitgelieferten Templates bleiben original** – globale Farbsteuerung läuft
ausschließlich über `--dark --check-contrast` in `setbg` (Empfehlung A).

| Platzhalter                  | Bedeutung                                 |
|------------------------------|-------------------------------------------|
| `%%background%%`             | Hintergrundfarbe                          |
| `%%foreground%%`             | Vordergrund-/Textfarbe                    |
| `%%cursor%%`                 | Cursor-Farbe                              |
| `%%color0%%` – `%%color15%%` | 16-Farben-Palette (0–7 normal, 8–15 hell) |
| `%%wallpaper%%`              | Pfad zum Hintergrundbild                  |

**Inline-Operationen** (ab v1.0.8) – optional für eigene Templates:
```
%%color1.saturate(0.2).lighten(0.1).hex%%
%%background.sepia(0.5).contrast(1.2).rgb alpha=0.8%%
%%color4.darken(0.15).hex%%
```

Verfügbare Operationen (verketten, links nach rechts):

| Operation         | Effekt                     |
|-------------------|----------------------------|
| `saturate(0.2)`   | Sättigung +20 %            |
| `desaturate(0.3)` | Sättigung −30 %            |
| `lighten(0.1)`    | Helligkeit +10 %           |
| `darken(0.2)`     | Helligkeit −20 %           |
| `saturation(0.8)` | Sättigung auf 80 % setzen  |
| `lightness(0.5)`  | Helligkeit auf 50 % setzen |
| `rotate(30)`      | Farbton um 30° drehen      |
| `complement`      | Komplementärfarbe          |
| `grayscale`       | Graustufen                 |
| `invert`          | Farbe invertieren          |
| `sepia(0.5)`      | Sepia-Tönung 50 %          |
| `contrast(1.2)`   | Kontrast ×1,2              |
| `brightness(0.9)` | Helligkeit ×0,9            |

Alpha direkt anhängen: `%%color1.hex alpha=0.5%%`

Einzelne Farbkanäle: `%%color1.r%%`, `%%color1.g%%`, `%%color1.b%%`

### 2. Postrun-Skript anpassen (`.config/hellwal/postrun`)

Das postrun-Skript wird nach dem Generieren ausgeführt. Aktuelle Aktionen:

| Aktion                            | Zweck                                                 |
|-----------------------------------|-------------------------------------------------------|
| `xrdb -merge`                     | Xresources aktualisieren (für st, xrdb-basierte Apps) |
| Symlinks setzen                   | dunstrc, zathurarc, kitty, alacritty verlinken        |
| tut.toml kopieren                 | Mastodon-Client-Theme aktualisieren                   |
| `fix_sequences`                   | Custom Terminal-Indices (256/258/259) setzen          |
| `pkill dunst` + `setsid -f dunst` | Dunst neustarten (neue Geometrie)                     |
| `kitty @ set-colors`              | Kitty-Farben per IPC aktualisieren                    |

**Anpassungen:** Weitere Symlinks hinzufügen, eigene Dienste neustarten, zusätzliche Aktionen einbauen.

### 3. Farbschema-Optionen in `setbg`

In `~/.local/bin/setbg` werden die hellwal-Parameter gesteuert:

| Option             | Standard | Beschreibung                                                                     |
|--------------------|----------|----------------------------------------------------------------------------------|
| `--dark`           | immer    | Dunkles Farbschema erzwingen                                                     |
| `--check-contrast` | immer    | hellwal prüft jede Akzentfarbe gegen den Hintergrund und korrigiert nur wo nötig |
| `-o ~/.cache/wal/` | fest     | Ausgabeverzeichnis                                                               |
| `-s <postrun>`     | fest     | Postrun-Skript-Pfad                                                              |
| `-q`               | fest     | Quiet-Modus (weniger Ausgabe)                                                    |

**Bewusst keine Offsets** (`--dark-offset`/`--bright-offset`) und keine
Helligkeitserkennung: Sie verändern die gesamte Palette inklusive Foreground
und machten dunkle Bilder in Tests flach bzw. matschig. `--check-contrast`
korrigiert gezielt nur die Farben, die wirklich unlesbar wären.

**Experimentelle Optionen** (in setbg einfügbar):

| Option                                       | Zweck                                              |
|----------------------------------------------|----------------------------------------------------|
| `--dominant-background`                      | Hintergrundfarbe aus häufigster Bildfarbe          |
| `--override-colors color1,color2,background` | Bestimmte Slots mit Wallpaper-Farben überschreiben |
| `--skip-term-colors`                         | Keine Escape-Sequenzen an Terminals senden         |
| `--skip-luminance-sort`                      | Palette pywal-ähnlicher (weniger vorhersagbar)     |
| `--preview`                                  | Farbpalette in Konsole anzeigen                    |
| `--no-cache`                                 | Cache umgehen (bei Problemen)                      |

### 4. Eigene Themes verwenden (`themes/`)

Das `themes/`-Verzeichnis ist bereit für vorgefertigte Themes:
```
hellwal -i wallpaper.jpg -t gruvbox.hellwal
```

Mit `--override-colors` lassen sich ausgewählte Slots eines Themes mit
Wallpaper-Farben mischen:
```
hellwal -i wallpaper.jpg -t gruvbox.hellwal --override-colors color1,color2,background
```

### 5. Template aktivieren/deaktivieren

Nur Templates, die im `templates/`-Verzeichnis liegen, werden gerendert. Um ein
Template zu **deaktivieren**, verschiebe es aus dem Verzeichnis oder benenne es
um (z.B. `.disabled`-Endung). Um ein Template **hinzuzufügen**, lege es in
`templates/` ab.

### 6. Helligkeitserkennung: bewusst entfernt

Frühere Fassungen bestimmten die Bildhelligkeit und setzten Offsets
(`--dark-offset`/`--bright-offset`). Beides ist entfernt:

- **JSON-Pre-Flight war toter Code:** Das grep-Muster passte nie auf hellwals
  pretty-printed JSON (`"background": "#..."` mit Leerzeichen) – die Offsets
  wurden nie angewendet.
- **Konzeptioneller Fehler:** Im `--dark`-Modus ist `background` per
  Konstruktion die dunkelste Palettefarbe – eine Luminanzmessung daran kann
  helle und dunkle Bilder gar nicht unterscheiden.
- **Messbar schädlich:** `--dark-offset` dunkelt auch den Foreground ab
  (weiß → grau), `--bright-offset` macht dunkle Bilder flach. Siehe Messwerte
  im Abschnitt „Einheitliche Farbanpassung".

Heute gilt einheitlich Empfehlung A: `--dark --check-contrast`.

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

## Einheitliche Farbanpassung (Empfehlung A)

`setbg` nutzt für alle Bilder dieselben Optionen:

```sh
hellwal_opts="--dark --check-contrast"
```

- `--dark`: Hintergrund dunkel, Vordergrund hell; color0/color15 sind immer
  die Extreme der Palette.
- `--check-contrast`: hellwal prüft jede Akzentfarbe gegen den Hintergrund
  und korrigiert nur wo nötig – keine pauschalen Offsets.

### Messwerte (WCAG-Kontrast, weißer Text auf Akzentfarbe)

| Bild              | A: `--dark --check-contrast` | E: zusätzlich `--dark-offset 0.35` |
|-------------------|------------------------------|------------------------------------|
| dunkel (art-8858) | **6.3 / 4.0 / 9.4 :1**       | 3.7 / 2.8 / 4.6 :1                 |
| hell (ogg3zp)     | **3.7 / 3.6 / 3.4 :1**       | 2.2 / 2.1 / 2.0 :1                 |
| mittel (po7q59)   | **4.1 / 4.1 / 3.5 :1**       | 3.0 / 2.9 / 2.0 :1                 |

Reihenfolge: Rofi-Auswahl / Zathura-Highlight / Dunst-low. A gewinnt auf
ganzer Linie; E bricht ein, weil der Foreground zu Grau abdunkelt.
Restrisiko hell: 3.4–4.1:1 – okay für UI-Elemente, unter WCAG 4.5:1 für
Kleintext. Bei Bedarf als nächster Einzelschritt: strukturelle
Template-Anpassung (dunkle Schrift auf hellen Auswahl-Hintergründen).

---

## Fehlerbehebung

| Problem                             | Lösung                                                                                                  |
|-------------------------------------|---------------------------------------------------------------------------------------------------------|
| Farben erscheinen nicht             | `xrdb -merge ~/.cache/wal/colors.Xresources` manuell ausführen                                          |
| Kitty aktualisiert nicht            | `kitty @ set-colors ~/.cache/wal/colors-kitty.conf` prüfen                                              |
| Template wird ignoriert             | Datei muss in `templates/` liegen, Symlinks sind seit v1.0.8 unterstützt                                |
| Terminal hängt beim Update          | `--skip-term-colors` verwenden                                                                          |
| Alte Palette bleibt                 | `~/.cache/hellwal/cache` löschen oder `--no-cache` nutzen                                               |
| Dunst startet nicht                 | Log prüfen: `${XDG_STATE_HOME}/xsession/dunst.log`                                                      |
| Akzentfarbe auf hellem Bild zu hell | `--check-contrast` wirkt automatisch; für Einzelfälle Template-Inlines wie `%%color2.darken(0.2).hex%%` |
| Less-Statuszeile unlesbar           | `LESS_TERMCAP_so` in `shell/profile` (Option D, Truecolor aus colors.sh)                                |
| Palette wirkt matschig              | Keine Offsets setzen – sie sind bewusst entfernt (siehe Abschnitt 6)                                    |

---

## Integrationen außerhalb von postrun

Nicht alles wird über postrun verteilt. Diese Stellen lesen die Palette
ebenfalls – bewusst dokumentiert, weil sie außerhalb liegen:

| Stelle | Mechanismus | Status |
|---|---|---|
| `shell/profile` (Option D) | sourct `~/.cache/wal/colors.sh`, setzt `LESS_TERMCAP_so` als Truecolor: Grund = color15, Schrift = color0 (Reverse-Video-Look, palettenexakt; Kontrast durch `--dark` garantiert). `LESS_TERMCAP_se` = Reset ist zwingend, da terminfo-rmso nur Reverse-Video ausschaltet. Wirkt ab neuem Login/Terminal. | aktiv |
| `shell/profile` LESS_TERMCAP_mb/md/us/so (alt) | ANSI-Slot-Rezept (z.B. `01;44;33` = Grund Slot 4, Schrift Slot 3) – auskommentiert, weil statische Slots bei dynamischer Palette kollabieren können (gemessen: 1.03:1 auf po7q59) | deaktiviert |
| `.config/wal/.hooks/less-contrast.sh` | altes Pywal-Hook für dieselbe Baustelle – Hellwal führt Pywal-Hooks nicht aus | tot |

---

## Audit: Statische Farben vs. Hellwal (2026-09-26)

### A. Kollidiert mit dem Konzept

| Datei | Statik | Wirkung |
|---|---|---|
| `nvim/lua/config/sarbs.lua:135-137`, `nvim/lua/plugins/zen-mode.lua:64-66` | `#e0def4`, `#444a73` hardcodiert (Rosé-Pine-Rest) | Zen-Mode malt feste Farben über jedes Wallpaper-Thema |
| `nvim/lua/plugins/zen-mode.lua:107` | `colorscheme pywal` | Theme existiert nicht (`~/.config/nvim/colors/` fehlt); das `colors-wal.vim`-Template wird nirgendwo installiert |
| `nvim/init.lua:121`, sarbs.lua | Default `tokyonight` | Neovim folgt hellwal derzeit gar nicht – größte Lücke |
| `kitty/kitty.conf:29,54` | `cursor #add8e6`, `url_color #83a598` | cursor wird vom späteren `include colors-kitty.conf` überstimmt (≈ harmlos); url_color bleibt statisch |
| `qt5ct/` + `qt6ct/colors/darker.conf` | feste Qt-Palette | Qt-Apps folgen hellwal nie (keine dynamische Gegenstelle aktiv) |
| `rmpc/themes/sarbs.ron:45,47` | `#1e2030` | MPD-Client-Theme statisch |
| außerhalb des Repos: `~/.local/src/DWM-local/config.h`, `st-DEV`, `dmenu`, `tabbed` | kompilierte Farbschemata | dwm-Rahmen/-Menus statisch; die `colors-wal-dwm.h`/`-st.h`-Templates werden nicht includiert |

### B. Bereits sauber (nicht anfassen)

- `x11/xresources`: alle statischen Themes auskommentiert
- `rofi/config.rasi`: importiert `~/.cache/wal/colors-rofi-dark.rasi`
- `tut/config.toml`: `theme="pywal-generated"` (postrun liefert dynamisch)
- zsh-Prompt, Statusbar-Skripte, lf, fastfetch: ANSI-basiert, palettenkompatibel
- dunst/zathura/kitty/alacritty-Farben: Symlinks/Includes aus `~/.cache/wal/`

### C. Tote Reste (funktionslos, aber unübersichtlich)

- `.config/wal/` inkl. `.hooks/` – Pywal-Ära; Hooks laufen unter hellwal nie
- `polybar/config.ini` – polybar wird nirgends gestartet
- `alacritty.toml:243` bell `#ffffff` – unsichtbar (duration 0), harmlos

---

## Empfehlungen / Roadmap (Meinung)

Ziel: Farben komplett über hellwal steuern. Statische Reste nach DEV-Philosophie
**auskommentieren, nicht löschen**. Vorgeschlagene Reihenfolge:

1. **Kitty** (`kitty.conf:29,54`): beide Zeilen kommentieren – Mini-Eingriff,
   entfernt statische Fallbacks (cursor-Fallback `#add8e6` könnte bei
   fehlendem Symlink sonst wieder auftauchen).
2. **Neovim als eigenes Teilprojekt**: postrun installiert `colors-wal.vim`
   nach `~/.config/nvim/colors/wal.vim` (wie bei tut), Default-Theme auf
   `wal`, Zen-Mode-Hexzeilen kommentieren. Größerer Eingriff – separat
   testen, nicht nebenbei.
3. **Qt + suckless bewusst offen lassen**: Qt bräuchte eine eigene Pipeline
   (das oomox-Template liegt bereit); dwm/st sind Build-Verzeichnisse
   außerhalb des Repos. Nichts heimlich ändern.
4. **Tote Reste** (`.config/wal/`, polybar) erst in einer TESTING-Bereinigung
   anfassen, nicht jetzt.

---

## Version

Genutzte Hellwal-Version: **v1.0.8** (September 2026)

Changelog: <https://github.com/danihek/hellwal/releases>
