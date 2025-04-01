-- lua/plugins/init.lua
-- ## 2025-03-30 SARBS
-- Beispiel für ein Colorscheme-Plugin
return {
  -- Pywall Farben für NeoVim
  {
    "AlphaTechnolog/pywal.nvim",
    priority = 1000,
    config = function()
      require('pywal').setup()
      -- vim.cmd("colorscheme pywal")

      -- Transparenzen explizit setzen
      vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
      -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
      -- vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" }) -- Nicht-aktive Fenster
      -- vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
      -- vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE" })
    end,
  },

  -- Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        transparent_background = true
      })
      vim.cmd.colorscheme "catppuccin"  -- Hier wird das Theme aktiviert
    end,
  },

  -- Tokyo Night (feste Farben ohne transparenz)
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Hier nicht automatisch aktivieren
    end,
  },

  {
  -- VimWiki
  "vimwiki/vimwiki",
  event = "VeryLazy",
  },
  {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- Optional, für Datei-Icons
  },
  config = function()
    require("nvim-tree").setup({
      sort_by = "case_sensitive",
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
    })
  end,
  },

  {
  -- Einrückungs hervorhebung
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
    opts = {
      indent = {
       char = "│", -- Zeichen für Einrückungslinien
      },
    scope = {
      enabled = true,
      show_start = true,
      show_end = true,
      },
    },
  }
}

