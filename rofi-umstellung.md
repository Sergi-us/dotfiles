# Migration von dmenu zu Rofi

Diese Datei listet alle Skripte, Konfigurationsdateien und Dokumentationen in
den Dotfiles auf, die derzeit `dmenu` verwenden oder erwähnen. Diese Übersicht
dient als Vorbereitung für die Umstellung auf `rofi -dmenu`.

## 1. Skripte (`.local/bin/`)
Diese Skripte führen aktiv `dmenu` aus (z.B. für Auswahlen, Prompts oder
Eingaben). Beim Umschreiben auf Rofi kann meist `dmenu` direkt durch `rofi
-dmenu` ersetzt werden, da Parameter wie `-i` (case-insensitive), `-p` (Prompt)
und `-l` (Anzahl der Zeilen) kompatibel sind.

 `displayselect` (Monitor-Setup)
 `mounter` & `unmounter` (Laufwerke ein/aushängen)
 `dmenupass` (Passwortabfrage)
 `clipctl` & `dmenucliphist` (Zwischenablage)
 `bookmarkthis` (Lesezeichen-Verwaltung)
* `st-urlhandler` 
* `dmenuhandler`, URL/Datei-Öffner
* `dmenumountcifs` (Netzwerklaufwerke)
* `dmenuunicode` (Emoji-Auswahl)
* `otp` (Zwei-Faktor-Authentifizierung)
* `maimpick` (Screenshot-Tool)
* `td-toggle` (Transmission Daemon)
* `tutorialvids` (Videoauswahl)
* `cam` (Webcam-Auswahl)
* `blue` (Bluetooth-Skript)
* `killer` (Prozesse beenden)
* `statusbar/sb-kbselect` & `statusbar/sb-doppler` (Statusleisten-Module)
* `sysact` (Power-Menü)
* `dmenurecord`, `dmenurecord-intel`, `dmenurecord-nvidia` (Bildschirmaufnahme)

## 2. Konfigurationsdateien (`.config/` und andere)
Hier sind Tastenkombinationen, Regeln für Fenster oder Auto-Kommandos definiert, die an `dmenu` gebunden sind.

* `.config/shell/profile` (Definiert `dmenupass` als `SUDO_ASKPASS`)
* `.config/picom/picom.conf` & `.config/picom/picom.conf.bac` (Fensterregeln, z.B. Transparenz/Schatten für `class_g = 'dmenu'`. Rofi hat eine eigene Klasse, z.B. `Rofi`)
* `.config/nsxiv/exec/key-handler` & `.config/sxiv/exec/key-handler` (Bildbetrachter-Aktionen, die ein Menü aufrufen)
* `.config/nvim/lua/config/autocmds.lua` (Auto-Kompilierung für den dmenu-Source-Code beim Speichern)
* `.local/share/gnupg/gpg-agent.conf` (GnuPG Pinentry; evtl. konfiguriert als `pinentry-dmenu`, was zu `pinentry-rofi` geändert werden könnte)
* `.config/newsraft/feeds` & `.config/newsboat/config` (RSS-Feeds zu dmenu Repositories)

## 3. Dokumentation & Wikis
Dateien, die `dmenu` in Erklärungen, Tabellen oder READMEs erwähnen. Diese müssen händisch aktualisiert werden.

* `README.md` & `AGENTS.md` (Haupt-Infos zum System)
* `.config/x11/README.md`
* **Neovim SARBS-Wiki** (`.local/share/nvim/sarbs/`):
    * `Einstellungen.wiki`
    * `Geräte mit Bluetooth Verbinden.wiki`
    * `Snippets.wiki`
    * `SARBS-Handbuch.wiki`
* Diverse README-Symlinks unter `.local/share/Readme/`
