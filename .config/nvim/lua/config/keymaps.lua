-- lua/config/keymaps.lua
-- ## 2025-07-13  SARBS

local map = vim.keymap.set

-- q für quit/close Aktionen nutzen
map('n', 'q', '<Nop>')  -- Erst mal deaktivieren
map('n', 'qq', ':q<CR>', { desc = "Quit" })
map('n', 'qa', ':qa<CR>', { desc = "Quit all" })
map('n', 'qw', ':wq<CR>', { desc = "Write and quit" })
map('n', 'qQ', ':q!<CR>', { desc = "Force quit" })

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

-- Keybinding für nvim-tree
map("n", "<leader>n", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Datumstempel
map('n', '<leader>dt', ':put=strftime(\'## %Y-%m-%d\')<CR>', { noremap = true })

-- Anpassungen für's Deutsche Tastaturlayout
map('n', 'YY', 'ZZ', { noremap = true })             -- Beenden mit Speichern
map('n', 'YQ', 'ZQ', { noremap = true })             -- Beenden ohne Speichern
map('n', '-', '/',   { noremap = true })             -- Suche (macht "-" zur Suchtaste statt "/")
map('n', 'äs', '[s', { noremap = true })             -- Zum vorherigen Rechtschreibfehler springen
map('n', 'ös', ']s', { noremap = true })             -- Zum nächsten Rechtschreibfehler springen
map('n', 'z0', 'z=', { noremap = true })             -- Zeigt Wortvorschläge für Rechtschreibfehler

-- === Funktionen ===
-- vim.keymap.set('n', '<leader>t', ':term<CR>', { noremap = true })  -- Terminal öffnen (auskommentiert wegen zsh Problemen)
map('', '<leader>s', ':setlocal spell! spelllang=de_de,en_us<CR>', { noremap = true })     -- Rechtschreibprüfung ein/ausschalten
map('', '<leader>o', ':!clear && shellcheck -x %<CR>', { noremap = true })              -- Shellskripte mit shellcheck analysieren
-- map('n', '<leader>h', ':call ToggleHiddenAll()<CR>', { noremap = true })                -- Versteckte Elemente ein-/ausblenden (benötigt die ToggleHiddenAll Funktion)

-- Suchhervorhebung ausschalten mit Escape
map('n', '<Esc>', ':nohlsearch<CR>', { noremap = true, silent = true })

-- Neuen Tab öffnen
map('n', '<leader>tn', ':tabnew<CR>', { noremap = true })

-- === Tastenkombinationen ===
-- Platzhalter-Navigation (bewegt zum nächsten <++> und löscht es)
-- vim.keymap.set('', ',,', ':keepp /<++><CR>ca<', { noremap = true })
-- vim.keymap.set('i', ',,', '<esc>:keepp /<++><CR>ca<', { noremap = true })

-- Dateien öffnen
-- vim.keymap.set('', '<leader>b', ':vsp<space>$BIB<CR>', { noremap = true })       -- Öffnet Bibliotheksdatei in vertikalem Split ($BIB muss definiert sein)
-- vim.keymap.set('', '<leader>r', ':vsp<space>$REFER<CR>', { noremap = true })     -- Öffnet Referenzdatei in vertikalem Split ($REFER muss definiert sein)

-- Dokument-Workflow
map('', '<leader>c', ':w! \\| !compiler "%:p"<CR>', { noremap = true })             -- Speichert und führt "compiler" mit aktuellem Dateipfad aus
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
map('n', '<leader>ga', ':!git add %<CR>', { desc = "Git add current file" })
map('n', '<leader>gA', ':!git add -A<CR>', { desc = "Git add all" })
map('n', '<leader>gc', ':!git commit<CR>', { desc = "Git commit (öffnet Editor)" })
map('n', '<leader>gp', ':!git push<CR>', { desc = "Git push" })
map('n', '<leader>gl', ':!git pull<CR>', { desc = "Git pull" })

-- Git Diff Varianten
map('n', '<leader>gd', ':!git diff %<CR>', { desc = "Git diff current file" })
map('n', '<leader>gD', ':!git diff<CR>', { desc = "Git diff all" })

-- Git Log schön formatiert
map('n', '<leader>gL', ':botright 20split | term git log --oneline --graph --decorate -20<CR>', { desc = "Git log (letzte 20)" })

-- Praktisch: Git-Befehle mit Fugitive-ähnlicher Syntax (wenn du kein Plugin willst)
map('n', '<leader>gb', ':!git blame %<CR>', { desc = "Git blame current file" })
map('n', '<leader>gh', ':!git log -p -1 %<CR>', { desc = "Git history current file" })
map('n', '<leader>t', '<Cmd>ToggleTerm<CR>', { desc = "Toggle Terminal" })
