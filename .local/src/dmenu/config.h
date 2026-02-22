/* Siehe LICENSE-Datei für Copyright- und Lizenzdetails.
 * Standardeinstellungen; können durch Kommandozeilenoptionen überschrieben werden.
 * ## 2026-02-09	SARBS
 * ~/.local/src/dmenu/config.h */

static int topbar = 1;                      /* -b Option; wenn 0, erscheint dmenu am unteren Bildschirmrand */
/* -fn Option überschreibt fonts[0]; Standard X11-Schriftart oder Schriftsatz */

static const char *fonts[] = {
    "JetBrainsMono NF ExtraLight:style=ExtraLight:size=10:antialias=true:autohint=true",
    "OpenMoji:size=12:antialias=true:autohint=true"
};
static const unsigned int bgalpha = 0xe0;   /* Hintergrund-Alpha (Transparenz) */
static const unsigned int fgalpha = OPAQUE; /* Vordergrund-Alpha (undurchsichtig) */
static const char *prompt      = NULL;      /* -p Option; Eingabeaufforderung links vom Eingabefeld */
static const char *colors[SchemeLast][2] = {
    /*     Vordergrund  Hintergrund */
    [SchemeNorm] = { "#bbbbbb", "#222222" }, /* Normale Einträge */
    [SchemeSel] = { "#eeeeee", "#005577" },  /* Ausgewählter Eintrag */
    [SchemeOut] = { "#000000", "#00ffff" },  /* Ausgabe-Schema */
};
static const unsigned int alphas[SchemeLast][2] = {
    /*      Vordergrund-Alpha  Hintergrund-Alpha */
    [SchemeNorm] = { fgalpha, bgalpha },
    [SchemeSel] = { fgalpha, bgalpha },
    [SchemeOut] = { fgalpha, bgalpha },
};
/* -l Option; wenn nicht Null, verwendet dmenu eine vertikale Liste mit der angegebenen Zeilenzahl */
static unsigned int lines      = 0;
/*
 * Zeichen, die beim Löschen von Wörtern nicht als Teil eines Wortes betrachtet werden
 * zum Beispiel: " /?\"&[]"
 */
static const char worddelimiters[] = " ";

