# Systemd Timer Anleitung

## 2026-08-07 SARBS

Systemd Timer ersetzen Cronjobs und bieten bessere Logging, Abhängigkeitsmanagement
und Flexibilität. Sie bestehen immer aus zwei Dateien:
- **.service** – definiert WAS ausgeführt wird
- **.timer** – definiert WANN es ausgeführt wird

---

## User-Timer vs System-Timer

| Aspekt                         | User-Timer                | System-Timer                   |
|--------------------------------|---------------------------|--------------------------------|
| Speicherort                    | `~/.config/systemd/user/` | `/etc/systemd/system/`         |
| Ausführung                     | Als aktueller Nutzer      | Als root                       |
| Aktivierung                    | `systemctl --user`        | `sudo systemctl`               |
| Neustart nötig                 | Nein                      | Ja (`systemctl daemon-reload`) |
| Umgebungsvariablen             | Vollständig vorhanden     | Eingeschränkt                  |
| GUI-Zugriff (DISPLAY, xdotool) | Ja                        | Nur mit Konfiguration          |

**Empfehlung:** User-Timer bevorzugen, es gibt zwingende Gründe für root.

---

## Häufige Timer-Optionen

### OnCalendar (Ersatz für Cron-Syntax)
```
*-*-* HH:MM:SS				# Exakter Zeitpunkt
*-*-* *:00:00				# Jede volle Stunde
*-*-* 00,06,12,18:00:00		# Alle 6 Stunden
Mon *-*-* 03:00:00			# Jeden Montag um 3 Uhr
daily						# Täglich um 00:00
weekly						# Wöchentlich
monthly						# Monatlich
```

### Weitere Optionen
- `Persistent=true` – Verpasste Ausführung nachholen (wie cron's @reboot catch-up)
- `OnBootSec=5min` – 5 Minuten nach Systemstart
- `OnUnitActiveSec=1h` – Alle 1 Stunde nach letzter Ausführung
- `RandomizedDelaySec=5min` – Zufällige Verzögerung (verhindert Lastspitzen)

---

## Wichtige Befehle

```bash
# Timer aktivieren/starten
systemctl --user enable --now mein-script.timer

# Status prüfen
systemctl --user status mein-script.timer

# Alle Timer auflisten
systemctl --user list-timers --all

# Logs anzeigen
journalctl --user -u mein-script.service

# Timer-Trigger manuell auslösen
systemctl --user start mein-script.service
```

---

## Bestehende Cronjobs

### 1. newsup (RSS-Feed-Update)
**Status:** Direkt als User-Timer umstellbar
**Zeitplan:** Alle 30 Minuten
**Besonderheit:** Benötigt DISPLAY/xdotool für Newsraft-Reload

### 2. checkup (Paket-Updates)
**Status:** Benötigt sudo für pacman
**Zeitplan:** Täglich
**Problem:** `sudo` in User-Timer fragt nach Passwort
**Lösung:** Siehe `sudoers`-Konfiguration unten

### 3. crontog (Cron-Toggle)
**Status:** Obsolet nach Umstellung auf systemd Timer
**Ersatz:** `systemctl --user start/stop` Befehle oder eigenes Toggle-Skript

---

### 4. mailbox (E-Mail-Synchronisierung)
**Status:** User-Timer mit bedingter Ausführung
**Zeitplan:** Alle 15 Minuten
**Besonderheit:** Wird nur ausgeführt wenn Mail-Accounts konfiguriert sind
**Mechanismus:** `ConditionPathExists` + `ExecStartPre` Check-Skript

---

## Bedingte Ausführung (nur wenn konfiguriert)

Für Timer die nur auf bestimmten Systemen laufen sollen (z.B. Mail-Sync):

### Ansatz 1: ConditionPathExists
```ini
[Unit]
ConditionPathExists=%h/.mbsyncrc
ConditionPathExistsGlob=%h/.config/mbsync/config
```
Der Service wird **nicht gestartet** wenn die Dateien nicht existieren.

### Ansatz 2: ExecStartPre mit Check-Skript
```ini
[Service]
ExecStartPre=/usr/local/bin/mail-sync-check
```
Das Skript muss mit Exit-Code 0 erfolgreich sein, sonst wird ExecStart nicht ausgeführt.

### Beispiel: mail-sync-check
```sh
#!/bin/sh
# Prüfe ob Accounts konfiguriert sind
mbsyncrc="${MBSYNCRC:-$HOME/.mbsyncrc}"
if ! grep -q "^\(Channel\|account\)" "$mbsyncrc" 2>/dev/null; then
    exit 1  # Keine Accounts → Service wird nicht ausgeführt
fi
exit 0
```

---

## Setup-Schritte

1. Service- und Timer-Dateien nach `~/.config/systemd/user/` kopieren
2. Für checkup: sudoers-Konfiguration erstellen (optional)
3. Timer aktivieren:
   ```bash
   systemctl --user daemon-reload
   systemctl --user enable --now newsup.timer
   systemctl --user enable --now checkup.timer
   ```
4. Status prüfen: `systemctl --user list-timers`

---

## Troubleshooting

```bash
# Service-Logs anzeigen
journalctl --user -u newsup.service -f

# Timer-Status detailliert
systemctl --user show newsup.timer

# Umgebungsvariablen prüfen (im Service-Kontext)
systemctl --user show-environment

# Fehlende Variablen setzen (z.B. DISPLAY)
systemctl --user setenv DISPLAY :0
```
