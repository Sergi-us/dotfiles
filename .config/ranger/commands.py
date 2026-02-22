# SARBS Ranger-Befehle
## 2026-02-21   SARBS
# Eigene Befehle angelehnt an die lf-Konfiguration

from __future__ import (absolute_import, division, print_function)

import os
import subprocess
from ranger.api.commands import Command


class extract(Command):
    """:extract
    Archivdateien extrahieren (zip, tar, etc.)
    """
    def execute(self):
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        if not marked_files:
            return

        for f in marked_files:
            filepath = f.path
            ext = filepath.lower()
            if ext.endswith('.tar.bz2'):
                cmd = ['tar', 'xjf', filepath]
            elif ext.endswith('.tar.gz'):
                cmd = ['tar', 'xzf', filepath]
            elif ext.endswith('.tar.xz'):
                cmd = ['tar', 'xf', filepath]
            elif ext.endswith('.bz2'):
                cmd = ['bunzip2', filepath]
            elif ext.endswith('.rar'):
                cmd = ['unrar', 'e', filepath]
            elif ext.endswith('.gz'):
                cmd = ['gunzip', filepath]
            elif ext.endswith('.tar'):
                cmd = ['tar', 'xf', filepath]
            elif ext.endswith('.tbz2'):
                cmd = ['tar', 'xjf', filepath]
            elif ext.endswith('.tgz'):
                cmd = ['tar', 'xzf', filepath]
            elif ext.endswith('.zip'):
                cmd = ['unzip', filepath]
            elif ext.endswith('.z'):
                cmd = ['uncompress', filepath]
            elif ext.endswith('.7z'):
                cmd = ['7z', 'x', filepath]
            elif ext.endswith('.img.xz'):
                cmd = ['xz', '-d', filepath]
            else:
                self.fm.notify("Unbekanntes Archivformat: " + filepath, bad=True)
                continue

            self.fm.execute_command(cmd, cwd=cwd.path)
            self.fm.notify("Extrahiert: " + os.path.basename(filepath))

        cwd.load_content()


class moveto(Command):
    """:moveto
    Dateien verschieben mit fzf-Zielauswahl aus Lesezeichen
    """
    def execute(self):
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()
        if not marked_files:
            return

        bm_dirs = os.path.expandvars(
            os.environ.get('XDG_CONFIG_HOME', os.path.expanduser('~/.config'))
            + '/shell/bm-dirs'
        )

        # fzf fuer Zielauswahl
        try:
            proc = subprocess.Popen(
                ['bash', '-c',
                 'sed -e "s/\\s*#.*//" -e "/^$/d" -e "s/^\\S*\\s*//" '
                 + '"' + bm_dirs + '" | fzf --prompt="Wohin verschieben> "'],
                stdout=subprocess.PIPE, stderr=subprocess.PIPE
            )
            stdout, _ = proc.communicate()
            dest = stdout.decode('utf-8').strip()
        except Exception:
            self.fm.notify("fzf nicht gefunden", bad=True)
            return

        if not dest:
            return

        dest = os.path.expanduser(dest.replace('~', os.path.expanduser('~')))

        for f in marked_files:
            self.fm.execute_command(
                ['mv', '-iv', f.path, dest],
                cwd=cwd.path
            )

        self.fm.notify("Datei(en) verschoben nach " + dest)
        cwd.load_content()


class copyto(Command):
    """:copyto
    Dateien kopieren mit fzf-Zielauswahl aus Lesezeichen
    """
    def execute(self):
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()
        if not marked_files:
            return

        bm_dirs = os.path.expandvars(
            os.environ.get('XDG_CONFIG_HOME', os.path.expanduser('~/.config'))
            + '/shell/bm-dirs'
        )

        try:
            proc = subprocess.Popen(
                ['bash', '-c',
                 'sed -e "s/\\s*#.*//" -e "/^$/d" -e "s/^\\S*\\s*//" '
                 + '"' + bm_dirs + '" | fzf --prompt="Wohin kopieren> "'],
                stdout=subprocess.PIPE, stderr=subprocess.PIPE
            )
            stdout, _ = proc.communicate()
            dest = stdout.decode('utf-8').strip()
        except Exception:
            self.fm.notify("fzf nicht gefunden", bad=True)
            return

        if not dest:
            return

        dest = os.path.expanduser(dest.replace('~', os.path.expanduser('~')))

        for f in marked_files:
            self.fm.execute_command(
                ['cp', '-ivr', f.path, dest],
                cwd=cwd.path
            )

        self.fm.notify("Datei(en) kopiert nach " + dest)
        cwd.load_content()


class bild_komprimieren(Command):
    """:bild_komprimieren
    Bilder auf 80% Qualitaet komprimieren (benoetogt imagemagick)
    """
    def execute(self):
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()
        if not marked_files:
            return

        for f in marked_files:
            filepath = f.path
            base, ext = os.path.splitext(filepath)
            output = base + "_komprimiert-80" + ext
            result = self.fm.execute_command(
                ['magick', filepath, '-quality', '80', output],
                cwd=cwd.path
            )
            if result == 0:
                self.fm.notify("Komprimiert: " + os.path.basename(output))
            else:
                self.fm.notify("Fehler bei: " + os.path.basename(filepath), bad=True)

        cwd.load_content()


class fzf_select(Command):
    """:fzf_select
    Dateisuche mit fzf (wie Strg+f in lf)
    """
    def execute(self):
        try:
            proc = subprocess.Popen(
                ['fzf', '--height=-10'],
                stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                cwd=self.fm.thisdir.path
            )
            stdout, _ = proc.communicate()
            result = stdout.decode('utf-8').strip()
        except Exception:
            self.fm.notify("fzf nicht gefunden", bad=True)
            return

        if not result:
            return

        fzf_file = os.path.join(self.fm.thisdir.path, result)
        fzf_file = os.path.abspath(fzf_file)

        if os.path.isdir(fzf_file):
            self.fm.cd(fzf_file)
        elif os.path.isfile(fzf_file):
            self.fm.select_file(fzf_file)


class fzf_bookmark(Command):
    """:fzf_bookmark
    Lesezeichenauswahl mit fzf (wie J in lf)
    """
    def execute(self):
        bm_dirs = os.path.expandvars(
            os.environ.get('XDG_CONFIG_HOME', os.path.expanduser('~/.config'))
            + '/shell/bm-dirs'
        )

        try:
            proc = subprocess.Popen(
                ['bash', '-c',
                 'sed -e "s/\\s*#.*//" -e "/^$/d" -e "s/^\\S*\\s*//" '
                 + '"' + bm_dirs + '" | fzf --prompt="Lesezeichen> "'],
                stdout=subprocess.PIPE, stderr=subprocess.PIPE
            )
            stdout, _ = proc.communicate()
            dest = stdout.decode('utf-8').strip()
        except Exception:
            self.fm.notify("fzf nicht gefunden", bad=True)
            return

        if dest:
            dest = os.path.expanduser(dest.replace('~', os.path.expanduser('~')))
            self.fm.cd(dest)


class git_status(Command):
    """:git_status
    Ausfuehrliche Git-Status-Anzeige (wie oess in lf)
    """
    def execute(self):
        self.fm.execute_command(
            ['bash', '-c',
             'if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then '
             'echo -e "\\033[33m=== Git Repository Status ===\\033[0m"; '
             'echo ""; '
             'echo -e "Branch: \\033[36m$(git branch --show-current)\\033[0m"; '
             'remote=$(git remote -v | head -1 | awk \'{print $2}\'); '
             '[ -n "$remote" ] && echo -e "Remote: \\033[34m$remote\\033[0m"; '
             'last_commit=$(git log -1 --pretty=format:"%h %s" 2>/dev/null); '
             '[ -n "$last_commit" ] && echo -e "Letzter Commit: \\033[35m$last_commit\\033[0m"; '
             'echo ""; echo -e "\\033[33mDateistatus:\\033[0m"; '
             'git status -s; '
             'else echo "Kein Git-Repository"; fi; '
             'echo ""; read -p "Enter druecken..."'],
            flags='w'
        )
