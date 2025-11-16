#!/bin/sh

# Beende alle laufenden Polybar-Instanzen
killall -q polybar

# Warte bis alle Polybar-Prozesse wirklich beendet sind
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Starte Polybar mit der "main" Bar aus deiner config.ini
polybar main 2>&1 | tee -a /tmp/polybar.log & disown

echo "Polybar gestartet..."
