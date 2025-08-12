# QuteBrowser Konfiguration mit Sicherheitsstufen
## 2025-08-12   SARBS

# Autoconfig laden (UI-Einstellungen werden übernommen)
config.load_autoconfig(True)

c.scrolling.smooth = False

# Browserverhalten
c.auto_save.session = False

# Editor-Einstellungen
c.editor.command = ['st', '-e', 'nvim', '{}']

# ================================================================================
# HiDPI & UI-EINSTELLUNGEN (Unkritisch für Sicherheit)
# ================================================================================

# Schriftgrößen einstellungen
FONTS = {
    'small': '10pt',
    'normal': '12pt',
    'large': '14pt',
    'xlarge': '18pt'
}

# Schriftgrößen für HiDPI-Display
c.fonts.default_size = FONTS['normal']
c.fonts.tabs.selected = f"{FONTS['normal']} default_family"
c.fonts.tabs.unselected = f"{FONTS['small']} default_family"

# Allgemeine UI-Schriftgröße
c.fonts.statusbar = f"{FONTS['normal']} default_family"
c.fonts.downloads = f"{FONTS['normal']} default_family"
c.fonts.prompts = f"{FONTS['normal']} default_family"
c.fonts.hints = f"bold {FONTS['normal']} default_family"

# Zoom-Faktor für Webseiten
c.zoom.default = '100%'

# Tabs-Einstellungen
c.tabs.position = 'top'
c.tabs.show = 'multiple'    # 'multiple' 'always' 'never' 'switching'
c.tabs.title.format = '{audio}{current_title}'
c.tabs.title.format_pinned = '{audio}'
c.tabs.padding = {'top': 4, 'bottom': 4, 'left': 8, 'right': 8}
c.tabs.indicator.width = 1  # Ladesymbol deaktivieren
c.tabs.favicons.show = 'always'

# Schriftgröße für die Kommandozeile
c.fonts.prompts = f"{FONTS['normal']} default_family"
c.fonts.statusbar = f"{FONTS['normal']} default_family"
c.fonts.completion.category = f"{FONTS['large']} default_family"
c.fonts.completion.entry = f"{FONTS['normal']} default_family"

# Completion-Menü (das Dropdown beim Tippen)
c.fonts.completion.category = f"bold {FONTS['normal']} default_family"
c.fonts.completion.entry = f"{FONTS['normal']} default_family"

# Messages/Fehlermeldungen
c.fonts.messages.error = f"bold {FONTS['large']} default_family"
c.fonts.messages.info = f"{FONTS['normal']} default_family"
c.fonts.messages.warning = f"{FONTS['normal']} default_family"

# ================================================================================
# DARK MODE EINSTELLUNGEN (Unkritisch für Sicherheit)
# ================================================================================

# Dark Mode für Webseiten aktivieren
c.colors.webpage.darkmode.enabled = True

# Dark Mode Algorithmus wählen (kann lightness-cielab, lightness-hsl, brightness-rgb  sein)
# c.colors.webpage.darkmode.algorithm = 'lightness-cielab'

# Bilder im Dark Mode nicht invertieren
# c.colors.webpage.darkmode.policy.images = 'never'

# Dark Mode für alle Seiten erzwingen, auch für solche mit eigenem Dark Mode
# c.colors.webpage.darkmode.policy.page = 'always'

# ================================================================================
# PYWALL FARBEN LADEN (Unkritisch für Sicherheit)
# ================================================================================

import os
import json

# Pywal colors laden wenn vorhanden
try:
    with open(os.path.expanduser('~/.cache/wal/colors.json')) as f:
        pywal = json.load(f)

    # Farben extrahieren
    bg = pywal['special']['background']
    fg = pywal['special']['foreground']
    colors = [pywal['colors'][f'color{i}'] for i in range(16)]

    # Qutebrowser theme
    # Completion (Dropdown beim Tippen)
    c.colors.completion.fg = [colors[7], fg, fg]
    c.colors.completion.odd.bg = colors[0]
    c.colors.completion.even.bg = bg
    c.colors.completion.category.bg = colors[8]
    c.colors.completion.category.fg = fg
    c.colors.completion.category.border.top = colors[8]
    c.colors.completion.category.border.bottom = colors[8]
    c.colors.completion.item.selected.bg = colors[4]
    c.colors.completion.item.selected.fg = bg
    c.colors.completion.item.selected.border.top = colors[4]
    c.colors.completion.item.selected.border.bottom = colors[4]

    # Statusbar - bleibt dunkel wie deine dmenu bar
    c.colors.statusbar.normal.bg = bg  # Dunkler Hintergrund
    c.colors.statusbar.normal.fg = fg  # Heller Text
    c.colors.statusbar.command.bg = bg
    c.colors.statusbar.command.fg = fg
    c.colors.statusbar.insert.bg = colors[2]
    c.colors.statusbar.insert.fg = bg
    c.colors.statusbar.passthrough.bg = colors[4]
    c.colors.statusbar.passthrough.fg = bg
    c.colors.statusbar.private.bg = colors[5]
    c.colors.statusbar.private.fg = bg

    # Tabs - EINHEITLICHE FARBEN!
    c.colors.tabs.bar.bg = bg  # Tab-Leiste wie Statusbar

    # Ausgewählte Tabs - Orange wie in deinem Screenshot
    c.colors.tabs.selected.odd.bg = colors[3]   # Orange (meist color3)
    c.colors.tabs.selected.odd.fg = bg          # Dunkler Text
    c.colors.tabs.selected.even.bg = colors[3]  # GLEICHE Farbe!
    c.colors.tabs.selected.even.fg = bg

    # Nicht ausgewählte Tabs - etwas heller als Hintergrund
    c.colors.tabs.odd.bg = colors[8]   # Mittleres Grau
    c.colors.tabs.odd.fg = fg          # Normaler Text
    c.colors.tabs.even.bg = colors[8]  # GLEICHE Farbe für Einheitlichkeit!
    c.colors.tabs.even.fg = fg

    # Tab-Indikatoren
    c.colors.tabs.indicator.start = colors[4]
    c.colors.tabs.indicator.stop = colors[2]
    c.colors.tabs.indicator.error = colors[1]

    # Pinned tabs - optional anders
    c.colors.tabs.pinned.selected.odd.bg = colors[3]
    c.colors.tabs.pinned.selected.odd.fg = bg
    c.colors.tabs.pinned.selected.even.bg = colors[3]
    c.colors.tabs.pinned.selected.even.fg = bg
    c.colors.tabs.pinned.odd.bg = colors[0]
    c.colors.tabs.pinned.odd.fg = colors[7]
    c.colors.tabs.pinned.even.bg = colors[0]
    c.colors.tabs.pinned.even.fg = colors[7]

    # Downloads
    c.colors.downloads.bar.bg = bg
    c.colors.downloads.start.bg = colors[4]
    c.colors.downloads.start.fg = bg
    c.colors.downloads.stop.bg = colors[2]
    c.colors.downloads.stop.fg = bg
    c.colors.downloads.error.bg = colors[1]
    c.colors.downloads.error.fg = fg

    # Hints
    c.colors.hints.bg = colors[3]
    c.colors.hints.fg = bg
    c.colors.hints.match.fg = colors[1]

    # Messages
    c.colors.messages.info.bg = colors[4]
    c.colors.messages.info.fg = bg
    c.colors.messages.warning.bg = colors[3]
    c.colors.messages.warning.fg = bg
    c.colors.messages.error.bg = colors[1]
    c.colors.messages.error.fg = fg

    # Prompts
    c.colors.prompts.bg = bg
    c.colors.prompts.fg = fg
    c.colors.prompts.border = colors[8]
    c.colors.prompts.selected.bg = colors[4]
    c.colors.prompts.selected.fg = bg

    print("✓ Pywal Farben erfolgreich geladen!")

except (FileNotFoundError, KeyError, json.JSONDecodeError) as e:
    print(f"✗ Fehler beim Laden der Pywal-Farben: {e}")
    # Fallback-Farben...

    # Fallback-Farben hier...

    # Grundfarben für die Benutzeroberfläche (FALLBACK)
    c.colors.completion.fg = ['#9cc4ff', 'white', 'white']
    c.colors.completion.odd.bg = '#1c1f24'
    c.colors.completion.even.bg = '#232429'
    c.colors.completion.category.bg = '#29303d'
    c.colors.completion.category.fg = '#f0f0f0'
    c.colors.completion.category.border.top = '#29303d'
    c.colors.completion.category.border.bottom = '#29303d'
    c.colors.completion.item.selected.bg = '#4491ed'
    c.colors.completion.item.selected.fg = '#f0f0f0'
    c.colors.completion.item.selected.border.top = '#4491ed'
    c.colors.completion.item.selected.border.bottom = '#4491ed'
    c.colors.statusbar.normal.bg = '#1c1f24'
    c.colors.statusbar.normal.fg = '#f0f0f0'
    c.colors.statusbar.command.bg = '#1c1f24'
    c.colors.statusbar.command.fg = '#f0f0f0'
    c.colors.tabs.bar.bg = '#1c1f24'
    c.colors.tabs.selected.odd.bg = '#323842'
    c.colors.tabs.selected.odd.fg = '#f0f0f0'
    c.colors.tabs.odd.bg = '#232429'
    c.colors.tabs.odd.fg = '#d0d0d0'
    c.colors.tabs.even.bg = '#1c1f24'
    c.colors.tabs.even.fg = '#d0d0d0'

# ================================================================================
# SICHERHEITSEINSTELLUNGEN - GRUNDSCHUTZ (EMPFOHLEN)
# ================================================================================
# Diese Einstellungen bieten einen guten Basisschutz ohne große Einschränkungen

# COOKIES - GRUNDSCHUTZ
# 'no-3rdparty' = Blockiert nur Drittanbieter-Cookies (empfohlen)
# 'all' = Akzeptiert alle Cookies (weniger sicher, aber manche Seiten brauchen das)
# 'never' = Blockiert alle Cookies (sehr sicher, aber viele Seiten funktionieren nicht)
c.content.cookies.accept = 'no-3rdparty'  # EMPFOHLEN: Gute Balance
# c.content.cookies.accept = 'all'  # LOCKERER: Für problematische Seiten

# Cookies speichern (für Login-Sessions wichtig)
# c.content.cookies.store = True  # Cookies bleiben gespeichert (für Logins wichtig)

# Do-Not-Track-Header senden (höfliche Bitte, kein Schutz)
c.content.headers.do_not_track = True

# Referrer-Policy (welche Infos an andere Seiten gesendet werden)
# 'same-domain' = Nur an gleiche Domain (sicher)
# 'no-referrer-when-downgrade' = Standard, weniger restriktiv
c.content.headers.referer = 'same-domain'  # EMPFOHLEN
# c.content.headers.referer = 'no-referrer-when-downgrade'  # LOCKERER

# ================================================================================
# SICHERHEITSEINSTELLUNGEN - ERHÖHTER SCHUTZ (OPTIONAL)
# ================================================================================
# Diese Einstellungen erhöhen die Sicherheit, können aber Seiten kaputt machen

# JAVASCRIPT - DER HAUPTSCHALTER
# False = JS komplett aus (sehr sicher, viele Seiten funktionieren nicht)
# True = JS an (normal)
# Tipp: Mit 'tsh' Keybind togglen statt permanent aus!
config.set("content.javascript.enabled", False)  # SEHR RESTRIKTIV!
# config.set("content.javascript.enabled", True)  # NORMAL (empfohlen mit Keybind)

# WEBGL - 3D-Grafiken im Browser
# False = Aus (sicherer, aber keine 3D-Inhalte)
config.set("content.webgl", False, "*")  # Für alle Seiten aus
# Ausnahmen für spezielle Seiten (z.B. Jitsi für Videocalls):
# config.set("content.webgl", True, "https://meet.jit.si/*")

# CANVAS FINGERPRINTING - Tracking-Schutz
# False = Canvas-Auslesen blockieren (gut gegen Tracking)
config.set("content.canvas_reading", False)  # EMPFOHLEN

# STANDORT-ZUGRIFF
# False = Keine Standortabfragen
config.set("content.geolocation", False)  # EMPFOHLEN

# WEBRTC - Für Videocalls, kann IP leaken
# 'default-public-interface-only' = Nur öffentliche IP (sicher)
# 'all-interfaces' = Alle IPs (für manche Videocalls nötig)
config.set("content.webrtc_ip_handling_policy", "default-public-interface-only")

# CLIPBOARD-ZUGRIFF
# 'none' = Kein Zugriff (sehr sicher, kein Copy&Paste auf Webseiten)
# 'access-paste' = Nur Einfügen erlaubt (Kompromiss)
# 'access' = Voller Zugriff (normal)
config.set('content.javascript.clipboard', 'access-paste')  # EMPFOHLEN: Guter Kompromiss
# config.set('content.javascript.clipboard', 'access')  # LOCKERER: Für Web-Apps

# BENACHRICHTIGUNGEN
# False = Keine Push-Benachrichtigungen
config.set('content.notifications.enabled', False)  # EMPFOHLEN

# ================================================================================
# TRACKING-SCHUTZ & WERBEBLOCKER
# ================================================================================

# BLOCKING METHODE
# 'both' = Hosts + Adblock-Filter (beste Blockierung, minimal langsamer)
# 'adblock' = Nur Adblock-Filter
# 'hosts' = Nur Hosts-Datei (schneller, aber weniger effektiv)
c.content.blocking.enabled = True
c.content.blocking.method = 'both'  # EMPFOHLEN für beste Blockierung

# FILTERLISTEN
# Kommentiere Listen aus, die zu aggressiv sind
c.content.blocking.adblock.lists = [
    # === BASIS-WERBEBLOCKER (EMPFOHLEN) ===
    'https://easylist.to/easylist/easylist.txt',  # Haupt-Werbeblocker
    'https://easylist-downloads.adblockplus.org/easylistgermany.txt',  # Deutsche Werbung

    # === PRIVACY & TRACKING (EMPFOHLEN) ===
    'https://easylist.to/easylist/easyprivacy.txt',  # Tracking-Schutz

    # === COOKIE-BANNER (EMPFOHLEN) ===
    'https://secure.fanboy.co.nz/fanboy-cookiemonster.txt',  # Cookie-Banner 1
    'https://raw.githubusercontent.com/OctoNezd/istilldontcareaboutcookies/main/dist/abp.txt',  # Cookie-Banner 2

    # === NERVIGE ELEMENTE (OPTIONAL - kann zu aggressiv sein) ===
    'https://secure.fanboy.co.nz/fanboy-annoyance.txt',  # Popups, Newsletter, etc.
    # Wenn zu aggressiv, auskommentieren und nur diese nutzen:
    # 'https://easylist-downloads.adblockplus.org/fanboy-social.txt',  # Nur Social-Media-Buttons

    # === YOUTUBE-SPEZIFISCH (OPTIONAL) ===
    'https://raw.githubusercontent.com/kbinani/adblock-youtube-ads/master/signed.txt',
    # 'https://github.com/ewpratten/youtube_ad_blocklist/blob/master/blocklist.txt',  # Oft veraltet

    # === UBLOCK ORIGIN FILTER (OPTIONAL - sehr aggressiv) ===
    # Diese können Seiten kaputt machen, bei Problemen auskommentieren:
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2024.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-cookies.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt',  # Wichtig! Fixt kaputte Seiten

    # === ALTE/LEGACY FILTER (meist nicht nötig) ===
    # 'https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt',
    # 'https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt',
    # 'https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt',
    # 'https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2022.txt',
    # 'https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2023.txt',
]

# ================================================================================
# FINGERPRINTING-SCHUTZ (OPTIONAL)
# ================================================================================
# Macht dich weniger trackbar, kann aber manche Seiten stören

# User-Agent vereinheitlichen (alle Linux-Nutzer sehen gleich aus)
c.content.headers.user_agent = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36'

# Sprache vereinheitlichen
c.content.headers.accept_language = 'de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7'

# ================================================================================
# PERFORMANCE-EINSTELLUNGEN (Unkritisch für Sicherheit)
# ================================================================================

# Cache-Größe (in Bytes, hier 100 MB)
c.content.cache.size = 104857600

# Tabs im Hintergrund öffnen
c.tabs.background = True
c.tabs.last_close = 'close'  # Fenster schließen bei letztem Tab

# DNS-Prefetching (minimal schneller, minimal weniger privat)
c.content.dns_prefetch = True  # Kann auf False für mehr Privacy
c.content.prefers_reduced_motion = True  # Weniger Animationen

# ================================================================================
# DOWNLOAD-EINSTELLUNGEN (Unkritisch für Sicherheit)
# ================================================================================

c.downloads.location.directory = '~/Downloads'
c.downloads.location.prompt = False  # Kein Nachfragen
c.downloads.location.remember = True
c.downloads.remove_finished = 60000  # Nach 1 Minute aus Liste entfernen

# ================================================================================
# SUCHMASCHINEN & STARTSEITE
# ================================================================================

c.url.searchengines = {
    'DEFAULT': 'https://duckduckgo.com/?q={}',
    'g': 'https://google.com/search?q={}',
    'yt': 'https://youtube.com/results?search_query={}',
    'w': 'https://de.wikipedia.org/wiki/{}',
    'gh': 'https://github.com/search?q={}',
}

c.url.start_pages = ['https://start.duckduckgo.com']
c.url.default_page = 'https://start.duckduckgo.com'

# ================================================================================
# KEYBINDINGS
# ================================================================================

# Tab-Management
config.unbind('d')
config.bind('dd', 'tab-close')

# Entwicklertools
config.bind('<F12>', 'devtools')

# === WICHTIGE TOGGLE-KEYBINDS FÜR PROBLEMSEITEN ===
# Mit diesen kannst du Einstellungen temporär ändern:

# JavaScript an/aus (für kaputte Seiten)
config.bind('tsh', 'config-cycle content.javascript.enabled true false')

# Cookies-Einstellung wechseln (wenn Login nicht geht)
config.bind('tsc', 'config-cycle content.cookies.accept all no-3rdparty never')

# Alle Sicherheitseinstellungen temporär lockern (Notfall-Taste!)
config.bind('tsa', 'cmd-set-text :set content.javascript.enabled true ;; set content.cookies.accept all')

# Dark Mode umschalten
config.bind('tsd', 'config-cycle colors.webpage.darkmode.enabled true false')

# Blocking temporär ausschalten (wenn Seite nicht lädt)
config.bind('tsb', 'config-cycle content.blocking.enabled true false')

# ================================================================================
# TROUBLE-SHOOTING BEFEHLE
# ================================================================================
# Wenn eine Seite nicht funktioniert, probiere diese Befehle in der Kommandozeile:
#
# :set content.javascript.enabled true              # JS einschalten
# :set content.cookies.accept all                   # Alle Cookies erlauben
# :set content.blocking.enabled false               # Blocker aus
# :set content.javascript.clipboard access          # Vollen Clipboard-Zugriff
# :reload -f                                        # Seite ohne Cache neu laden
#
# Für dauerhafte Ausnahmen für bestimmte Seiten:
# :set -u DOMAIN content.javascript.enabled true
# Beispiel: :set -u github.com content.javascript.enabled true
