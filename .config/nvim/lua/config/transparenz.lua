#!/usr/bin/env lua
-- #!/usr/bin/env lua
-- lua/config/transparenz.lua

-- Allgemeine Einstellungen für Transparenz
local function setup_transparency()
  -- Setze den Hintergrund für den Editor auf transparent
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })

  -- Entferne Hintergrund für Statuszeilen und Ränder
  vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE", ctermbg = "NONE" })

  -- Mache Signalspalte transparent (für Gitsigns, Diagnostics, etc.)
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", ctermbg = "NONE" })

  -- Mache Zeilennummern transparent
  vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE", ctermbg = "NONE" })

  -- Entferne Hintergrund für das Ende des Buffers (die ~ Zeichen)
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE", ctermbg = "NONE" })

  -- Spezielle Transparenz für Floating-Windows und Popups
  vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "NONE", ctermbg = "NONE" })

  -- Transparenz für nvim-tree
  vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { bg = "NONE", ctermbg = "NONE" })

  -- Transparenz für Telescope (falls verwendet)
  vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "NONE", ctermbg = "NONE" })

  -- Transparenz für lualine (falls verwendet)
  vim.api.nvim_set_hl(0, "lualine_c_normal", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "lualine_c_inactive", { bg = "NONE", ctermbg = "NONE" })
end

-- Erstelle einen Befehl, um Transparenz ein-/auszuschalten
local transparency_enabled = true

local function toggle_transparency()
  transparency_enabled = not transparency_enabled

  if transparency_enabled then
    setup_transparency()
    vim.notify("Transparenz aktiviert", vim.log.levels.INFO)
  else
    -- Versuche, das aktuelle Farbschema zu bekommen, mit Fallback auf "pywal"
    local current_scheme = vim.g.colors_name or "pywal"
    vim.cmd("colorscheme " .. current_scheme)
    vim.notify("Transparenz deaktiviert", vim.log.levels.INFO)
  end
end

-- Führe die Einrichtung beim Start aus
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Warte einen Moment, um sicherzustellen, dass das Farbschema geladen ist
    vim.defer_fn(function()
      if transparency_enabled then
        setup_transparency()
      end
    end, 100)
  end
})

-- Erneut anwenden, wenn das Farbschema wechselt
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    if transparency_enabled then
      -- Warte einen Moment, um sicherzustellen, dass das neue Farbschema vollständig geladen ist
      vim.defer_fn(function()
        setup_transparency()
      end, 10)
    end
  end
})

-- Benutzerdefinierter Befehl zum Umschalten der Transparenz
vim.api.nvim_create_user_command("ToggleTransparency", toggle_transparency, {})

-- Keymap zum Umschalten der Transparenz (optional)
vim.keymap.set("n", "<leader>ü", ":ToggleTransparency<CR>", { noremap = true, silent = true, desc = "Toggle transparency" })

-- Diese Transparenz-Einstellungen exportieren
return {
  setup = setup_transparency,
  toggle = toggle_transparency,
  enabled = function() return transparency_enabled end
}
