return {
  "jreybert/vimagit",
  lazy = false,  -- Lädt das Plugin direkt beim Start
  cmd = "Magit",
  keys = {
    { "<leader>gs", ":Magit<CR>", desc = "Open Magit status" },
  },
  -- Optional: Wenn du weitere Einstellungen hast
  init = function()
    -- Optionale Einstellungen, zum Beispiel:
    -- vim.g.magit_default_fold_level = 1
    -- vim.g.magit_default_sections = "sHhU"
    -- vim.g.magit_show_help = 0
  end,
  }

