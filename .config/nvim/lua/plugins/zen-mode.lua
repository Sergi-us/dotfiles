-- Zen-mode.lua
-- ## 2025-04-01
return {
  {
    "folke/zen-mode.nvim",
    dependencies = {
      "folke/twilight.nvim", -- Optional, dimmt Code außerhalb des aktuellen Fokusbereichs
    },
    config = function()
      -- Speichere die ursprünglichen Einstellungen in einer globalen Variable
      _G.original_settings = {
        wrap = vim.opt.wrap:get(),
        linebreak = vim.opt.linebreak:get(),
        breakindent = vim.opt.breakindent:get(),
        spell = vim.opt.spell:get(),
        cursorline = vim.opt.cursorline:get(),
        showcmd = vim.opt.showcmd:get()
      }

      require("zen-mode").setup({
        window = {
          width = 120, -- Maximale Zeilenbreite
          height = 0.9, -- Fensterhöhe (1.0 = 100% des Bildschirms)
          backdrop = 0.9, -- Deckkraft des Hintergrunds (0-1)
          options = {
            signcolumn = "no",      -- Signatur-Spalte ausblenden
            number = false,         -- Zeilennummern ausblenden
            relativenumber = false, -- Relative Zeilennummern ausblenden
            cursorline = false,     -- Cursor-Zeile nicht hervorheben
            cursorcolumn = false,   -- Cursor-Spalte nicht hervorheben
            foldcolumn = "0",       -- Falten-Spalte ausblenden
            list = false,           -- Spezialzeichen ausblenden
          },
        },
        plugins = {
          options = {
            enabled = true,
            ruler = false,   -- Position des Cursors ausblenden
            showcmd = false, -- Befehle nicht anzeigen
          },
          twilight = { enabled = false }, -- Dimmt nicht-aktiven Code
          gitsigns = { enabled = true },
        },
        on_open = function()
          -- Speichere aktuelle Einstellungen vor dem Öffnen
          _G.original_settings = {
            wrap = vim.opt.wrap:get(),
            linebreak = vim.opt.linebreak:get(),
            breakindent = vim.opt.breakindent:get(),
            spell = vim.opt.spell:get(),
            cursorline = vim.opt.cursorline:get(),
            cursorcolumn = vim.opt.cursorcolumn:get(), -- NEU
            showcmd = vim.opt.showcmd:get()
          }

          -- Aktiviere automatischen Zeilenumbruch beim Öffnen
          vim.opt.wrap = true
          vim.opt.linebreak = true  -- Umbruch an Wortgrenzen
          vim.opt.breakindent = true  -- Einrückung nach Umbruch beibehalten
          vim.cmd("setlocal spell spelllang=de_de,en_us") -- Rechtschreibprüfung mit Deutsch und Englisch aktivieren

          -- Schönere Farben im Schreibmodus
          vim.cmd("highlight Normal guibg=#232136 guifg=#e0def4")
          vim.cmd("highlight LineNr guifg=#444a73")
          vim.cmd("highlight StatusLine guibg=#393552 guifg=#e0def4")

          -- Verwende die Transparenz-Funktion aus transparenz.lua, wenn verfügbar
          local transparenz = require("config.transparenz")
          if transparenz and transparenz.setup then
            transparenz.setup()
          end

          -- Klammern-Hervorhebung beibehalten
          if vim.fn.exists("*HighlightMatchParen") == 1 then
            vim.cmd("call HighlightMatchParen()")
          end
        end,

      on_close = function()
        -- Stelle die ursprünglichen Einstellungen wieder her
        if _G.original_settings then
          vim.opt.wrap = _G.original_settings.wrap
          vim.opt.linebreak = _G.original_settings.linebreak
          vim.opt.breakindent = _G.original_settings.breakindent
          vim.opt.cursorline = _G.original_settings.cursorline     -- Stellt cursorline wieder her
          vim.opt.cursorcolumn = _G.original_settings.cursorcolumn -- Stellt cursorcolumn wieder her (NEU)

          if not _G.original_settings.spell then
            vim.cmd("setlocal nospell")
          end

          vim.opt.showcmd = _G.original_settings.showcmd
        else
          -- Fallback, falls original_settings nicht verfügbar
          vim.opt.wrap = false
          vim.opt.linebreak = false
          vim.opt.breakindent = false
          vim.opt.cursorline = true     -- Standardwert wiederherstellen
          vim.opt.cursorcolumn = true   -- Standardwert wiederherstellen (NEU)
          vim.cmd("setlocal nospell")
        end

          -- Theme wiederherstellen
          vim.cmd.colorscheme "pywal"

          -- Verwende die Transparenz-Funktion aus transparenz.lua, wenn verfügbar
          local transparenz = require("config.transparenz")
          if transparenz and transparenz.setup then
            transparenz.setup()
          end

        -- Klammern-Hervorhebung beibehalten
        if vim.fn.exists("*HighlightMatchParen") == 1 then
          vim.cmd("call HighlightMatchParen()")
        end
        end,
      })
    end,
    keys = {
      { "<leader>z", "<cmd>ZenMode<CR>", desc = "Zen Mode" },
    },
  },
}
