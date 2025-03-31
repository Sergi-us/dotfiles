-- lua/config/options.lua
-- ## 2025-03-30 SARBS
local opt = vim.opt

-- UI
opt.number = true           -- Zeilennummern anzeigen
opt.relativenumber = true   -- Relative Zeilennummern
opt.wrap = false            -- Kein Zeilenumbruch
opt.showmode = false        -- Kein -- INSERT -- usw. (redundant mit Statusleiste)
opt.cursorline = true       -- Aktuelle Zeile hervorheben
opt.termguicolors = true    -- True-Color-Unterstützung
opt.signcolumn = "yes"      -- Zeichenspalte immer anzeigen

-- Verhalten
opt.ignorecase = true       -- Groß-/Kleinschreibung bei Suche ignorieren
opt.smartcase = true        -- Groß-/Kleinschreibung beachten, wenn Großbuchstabe in Suche
opt.hlsearch = true         -- Suchübereinstimmungen hervorheben
opt.incsearch = true        -- Inkrementelle Suche
opt.clipboard = "unnamedplus" -- System-Zwischenablage verwenden

-- Einrückung
opt.expandtab = true        -- Tabs in Leerzeichen umwandeln
opt.shiftwidth = 2          -- Einrückungsgröße
opt.tabstop = 2             -- Tab-Größe
opt.softtabstop = 2         -- Tab-Größe im Einfügemodus
opt.smartindent = true      -- Intelligente Einrückung

-- Dateien
opt.undofile = true         -- Persistente Undo-Historie
opt.backup = false          -- Keine Backup-Dateien
opt.writebackup = false     -- Keine temporären Backup-Dateien
