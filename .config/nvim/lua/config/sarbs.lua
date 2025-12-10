-- lua/config/sarbs.lua
-- Zentrale Konfiguration für alle visuellen Einstellungen
-- SARBS 2025-04-02

local M = {}

-- State
M.state = {
  transparency_enabled = true,
  current_theme = "pywal",
  zen_mode_active = false,
}

-- Theme-spezifische Transparenz-Overrides
M.theme_transparency_config = {
  pywal = {
    enabled = true,
    extra_highlights = function()
      -- Spezielle pywal Transparenz-Anpassungen
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })
    end
  },
  tokyonight = {
    enabled = true,
    extra_highlights = function()
      -- Tokyo Night spezifische Anpassungen
      vim.api.nvim_set_hl(0, "NormalSidebar", { bg = "NONE", ctermbg = "NONE" })
    end
  },
  -- Weitere Themes können hier konfiguriert werden
}

-- Basis-Transparenz-Funktion
function M.apply_transparency()
  if not M.state.transparency_enabled then
    return
  end

  -- Basis-Transparenz
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "WinSeparator", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "Pmenu", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "PmenuSbar", { bg = "NONE", ctermbg = "NONE" })

  -- ColorColumn: Theme-unabhängig mit Underline
  vim.api.nvim_set_hl(0, "ColorColumn", { bg = "NONE", ctermbg = "NONE", underline = true })

  -- Plugin-spezifische Transparenz
  vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "NONE", ctermbg = "NONE" })
  -- Spezielle Bereiche die oft vergessen werden
  vim.api.nvim_set_hl(0, "MsgArea", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "ModeMsg", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "MoreMsg", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "Question", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "ErrorMsg", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "WarningMsg", { bg = "NONE", ctermbg = "NONE" })

  -- Theme-spezifische Extra-Highlights anwenden
  local theme_config = M.theme_transparency_config[M.state.current_theme]
  if theme_config and theme_config.extra_highlights then
    theme_config.extra_highlights()
  end
end

-- Theme setzen mit integrierter Transparenz-Unterstützung
function M.set_theme(theme_name, variant)
  -- Theme setzen
  local cmd = "colorscheme " .. theme_name

  -- Varianten-Handling (z.B. für tokyonight, catppuccin)
  if variant then
    if theme_name == "tokyonight" then
      vim.g.tokyonight_style = variant
    elseif theme_name == "catppuccin" then
      vim.g.catppuccin_flavour = variant
    end
  end

  -- Theme anwenden
  local ok = pcall(vim.cmd, cmd)
  if not ok then
    vim.notify("Fehler beim Setzen des Themes: " .. theme_name, vim.log.levels.ERROR)
    return false
  end

  -- State aktualisieren
  M.state.current_theme = theme_name

  -- Transparenz nach Theme-Wechsel anwenden (mit Verzögerung)
  vim.defer_fn(function()
    if M.state.transparency_enabled then
      M.apply_transparency()
    end
  end, 50)

  return true
end

-- Transparenz togglen
function M.toggle_transparency()
  M.state.transparency_enabled = not M.state.transparency_enabled

  if M.state.transparency_enabled then
    M.apply_transparency()
    vim.notify("Transparenz aktiviert", vim.log.levels.INFO)
  else
    -- Theme neu laden ohne Transparenz
    vim.cmd("colorscheme " .. M.state.current_theme)
    -- MsgArea muss extra behandelt werden, da viele Themes das nicht setzen
    vim.defer_fn(function()
      vim.cmd("highlight MsgArea guibg=NONE ctermbg=NONE")
    end, 10)
    vim.notify("Transparenz deaktiviert", vim.log.levels.INFO)
  end
end

-- Zen-Mode visuelle Einstellungen
function M.zen_mode_on()
  M.state.zen_mode_active = true

  -- Spezielle Zen-Mode Farben (nur Vordergrund, für Transparenz)
  vim.cmd("highlight Normal guifg=#e0def4")
  vim.cmd("highlight LineNr guifg=#444a73")
  vim.cmd("highlight StatusLine guifg=#e0def4")

  -- Transparenz erneut anwenden
  vim.defer_fn(function()
    if M.state.transparency_enabled then
      M.apply_transparency()
    end
  end, 50)
end

function M.zen_mode_off()
  M.state.zen_mode_active = false

  -- Theme wiederherstellen
  M.set_theme(M.state.current_theme)
end

-- Setup-Funktion
function M.setup()
  -- Autocmds für ColorScheme-Events
  vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
      if M.state.transparency_enabled and not M.state.zen_mode_active then
        vim.defer_fn(function()
          M.apply_transparency()
        end, 10)
      end
    end
  })

  -- Initial-Setup
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      vim.defer_fn(function()
        if M.state.transparency_enabled then
          M.apply_transparency()
        end
      end, 100)
    end
  })

  -- Befehle
  vim.api.nvim_create_user_command("ToggleTransparency", M.toggle_transparency, {})

  -- Keymaps
  vim.keymap.set("n", "<leader>ä", ":ToggleTransparency<CR>", {
    noremap = true,
    silent = true,
    desc = "Toggle transparency"
  })
end

-- Kompatibilitäts-Interface für bestehende Module
M.enabled = function() return M.state.transparency_enabled end
M.ist_aktiviert = M.enabled  -- Für themes.lua Kompatibilität

return M
