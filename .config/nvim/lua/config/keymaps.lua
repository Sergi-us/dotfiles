-- lua/config/keymaps.lua
-- ## 2025-03-30 SARBS
local map = vim.keymap.set

-- Bessere Standardkombinationen
map("n", "<C-h>", "<C-w>h", { desc = "Fenster links" })
map("n", "<C-j>", "<C-w>j", { desc = "Fenster unten" })
map("n", "<C-k>", "<C-w>k", { desc = "Fenster oben" })
map("n", "<C-l>", "<C-w>l", { desc = "Fenster rechts" })

-- Zeilen bewegen
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Zeile nach unten bewegen" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Zeile nach oben bewegen" })

-- Puffer wechseln
map("n", "<leader>bn", ":bnext<CR>", { desc = "Nächster Puffer" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Vorheriger Puffer" })

-- Keybinding für nvim-tree
vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Persönliche Binding
vim.keymap.set('n', '<leader>dt', ':put=strftime(\'## %Y-%m-%d\')<CR>', { noremap = true })

-- Anpassungen für's Deutsche Tastaturlayout
vim.keymap.set('n', 'YY', 'ZZ', { noremap = true })            -- Beenden mit Speichern
vim.keymap.set('n', 'YQ', 'ZQ', { noremap = true })            -- Beenden ohne Speichern
vim.keymap.set('n', '-', '/', { noremap = true })              -- Suche (macht "-" zur Suchtaste statt "/")
vim.keymap.set('n', 'ök', '[s', { noremap = true })            -- Zum vorherigen Rechtschreibfehler springen
vim.keymap.set('n', 'öj', ']s', { noremap = true })            -- Zum nächsten Rechtschreibfehler springen
vim.keymap.set('n', 'z0', 'z=', { noremap = true })            -- Zeigt Wortvorschläge für Rechtschreibfehler

-- === Funktionen ===
-- vim.keymap.set('n', '<leader>t', ':term<CR>', { noremap = true })  -- Terminal öffnen (auskommentiert wegen zsh Problemen)
vim.keymap.set('', '<leader>s', ':setlocal spell! spelllang=de_de,en_us<CR>', { noremap = true })     -- Rechtschreibprüfung ein/ausschalten
-- vim.keymap.set('', '<leader>o', ':!clear && shellcheck -x %<CR>', { noremap = true })              -- Shellskripte mit shellcheck analysieren
-- vim.keymap.set('n', '<leader>h', ':call ToggleHiddenAll()<CR>', { noremap = true })                -- Versteckte Elemente ein-/ausblenden (benötigt die ToggleHiddenAll Funktion)

-- Suchhervorhebung ausschalten mit Escape
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { noremap = true, silent = true })

-- Neuen Tab öffnen
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { noremap = true })

-- === Tastenkombinationen ===
-- Platzhalter-Navigation (bewegt zum nächsten <++> und löscht es)
-- vim.keymap.set('', ',,', ':keepp /<++><CR>ca<', { noremap = true })
-- vim.keymap.set('i', ',,', '<esc>:keepp /<++><CR>ca<', { noremap = true })

-- Dateien öffnen
-- vim.keymap.set('', '<leader>b', ':vsp<space>$BIB<CR>', { noremap = true })       -- Öffnet Bibliotheksdatei in vertikalem Split ($BIB muss definiert sein)
-- vim.keymap.set('', '<leader>r', ':vsp<space>$REFER<CR>', { noremap = true })     -- Öffnet Referenzdatei in vertikalem Split ($REFER muss definiert sein)

-- Dokument-Workflow
-- vim.keymap.set('', '<leader>c', ':w! \\| !compiler "%:p"<CR>', { noremap = true })  -- Speichert und führt "compiler" mit aktuellem Dateipfad aus
-- vim.keymap.set('', '<leader>p', ':!opout "%:p"<CR>', { noremap = true })            -- Führt "opout" mit aktuellem Dateipfad aus (vermutlich zum Anzeigen des Outputs)

-- Terminal öffnen (funktionierendes Binding)
-- vim.keymap.set('n', '<leader>t', ':term<CR>', { noremap = true })
