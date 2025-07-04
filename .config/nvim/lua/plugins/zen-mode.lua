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
            laststatus = 0,  -- Statusleiste komplett ausblenden
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
            cursorcolumn = vim.opt.cursorcolumn:get(),
            showcmd = vim.opt.showcmd:get()
          }

          -- Aktiviere automatischen Zeilenumbruch beim Öffnen
          vim.opt.wrap = true
          vim.opt.linebreak = true  -- Umbruch an Wortgrenzen
          vim.opt.breakindent = true  -- Einrückung nach Umbruch beibehalten
          vim.cmd("setlocal spell spelllang=de_de,en_us") -- Rechtschreibprüfung mit Deutsch und Englisch aktivieren

          -- Schönere Farben im Schreibmodus (ohne Hintergrund für Transparenz)
          vim.cmd("highlight Normal guifg=#e0def4")
          vim.cmd("highlight LineNr guifg=#444a73")
          vim.cmd("highlight StatusLine guifg=#e0def4")

          -- Verwende die Transparenz-Funktion aus transparenz.lua, wenn verfügbar
          -- WICHTIG: Nach dem Setzen der Farben, damit Transparenz erhalten bleibt
          vim.defer_fn(function()
						local ok, sarbs = pcall(require, "config.sarbs")
						if ok and sarbs then
							sarbs.zen_mode_on()  -- bzw. zen_mode_off()
						end
          end, 50)

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
            vim.opt.cursorline = _G.original_settings.cursorline
            vim.opt.cursorcolumn = _G.original_settings.cursorcolumn or false
            vim.opt.showcmd = _G.original_settings.showcmd

            if not _G.original_settings.spell then
              vim.cmd("setlocal nospell")
            end
          else
            -- Fallback, falls original_settings nicht verfügbar
            vim.opt.wrap = false
            vim.opt.linebreak = false
            vim.opt.breakindent = false
            vim.opt.cursorline = true
            vim.opt.cursorcolumn = false
            vim.cmd("setlocal nospell")
          end

          -- Theme wiederherstellen
          vim.cmd("colorscheme pywal")

          -- Verwende die Transparenz-Funktion aus transparenz.lua, wenn verfügbar
          -- WICHTIG: Nach colorscheme, damit Transparenz wieder angewendet wird
          vim.defer_fn(function()
						local ok, sarbs = pcall(require, "config.sarbs")
						if ok and sarbs then
							sarbs.zen_mode_on()  -- bzw. zen_mode_off()
						end
          end, 50)

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
