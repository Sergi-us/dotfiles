# chroot-update — Dokumentation
## 2026-08-30 SARBS core DEV

Zentrales Skript zum Bauen von AUR-Paketen in einer systemweit geteilten
chroot-Umgebung.

## Konzept

AUR-Pakete werden nicht direkt auf dem System gebaut, sondern isoliert in
einer sauberen Arch-chroot. Das erhöht die Sicherheit (PKGBUILD-Code läuft
abgeschottet in `systemd-nspawn`) und die Reproduzierbarkeit (Build in
definierter Umgebung mit `base-devel`).

Kernentscheidungen:

- **Eine chroot für alle Nutzer** statt einer pro Nutzer. Die chroot ist nur
  ein Verzeichnisbaum und kann geteilt werden. Das spart pro Nutzer ca. 2 GB.
- **Dedizierter System-Nutzer `aurbuilder`**: Alle Builds laufen als dieser
  Nutzer, dadurch ist das Skript unabhängig vom aufrufenden Nutzer und alle
  Nutzer teilen sich dieselbe chroot-Arbeitskopie
  (`/var/lib/archbuild/sarbs-chroot/extra-x86_64/aurbuilder`).
- **Lokales Repo `sarbs-local`**: Gebaute Pakete landen in
  `/var/cache/pacman/pkg/sarbs-local/`, werden per `repo-add` in eine
  pacman-Datenbank eingetragen (in `pacman.conf` registriert) und von dort
  installiert.

## Ablauf eines Upgrades (`chroot-update update`)

```
sudo -v + Keep-alive (lange Builds, sudo-Cache läuft nicht ab)
   │
   ├─ 1. pacman -Syy                  (Paketdatenbanken synchronisieren)
   ├─ 2. Updates analysieren          (yay -Qu: offiziell vs. AUR trennen)
   ├─ 3. Offizielle Pakete: pacman -Su (VOR dem AUR-Build, damit chroot
   │                                    und System zusammenpassen)
   ├─ 4. AUR-Pakete im chroot bauen:
   │      yay -G <paket>              (PKGBUILD aus dem AUR klonen)
   │      chown auf aurbuilder        (Schreibrechte, s.u.)
   │      sudo -u aurbuilder extra-x86_64-build -r <chroot-dir>
   │      Ergebnis nach sarbs-local kopieren
   ├─ 5. repo-add -n -p               (lokale Repo-Datenbank aktualisieren)
   ├─ 6. pacman -U <gebaute Pakete>   (installieren)
   └─ 7. Statusbar-Signale RTMIN+5 / RTMIN+8 (sb-pacpackages, sb-news)
```

## Aufbau des Skripts

Subkommandos für spätere Rofi/dmenu-Integration:

| Befehl            | Zweck                                                       |
|-------------------|-------------------------------------------------------------|
| `setup`           | Build-Nutzer, chroot, lokales Repo + pacman.conf-Eintrag anlegen (idempotent) |
| `update`          | Vollständiges System-Upgrade (offiziell + AUR im chroot)    |
| `build <paket>`   | Einzelnes AUR-Paket bauen und installieren                  |
| `status`          | Maschinell lesbare Statusausgabe (chroot, Nutzer, Update-Zahlen) |
| `clean`           | Build-Reste, chroot-Arbeitskopien, verwaiste Dateien entfernen |
| `--no-notify`     | Desktop-Benachrichtigungen unterdrücken                     |

Interne Funktionen:

- `meldung()`          — Ausgabe auf stdout + optional `notify-send`
- `sudo_keepalive()`   — Hintergrund-Schleife, erneuert den sudo-Cache alle 55 s
- `updates_analysieren()` — Update-Liste in offiziell/AUR trennen
- `pruefe_aur_version()`  — AUR-RPC-Abfrage + `vercmp` (s. Abschnitt Watchliste)
- `baue_aur_paket()`   — PKGBUILD holen, Rechte setzen, im chroot bauen, Paket einsammeln
- `repo_aktualisieren()` — `repo-add` auf die neu gebauten Pakete

## Das Berechtigungsmodell

Der komplizierteste Teil. Vier Ebenen spielen zusammen:

```
aufrufender Nutzer (z.B. sergi, in wheel)
   │ sudo -u aurbuilder             ← sudoers-Zeile 2
   ▼
aurbuilder (System-Nutzer, nologin)
   │ extra-x86_64-build
   │   └─ check_root: exec sudo -- …  ← sudoers-Zeile 1 (devtools-intern!)
   ▼
root
   └─ makechrootpkg → arch-nspawn → systemd-nspawn (chroot/Container)
        └─ darin: Build-Nutzer "builduser" mit der UID von aurbuilder
            └─ makepkg läuft als builduser (niemals als root)
```

Wichtige Erkenntnisse (Quelle: devtools-Quelltext `/usr/bin/makechrootpkg`,
`/usr/bin/extra-x86_64-build`, `/usr/share/devtools/lib/archroot.sh`):

1. **devtools eskaliert selbst.** `extra-x86_64-build` und `makechrootpkg`
   rufen intern `check_root` auf, das sich per `exec sudo --` selbst als root
   neu startet. `aurbuilder` braucht deshalb genau eine NOPASSWD-Regel für
   `/usr/bin/extra-x86_64-build`.
2. **Arbeitskopie heißt wie `$SUDO_USER`.** `makechrootpkg` benennt die
   Build-Kopie der chroot nach `$SUDO_USER` (Zeile 46) — beim eskalierten
   sudo ist das immer `aurbuilder`. Deshalb teilen sich alle Nutzer eine
   Kopie, egal wer den Build anstößt. `src_owner=$SUDO_USER` sorgt dafür,
   dass fertige Pakete anschließend `aurbuilder` gehören.
3. **Quellen-Download läuft als `aurbuilder` auf dem Host.**
   `makechrootpkg:download_sources()` führt `sudo -u aurbuilder makepkg
   --verifysource` aus, mit `$SRCDEST` = unserem Paketverzeichnis. Dieses
   Verzeichnis gehört aber zunächst dem aufrufenden Nutzer →
   `sudo chown -R aurbuilder "$pkg_dir"` vor dem Build ist Pflicht
   (Fehler sonst: "You do not have write permission for the directory
   $SRCDEST").
4. **Aufräumen nur mit sudo.** Nach dem Build gehören die Dateien
   `aurbuilder` bzw. root — `rm -rf` ohne sudo schlägt fehl. Das gilt auch
   für `clean` und das temporäre Build-Verzeichnis `/tmp/chroot-update`.

Die sudoers-Datei (manuell anzulegen, Anleitung steht auch im Skriptkopf):

```
# sudo visudo -f /etc/sudoers.d/aurbuilder
aurbuilder ALL=(root) NOPASSWD: /usr/bin/extra-x86_64-build
%wheel ALL=(aurbuilder) NOPASSWD: /usr/bin/extra-x86_64-build
```

## Weg der Befehle in die chroot

```
extra-x86_64-build -r <dir> [-- <makechrootpkg-Argumente>]
   │  hängt an <dir> automatisch "extra-x86_64" an (Repo-Architektur)!
   │  erstellt/synchronisiert <dir>/extra-x86_64/root selbst
   │  (erster Aufruf: mkarchroot, danach: pacman -Syuu in der root-Kopie)
   ▼
makechrootpkg -r <dir>/extra-x86_64 -c -n -C [-- <makepkg-Argumente>]
   │  -c: Arbeitskopie vorher säubern   -n: namcap   -C: checkpkg
   │  legt Kopie an: <dir>/extra-x86_64/aurbuilder
   │  bind-mountet das aktuelle Verzeichnis (mit PKGBUILD) nach /startdir
   ▼
arch-nspawn → systemd-nspawn (Container aus der Kopie)
   │  im Container: pacman holt Build-Abhängigkeiten (--syncdeps)
   ▼
sudo -iu builduser makepkg --noconfirm …   (builduser = UID von aurbuilder)
   ▼
Ergebnis: *.pkg.tar.zst wird zurück nach /startdir (= unser pkg_dir)
kopiert und gehört danach aurbuilder
```

Stolperfalle Doppel-Dash: Alles nach `--` bei `extra-x86_64-build` geht an
**makechrootpkg**, nicht an makepkg. makepkg-Argumente brauchen ein zweites
`--` (`extra-x86_64-build -r … -- -- --clean --noconfirm`). Die
makepkg-Standards von makechrootpkg (`--syncdeps --noconfirm --log --holdver
--skipinteg`) genügen jedoch — das Skript übergibt daher gar keine
Extra-Argumente.

## AUR-Erkennung und die Watchliste

- `yay -Qu` listet **alle** Updates; Zeilen mit `[ignored]` werden
  gefiltert. Achtung: `yay -Qua` würde mit `-a` auf AUR filtern und die
  offiziellen Updates verschlucken (Bug aus dem Alt-Skript).
- Installierte Fremd-Pakete (`pacman -Qm`) werden mit der Update-Liste
  abgeglichen → AUR-Kandidaten.
- **Problem:** Ein Paket, das aus dem lokalen Repo installiert wurde, gilt
  für pacman als "nativ" (steht ja in der sarbs-local-Datenbank) und taucht
  nicht mehr in `pacman -Qm` auf — Updates dafür würden nie erkannt.
- **Lösung:** `sarbs-local/aur-pakete.txt` merkt sich jedes selbst gebaute
  Paket (Watchliste). Für diese Pakete wird die AUR-Version direkt per
  AUR-RPC (`curl https://aur.archlinux.org/rpc/v5/info`) geholt und mit
  `vercmp` gegen die installierte Version verglichen.
- DEV-Alternative (im Skript auskommentiert dokumentiert): auf `repo-add`
  verzichten, dann blieben die Pakete "foreign" — aber ohne gepflegtes Repo.

## Pfade

| Pfad                                                      | Inhalt                                |
|-----------------------------------------------------------|---------------------------------------|
| `/var/lib/archbuild/sarbs-chroot/extra-x86_64/root`       | unberührte chroot-Basis               |
| `/var/lib/archbuild/sarbs-chroot/extra-x86_64/aurbuilder` | Arbeitskopie (alle Nutzer)            |
| `/var/cache/pacman/pkg/sarbs-local/`                      | gebaute Pakete + Repo-DB + Watchliste |
| `/tmp/chroot-update/<paket>/`                             | PKGBUILD + Build-Zwischenablage       |

## Einbindung

- `statusbar/sb-popupgrade` ruft `chroot-update update` auf.
  `CHROOT_BUILD=0` erzwingt den Direktmodus (`yay -Syu`), fehlendes Setup
  führt zu einer Rückfrage mit Fallback.
- Nach dem Upgrade sendet das Skript `pkill -RTMIN+5/-8` an dwmblocks
  (Update-Symbol und News-Modul aktualisieren sich).
- Für Rofi/dmenu: `status` liefert einfache Textzeilen, `--no-notify`
  unterdrückt Desktop-Popups.

## Lehren aus der DEV-Phase (getestete Fehlerbilder)

1. `-- --clean --noconfirm` landete im `getopts` von makechrootpkg
   → "illegal option -- -". Argumente nach `--` sind makechrootpkg-Argumente.
2. Die chroot liegt nicht direkt unter `-r <dir>`, sondern unter
   `<dir>/extra-x86_64/`; devtools erstellt/synchronisiert sie selbst.
   Ein eigener `arch-nspawn`-Sync war überflüssig und pflegte die falsche Kopie.
3. Ohne `chown` des Paketverzeichnisses: "You do not have write permission
   for the directory $SRCDEST" (Quellen-Download läuft als `aurbuilder`).
4. Der Globus `*.pkg.tar.*` fischt auch `…pkg.tar.zst-namcap.log` heraus —
   Filter auf `*.log`/`*.sig` nötig, sonst füttert man `repo-add`/`pacman -U`
   mit Logdateien.
5. Aufräumen fremder Dateien braucht `sudo`; `status` nutzt `sudo -n`,
   um nie nach einem Passwort zu fragen.
6. `yay -Qua` zeigt nur AUR-Updates → offizielle Pakete wurden nie
   aktualisiert; korrekt ist `yay -Qu`.

## Status

DEV-Modus: Das Skript wird einige Monate im Mehrnutzer-Betrieb getestet.
Erst danach wird der DEV-Header entfernt und auskommentierter Test-Code
bereinigt. Bekannte Grenzen: AUR-Pakete, die von *anderen* AUR-Paketen
abhängen, können im chroot nicht aufgelöst werden (das lokale Repo ist dort
nicht eingebunden).
