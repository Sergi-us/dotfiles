# QuteBrowser Konfiguration
## 2025-06-21   SARBS
# TODO Scrollgeschwindigkeit regeln

# Autoconfig laden (UI-Einstellungen werden übernommen)
config.load_autoconfig(True)

c.scrolling.smooth = False

# Browserverhalten
c.auto_save.session = False

# Editor-Einstellungen
c.editor.command = ['st', '-e', 'nvim', '{}']

# ================================================================================
# HiDPI & UI-EINSTELLUNGEN
# ================================================================================

# Schriftgrößen für HiDPI-Display
# c.fonts.default_size = '16pt'
c.fonts.tabs.selected = '16pt default_family'
c.fonts.tabs.unselected = '12pt default_family'

# Allgemeine UI-Schriftgröße
c.fonts.statusbar = '14pt default_family'
c.fonts.downloads = '14pt default_family'
c.fonts.prompts = '14pt default_family'
c.fonts.hints = 'bold 14pt default_family'

# Zoom-Faktor für Webseiten
c.zoom.default = '150%'

# Tabs-Einstellungen
c.tabs.position = 'top'
c.tabs.show = 'always'
c.tabs.title.format = '{audio}{current_title}'
c.tabs.title.format_pinned = '{audio}'
c.tabs.padding = {'top': 4, 'bottom': 4, 'left': 8, 'right': 8}
c.tabs.indicator.width = 1  # Ladesymbol deaktivieren
c.tabs.favicons.show = 'always'

# Schriftgröße für die Kommandozeile
c.fonts.prompts = '14pt default_family'
c.fonts.statusbar = '14pt default_family'
c.fonts.completion.category = 'bold 16pt default_family'
c.fonts.completion.entry = '14pt default_family'

# Completion-Menü (das Dropdown beim Tippen)
c.fonts.completion.category = 'bold 14pt default_family'
c.fonts.completion.entry = '14pt default_family'

# Messages/Fehlermeldungen
c.fonts.messages.error = 'bold 16pt default_family'
c.fonts.messages.info = '16pt default_family'
c.fonts.messages.warning = '16pt default_family'

# ================================================================================
# DARK MODE EINSTELLUNGEN
# ================================================================================

# Dark Mode für Webseiten aktivieren
c.colors.webpage.darkmode.enabled = True

# Dark Mode Algorithmus wählen (kann lightness-cielab, lightness-hsl, brightness-rgb  sein)
c.colors.webpage.darkmode.algorithm = 'lightness-cielab'

# Bilder im Dark Mode nicht invertieren
c.colors.webpage.darkmode.policy.images = 'never'

# Dark Mode für alle Seiten erzwingen, auch für solche mit eigenem Dark Mode
c.colors.webpage.darkmode.policy.page = 'always'

# Grundfarben für die Benutzeroberfläche
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
# SICHERHEITSEINSTELLUNGEN
# ================================================================================

# JavaScript deaktivieren für bestimmte Domains (Beispiel)
# c.content.javascript.enabled = True  # Allgemein aktivieren
# config.set('content.javascript.enabled', False, 'https://example.com/*')  # Für bestimmte Seiten deaktivieren

# Cookies von Drittanbietern blockieren
c.content.cookies.accept = 'no-3rdparty'
# c.content.cookies.accept = 'no-3rdparty'
c.content.cookies.store = True

# Do-Not-Track-Header senden
c.content.headers.do_not_track = True

config.set("content.webgl", False, "*")
# WebGL für Jitsi erlauben
config.set("content.webgl", True, "https://meet.jit.si/*")
config.set("content.webgl", True, "https://*.jitsi.org/*")

config.set("content.canvas_reading", False)
config.set("content.geolocation", False)
config.set("content.webrtc_ip_handling_policy", "default-public-interface-only")
# WebRTC für Jitsi-Domains erlauben
##config.set("content.webrtc_ip_handling_policy", "default-public-and-private-interfaces", "https://meet.jit.si/*")
##config.set("content.webrtc_ip_handling_policy", "default-public-and-private-interfaces", "https://*.jitsi.org/*")
config.set("content.cookies.accept", "all")
config.set("content.cookies.store", True)
# config.set("content.javascript.enabled", False) # tsh keybind to toggle

# Referrer-Policy einschränken
c.content.headers.referer = 'same-domain'

# HTTPS-Redirects erzwingen
# c.content.https.enforced = 'strict'
c.content.default_encoding = 'utf-8'
# Mit zusätzlichem userscript kann man HTTPS erzwingen
# Manuell installieren: https://github.com/qutebrowser/qutebrowser/blob/master/misc/userscripts/redirect_https

# Cache löschen beim Schließen
c.content.private_browsing = False  # Vollständiger Privat-Modus (optional)
c.completion.web_history.max_items = 1000  # Begrenze Historie

# WebRTC IP-Handling einschränken (verhindert IP-Leaks)
c.content.webrtc_ip_handling_policy = 'default-public-interface-only'

# Fingerprinting reduzieren
c.content.headers.user_agent = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/112.0.0.0 Safari/537.36'
c.content.headers.accept_language = 'de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7'

# Tracking-Schutz aktivieren
# Adblocking info -->
    # For yt ads: place the greasemonkey script yt-ads.js in your greasemonkey folder (~/.config/qutebrowser/greasemonkey).
    # The script skips through the entire ad, so all you have to do is click the skip button.
    # Yeah it's not ublock origin, but if you want a minimal browser, this is a solution for the tradeoff.
    # You can also watch yt vids directly in mpv, see qutebrowser FAQ for how to do that.
    # If you want additional blocklists, you can get the python-adblock package, or you can uncomment the ublock lists here.
    # https://wiki.greasespot.net/User_Script_Hosting
    # https://greasyfork.org/de
c.content.blocking.enabled = True
c.content.blocking.method = 'hosts'  # Statt 'both'
c.content.blocking.adblock.lists = [
    'https://raw.githubusercontent.com/kbinani/adblock-youtube-ads/master/signed.txt',
    'https://easylist.to/easylist/easylist.txt',
    'https://easylist.to/easylist/easyprivacy.txt',
    'https://secure.fanboy.co.nz/fanboy-annoyance.txt',
    'https://easylist-downloads.adblockplus.org/easylistgermany.txt',
    'https://github.com/ewpratten/youtube_ad_blocklist/blob/master/blocklist.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2022.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2023.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2024.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-cookies.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances-others.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/quick-fixes.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt',
    'https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt',
]

# ================================================================================
# PERFORMANCE-EINSTELLUNGEN
# ================================================================================

# Cache-Größe (in Bytes, hier 100 MB)
c.content.cache.size = 104857600

# Hintergrund-Tabs pausieren (spart Ressourcen)
# c.content.unload_tabs = True                          # funktioniert nicht mehr

# Neue Alternative - Ressourcenschonung durch Tabs pausieren:
c.tabs.background = True                                # Tabs im Hintergrund öffnen
c.tabs.last_close = 'close'                             # Fenster schließen, wenn letzter Tab geschlossen wird

# Optional: RAM-Reduzierung durch Speicherlimit
# TODO Konfiguration fixen
# qt.chromium.process_model = 'process-per-site-instance'        # Reduziert RAM-Verbrauch
c.content.javascript.clipboard = 'none'                 # 'access' erlaubt Zugriff, 'none' verbietet ihn

# Präfetching (Performance vs. Datenschutz)
c.content.dns_prefetch = True
c.content.prefers_reduced_motion = True                 # Animationen reduzieren

# ================================================================================
# DATENSCHUTZ- UND DOWNLOAD-EINSTELLUNGEN
# ================================================================================

# Downloads automatisch in diesen Ordner speichern
c.downloads.location.directory = '~/Downloads'
c.downloads.location.prompt = False  # Kein Nachfragen bei Downloads
c.downloads.location.remember = True
c.downloads.remove_finished = 60000  # Nach 1ner Minute aus der Liste entfernen

# URLs abkürzen
c.url.searchengines = {
    'DEFAULT': 'https://duckduckgo.com/?q={}',
    'g': 'https://google.com/search?q={}',
    'yt': 'https://youtube.com/results?search_query={}',
    'w': 'https://de.wikipedia.org/wiki/{}',
    'gh': 'https://github.com/search?q={}',
}

# Startseite festlegen
c.url.start_pages = ['https://start.duckduckgo.com']
c.url.default_page = 'https://start.duckduckgo.com'

# ================================================================================
# KEYBINDINGS
# ================================================================================

# Einige Vim-ähnlichere Keybindings
config.unbind('d')  # Standard Tab schließen unbinden
config.bind('dd', 'tab-close')  # Tab mit 'dd' schließen
##config.bind('+', 'zoom-in')  # Zoom vergrößern
##config.bind('-', 'zoom-out')  # Zoom verkleinern
config.bind('<F12>', 'devtools')  # Entwicklertools mit F12
# Schneller Zugriff auf bestimmte Einstellungen
##config.bind(',tp', 'set content.private_browsing !') # Toggle Private Mode
##config.bind(',tj', 'set content.javascript.enabled !') # Toggle JavaScript

# Sicherheitsrelevante Tastenkombinationen
##config.bind(',c', 'config-clear')  # Konfiguration zurücksetzen
##config.bind(',p', 'set content.proxy socks://localhost:9050/')  # Tor-Proxy einschalten (wenn installiert)
##config.bind(',P', 'set content.proxy system')  # Proxy ausschalten

# Dark Mode Toggle
##config.bind(',d', 'set colors.webpage.darkmode.enabled !') # Dark mode umschalten
