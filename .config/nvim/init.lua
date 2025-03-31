-- init.lua
-- ## 2025-03-30 SARBS

--  === === === === === === === === === === === === === === === === === === ===
-- ===                   SERGI Neovim-Konfiguration                          ===
-- ===                   https://sarbs.xyz                                   ===
-- ===                                                                       ===
-- ===                   TODO    umstieg auf lua                             ===
-- ===                   TODO    Tabulator Thematik ENDLICH angehen          ===
-- ===                   TODO    snack.nvim                                  ===
-- ===                   TODO    Gojo fixen                                  ===
--  === === === === === === === === === === === === === === === === === === ===

-- Lazy.nvim Bootstrap (Selbstinstallation)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Grundlegende Neovim Konfiguration
vim.g.mapleader = " "      -- Space als Leader-Taste
vim.g.maplocalleader = "," -- Komma als lokale Leader-Taste


-- Initialisiere Lazy.nvim mit Plugins
-- Die anderen Konfigurationen laden wir erst NACH der Lazy-Initialisierung
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  print("Lazy.nvim konnte nicht geladen werden!")
  return
end

lazy.setup({
  spec = {
    -- Importiere alle Plugins aus dem plugins/ Verzeichnis
    { import = "plugins" },
  },
  defaults = {
    lazy = false,         -- Ob Plugins standardmäßig lazy-loaded werden sollen
    version = false,      -- Plugin-Version verwenden (kann auch "*" für aktuellste Version sein)
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- Automatische Prüfung auf Updates
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Lade Benutzereinstellungen nach dem Lazy-Setup
pcall(require, "config.options")  -- Grundlegende Vim-Optionen
pcall(require, "config.keymaps")  -- Tastenkombinationen
pcall(require, "config.autocmds") -- Automatische Befehle
