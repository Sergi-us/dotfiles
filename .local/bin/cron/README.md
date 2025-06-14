# Cronjob Hinweise
## 2025-06-14 SARBS

Diese Cronjobs haben Komponenten, die Informationen über Ihr aktuelles Display benötigen, um Benachrichtigungen korrekt anzuzeigen.

Es können eigene Cronjobs angelegt werden und diese können mit `crontag` :

Wenn Sie sie als Cronjobs hinzufügen, empfehle ich Ihnen, dem Befehl die folgenden Befehle voranzustellen:

```
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $USER)/bus; export DISPLAY=:0; . $HOME/.zprofile;  dann_geht_der_befehl_hier_hin
```

Dies stellt sicher, dass Benachrichtigungen angezeigt werden, xdotool-Befehle funktionieren und Umgebungsvariablen ebenfalls funktionieren.

## Setting up Cronjobs

### 1. Install and Start
```
p -S cronie
sudo systemctl enable --now cronie
systemctl status cronie
```

### 2. Syntax verstehen
Crontab-Einträge haben folgendes Format:
Minute Stunde Tag Monat Wochentag Befehl

Jedes Zeitfeld kann folgende Werte haben:

```
* : Jeder mögliche Wert
*/n : Alle n Werte (z.B. */2 für jede zweite Einheit)
n-m : Bereich von n bis m
n,m,o : Liste bestimmter Werte
```

### 3. Beispiele

- Führt das Skript zu jeder vollen Stunde aus
```
0 * * * * $HOME/.local/bin/yt-stats > /dev/null 2>&1
```

- Führt das Skript um 0:00, 6:00, 12:00 und 18:00 Uhr aus
```
0 */6 * * * $HOME/.local/bin/yt-stats > /dev/null 2>&1
```

- Führt das Skript jeden Tag um 3:00 Uhr nachts aus
```
0 3 * * * $HOME/.local/bin/yt-stats > /dev/null 2>&1
```

- Führt das Skript um 9:00, 15:00 und 21:00 Uhr aus
```
0 9,15,21 * * * $HOME/.local/bin/yt-stats > /dev/null 2>&1
```

- Wenn Sie die Ausgabe des Skripts protokollieren möchten:
```
0 * * * * $HOME/.local/bin/yt-stats >> $HOME/.local/share/yt-stats/log.txt 2>&1
```

### Troubleshooting/Fehlersuche
```
grep CRON /var/log/syslog
```
