-- VimWiki Konfiguration
-- ## 2025-07-06 SARBS
--
-- Diese Konfiguration definiert mehrere Wikis für verschiedene Themenbereiche.
-- Jedes Wiki hat seinen eigenen Ordner und kann unterschiedliche Formate nutzen.
--
-- Anpassung für eigene Bedürfnisse:
-- 1. Ändere die Pfade zu deinen bevorzugten Verzeichnissen
-- 2. Füge neue Wikis hinzu oder entferne nicht benötigte
-- 3. Passe die Syntax an (markdown oder default/wiki)

return {
  {
    "vimwiki/vimwiki",
    lazy = false,
    keys = {
      -- Haupttastenkombinationen für VimWiki
      { "<leader>v", ":VimwikiIndex<CR>", desc = "Wiki Index öffnen", noremap = true, silent = true },
      { "<leader>ws", ":VimwikiUISelect<CR>", desc = "Wiki Auswahl-Menü", noremap = true, silent = true },
    },
    init = function()
      -- Wiki-Liste Definition
      -- Jeder Eintrag ist ein separates Wiki mit eigenen Einstellungen
      vim.g.vimwiki_list = {
        -- === HAUPTWIKI ===
        -- Für allgemeine Notizen im Markdown-Format
        {
          path = '~/.local/share/nvim/vimwiki',
          syntax = 'markdown',
          ext = '.md'
        },

        -- === WISSENSDATENBANK ===
        -- Persönliche Wissensdatenbank mit HTML-Export
        {
          path = '~/.local/share/nvim/sarbs',
          syntax = 'default',  -- VimWiki's eigene Syntax
          ext = '.wiki',
          path_html = '~/www/wiki',  -- HTML-Export Pfad
          auto_toc = 1,              -- Automatisches Inhaltsverzeichnis
          auto_tags = 1,             -- Automatische Tag-Generierung
          auto_generate_links = 1,   -- Links automatisch erstellen
          auto_generate_tags = 1     -- Tags automatisch generieren
        },
      }

      -- Dateiendungen für Markdown-Unterstützung
      -- VimWiki erkennt diese Endungen als Markdown
      vim.g.vimwiki_ext2syntax = {
        ['.Rmd'] = 'markdown',      -- R Markdown
        ['.rmd'] = 'markdown',
        ['.md'] = 'markdown',       -- Standard Markdown
        ['.markdown'] = 'markdown',
        ['.mdown'] = 'markdown'
      }

      -- Textverhalten: Neue Zeilen nicht ignorieren
      vim.g.vimwiki_text_ignore_newline = 0

      -- Spezielle Tastenkombination für VimWiki-Dateien
      -- "-" wird zur Suche (wie in deiner Konfiguration)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "vimwiki",
        callback = function()
          vim.api.nvim_buf_set_keymap(0, "n", "-", "/", { noremap = true })
        end
      })
    end
  }
}
