-- lua/config/keymaps.lua
-- ## 2025-07-13  SARBS

local map = vim.keymap.set

-- q für quit/close Aktionen nutzen
map('n', 'q', '<Nop>', { desc = "Deaktiviert (q für Quit-Aktionen)" })
map('n', 'qq', ':q<CR>', { desc = "Beenden" })
map('n', 'qa', ':qa<CR>', { desc = "Alle beenden" })
map('n', 'qw', ':wq<CR>', { desc = "Speichern und beenden" })
map('n', 'qQ', ':q!<CR>', { desc = "Erzwungen beenden" })

-- Macros auf Leader-Kombinationen verschieben  m für "macro"
-- map('n', '<leader>mr', 'q', { desc = "Macro record" })
-- map('n', '<leader>mp', '@', { desc = "Macro play" })
-- map('n', '<leader>m@', '@@', { desc = "Macro repeat last" })

-- Split verhalten
map('n', '<leader>-', ':split<CR>', { desc = "Split horizontal" })
map('n', '<leader>_', ':vsplit<CR>', { desc = "Split vertikal" })

-- Split schließen
map("n", "Q", "<C-w>q", { desc = "Split schließen" })

-- Split Navigation
map("n", "<C-h>", "<C-w>h", { desc = "Fenster links" })
map("n", "<C-j>", "<C-w>j", { desc = "Fenster unten" })
map("n", "<C-k>", "<C-w>k", { desc = "Fenster oben" })
map("n", "<C-l>", "<C-w>l", { desc = "Fenster rechts" })

-- Zeilen bewegen
map("n", "<C-j>", ":m .+1<CR>==", { desc = "Zeile nach unten bewegen" })
map("n", "<C-k>", ":m .-2<CR>==", { desc = "Zeile nach oben bewegen" })

-- S für substitute im ganzen Dokument
map("n", "S", ":%s//g<Left><Left>", { desc = "Substitute in ganzer Datei" })

-- Puffer wechseln
map("n", "<leader>bn", ":bnext<CR>", { desc = "Nächster Puffer" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Vorheriger Puffer" })

-- Keybinding für nvim-tree (definiert in plugins/nerd-tree.lua)

-- Datumstempel
map('n', '<leader>dt', ':put=strftime(\'## %Y-%m-%d\')<CR>', { noremap = true, desc = "Datumstempel einfügen" })

-- Anpassungen für's Deutsche Tastaturlayout
map('n', 'YY', 'ZZ', { noremap = true, desc = "Beenden mit Speichern" })
map('n', 'YQ', 'ZQ', { noremap = true, desc = "Beenden ohne Speichern" })
map('n', '-', '/',   { noremap = true, desc = "Suche" })
map('n', 'äs', '[s', { noremap = true, desc = "Vorheriger Rechtschreibfehler" })
map('n', 'ös', ']s', { noremap = true, desc = "Nächster Rechtschreibfehler" })
map('n', 'z0', 'z=', { noremap = true, desc = "Rechtschreibvorschläge" })

-- Diff-Navigation (Deutsche Tastatur-Anpassung)
map('n', 'öc', ']c', { noremap = true, desc = "Nächster Diff-Unterschied" })
map('n', 'äc', '[c', { noremap = true, desc = "Vorheriger Diff-Unterschied" })

-- === Funktionen ===
-- vim.keymap.set('n', '<leader>t', ':term<CR>', { noremap = true })  -- Terminal öffnen (auskommentiert wegen zsh Problemen)
map('', '<leader>s', ':setlocal spell! spelllang=de_de,en_us<CR>', { noremap = true, desc = "Rechtschreibprüfung umschalten" })
map('', '<leader>o', ':!clear && shellcheck -x %<CR>', { noremap = true, desc = "Shellcheck ausführen" })
-- map('n', '<leader>h', ':call ToggleHiddenAll()<CR>', { noremap = true })                -- Versteckte Elemente ein-/ausblenden (benötigt die ToggleHiddenAll Funktion)

-- Suchhervorhebung ausschalten mit Escape
map('n', '<Esc>', ':nohlsearch<CR>', { noremap = true, silent = true, desc = "Suchhervorhebung ausschalten" })

-- Neuen Tab öffnen
map('n', '<leader>tn', ':tabnew<CR>', { noremap = true, desc = "Neuer Tab" })

-- === Tastenkombinationen ===
-- Platzhalter-Navigation (bewegt zum nächsten <++> und löscht es)
-- vim.keymap.set('', ',,', ':keepp /<++><CR>ca<', { noremap = true })
-- vim.keymap.set('i', ',,', '<esc>:keepp /<++><CR>ca<', { noremap = true })

-- Dateien öffnen
-- vim.keymap.set('', '<leader>b', ':vsp<space>$BIB<CR>', { noremap = true })       -- Öffnet Bibliotheksdatei in vertikalem Split ($BIB muss definiert sein)
-- vim.keymap.set('', '<leader>r', ':vsp<space>$REFER<CR>', { noremap = true })     -- Öffnet Referenzdatei in vertikalem Split ($REFER muss definiert sein)

-- Dokument-Workflow
map('', '<leader>c', ':w! \\| !compiler "%:p"<CR>', { noremap = true, desc = "Speichern und kompilieren" })
-- vim.keymap.set('', '<leader>p', ':!opout "%:p"<CR>', { noremap = true })         -- Führt "opout" mit aktuellem Dateipfad aus (vermutlich zum Anzeigen des Outputs)

-- Terminal (funktionierendes Binding) Plugin testen
-- map('n', '<leader>t', ':split | resize 10 | term<CR>i', { desc = "Terminal unten öffnen" })
-- map('n', '<leader>t', ':botright 15split | term<CR>i', { desc = "Terminal unten (15 Zeilen)" })
-- map('t', '<C-q>', '<C-\\><C-n>', { desc = "Terminal-Mode verlassen" })
map('n', '<leader>T', ':!cd %:p:h && st &<CR><CR>', { desc = "ST hier öffnen" })

-- Git funktionalität
-- Git-Root Terminal
map('n', '<leader>gt', ':!cd "$(git rev-parse --show-toplevel 2>/dev/null || echo %:p:h)" && st &<CR><CR>', { desc = "ST im Git-Root" })

-- Git Status im internen Terminal (schnell schauen)
map('n', '<leader>gs', ':botright 12split | term git status<CR>', { desc = "Git Status" })

-- Git Commands in externem ST (für längere Sessions)
map('n', '<leader>gT', ':!cd "$(git rev-parse --show-toplevel 2>/dev/null || echo %:p:h)" && st -e sh -c "git status; $SHELL" &<CR><CR>', { desc = "ST mit Git Status" })

-- Direkte Git-Befehle (ohne Terminal)
map('n', '<leader>ga', ':!git add %<CR>', { desc = "Git add aktuelle Datei" })
map('n', '<leader>gA', ':!git add -A<CR>', { desc = "Git add alle Dateien" })
map('n', '<leader>gc', ':!git commit<CR>', { desc = "Git commit" })
map('n', '<leader>gp', ':!git push<CR>', { desc = "Git push" })
map('n', '<leader>gl', ':!git pull<CR>', { desc = "Git pull" })

-- Git Diff Varianten
map('n', '<leader>gd', ':!git diff %<CR>', { desc = "Git diff aktuelle Datei" })
map('n', '<leader>gD', ':!git diff<CR>', { desc = "Git diff alle Dateien" })

-- Git Log schön formatiert
map('n', '<leader>gL', ':botright 20split | term git log --oneline --graph --decorate -20<CR>', { desc = "Git log (letzte 20)" })

-- Praktisch: Git-Befehle mit Fugitive-ähnlicher Syntax (wenn du kein Plugin willst)
map('n', '<leader>gb', ':!git blame %<CR>', { desc = "Git blame aktuelle Datei" })
map('n', '<leader>gh', ':!git log -p -1 %<CR>', { desc = "Git history aktuelle Datei" })
map('n', '<leader>t', '<Cmd>ToggleTerm<CR>', { desc = "Terminal umschalten" })

-- Which-key manuell öffnen
map('n', '<leader>ß', '<Cmd>WhichKey<CR>', { desc = "Zeige alle Keybindings" })
