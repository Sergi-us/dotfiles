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
      vim.cmd("colorscheme pywal")
      -- Transparenzeinstellungen wurden entfernt und in die transparenz.lua ausgelagert
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
