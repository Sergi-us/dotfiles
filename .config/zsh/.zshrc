## 2025-01-08 SARBS
#
# TODO Zinit testen https://github.com/zdharma-continuum/zinit
# TODO Plugin's Testen

# Hilfsfunktion zum Hinzufügen einer Datei zur Zsh-Konfiguration
function zsh_add_file() {
    local FILE_PATH="$ZDOTDIR/$1"
    if [ -f "$FILE_PATH" ]; then
        source "$FILE_PATH"
        return 0
    else
        return 1
    fi
}

# Funktion für Container-Check
function container_status() {
    [ -f /run/.containerenv ] && echo "🐋 "
}

# Farben einschalten und Eingabeaufforderung ändern
autoload -U colors && colors
autoload -Uz vcs_info
autoload -Uz tetriscurses

# Funktion zum Hinzufügen eines Symbols für ungetrackte Dateien
vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
       git status --porcelain | grep '??' &> /dev/null ; then
        echo -n " "
    fi
}

# Git-Änderungen prüfen und Format festlegen
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats "%{$fg[red]%}[%u %{$fg[magenta]%}%b%{$fg[red]%}]"
##zstyle ':vcs_info:git:*' formats " %{$fg[blue]%}(%{$fg[red]%}%m%{$fg[red]%}(%u)%c%{$fg[magenta]%} %b%{$fg[blue]%})%{$reset_color%}"

# Funktion zum Initialisieren von vcs_info vor jedem Prompt
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst

# Einzeileger Prompt-Konfiguration
# PROMPT="%B[%{$fg[magenta]%}%n@%m%{$reset_color%}] [%{$fg[cyan]%}%~%{$reset_color%}]"
# RPROMPT='$vcs_info_msg_0_ %B%F{cyan}[%*]%b%f'

# Zweizeiliger Promt
PROMPT="%B%{$fg[magenta]%}%n@%m%{$reset_color%} %(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}✗) %{$fg[cyan]%}%c%{$reset_color%} "
RPROMPT='$(container_status)$vcs_info_msg_0_%B%F{cyan}[%*]%b%f'

# Automatisches Wechseln in Verzeichnisse bei Eingabe
setopt autocd

# Deaktivieren von Strg-s, um das Terminal einzufrieren
stty stop undef

# Erlaube Kommentare in interaktiven Shells
setopt interactive_comments

# Verlauf im Cache-Verzeichnis speichern
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CONFIG_HOME:-$HOME/}/zsh/history"
setopt inc_append_history

# Alias und Verknüpfungen laden, falls vorhanden
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"


# Basic auto/tab completion
autoload -U compinit
zstyle ':completion:*' menu select  # Diese Zeile deaktivieren oder anpassen
zmodload zsh/complist
compinit
_comp_options+=(globdots)  # Versteckte Dateien einbeziehen
zstyle ':completion:*' list-prompt ''
zstyle ':completion:*' list-max 0

# vi Modus mit Tastenbelegungen und unterschiedlichen Cursern
bindkey -v
export KEYTIMEOUT=1

# Vim Tasten in Tab Completion Menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Cursor ändern für verschiedene vi Modi
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;  # Block
        viins|main) echo -ne '\e[5 q';;  # Strahl
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q'  # Strahlform-Cursor beim Start
preexec() { echo -ne '\e[5 q' ;}  # Strahlform-Cursor für jeden neuen Prompt

# Funktion um Verzeichnisse mit lf zu wechseln und an Strg-o binden
lfcd () {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' '^ulfcd\n'

bindkey -s '^a' '^ubc -lq\n'
bindkey -s '^f' '^ucd "$(dirname "$(fzf)")"\n'
bindkey '^[[P' delete-char

# Zeile in nvim mit Strg-e bearbeiten
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete

# Key Binding für Strg+f um fzf zu starten
bindkey '^f' fzf-file-widget

# Funktion um die Bash-Historie mit fzf zu durchsuchen
fzf-history-widget() {
  BUFFER=$(fc -l -n 1 | awk '!x[$0]++' | fzf +s +m -e)
  CURSOR=$#BUFFER
  zle redisplay
}

# Funktion um Datein zu finden
bindkey -s '^f' '^ucd "$(dirname "$(fzf)")"\n'

# Strg+r an fzf-history-widget binden
zle -N fzf-history-widget
bindkey '^r' fzf-history-widget

# Auto-Suggestions aktivieren (zsh-autosuggestions muss installiert sein)
# source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# Funktion zum Hinzufügen von Zsh-Plugins
function zsh_add_plugin() {
    local REPO=$1
    local PLUGIN_NAME=$(echo $REPO | awk -F'/' '{print $2}')
    local PLUGIN_PATH="$ZDOTDIR/plugins/$PLUGIN_NAME"

    # Stelle sicher, dass das Plugin-Verzeichnis existiert
    mkdir -p "$ZDOTDIR/plugins"

    # Plugin-Dateien laden
    function load_plugin_files() {
        if ! zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh"; then
            if ! zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"; then
                echo "Plugin-Dateien für $PLUGIN_NAME nicht gefunden."
                return 1
            fi
        fi
        return 0
    }

    if [ -d "$PLUGIN_PATH" ]; then
        # Plugin existiert bereits, versuche Plugin-Datei zu laden
        if ! load_plugin_files; then
            echo "Fehler beim Laden der Plugin-Dateien für $PLUGIN_NAME"
            return 1
        fi
    else
        # Klone das Plugin-Repository
        git clone "https://github.com/$REPO.git" "$PLUGIN_PATH" || {
            echo "Fehler beim Klonen des Repositories $REPO"
            return 1
        }
        # Plugin-Dateien laden
        if ! load_plugin_files; then
            echo "Fehler beim Laden der Plugin-Dateien für $PLUGIN_NAME"
            return 1
        fi
    fi
    return 0
}


# Laden von Plugins aus verschiedenen Repositories
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zdharma-continuum/zinit"
