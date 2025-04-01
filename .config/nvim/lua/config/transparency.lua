-- Füge diesen Code am Ende deiner init.lua ein,
-- oder erstelle eine neue Datei unter lua/config/transparency.lua
-- und füge sie zu deinen Konfigurationen hinzu

-- Funktion, um transparente Hintergründe zu erzwingen
_G.set_transparent_background = function()
  -- Haupthintergrund transparent machen
  vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE", ctermbg = "NONE" })

  -- SignColumn (Gutter) transparent machen
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE", ctermbg = "NONE" })

  -- Zeilennummern anpassen
  vim.api.nvim_set_hl(0, "LineNr", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "NONE", ctermbg = "NONE", bold = true })

  -- Statuszeile transparent machen
  vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", ctermbg = "NONE" })

  -- Aktuelle Zeile mit leichtem Hintergrund (nicht komplett schwarz)
  vim.api.nvim_set_hl(0, "CursorLine", { bg = "#232836", ctermbg = "236", blend = 15 })

  -- MatchParen mit auffälliger Hervorhebung (stark kontrastierend)
  vim.api.nvim_set_hl(0, "MatchParen", {
    bg = "#ff5555", -- Kräftiges Rot als Hintergrund
    fg = "#ffffff", -- Weiße Schrift
    bold = true,   -- Fett gedruckt
    blend = 0      -- Keine Transparenz
  })

  -- Tabs und Statuszeile
  vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE", ctermbg = "NONE" })
  vim.api.nvim_set_hl(0, "TabLineSel", { bg = "NONE", ctermbg = "NONE", bold = true })

  -- Popups und Menüs
  vim.api.nvim_set_hl(0, "Pmenu", { bg = "#232836", blend = 10 })
  vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#3a3f4b" })
end

-- Führe die Funktion sofort aus
_G.set_transparent_background()

-- Führe die Funktion auch nach jedem Themenwechsel aus
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    _G.set_transparent_background()
  end,
})
