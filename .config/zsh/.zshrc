## 2025-09-11   SARBS
#
# TODO Git integration überprüfen und neue Symbole ergänzen ✂ ☇ ⫽
# TODO Pure Prompt testen (sieht interessant aus)
# gitpromt funktion überarbeiten (ist auf Debian Server nicht verfügbar)
# Benötigt: zsh, fzf

# ============================================================================
# PATH und Umgebungsvariablen
# ============================================================================

# Rust/Cargo
export PATH="$HOME/.local/share/cargo/bin:$PATH"

# Zsh Completion Cache (XDG Base Directory konform)
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"

# ============================================================================
# Zap Plugin Manager
# ============================================================================

# Zap automatisch installieren, falls nicht vorhanden
ZAP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zap"
if [[ ! -f "$ZAP_DIR/zap.zsh" ]]; then
    echo "Installiere Zap Plugin Manager..."
    git clone -b release-v1 https://github.com/zap-zsh/zap.git "$ZAP_DIR" > /dev/null 2>&1
fi

# Zap laden
source "$ZAP_DIR/zap.zsh"

# Plugins laden mit Zap
plug "zsh-users/zsh-syntax-highlighting"
# plug "zsh-users/zsh-autosuggestions"
# plug "jeffreytse/zsh-vi-mode"  # DEAKTIVIERT: Verursacht j-Latenz! und hört auf jeden Tastendruck...

# ============================================================================
# PROMPT PLUGINS - Wähle EINEN aus (oder keinen für Fallback)
# ============================================================================
plug "woefe/git-prompt.zsh"             # Simpel, nur Git-Info, sehr schnell, mit SARBS-Prompt

# --- Minimalistische Prompts ---
# plug "zap-zsh/zap-prompt"             # ⚡➜ ~ Der Standard Zap Prompt
# plug "zap-zsh/cloud-prompt"           # ☁️ Cloud-themed Prompt
# plug "geometry-zsh/geometry"          # Minimal, konfigurierbar
# plug "agkozak/agkozak-zsh-prompt"     # Minimal aber informativ, async

# --- Feature-reiche Prompts (mit Dependencies) ---
# plug "mafredri/zsh-async"             # Dependency für Pure
# plug "sindresorhus/pure"              # Minimalistisch, elegant (braucht zsh-async!)
# plug "spaceship-prompt/spaceship-prompt"  # Feature-reich (überschreibt Settings!)

# --- Heavyweight aber powerful ---
# plug "romkatv/powerlevel10k"          # Ultra-konfigurierbar (überladen?)

# --- Starship (externes Binary, kein Zsh-Plugin) ---
# Installiere mit: curl -sS https://starship.rs/install.sh | sh
# Dann uncomment: eval "$(starship init zsh)"

# ============================================================================
# PRODUKTIVITÄT & NAVIGATION
# ============================================================================

plug "Aloxaf/fzf-tab"                   # Tab-Completion mit fzf (mega cool!)
# plug "unixorn/fzf-zsh-plugin"             # FZF Integration - lädt Keybindings & Completion! (problematisch!)
# plug "agkozak/zsh-z"                  # Pure Zsh Implementation von z (keine Dependencies!)
# plug "wfxr/forgit"                      # Git mit fzf Interface (git add -i auf Steroiden!)
# plug "paulirish/git-open"             # 'git open' öffnet Repo im Browser
plug "MichaelAquilina/zsh-you-should-use"  # Erinnert dich an Aliases die du hast!

# ============================================================================
# DEVELOPER TOOLS
# ============================================================================

# plug "hlissner/zsh-autopair"          # Auto-schließende Klammern/Quotes
plug "zsh-users/zsh-history-substring-search"  # Bessere History-Suche (↑↓ Tasten)
# plug "zdharma-continuum/fast-syntax-highlighting"  # Schnellere Alternative zu zsh-syntax-highlighting
# plug "marlonrichert/zsh-autocomplete" # Real-time Autocomplete (WARNUNG: ändert viel Verhalten!)
plug "djui/alias-tips"                  # Zeigt Alias-Tipps wenn du lange Befehle tippst

# ============================================================================
# VISUAL & INFO
# ============================================================================

# plug "zsh-users/zsh-completions"        # Vervollständigung
# plug "reegnz/jq-zsh-plugin"           # jq Completions und Helpers
# plug "lukechilds/zsh-better-npm-completion"  # Bessere npm Completions
# plug "greymd/docker-zsh-completion"   # Docker Completions
# plug "srijanshetty/docker-compose"    # Docker-compose Completions

# ============================================================================
# SYSTEM & ENVIRONMENT
# ============================================================================

# plug "mattmc3/zsh-safe-rm"           # rm mit Trash/Papierkorb statt löschen
# plug "unixorn/autoupdate-zsh-plugin" # Auto-Update für Zsh Plugins
# plug "laurenkt/zsh-vimto"            # ESC-v öffnet Command in vim (Alternative zu Ctrl-e)
# plug "zpm-zsh/colorize"              # Colorize für man, less, etc.
# plug "rummik/zsh-tailf"              # tail -f mit Highlighting
# plug "ael-code/zsh-colored-man-pages" # Farbige man pages

# ============================================================================
# FUN & EXTRAS (weil warum nicht?)
# ============================================================================

# plug "rupa/v"                         # Wie 'z' aber für vim (öffnet häufig editierte Files)
# plug "adolfoabegg/browse-commit"     # Browse git commits im Browser
# plug "wfxr/emoji-cli"                # Emoji picker für Terminal! (braucht fzf)
# plug "freed-wu/zsh-help"             # Bessere help Funktion
# plug "chrisands/zsh-yarn-completions" # Yarn Completions

# ============================================================================
# Eigene Funktionen (bereinigt)
# ============================================================================

# Tomb in deutsch starten
tomb() {
    TEXTDOMAIN=tomb TEXTDOMAINDIR=/usr/local/share/locale LANG=de_DE.UTF-8 command tomb "$@"
}

# Container-Status für Prompt
container_status() {
    [ -f /run/.containerenv ] && echo "⚟ "
}

# lf mit Verzeichniswechsel (verbesserte Version die zuerst lfub probiert)
lfcd() {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT

    # Verwende lfub wenn verfügbar, sonst lf
    if command -v lfub >/dev/null 2>&1; then
        lfub -last-dir-path="$tmp" "$@"
    else
        lf -last-dir-path="$tmp" "$@"
    fi

    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

# ============================================================================
# Universal Prompt Settings (für alle Plugins)
# ============================================================================

# Diese Settings gelten für alle Prompt-Plugins
export PROMPT_EOL_MARK=""                    # Kein EOL-Marker
setopt prompt_subst                         # Variable substitution in prompts
autoload -U colors && colors

# ============================================================================
# Plugin-spezifische Konfigurationen (bereinigt)
# ============================================================================

# --- Zap Prompts ---
if [[ -n "$functions[zap_prompt]" ]]; then
    # Zap-Prompt ist bereits aktiv
    PROMPT_CHAR="➜"
fi

# --- Woefe Git-Prompt ---
if command -v gitprompt &> /dev/null; then
    # Git-Prompt Konfiguration (Nerd Font Symbole)
    # Nutzt ANSI-Farben (0-15) statt benannte Farben - kompatibel mit hellwal!
    ZSH_GIT_PROMPT_SHOW_UPSTREAM="no"                                       # no full
    ZSH_THEME_GIT_PROMPT_PREFIX=""
    ZSH_THEME_GIT_PROMPT_SUFFIX=""
    ZSH_THEME_GIT_PROMPT_SEPARATOR=""
    ZSH_THEME_GIT_PROMPT_DETACHED="%{$fg_bold[cyan]%}:"
    ZSH_THEME_GIT_PROMPT_BRANCH=""                                         # 
    ZSH_THEME_GIT_PROMPT_UPSTREAM_SYMBOL="⟳ "
    ZSH_THEME_GIT_PROMPT_UPSTREAM_PREFIX="%{$fg[red]%}(%{$fg[yellow]%}"
    ZSH_THEME_GIT_PROMPT_UPSTREAM_SUFFIX="%{$fg[red]%})"
    ZSH_THEME_GIT_PROMPT_BEHIND="↓"
    ZSH_THEME_GIT_PROMPT_AHEAD="↑"
    ZSH_THEME_GIT_PROMPT_UNMERGED="✖ "
    ZSH_THEME_GIT_PROMPT_STAGED="●"
    ZSH_THEME_GIT_PROMPT_UNSTAGED="✚"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="…"
    ZSH_THEME_GIT_PROMPT_STASHED="⚑"
    ZSH_THEME_GIT_PROMPT_CLEAN="✔ "


    # Prompt (hellwal-kompatibel mit ANSI-Farben 0-15)
    # %F{N} = Farbe N, %f = Farbe reset, %B = bold, %b = bold reset
    PROMPT="%F{5}%n%f%F{2}@%f%F{4}%m%f %(?:%B%F{2}➜%f%b:%B%F{1}✗%f%b) %B%F{6}%c%f%b "

    RPROMPT='$(container_status)$(gitprompt)%F{6}[%*]%f'
    #                                        └─6=cyan, normal (kein %B)
fi

# --- Agkozak Prompt ---
if [[ -n "$functions[_agkozak_prompt]" ]]; then
    AGKOZAK_PROMPT_CHAR=( '➜' '❮' )
    AGKOZAK_COLORS_USER_HOST=magenta
    AGKOZAK_COLORS_PATH=cyan
fi

# --- Pure Prompt ---
if command -v prompt_pure_setup &> /dev/null; then
    PURE_PROMPT_SYMBOL="➜"
    PURE_PROMPT_VICMD_SYMBOL="❮"
    zstyle :prompt:pure:git:stash show yes
    autoload -U promptinit && promptinit && prompt pure
fi

# --- Starship (External Binary) ---
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# --- Starship (External Binary) ---
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

## ============================================================================
## Fallback Prompt (bereinigt)
## ============================================================================
##
## Minimal Fallback - nur wenn KEIN Prompt-Plugin geladen ist
#if [[ -z "$PROMPT" ]] && \
#   ! command -v prompt_pure_setup &> /dev/null && \
#   ! command -v starship &> /dev/null && \
#   [[ -z "$functions[_agkozak_prompt]" ]] && \
#   [[ -z "$functions[zap_prompt]" ]]; then
#
#    # Einfacher Prompt OHNE Git (Plugin-free, hellwal-kompatibel)
#    PROMPT="%F{5}%n@%m%f %(?:%B%F{2}➜%f%b:%B%F{1}✗%f%b) %B%F{6}%c%f%b "
#    RPROMPT='$(container_status)%F{6}[%*]%f'
#fi

# ============================================================================
# Completion System (erweitert aber KISS)
# ============================================================================

# Basic Completion System
autoload -U compinit
zmodload zsh/complist

# Completion-Dateien Cache (Performance)
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C  # Skip security check für faster startup
fi

# Grundeinstellungen
zstyle ':completion:*' menu select
zstyle ':completion:*' list-max 0
zstyle ':completion:*' list-prompt ''
_comp_options+=(globdots)                                   # Versteckte Dateien
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'      # Case-insensitive
zstyle ':completion:*' group-name ''                        # Gruppierung
zstyle ':completion:*:descriptions' format '%B%d%b'         # Gruppenbeschreibungen

# Verzeichnis-Navigation
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' special-dirs true

# FZF-Tab Integration (falls Plugin verfügbar)
if [[ -n "$functions[_fzf_tab_compl_wrapper]" ]]; then
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -la $realpath'
    zstyle ':fzf-tab:*' fzf-flags --height=40% --layout=reverse
    zstyle ':fzf-tab:*' switch-group ',' '.'
fi

# Performance Cache
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# ============================================================================
# Vi-Mode Konfiguration (Native Zsh, ohne Plugin!)
# ============================================================================

# Native Vi-Mode aktivieren
bindkey -v
export KEYTIMEOUT=1  # 10ms Timeout für Multi-Key-Sequenzen

# Cursor-Style ändern je nach Mode (Block im Command, Line im Insert)
function zle-keymap-select {
    case $KEYMAP in
        vicmd)      echo -ne '\e[1 q';;  # Block-Cursor
        viins|main) echo -ne '\e[5 q';;  # Line-Cursor
    esac
}
zle -N zle-keymap-select
zle-line-init() { echo -ne '\e[5 q' }  # Start mit Line-Cursor
zle -N zle-line-init

# Fenstertitel setzen (für dwm Statusleiste)
preexec() { printf '\e]0;%s\a' "$1" }   # Laufendes Kommando als Titel
precmd() { printf '\e]0;zsh\a' }         # Zurück zu "zsh" wenn idle

# Vi-Navigation im Completion-Menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# ============================================================================
# Custom Keybindings
# ============================================================================

# Zeile in Editor bearbeiten (Strg+E)
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# FZF Keybindings (Custom, da Alt+C in DWM belegt ist)
bindkey '^f' fzf-file-widget      # Strg+F für Dateisuche
bindkey '^r' fzf-history-widget   # Strg+R für History
bindkey '^g' fzf-cd-widget        # Strg+G für Verzeichniswechsel (Alt+C in DWM belegt)

# Schnellzugriffe
bindkey -s '^o' '^ulfcd\n'        # Strg+O öffnet lf mit cd-Funktion
bindkey -s '^a' '^ubc -lq\n'      # Strg+A öffnet bc Calculator

# ============================================================================
# FZF Integration (Key-Bindings & Completion)
# ============================================================================
# Custom Keybindings (siehe unten in zvm_after_init):
#   Strg+F - Dateisuche (rekursiv im aktuellen Verzeichnis)
#   Strg+R - History-Suche (durchsuchbare Befehlshistorie)
#   Strg+G - Verzeichniswechsel (fuzzy cd)

# FZF Completion laden
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

# FZF Key-Bindings laden (definiert fzf-file-widget, fzf-cd-widget, fzf-history-widget)
# WICHTIG: Dies muss VOR den Custom-Bindings in zvm_after_init() geladen werden!
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh

# ============================================================================
# ZSH Optionen
# ============================================================================

# Verzeichnis-Navigation
setopt autocd                       # Automatisch in Verzeichnisse wechseln
setopt interactive_comments         # Kommentare in interaktiven Shells
# setopt CORRECT                      # Simple Autokorrektur

# History Konfiguration
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTORY_IGNORE="(pass|pass *|man *|ls|ls *|cd|cd *|ytt|ytt *|yt|yt *|tomb|tomb *|pwd|exit|clear|history|history *)"
setopt HIST_IGNORE_ALL_DUPS     # Alle Duplikate ignorieren
setopt HIST_SAVE_NO_DUPS        # Keine Duplikate speichern
setopt HIST_IGNORE_SPACE        # Befehle mit führendem Leerzeichen ignorieren
setopt inc_append_history       # Sofort schreiben

# ============================================================================
# Externe Konfigurationen laden
# ============================================================================

# Alias und Verknüpfungen laden, falls vorhanden
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"

# ============================================================================
# Sonstiges
# ============================================================================

# Strg-s deaktivieren (Terminal-Freeze verhindern)
stty stop undef
# XDG Konforme zoxide konfiguration
export _ZO_DATA_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/zoxide"
eval "$(zoxide init zsh)"
