-- lua/plugins/which-key.lua
-- ## 2025-12-10 SARBS
-- Keybinding-Hilfe und Übersicht

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- Verzögerung bevor which-key erscheint (in ms)
    delay = 500,

    -- Icons und Darstellung
    icons = {
      breadcrumb = "»", -- Symbol für verschachtelte Gruppen
      separator = "➜", -- Symbol zwischen Taste und Beschreibung
      group = "+", -- Symbol für Gruppen
    },

    -- Layout-Einstellungen
    win = {
      border = "single", -- Rahmen: "none", "single", "double", "rounded"
      padding = { 1, 2 }, -- Extra Padding im Fenster
    },

    -- Zeige Icons für eingebaute und benutzerdefinierte Keymaps
    show_help = true,
    show_keys = true,
  },

  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Gruppen-Beschreibungen für bessere Übersicht
    wk.add({
      -- Leader-basierte Gruppen
      { "<leader>b", group = "Buffer" },
      { "<leader>d", group = "Datum/Debug" },
      { "<leader>g", group = "Git" },
      { "<leader>t", group = "Terminal/Tabs" },
      { "<leader>-", group = "Splits" },

      -- q-basierte Gruppen (deine quit-Befehle)
      { "q", group = "Quit" },

      -- Weitere nützliche Markierungen
      { "<leader>s", desc = "Rechtschreibprüfung" },
      { "<leader>o", desc = "Shellcheck" },
      { "<leader>c", desc = "Compile" },
      { "<leader>ä", desc = "Toggle Transparenz" },
    })
  end,
}
