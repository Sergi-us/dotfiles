--[[
  Theme-Verwaltung für Neovim
  Datei: lua/plugins/themes.lua
  Autor: SARBS
  Datum: 2025-04-02
--]]

-- Theme-Plugin-Konfiguration
return {
  -- Theme-Manager
  {
    "folke/lazy.nvim",
    name = "theme-manager",
    dependencies = {
      "nvim-telescope/telescope.nvim", -- Abhängigkeit für den Theme-Picker
    },
    config = function()
      -- Theme-Manager-Logik
      local M = {}

      -- Liste der verfügbaren Themes
      M.themes = {
        -- Standard-Themes
        { name = "pywal", source = "pywal.nvim" },
        { name = "tokyonight", variants = { "storm", "moon", "night", "day" } },
        { name = "gruvbox" },
        { name = "nord" },
        { name = "catppuccin", variants = { "latte", "frappe", "macchiato", "mocha" } },
        { name = "onedark" },
        { name = "dracula" },
        { name = "everforest" },
        -- Füge hier weitere Themes hinzu
      }

      -- Standard-Theme-Einstellungen
      M.default_theme = "pywal"
      M.default_variant = nil

      -- Aktuelles Theme initialisieren
      M.current_theme = M.default_theme
      M.current_variant = M.default_variant

      -- Transparenz-Modul laden (wenn verfügbar)
      local transparenz_ok, transparenz = pcall(require, "config.transparenz")

      -- Datei für das persistente Speichern des Themes
      local theme_data_file = vim.fn.stdpath("data") .. "/theme_data.json"

      -- Theme-Daten speichern
      local function save_theme_data()
        local data = {
          theme = M.current_theme,
          variant = M.current_variant
        }

        local json_data = vim.fn.json_encode(data)
        local file = io.open(theme_data_file, "w")

        if file then
          file:write(json_data)
          file:close()
        else
          vim.notify("Konnte Theme-Daten nicht speichern", vim.log.levels.WARN)
        end
      end

      -- Theme-Daten laden
      local function load_theme_data()
        local file = io.open(theme_data_file, "r")

        if file then
          local content = file:read("*a")
          file:close()

          local ok, data = pcall(vim.fn.json_decode, content)
          if ok and data then
            return data
          end
        end

        return {
          theme = M.default_theme,
          variant = M.default_variant
        }
      end

      -- Theme wechseln
      function M.set_theme(theme_name, variant)
        -- Überprüfe, ob das Theme existiert
        local theme_exists = false
        for _, theme in ipairs(M.themes) do
          if theme.name == theme_name then
            theme_exists = true
            break
          end
        end

        if not theme_exists then
          vim.notify("Theme '" .. theme_name .. "' nicht gefunden", vim.log.levels.ERROR)
          return false
        end

        -- Theme setzen
        local cmd = "colorscheme " .. theme_name

        -- Variante hinzufügen, falls vorhanden
        if variant then
          -- Prüfe, ob die Variante gültig ist
          local valid_variant = false
          for _, theme in ipairs(M.themes) do
            if theme.name == theme_name and theme.variants then
              for _, v in ipairs(theme.variants) do
                if v == variant then
                  valid_variant = true
                  break
                end
              end
            end
          end

          if not valid_variant then
            vim.notify("Variante '" .. variant .. "' für Theme '" .. theme_name .. "' nicht gefunden", vim.log.levels.ERROR)
            return false
          end

          -- Theme-spezifische Variablen setzen
          if theme_name == "tokyonight" then
            vim.g.tokyonight_style = variant
          elseif theme_name == "catppuccin" then
            vim.g.catppuccin_flavour = variant
          end
          -- Hier weitere theme-spezifische Varianten hinzufügen
        end

        -- Versuche, das Theme zu setzen
        local success, err = pcall(vim.cmd, cmd)
        if not success then
          vim.notify("Fehler beim Setzen des Themes: " .. err, vim.log.levels.ERROR)
          return false
        end

        -- Aktuelles Theme speichern
        M.current_theme = theme_name
        M.current_variant = variant

        -- Transparenz anwenden, falls aktiviert
        if transparenz_ok and transparenz.ist_aktiviert and transparenz.ist_aktiviert() then
          transparenz.setup()
        end

        -- Theme persistent speichern
        save_theme_data()

        vim.notify("Theme gewechselt zu: " .. theme_name .. (variant and (" (" .. variant .. ")") or ""), vim.log.levels.INFO)
        return true
      end

      -- Theme-Picker mit Telescope erstellen
      function M.theme_picker()
        local telescope_ok, _ = pcall(require, "telescope")
        if not telescope_ok then
          vim.notify("Telescope nicht gefunden. Bitte installiere es für den Theme-Picker.", vim.log.levels.ERROR)
          return
        end

        -- Liste aller Themes für Telescope vorbereiten
        local theme_list = {}
        for _, theme in ipairs(M.themes) do
          if theme.variants then
            for _, variant in ipairs(theme.variants) do
              table.insert(theme_list, { theme.name, variant })
            end
          else
            table.insert(theme_list, { theme.name })
          end
        end

        -- Telescope-Picker erstellen
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        pickers.new({}, {
          prompt_title = "Themes",
          finder = finders.new_table({
            results = theme_list,
            entry_maker = function(entry)
              return {
                value = entry,
                display = entry[1] .. (entry[2] and (" (" .. entry[2] .. ")") or ""),
                ordinal = entry[1] .. (entry[2] and (" " .. entry[2]) or ""),
              }
            end,
          }),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              local theme_name = selection.value[1]
              local variant = selection.value[2]
              M.set_theme(theme_name, variant)
            end)
            return true
          end,
        }):find()
      end

      -- Zyklisch durch alle Themes wechseln
      function M.cycle_themes()
        local current_index = 1

        -- Aktuellen Theme-Index finden
        for i, theme in ipairs(M.themes) do
          if theme.name == M.current_theme then
            current_index = i
            break
          end
        end

        -- Zum nächsten Theme wechseln
        local next_index = current_index % #M.themes + 1
        local next_theme = M.themes[next_index]

        -- Wenn das Theme Varianten hat, erste Variante auswählen, sonst nil
        local next_variant = nil
        if next_theme.variants then
          next_variant = next_theme.variants[1]
        end

        -- Theme wechseln
        M.set_theme(next_theme.name, next_variant)
      end

      -- Befehle erstellen
      vim.api.nvim_create_user_command("ThemeSet", function(opts)
        local args = opts.args
        local theme_name, variant

        if args:find(" ") then
          theme_name, variant = args:match("([^ ]+) (.+)")
        else
          theme_name = args
        end

        M.set_theme(theme_name, variant)
      end, {
        nargs = "*",
        complete = function(ArgLead, CmdLine, CursorPos)
          local completions = {}
          for _, theme in ipairs(M.themes) do
            if theme.name:find(ArgLead) then
              if theme.variants then
                for _, variant in ipairs(theme.variants) do
                  table.insert(completions, theme.name .. " " .. variant)
                end
              else
                table.insert(completions, theme.name)
              end
            end
          end
          return completions
        end
      })

      vim.api.nvim_create_user_command("ThemePicker", function()
        M.theme_picker()
      end, {})

      vim.api.nvim_create_user_command("ThemeCycle", function()
        M.cycle_themes()
      end, {})

      -- Tastenkombinationen
      vim.keymap.set("n", "<leader>tc", ":ThemeCycle<CR>", { noremap = true, silent = true, desc = "Cycle themes" })
      vim.keymap.set("n", "<leader>tp", ":ThemePicker<CR>", { noremap = true, silent = true, desc = "Theme picker" })

      -- Beim Laden das gespeicherte Theme laden und anwenden
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.defer_fn(function()
            -- Gespeicherte Theme-Daten laden
            local data = load_theme_data()

            -- Theme setzen, wenn noch keines geladen wurde
            if not vim.g.colors_name then
              M.set_theme(data.theme or M.default_theme, data.variant)
            else
              -- Aktuelles Theme übernehmen
              M.current_theme = vim.g.colors_name
              -- Trotzdem speichern, falls wir später die Variante ändern
              save_theme_data()
            end
          end, 10)
        end
      })

      -- Modul global verfügbar machen
      _G.theme_manager = M
    end
  },

  -- Theme-Plugins
  { "AlphaTechnolog/pywal.nvim", lazy = true },
  { "folke/tokyonight.nvim", lazy = true },
  { "ellisonleao/gruvbox.nvim", lazy = true },
  { "shaunsingh/nord.nvim", lazy = true },
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "navarasu/onedark.nvim", lazy = true },
  { "dracula/vim", name = "dracula", lazy = true },
  { "sainnhe/everforest", lazy = true },
}
