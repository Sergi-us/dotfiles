-- lua/plugins/rainbow.lua
-- Nur aktivieren, wenn du die farbigen Klammern wirklich benötigst
return {
  "HiPhish/rainbow-delimiters.nvim", -- Neuere und stabilere Alternative zu nvim-ts-rainbow2
  config = function()
    -- Laden des Moduls
    local rainbow_delimiters = require('rainbow-delimiters')

    -- Setup mit konservativen Einstellungen
    vim.g.rainbow_delimiters = {
      strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        vim = rainbow_delimiters.strategy['local'],
      },
      query = {
        [''] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
      },
      highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
      },
      -- Klammern für bestimmte Dateitypen deaktivieren
      blacklist = {'markdown', 'vimwiki'},
    }
  end,
  -- Abhängigkeit von Treesitter, wird automatisch geladen
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  }
}
