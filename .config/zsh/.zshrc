## 2025-01-08 SARBS - Neu mit Zap Plugin Manager
#
# TODO Git integration überprüfen und neue Symbole ergänzen ✂ ☇ ⫽
# TODO Pure Prompt testen (sieht interessant aus)

# ============================================================================
# PATH und Umgebungsvariablen
# ============================================================================

# Rust/Cargo
export PATH="$HOME/.local/share/cargo/bin:$PATH"

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
plug "jeffreytse/zsh-vi-mode"  # Vi-mode mit allem drum und dran

# ============================================================================
# PROMPT PLUGINS - Wähle EINEN aus (oder keinen für Fallback)
# ============================================================================

# --- Minimalistische Prompts ---
plug "woefe/git-prompt.zsh"             # Simpel, nur Git-Info, sehr schnell, mit Standart-Prompt
# plug "agkozak/agkozak-zsh-prompt"     # Minimal aber informativ, async
# plug "geometry-zsh/geometry"          # Minimal, konfigurierbar

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
plug "agkozak/zsh-z"                  # Pure Zsh Implementation von z (keine Dependencies!)
plug "wfxr/forgit"                      # Git mit fzf Interface (git add -i auf Steroiden!)
# plug "paulirish/git-open"             # 'git open' öffnet Repo im Browser
plug "MichaelAquilina/zsh-you-should-use"  # Erinnert dich an Aliases die du hast!

# ============================================================================
# DEVELOPER TOOLS
# ============================================================================

# plug "hlissner/zsh-autopair"          # Auto-schließende Klammern/Quotes
# plug "zsh-users/zsh-history-substring-search"  # Bessere History-Suche (↑↓ Tasten)
# plug "zdharma-continuum/fast-syntax-highlighting"  # Schnellere Alternative zu zsh-syntax-highlighting
# plug "marlonrichert/zsh-autocomplete" # Real-time Autocomplete (WARNUNG: ändert viel Verhalten!)
plug "djui/alias-tips"                  # Zeigt Alias-Tipps wenn du lange Befehle tippst

# ============================================================================
# VISUAL & INFO
# ============================================================================

plug "zsh-users/zsh-completions"        # Vervollständigung
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
# Eigene Funktionen
# ============================================================================

# Tomb in deutsch starten
tomb() {
    TEXTDOMAIN=tomb TEXTDOMAINDIR=/usr/local/share/locale LANG=de_DE.UTF-8 command tomb "$@"
}

# Container-Status für Prompt
function container_status() {
    [ -f /run/.containerenv ] && echo "⚟ "
}

# lf mit Verzeichniswechsel
lfcd () {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

# fzf History Widget
fzf-history-widget() {
  BUFFER=$(fc -l -n 1 | awk '!x[$0]++' | fzf +s +m -e)
  CURSOR=$#BUFFER
  zle redisplay
}

# ============================================================================
# Prompt Konfiguration
# ============================================================================

# Prüfen ob ein Prompt-Plugin geladen wurde (außer git-prompt)
if ! command -v prompt_pure_setup &> /dev/null && \
   ! command -v spaceship_prompt &> /dev/null && \
   [[ -z "$STARSHIP_SHELL" ]] && \
   [[ -z "$POWERLEVEL9K_VERSION" ]]; then

    # FALLBACK: Eigener Prompt (mit git-prompt.zsh Integration falls vorhanden)
    # Farben und Module laden
    autoload -U colors && colors
    autoload -Uz tetriscurses
    # Wenn git-prompt.zsh Plugin geladen ist, nutze es
    if command -v gitprompt &> /dev/null; then
        # git-prompt.zsh Konfiguration
        ZSH_GIT_PROMPT_SHOW_UPSTREAM="full"
        ZSH_GIT_PROMPT_SHOW_STASH=1
        # Nerd Font Symbole für git-prompt.zsh
        ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[magenta]%} "
        ZSH_THEME_GIT_PROMPT_SUFFIX=""
        ZSH_THEME_GIT_PROMPT_SEPARATOR=" "
        ZSH_THEME_GIT_PROMPT_BRANCH="⎇ "                    # Branch Symbol (Nerd Font)
        ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}✓"       # Staged changes
        ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}✖"      # Conflicts
        ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[yellow]%}✚"     # Changed files
        ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}…"     # Untracked
        ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%}⚑"       # Stash
        ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[red]%}↓"         # Behind remote
        ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[green]%}↑"        # Ahead of remote

        # Prompt mit git-prompt.zsh
        PROMPT="%B%{$fg[magenta]%}%n@%m%{$reset_color%} %(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}✗) %{$fg[cyan]%}%c%{$reset_color%} "
        RPROMPT='$(container_status)$(gitprompt)%B%F{cyan} [%*]%b%f'
    else
        # Original Prompt OHNE git-prompt.zsh (mit vcs_info)
        autoload -Uz vcs_info

        # Git Integration für Prompt
        zstyle ':vcs_info:*' enable git
        zstyle ':vcs_info:*' check-for-changes true
        zstyle ':vcs_info:git:*' formats "%{$fg[red]%}[%u %{$fg[magenta]%}%b%{$fg[red]%}]"

        # vcs_info vor jedem Prompt updaten
        precmd_vcs_info() { vcs_info }
        precmd_functions+=( precmd_vcs_info )
        setopt prompt_subst

        # Standard Prompt
        PROMPT="%B%{$fg[magenta]%}%n@%m%{$reset_color%} %(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}✗) %{$fg[cyan]%}%c%{$reset_color%} "
        RPROMPT='$(container_status)$vcs_info_msg_0_%B%F{cyan}[%*]%b%f'
    fi
fi

# ============================================================================
# ZSH Optionen
# ============================================================================

# Verzeichnis-Navigation
setopt autocd                       # Automatisch in Verzeichnisse wechseln
setopt interactive_comments         # Kommentare in interaktiven Shells

# History Konfiguration
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/history"
setopt HIST_IGNORE_ALL_DUPS     # Alle Duplikate ignorieren
setopt HIST_SAVE_NO_DUPS        # Keine Duplikate speichern
setopt HIST_IGNORE_SPACE        # Befehle mit führendem Leerzeichen ignorieren
setopt inc_append_history       # Sofort schreiben
HISTORY_IGNORE="(pass|pass *|man *|ls|ls *|cd|cd *|ytt|ytt *|yt|yt *|tomb|tomb *|pwd|exit|clear|history|history *)"

# ============================================================================
# Completion System
# ============================================================================

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)       # Versteckte Dateien einbeziehen
zstyle ':completion:*' list-prompt ''
zstyle ':completion:*' list-max 0

# ============================================================================
# Keybindings (nur noch die Custom-Bindings, Vi-Mode kommt vom Plugin)
# ============================================================================

# Falls zsh-vi-mode Plugin NICHT geladen ist, nutze basic vi-mode
if ! command -v zvm_version &> /dev/null; then
    bindkey -v
    export KEYTIMEOUT=1
fi

# Custom Keybindings (funktionieren mit und ohne vi-mode plugin)
# Diese müssen NACH dem vi-mode plugin definiert werden

# Completion Menu Navigation (falls vi-mode plugin nicht läuft)
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Custom Funktions-Keybindings
bindkey -s '^o' '^ulfcd\n'                          # Strg+o für lf
bindkey -s '^a' '^ubc -lq\n'                        # Strg+a für bc

# Überschreibe FZF Standard-Keybinding (Ctrl+T → Ctrl+F)
bindkey '^f' fzf-file-widget            # Strg+f für FZF Dateisuche

# FZF Integration laden (ohne Plugin)
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

# fzf History
zle -N fzf-history-widget
bindkey '^r' fzf-history-widget

# Zeile in nvim bearbeiten
autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

# Für zsh-vi-mode Plugin: Custom bindings nach Plugin-Init
if command -v zvm_version &> /dev/null; then
    # Das Plugin überschreibt manche Keybindings, also definieren wir sie neu
    zvm_after_init() {
        # FZF Bindings nach vi-mode Init
        if [ -f /usr/share/fzf/key-bindings.zsh ]; then
            source /usr/share/fzf/key-bindings.zsh
        fi
        bindkey '^r' fzf-history-widget
        bindkey '^f' fzf-file-widget
        bindkey '^e' edit-command-line
    }
fi

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
