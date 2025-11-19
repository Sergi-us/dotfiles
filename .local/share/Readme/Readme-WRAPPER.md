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
Normale Apps: Nutzen 192 DPI direkt
↓
Wrapper Apps: Nutzen SCALE_FACTOR (z.B. 1.5)
Effektiv: 144 DPI statt 192 DPI
```

### Verwendung

#### Globale Einstellung
In `~/.config/x11/xprofile`:

```bash
MASTER_DPI=192          # System-DPI
SCALE_FACTOR=1.5        # Für Wrapper-Skripte
```
### App-spezifische Überschreibung
In jedem Wrapper-Skript:

```bash
# Auskommentiert = nutze xprofile Wert
# SCALE_FACTOR=1.75

# Aktiv = überschreibe xprofile
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

1. Lokale Variable im Skript (wenn gesetzt)
2. SCALE_FACTOR aus xprofile
3. Hartcodierter Fallback (1.5)

## Tipps

- Integer Scaling (1.0, 2.0) funktioniert am besten
- Fractional Scaling (1.5, 1.75) kann zu Unschärfen führen
- Bei Problemen: App-spezifischen Wert im Wrapper setzen
