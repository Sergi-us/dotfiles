#!/bin/sh
# Hook-Skript für Pywal zum Anpassen der LESS_TERMCAP-Statuszeilenfarben.

# Lese die generierten Pywal-Farben ein:
source "${HOME}/.cache/wal/colors.sh"

# Setze kontrastreiche Farben für LESS:
export LESS_TERMCAP_so=$(printf '\e[1;48;2;%d;%d;%dm\e[38;2;%d;%d;%dm' \
    ${color8:1:2} ${color8:3:2} ${color8:5:2} \
    ${color7:1:2} ${color7:3:2} ${color7:5:2})
