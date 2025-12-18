# HiDPI Wrapper Scripts
## 2025-08-23

## TODO: MIME-Type basierte Anwendungsauswahl
**Problem**: Rofi's `drun` Mode nutzt .desktop-Dateien, die fest auf Binaries zeigen.
Nach Wrapper-Installation existieren doppelte Einträge oder falsche Verlinkungen.

**Aufgaben**:
- [ ] MIME-Type Associations für Wrapper konfigurieren
- [ ] Default-Applications für verschiedene Dateitypen setzen
- [ ] Desktop-Dateien konsolidieren (keine Duplikate in Rofi)

**Beispiel-Struktur**:
```bash
~/.local/share/applications/
├── chromium.desktop        # Zeigt auf Wrapper
├── mimeapps.list           # Definiert Standard-Apps für Dateitypen
└── mimeinfo.cache          # Cache für MIME-Associations
```

### Workaround: rofi -show run nutzt PATH statt .desktop-Dateien

Referenz:

xdg-mime query default text/html - Zeigt Standard-Browser
xdg-settings set default-web-browser chromium.desktop
Arch Wiki: [Default Applications](https://wiki.archlinux.org/title/Default_applications)



## Wrapper Konzept
Die Wrapper-Skripte ermöglichen individuelle Skalierung für spezifische Anwendungen bei einem DPI-Only Setup.

### Warum Wrapper?
Bei hochauflösenden Displays (HiDPI) skalieren nicht alle Anwendungen korrekt:
- **System-DPI**: 192 (2× Skalierung) für native Anwendungen
- **Problem**: Manche Apps (Browser, Electron) werden zu groß
- **Lösung**: Wrapper mit reduziertem Skalierungsfaktor

### Architektur
```
System: xrandr --dpi 192 (MASTER_DPI)
↓
.xprofile: Berechnet SCALE_FACTOR automatisch
↓
State-Datei: ~/.local/state/xsession/scale (enthält z.B. "1.5")
↓
Wrapper Apps: Lesen SCALE_FACTOR aus State-Datei
Effektiv: Reduzierte Skalierung für problematische Apps
```

### Verwendung

#### Automatische Erkennung (Standard)
In `~/.xprofile` werden DPI und SCALE_FACTOR automatisch berechnet:

```bash
# Automatische Erkennung basierend auf Display
MASTER_DPI=$(calculate_auto_dpi)      # z.B. 192
SCALE_FACTOR=$(calculate_scale_factor) # z.B. 1.5

# State-Datei für Wrapper-Skripte
echo "$SCALE_FACTOR" > ~/.local/state/xsession/scale
echo "$MASTER_DPI" > ~/.local/state/xsession/dpi
```

#### Manuelle Überschreibung
**Global** (in ~/.zprofile oder ~/.xprofile):
```bash
export FORCE_DPI=192
export FORCE_SCALE=1.5
```

**App-spezifisch** (in jedem Wrapper-Skript):
```bash
# Auskommentiert = nutze State-Datei
# SCALE_FACTOR=1.75

# Aktiv = überschreibe Auto-Erkennung
SCALE_FACTOR=2.0
```

### Unterstützte Anwendungen
#### Chromium-basierte Browser

- Chromium, Brave, Vivaldi
- Flag: --force-device-scale-factor
- Typischer Faktor: 1.5 bei 192 DPI

#### Firefox-basierte Browser
- Firefox, Librewolf
- Variable: GDK_DPI_SCALE
- Typischer Faktor: 1.5 bei 192 DPI

#### Qt-Anwendungen
- Telegram, KeePassXC
- Variable: QT_SCALE_FACTOR
- Typischer Faktor: 1.0-2.0

### Installation
1. Wrapper in ~/.local/bin/wrapper/ ablegen
2. Desktop-Dateien anpassen:
	```bash
	cp /usr/share/applications/app.desktop ~/.local/share/applications/
	# Exec-Zeile auf Wrapper zeigen lassen
	```

3. Desktop-Datenbank updaten:
	```bash
	update-desktop-database ~/.local/share/applications/
	```

### Debugging
	```bash
	# Qt-Apps: Skalierung prüfen
	QT_LOGGING_RULES="qt.qpa.*=true" telegram | grep devicePixelRatio

	# Aktuelle DPI anzeigen
	xrdb -query | grep dpi

	# Welcher Binary wird genutzt
	which -a chromium
	```

### Fallback-Hierarchie

1. Lokale Variable im Skript (wenn manuell gesetzt)
2. SCALE_FACTOR aus State-Datei (~/.local/state/xsession/scale)
3. Hartcodierter Fallback (1.5)

### State-Dateien
Die automatisch berechneten Werte werden in `~/.local/state/xsession/` gespeichert:
- `scale` - Skalierungsfaktor (z.B. "1.5")
- `dpi` - System-DPI (z.B. "192")

Diese Dateien werden bei jedem X-Start von `.xprofile` neu geschrieben.

## Tipps

- Integer Scaling (1.0, 2.0) funktioniert am besten
- Fractional Scaling (1.5, 1.75) kann zu Unschärfen führen
- Bei Problemen: App-spezifischen Wert im Wrapper setzen
