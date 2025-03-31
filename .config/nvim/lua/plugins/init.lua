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

  -- VimWiki
  {
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

  -- lualine: schnelle, leichtgewichtige und hoch konfigurierbare Statusleiste
{
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "pywal", -- Passt zu deinem Pywal-Theme
        -- nf pl divider
        -- component_separators = { left = "", right = "" },
        -- section_separators = { left = "", right = "" },
        --  nf ple circle
        -- component_separators = { left = "", right = "" },
        -- section_separators = { left = "", right = "" },
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
        ignore_focus = {},
        disabled_filetypes = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = true, -- Eine globale Statuszeile für alle Fenster
      refresh = {
        statusline = 100,
        tabline = 100,
        winbar = 100,
        }
      },
      sections = {
        lualine_a = {{ "mode", separator = { left = "", right = "" }, right_padding = 2 }},
        lualine_b = {{ "branch", icon = "" }, "diff", "diagnostics" },
        lualine_c = {{ "filename", path = 1 }}, -- 1 = relative Pfade
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = {{ "location", separator = { left = "", right = "" }, left_padding = 2 }}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      extensions = { "nvim-tree" } -- Integration mit nvim-tree
    })
  end,
}

}

