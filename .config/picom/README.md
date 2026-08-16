# picom: Umstellung von picom-ftlabs-git (AUR) auf extra/picom v13

Diese README dokumentiert die Migration der picom-Konfiguration vom
AUR-Paket `picom-ftlabs-git` (Fork mit eigenen Animationen) auf das
offizielle Arch-Paket `picom` (v13+), durchgeführt am 16.08.2026.

## Dateien in diesem Verzeichnis

| Datei            | Bedeutung                                              |
|------------------|--------------------------------------------------------|
| `picom.conf`     | Aktive Config, migriert auf picom v13                  |
| `picom.conf.bac` | Backup der alten ftlabs-Config                         |
| `picom.conf.priv`| Alte Config (Februar 2025, nur Archiv)                 |
| `README.md`      | Dieses Dokument                                        |

---

## 1. Paket-Änderungen

### Entfernen

```bash
pacman -R picom-ftlabs-git    # AUR-Paket (falls noch installiert)
```

### Installieren

```bash
pacman -S picom               # extra/picom v13+
pacman -S xorg-mkfontscale    # liefert mkfontdir (für den Font-Fix, s.u.)
```

Bereits vorhanden sein sollten (sonst mit installieren):

```bash
pacman -S xorg-fonts-misc xorg-fonts-alias-misc
```

> Hinweis: Das Paket heißt `xorg-mkfontscale`, nicht `xorg-mkfontdir` –
> es stellt beide Binaries bereit (`mkfontdir` und `mkfontscale`).

---

## 2. Config-Migration (picom.conf)

### 2.1 Backend

Die Option `egl` wurde in v13 entfernt. `glx` nutzt automatisch EGL,
wenn verfügbar:

```diff
-backend = "egl";
+backend = "glx";
```

### 2.2 Deprecated Optionen entfernen

```diff
-glx-no-stencil = true;    # in v13 deprecated
```

### 2.3 Animationen: komplett neue Syntax

Die ftlabs-Optionen existieren in v13 nicht mehr:

```
animations = true/false            # jetzt eine Liste von Scripten
animation-stiffness-in-tag
animation-stiffness-tag-change
animation-window-mass
animation-dampening
animation-clamping
animation-for-open-window
animation-for-unmap-window
animation-for-transient-window
animation-for-prev-tag
animation-for-next-tag
enable-fading-prev-tag
enable-fading-next-tag
```

Ersetzt durch das neue Script-System mit **Triggern** und **Presets**:

| Alt (ftlabs)                              | Neu (v13)                              |
|-------------------------------------------|----------------------------------------|
| `animation-for-open-window = "zoom"`      | Trigger `open` + Preset `appear`       |
| `animation-for-unmap-window = "minimize"` | Trigger `close` + Preset `disappear`   |
| `animation-for-prev-tag = "minimize"`     | Trigger `hide` + Preset `disappear`    |
| `animation-for-next-tag = "slide-in-center"` | Trigger `show` + Preset `slide-in`  |
| `animation-for-transient-window`          | `rules`-Eintrag mit `WM_TRANSIENT_FOR@`|

Verfügbare Presets: `appear`, `disappear`, `slide-in`, `slide-out`,
`fly-in`, `fly-out`, `geometry-change` (Details: `man picom`,
Abschnitt ANIMATIONS). Tuning über `duration` (Sekunden) und `scale`
statt Feder-Physik (stiffness/mass/dampening).

Beispiel:

```
animations = ({
    triggers = [ "open" ];
    preset = "appear";
    scale = 0.5;
    duration = 0.3;
}, {
    triggers = [ "close", "hide" ];
    preset = "disappear";
    scale = 0.5;
    duration = 0.3;
}, {
    triggers = [ "show" ];
    preset = "slide-in";
    direction = "up";
    duration = 0.3;
});
```

> Hinweis für dwm: Tag-Wechsel triggern `hide` (alter Tag, Fenster
> werden ungemappt) und `show` (neuer Tag, Fenster werden gemappt).

### 2.4 Fenster-Regeln: alles in `rules` zusammenführen

**Wichtig:** Sobald die Option `rules` gesetzt ist, werden die alten
Regel-Optionen in v13 **komplett ignoriert** (mit Warnung):

- `opacity-rule`
- `corner-radius-rules`
- `rounded-corners-exclude`
- `wintypes`

Alles muss ins neue `rules`-System migriert werden. Syntax:

```
rules = ({
    match = "BEDINGUNG";
    opacity = 0.85;        # jetzt 0.0-1.0 statt 0-100
    corner-radius = 10;
    shadow = false;
    fade = true;
}, {
    match = "...";
    ...
});
```

**Achtung – Semantik-Änderung:** Bei `rules` werden alle passenden
Regeln angewendet, die **letzte** gewinnt. Bei den alten Optionen
(`opacity-rule` etc.) gewann der **erste** Treffer. Die Reihenfolge
der Regeln muss daher ggf. umgedacht werden (allgemeine Regeln zuerst,
spezifische danach).

Mapping der wintypes-Optionen:

| Alt (wintypes)                          | Neu (rules)                                  |
|-----------------------------------------|----------------------------------------------|
| `tooltip = { opacity = 0.85; ... }`     | `match = "window_type = 'tooltip'"`          |
| `dock = { shadow = false; }`            | `match = "window_type = 'dock'"`             |
| `focus = true` (tooltip etc.)           | entfällt – in v13 für alle Typen außer `normal`/`dialog` der Default |

---

## 3. Font-Fix: "Cannot open the bold font"

picom v13 zeigt Config-Warnungen zusätzlich als On-Screen-Meldung und
lädt dafür die X-Core-Fonts `fixed` und `-*-fixed-bold-*`. Auf Arch
ist der Font-Path des X-Servers standardmäßig nur `built-ins`, und
`/usr/share/fonts/misc` hat kein `fonts.dir` – der Bold-Font wird
nicht gefunden:

```
[ ui_new ERROR ] Cannot open the bold font, falling back to normal font
```

Fix (einmalig, als root):

```bash
pacman -S xorg-mkfontscale xorg-fonts-misc xorg-fonts-alias-misc
mkfontdir /usr/share/fonts/misc
```

Damit der X-Server das Verzeichnis auch nutzt, den Font-Path beim
Session-Start erweitern (z.B. in `~/.xprofile` bzw. `~/.xinitrc`,
**vor** dem picom-Start):

```bash
xset fp+ /usr/share/fonts/misc 2>/dev/null
```

> Hintergrund: Ein Font-Path-Eintrag OHNE `fonts.dir` (nur `fonts.alias`)
> führt zu fehlerhaftem Wildcard-Matching in libXfont2 – dann schlagen
> auch Muster wie `-*-fixed-bold-*` fehl, obwohl der Font existiert.
> `mkfontdir` erzeugt das fehlende `fonts.dir` und löst das Problem.

---

## 4. Start / Test

**Wichtig:** Nach dem Paket-Wechsel läuft der alte ftlabs-picom weiter
(Prozess mit altem Binary). Vor dem ersten Start des neuen picom:

```bash
pkill -x picom
```

Dann testen (Vordergrund, Ausgaben bleiben sichtbar):

```bash
picom
```

Bei sauberer Config: keine Ausgabe. Danach dauerhaft:

```bash
picom -b
```

Verifikation:

```bash
picom --diagnostics        # zeigt Backend, Rules, Config-Pfad
pgrep -x picom             # Prozess muss laufen
```

### Checkliste für das Test-System

- [ ] `picom-ftlabs-git` entfernt, `picom` v13+ installiert
- [ ] `xorg-mkfontscale` installiert, `mkfontdir /usr/share/fonts/misc` ausgeführt
- [ ] `xset fp+ /usr/share/fonts/misc` im Session-Start (xprofile/xinitrc)
- [ ] `picom.conf`: `backend = "glx"`, kein `glx-no-stencil`, keine ftlabs-Optionen mehr
- [ ] Alle Fenster-Regeln in `rules` (keine Mischung mit `opacity-rule` & Co.)
- [ ] Alter picom-Prozess gekillt (`pkill -x picom`), neuer startet ohne Warnungen
- [ ] Animationen beim Fensteröffnen/-schließen und Tag-Wechsel sichtbar
