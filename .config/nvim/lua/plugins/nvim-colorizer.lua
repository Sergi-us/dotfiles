return{
  "NvChad/nvim-colorizer.lua",
  lazy = true,
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("colorizer").setup({
      filetypes = { "*" },                      -- Dateitypen zum Hervorheben, "*" für alle
      buftypes = {},                            -- Puffertypen zum Hervorheben
      user_commands = true,                     -- Benutzerbefehle aktivieren (ColorizerToggle, etc.)
      lazy_load = false,                        -- Puffer-Hervorhebung verzögert planen
      options = {
        parsers = {
          css = false,                          -- Voreinstellung: aktiviert names, hex, rgb, hsl, oklch, css_var
          css_fn = false,                       -- Voreinstellung: aktiviert rgb, hsl, oklch
          names = {
            enable = true,                      -- Benannte Farben aktivieren (z.B. "Blue")
            lowercase = true,                   -- Kleinbuchstaben-Namen abgleichen
            camelcase = true,                   -- CamelCase-Namen abgleichen (z.B. "LightBlue")
            uppercase = false,                  -- GROSSBUCHSTABEN-Namen abgleichen
            strip_digits = false,               -- Namen mit nachfolgenden Ziffern ignorieren (z.B. "blue3")
            custom = false,                     -- Benutzerdefinierte Name-zu-Hex-Zuweisungen; table|function|false
            extra_word_chars = "-",             -- Zusätzliche Zeichen, die als Teil des Farbnamens behandelt werden
          },
          hex = {
            default = true,                     -- Standardwert für nicht gesetzte Formatschlüssel (siehe oben)
            rgb = true,                         -- #RGB (3-stellig)
            rgba = true,                        -- #RGBA (4-stellig)
            rrggbb = true,                      -- #RRGGBB (6-stellig)
            rrggbbaa = false,                   -- #RRGGBBAA (8-stellig)
            hash_aarrggbb = false,              -- #AARRGGBB (QML-Stil, Alpha zuerst)
            aarrggbb = false,                   -- 0xAARRGGBB
            no_hash = false,                    -- Hex ohne '#' an Wortgrenzen
          },
          rgb = { enable = false },             -- rgb()/rgba() Funktionen
          hsl = { enable = false },             -- hsl()/hsla() Funktionen
          oklch = { enable = false },           -- oklch() Funktion
          hwb = { enable = false },             -- hwb() Funktion (CSS Color Level 4)
          lab = { enable = false },             -- lab() Funktion (CIE Lab)
          lch = { enable = false },             -- lch() Funktion (CIE LCH)
          css_color = { enable = false },       -- color() Funktion (srgb, display-p3, a98-rgb, etc.)
          tailwind = {
            enable = false,                     -- Tailwind-Farbnamen parsen
            update_names = false,               -- LSP-Farben zurück in den Namen-Parser speisen (erfordert enable + lsp.enable)
            lsp = {                             -- Akzeptiert Boolean, true ist eine Abkürzung für { enable = true, disable_document_color = true }
              enable = false,                   -- Tailwind LSP documentColor verwenden
              disable_document_color = true,    -- vim.lsp.document_color beim Anhängen automatisch deaktivieren
            },
          },
          sass = {
            enable = false,                     -- Sass-Farbvariablen parsen
            parsers = { css = true },           -- Parser zur Auflösung von Variablenwerten
            variable_pattern = "^%$([%w_-]+)",  -- Lua-Muster für Variablennamen
          },
          xterm = { enable = false },           -- xterm 256-Farbcodes (#xNN, \e[38;5;NNNm)
          xcolor = { enable = true },           -- LaTeX xcolor-Ausdrücke (z.B. red!30)
          hsluv = { enable = false },           -- hsluv()/hsluvu() Funktionen
          css_var_rgb = { enable = false },     -- CSS-Variablen mit R,G,B (z.B. --color: 240,198,198)
          css_var = {
            enable = false,                     -- var(--name) Referenzen auf ihre definierte Farbe auflösen
            parsers = { css = true },           -- Parser zur Auflösung von Variablenwerten
          },
          custom = {},                          -- Liste benutzerdefinierter Parser-Definitionen
        },
        display = {
          mode = "background",                  -- String oder Liste: "background"|"foreground"|"underline"|"virtualtext"
          background = {
            bright_fg = "#000000",              -- Textfarbe auf hellen Hintergründen
            dark_fg = "#ffffff",                -- Textfarbe auf dunklen Hintergründen
          },
          virtualtext = {
            char = "■",                         -- Zeichen, das für virtualtext verwendet wird
            position = "eol",                   -- "eol"|"before"|"after"
            hl_mode = "foreground",             -- "background"|"foreground"
          },
          priority = {
            default = 150,                      -- extmark-Priorität für normale Hervorhebungen
            lsp = 200,                          -- extmark-Priorität für LSP/Tailwind-Hervorhebungen
          },
          disable_document_color = true,        -- true (alle LSPs) | false | { lsp_name = true, ... }
        },
        hooks = {
          should_highlight_line = false,        -- function(line, bufnr, line_num) -> bool
          should_highlight_color = false,       -- function(rgb_hex, parser_name, ctx) -> bool
          transform_color = false,              -- function(rgb_hex, ctx) -> string
          on_attach = false,                    -- function(bufnr, opts)
          on_detach = false,                    -- function(bufnr)
        },
        always_update = false,                  -- Hervorhebungen auch in nicht fokussierten Puffern aktualisieren
        debounce_ms = 0,                        -- Verzögerung für Hervorhebungsaktualisierungen (ms); 0 = keine Verzögerung (debounce)
      },
    })
  end,
}
