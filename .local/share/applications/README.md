# Anleitung: Standardanwendungen & MIME-Typen in Arch Linux konfigurieren

Diese Anleitung zeigt, wie du in einem Arch Linux System (mit DWM) den Standardbrowser und den Editor für Textdateien/Shell-Skripte konfigurierst.

## 1. Standardbrowser setzen

### a) xdg-Settings & xdg-Mime verwenden

Definiere Librewolf als Standardbrowser, indem du die entsprechenden MIME-Typen und URL-Schemata anpasst:

```bash
xdg-settings set default-web-browser librewolf.desktop
xdg-mime default librewolf.desktop x-scheme-handler/http
xdg-mime default librewolf.desktop x-scheme-handler/https
```

## b) Eigene .desktop-Datei erstellen
Erstelle eine Datei namens browser.desktop in ~/.local/share/applications/ mit folgendem Inhalt:

```
[Desktop Entry]
Version=1.0
Type=Application
Name=Librewolf Browser
GenericName=Webbrowser
Comment=Datenschutzorientierter Webbrowser basierend auf Firefox
Exec=librewolf %u
Terminal=false
Icon=librewolf
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
```

## 2. Editor für Textdateien und Shell-Skripte konfigurieren
### a) Eigene text.desktop anpassen

Lege in ~/.local/share/applications/text.desktop folgenden Inhalt an, um nvim in st zu starten:

```
[Desktop Entry]
Type=Application
Name=Text editor
Exec=/usr/local/bin/st -e nvim %u
Terminal=true
MimeType=text/plain;text/x-shellscript;application/x-shellscript;
```

### b) mimeapps.list anpassen

Stelle sicher, dass in deiner ~/.config/mimeapps.list (oder einer systemweiten Datei) folgende Einträge enthalten sind:

```
text/plain=text.desktop
text/x-shellscript=text.desktop
application/x-shellscript=text.desktop
```

Dadurch werden sowohl reine Textdateien als auch Shell-Skripte über deine text.desktop geöffnet.

## 3. LF (listfiles) Konfiguration
LF nutzt standardmäßig einen eigenen Opener. Damit LF die oben definierten Standardanwendungen nutzt, kannst du in deiner LF-Konfiguration (~/.config/lf/lfrc) folgendes setzen:

```
set opener /usr/local/bin/xdg-open
```

Alternativ kannst du in der lfrc auch ein direktes Mapping für Textdateien definieren:

```
cmd open {{
    if [[ "$(file --mime-type -b "$f")" == text/* ]]; then
        st -e nvim "$f"
    else
        xdg-open "$f"
    fi
}}
```

## 4. Wichtige Befehle und Tools

## xdg-settings:
Legt Standardanwendungen fest.
Beispiel:

```
xdg-settings set default-web-browser librewolf.desktop
```

## xdg-mime:
Definiert MIME-Typ Zuordnungen.
Beispiel:

```
xdg-mime default librewolf.desktop x-scheme-handler/http
```

## file --mime-type:
Zeigt den MIME-Typ einer Datei an.
Beispiel:

```
file --mime-type <datei>
```

mimeapps.list:
Zentrale Konfigurationsdatei für Standardanwendungen (unter ~/.config/mimeapps.list).
