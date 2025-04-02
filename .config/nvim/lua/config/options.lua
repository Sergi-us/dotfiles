-- lua/config/options.lua
-- ## 2025-04-01 SARBS
local opt = vim.opt

-- UI
opt.number = true           -- Zeilennummern anzeigen
opt.relativenumber = true   -- Relative Zeilennummern
opt.wrap = false            -- Kein Zeilenumbruch
opt.showmode = false        -- Kein -- INSERT -- usw. (redundant mit Statusleiste)
opt.cursorline = false      -- Aktuelle Zeile hervorheben
opt.cursorcolumn = false    -- Aktuelle Spalte hervorheben (NEU)
opt.termguicolors = true    -- True-Color-Unterstützung
opt.signcolumn = "yes"      -- Zeichenspalte immer anzeigen
opt.scrolloff = 8           -- Mindestens 8 Zeilen am Ende anzeigen
opt.sidescrolloff = 8       -- Mindestens 8 Spalten am Rand anzeigen
opt.showmode = false        -- Modus nicht anzeigen (wird durch Statusleiste ersetzt)
opt.showtabline = 1         -- Tabs immer anzeigen
opt.laststatus = 3          -- Globale Statuszeile
opt.splitbelow = true       -- Horizontale Splits öffnen sich unter dem aktuellen
opt.splitright = true       -- Vertikale Splits öffnen sich rechts vom aktuellen

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
