# Yazi-Umstellungsdokumentation

Tabellarischer Vergleich aller Funktionen zwischen LF und Yazi.

## Navigation

| Funktion             | LF-Binding | Yazi-Binding |
|----------------------|------------|--------------|
| Vorherige Datei      | `k`        | `k`          |
| Nächste Datei        | `j`        | `j`          |
| Ins Unterverzeichnis | `l`        | `l`          |
| Zurück (Parent)      | `h`        | `h`          |
| Zum Anfang           | `g`        | `g g`        |
| Zum Ende             | `-`        | `G`          |
| Verlauf zurück       | –          | `H`          |
| Verlauf vorwärts     | –          | `L`          |
| Home-Verzeichnis     | `H`        | `g h`        |
| Nach Unten (Seite)   | `<C-f>`    | `<C-f>`      |
| Nach Oben (Seite)    | `<C-b>`    | `<C-b>`      |
| Vorschau scrollen ↑  | –          | `K`          |
| Vorschau scrollen ↓  | –          | `J`          |

## Datei-Operationen

| Funktion                 | LF-Binding      | Yazi-Binding      |
|--------------------------|-----------------|-------------------|
| Öffnen (Standard)        | `o`             | `o` / `<Enter>`   |
| Öffnen (Auswahl)         | `O`             | `O` / `<S-Enter>` |
| Kopieren (yank)          | –               | `y`               |
| Ausschneiden (cut)       | –               | `x`               |
| Einfügen (paste)         | –               | `p`               |
| Einfügen (überschreiben) | –               | `P`               |
| Löschen (Papierkorb)     | –               | `d`               |
| Löschen (permanent)      | `D`             | `D`               |
| Datei erstellen          | –               | `a`               |
| Umbenennen               | `I` / `i` / `c` | `r`               |
| Hardlink erstellen       | –               | `<C-->`           |
| Symlink erstellen        | –               | `-`               |
| Symlink relativ          | –               | `_`               |
| Auswahl umkehren         | –               | `<C-r>`           |
| Alle auswählen           | –               | `<C-a>`           |
| Toggle/Markieren         | `<Space>`       | `<Space>`         |
| Visueller Modus          | –               | `v` / `V`         |
| Abwählen                 | `<C-l>`         | `<Esc>`           |
| Versteckte Dateien       | `<C-s>`         | `.`               |

## Suche & Filter

| Funktion               | LF-Binding        | Yazi-Binding |
|------------------------|-------------------|--------------|
| Suche mit fzf          | `<C-f>`           | `z`          |
| Suche mit fd           | `J` (Lesezeichen) | `s`          |
| Inhaltssuche (rg)      | –                 | `S`          |
| Filtern                | `-`               | `f`          |
| Find (vorwärts)        | –                 | `/`          |
| Find (rückwärts)       | –                 | `?`          |
| Nächstes Ergebnis      | –                 | `n` / `N`    |
| Zoxide (Verzeichnisse) | –                 | `Z`          |

## Sortierung

| Funktion                      | LF-Binding | Yazi-Binding  |
|-------------------------------|------------|---------------|
| Sortierung alphabetisch       | `sc`       | `, a` / `, A` |
| Sortierung natürlich          | –          | `, n` / `, N` |
| Sortierung Größe              | –          | `, s` / `, S` |
| Sortierung Zeit (mtime)       | –          | `, m` / `, M` |
| Sortierung Erstellung (btime) | –          | `, b` / `, B` |
| Sortierung Erweiterung        | –          | `, e` / `, E` |
| Sortierung zufällig           | –          | `, r`         |

## Anzeige & Vorschau

| Funktion                  | LF-Binding   | Yazi-Binding |
|---------------------------|--------------|--------------|
| Vorschau                  | Scope-Skript | Eingebaut    |
| Linemode: Keine           | –            | `m n`        |
| Linemode: Größe           | –            | `m s`        |
| Linemode: Berechtigungen  | –            | `m p`        |
| Linemode: Erstellungszeit | –            | `m b`        |
| Linemode: Änderungszeit   | –            | `m m`        |
| Linemode: Besitzer        | –            | `m o`        |
| Detail-Anzeige (Spot)     | –            | `<Tab>`      |
| Hilfe                     | –            | `~` / `<F1>` |

## Tabs

| Funktion                 | LF-Binding | Yazi-Binding |
|--------------------------|------------|--------------|
| Neuer Tab                | –          | `t t`        |
| Tab umbenennen           | –          | `t r`        |
| Tab 1-9 wechseln         | –          | `1`-`9`      |
| Tab wechseln (prev/next) | –          | `[` / `]`    |
| Tab tauschen             | –          | `{` / `}`    |

## Aufgaben-Manager

| Funktion          | LF-Binding | Yazi-Binding |
|-------------------|------------|--------------|
| Aufgaben anzeigen | –          | `w`          |
| Suspendieren      | `<C-z>`    | `<C-z>`      |

## Shell & Befehle

| Funktion            | LF-Binding | Yazi-Binding |
|---------------------|------------|--------------|
| Shell öffnen        | `<Enter>`  | `;`          |
| Shell (blockierend) | `X`        | `:`          |
| Datei ausführen     | `x` / `X`  | `;` / `:`    |

## Zwischenablage

| Funktion             | LF-Binding | Yazi-Binding |
|----------------------|------------|--------------|
| Pfad kopieren        | `U`        | `c c`        |
| Verzeichnis kopieren | –          | `c d`        |
| Dateiname kopieren   | `u`        | `c f`        |
| Name ohne Extension  | –          | `c n`        |
| ClipFile Copy        | `Yy`       | –            |
| ClipFile Cut         | `Yx`       | –            |
| ClipFile Paste       | `Yp`       | –            |
| ClipPaste            | `Yi`       | –            |

## Deine benutzerdefinierten LF-Funktionen (müssen migriert werden)

| Funktion                    | LF-Binding        | Yazi-Status                       |
|-----------------------------|-------------------|-----------------------------------|
| Filme archivieren (rsync)   | `Af`              | ❌ Muss erstellt werden           |
| Handy-Downloads (ADB)       | `Ad`              | ❌ Muss erstellt werden           |
| Handy-Musik (ADB)           | `Am`              | ❌ Muss erstellt werden           |
| Bildkomprimierung 80%       | `P8`              | ❌ Muss erstellt werden           |
| Bildkomprimierung 60%       | `P6`              | ❌ Muss erstellt werden           |
| Video → Audio               | `Rx`              | ❌ Muss erstellt werden           |
| Video konvertieren          | `Rv`              | ❌ Muss erstellt werden           |
| Video → YouTube             | `Ry`              | ❌ Muss erstellt werden           |
| Datum bearbeiten            | `äd`              | ❌ Muss erstellt werden           |
| Ausführungsrechte setzen    | `äx` / `<C-x>`    | ❌ Muss erstellt werden           |
| Ausführungsrechte entziehen | `äX` / `<C-y>`    | ❌ Muss erstellt werden           |
| Bulk Rename                 | `B`               | ⚠️ Yazi hat eigenes Rename        |
| Hintergrund setzen          | `b`               | ❌ Muss erstellt werden           |
| Thumbnail-Modus (nsxiv)     | `T`               | ⚠️ Yazi hat eingebaute Vorschau   |
| Neues Verzeichnis           | `<C-n>`           | ❌ `a` erstellt beides            |
| Reload                      | `<C-r>` / `<Tab>` | ⚠️ Automatisch bei Yazi           |
| Git Status                  | `ös`              | ❌ Muss erstellt werden           |
| Git Log                     | `öl`              | ❌ Muss erstellt werden           |
| Git Diff                    | `öd`              | ❌ Muss erstellt werden           |
| Git Add                     | `öa`              | ❌ Muss erstellt werden           |
| Git Add All                 | `öA`              | ❌ Muss erstellt werden           |
| Git Reset                   | `ör`              | ❌ Muss erstellt werden           |
| Git Commit                  | `öc`              | ❌ Muss erstellt werden           |
| Git Push                    | `öp`              | ❌ Muss erstellt werden           |
| Git Pull                    | `öP`              | ❌ Muss erstellt werden           |
| Git Magit                   | `öm`              | ❌ Muss erstellt werden           |
| Git Add Interactive         | `öi`              | ❌ Muss erstellt werden           |
| Lesezeichen (bm-dirs)       | `J`               | ❌ Muss erstellt werden           |
| Extrahieren                 | `E`               | ⚠️ Yazi hat eingebaute Extraktion |
| Kopieren nach... (fzf)      | `C`               | ❌ Muss erstellt werden           |
| Verschieben nach... (fzf)   | `M`               | ❌ Muss erstellt werden           |

## Migrationsplan

### Phase 1: Yazi-Grundlagen einrichten
- [ ] Keymap.toml mit LF-ähnlichen Bindings ergänzen
- [ ] yazi.toml für Anzeige- und Vorschaueinstellungen konfigurieren
- [ ] Plugins installieren (fzf, zoxide)

### Phase 2: Benutzerdefinierte Funktionen migrieren
- [ ] Shell-Befehle als Yazi-Kommandos erstellen
- [ ] Git-Funktionen als Skripte/Plugins portieren
- [ ] Medien-Funktionen (Konvertierung, Archiv) portieren

### Phase 3: Feinabstimmung
- [ ] Which-Menu für benutzerdefinierte Funktionen einrichten
- [ ] Lesezeichen-System einrichten
- [ ] Open-Rules für spezielle Dateitypen konfigurieren
