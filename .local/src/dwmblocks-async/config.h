#ifndef CONFIG_H
#define CONFIG_H

/*
 * 2026-02-09	SARBS
 * Zeichenkette, die zwischen den Block-Ausgaben in der Statusleiste eingefügt wird.
 * Beispiele für mögliche Delimiter: █ 󰇝 󱋱    |
 */
#define DELIMITER "|"

// Maximale Anzahl von Unicode-Zeichen, die ein Block ausgeben kann.
#define MAX_BLOCK_OUTPUT_LENGTH 45

// Steuert, ob Blöcke anklickbar sind (1 = aktiviert, 0 = deaktiviert).
#define CLICKABLE_BLOCKS 1

// Steuert, ob ein führender Delimiter am Anfang der Statusleiste eingefügt wird.
#define LEADING_DELIMITER 0

// Steuert, ob ein abschließender Delimiter am Ende der Statusleiste eingefügt wird.
#define TRAILING_DELIMITER 0

// status2d: Automatisches Einfügen von ^d^ (Farb-Reset) zwischen Blöcken
// DEAKTIVIERT: Inkompatibel mit statuscmd - Farben müssen in Skripten mit ^d^ beendet werden
#define STATUS2D_AUTO_RESET 0

/* Definiert Blöcke für die Statusleiste als X(Symbol, Befehl, Intervall, Signal). */
/*  X(Symbol,   Befehl,                             Intervall,  Aktualisierungssignal) */
/*  Hinweis: Signale müssen zwischen 1-30 liegen (SIGRTMIN+0 bis SIGRTMIN+29).     */
/*  Intervall in Sekunden: 0 = nur bei Signal-Aktualisierung, >0 = regelmäßig.     */
#define BLOCKS(X)                                                               \
    X("",       "cat /tmp/recordingicon 2>/dev/null",   1,      1)              \
    X("",       "sb-music",                             1,      7)              \
    X("",		"sb-pacpackages",                       0,      5)              \
    X("",       "sb-mailbox",                           600,    20)             \
    X("",       "sb-news",                              600,    8)              \
    X("",       "sb-nettraf",                           1,      24)             \
	X("",       "sb-internet",                          5,      23)             \
    X("",       "sb-volume",                            60,     21)             \
	X("",		"sb-bluetooth",							0,		18)				\
    X("",       "sb-battery",                           60,     22)             \
	X("",       "sb-xsct",                              300,    30)             \
    X("",       "sb-clock",                             60,     26)             \
	X("",		"sb-iplocate",							0,		27)				\

#endif
/*
    Auskommentierte Blöcke (bei Bedarf aktivieren):
	X("",       "sb-yt",                                0,      28)             \
	X("",       "sb-hintergrund",                       0,      29)             \
	X("",       "sb-price btc-usd Bitcoin ",           9000,   12)             \
	X("",       "sb-doppler",                           0,      2)              \
	X("",       "sb-forecast",                          18000,  19)             \
	X("",       "sb-moonphase",                         18000,  4)              \
    X("",       "sb-tasks",                             10,     6)              \
    X("",       "sb-price xmr-btc \"Monero to Bitcoin\"  25",   9000,   9)      \
    X("",       "sb-price xmr-usd Monero ",            9000,   10)             \
    X("",       "sb-price eth-usd Ethereum ",          9000,   11)             \
    X("",       "sb-tomb",                              0,      11)             \
    X("",       "sb-price btc-usd Bitcoin 󰠓",           9000,   12)             \
    X("",       "sb-torrent",                           20,     13)             \
    X("",       "sb-ram",                               10,     14)             \
    X("",       "sb-cpu",                               10,     15)             \
    X("",       "sb-disk",                              10,     16)             \
    X("",       "sb-cpubars",                           1,      17)             \
    X("",       "sb-kbselect",                          0,      25)             \
	X("",       "sb-help-icon",                         0,		3)              \
*/
