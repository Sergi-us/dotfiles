-- lua/plugins/themes.lua
-- Vereinfachte Theme-Verwaltung
-- SARBS 2025

return {
  -- Nur die Themes die du wirklich nutzt
  { "AlphaTechnolog/pywal.nvim", lazy = false },
  { "ellisonleao/gruvbox.nvim", lazy = false },
  { "folke/tokyonight.nvim", lazy = false },
  { "catppuccin/nvim", name = "catppuccin", lazy = false },
  { "rebelot/kanagawa.nvim", lazy = false },  -- Sehr beliebt, inspiriert von japanischen Farben

  -- Theme-Manager Konfiguration
  {
    "folke/lazy.nvim",
    name = "simple-theme-manager",
    config = function()
      local M = {}

      -- Nur die Themes die du willst
      M.themes = {
        "pywal",
        "gruvbox",
        "tokyonight",
        "catppuccin",
        "kanagawa",
      }

      M.current_index = 1

      -- Theme setzen mit sarbs.lua Integration
      function M.set_theme(theme_name)
        local sarbs_ok, sarbs = pcall(require, "config.sarbs")

        -- Versuche Theme zu setzen
        local ok = pcall(vim.cmd, "colorscheme " .. theme_name)
        if not ok then
          vim.notify("Theme " .. theme_name .. " nicht gefunden", vim.log.levels.ERROR)
          return false
        end

        -- Theme-Name für später speichern
        M.current_theme = theme_name

        -- Update sarbs state
        if sarbs_ok and sarbs then
          sarbs.state.current_theme = theme_name
          -- Transparenz wieder anwenden wenn aktiviert
          if sarbs.state.transparency_enabled then
            vim.defer_fn(function()
              sarbs.apply_transparency()
            end, 50)
          end
        end

        -- Einfache Persistenz
        local file = io.open(vim.fn.stdpath("data") .. "/last_theme.txt", "w")
        if file then
          file:write(theme_name)
          file:close()
        end

        -- Immer benachrichtigen
        vim.notify("Theme: " .. theme_name, vim.log.levels.INFO)
        return true
      end

      -- Durch Themes durchschalten
      function M.cycle()
        M.current_index = M.current_index % #M.themes + 1
        M.set_theme(M.themes[M.current_index])
      end

      -- Commands
      vim.api.nvim_create_user_command("ThemeSet", function(opts)
        M.set_theme(opts.args)
      end, {
        nargs = 1,
        complete = function()
          return M.themes
        end
      })

      vim.api.nvim_create_user_command("ThemeCycle", function()
        M.cycle()
      end, {})

      -- Keymaps
      vim.keymap.set("n", "<leader>tc", ":ThemeCycle<CR>", {
        silent = true,
        desc = "Cycle themes"
      })

      -- Startup - Letztes Theme laden
      vim.defer_fn(function()
        local file = io.open(vim.fn.stdpath("data") .. "/last_theme.txt", "r")
        local last_theme = "pywal"  -- Fallback
        if file then
          last_theme = file:read("*a") or "pywal"
          file:close()
        end
        M.set_theme(last_theme)
      end, 100)
    end
  },
}
