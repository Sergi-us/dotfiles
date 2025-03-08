# Important Note
## 2025-01-09 SARBS

These cronjobs have components that require information about your current display to display notifications correctly.

When you add them as cronjobs, I recommend you precede the command with commands as those below:

```
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $USER)/bus; export DISPLAY=:0; . $HOME/.zprofile;  then_command_goes_here
```

This ensures that notifications will display, xdotool commands will function and environmental variables will work as well.

## Cronjob einrichten

### 1. Instalieren und Starten
```
p -S cronie
sudo systemctl enable --now cronie
systemctl status cronie
```

### 2. Syntax verstehen
Crontab-Einträge haben folgendes Format:
Minute Stunde Tag Monat Wochentag Befehl
Jedes Zeitfeld kann folgende Werte haben:

``
* : Jeder mögliche Wert
*/n : Alle n Werte (z.B. */2 für jede zweite Einheit)
n-m : Bereich von n bis m
n,m,o : Liste bestimmter Werte
``

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

- Wenn du die Ausgabe des Skripts protokollieren möchtest:
```
0 * * * * $HOME/.local/bin/yt-stats >> $HOME/.local/share/yt-stats/log.txt 2>&1
```

### Fehlerbehebung
```
grep CRON /var/log/syslog
```
