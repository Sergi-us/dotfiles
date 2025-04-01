-- VimWiki Konfiguration
-- ## 2025-03-30 SARBS
return {
  {
    "vimwiki/vimwiki",
    lazy = false,
    init = function()
      vim.g.vimwiki_list = {
        {
          path = '~/.local/share/nvim/vimwiki',
          syntax = 'markdown',
          ext = '.md'
        },
        {
          path = '~/.local/share/nvim/sarbs',
          syntax = 'default',
          ext = '.wiki',
          path_html = '~/www/wiki',
          auto_toc = 1,
          auto_tags = 1,
          auto_generate_links = 1,
          auto_generate_tags = 1
        },
      }

      vim.g.vimwiki_ext2syntax = {
        ['.Rmd'] = 'markdown',
        ['.rmd'] = 'markdown',
        ['.md'] = 'markdown',
        ['.markdown'] = 'markdown',
        ['.mdown'] = 'markdown'
      }

      vim.g.vimwiki_text_ignore_newline = 0

      -- Tastenkürzel
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "vimwiki",
        callback = function()
          vim.api.nvim_buf_set_keymap(0, "n", "-", "/", { noremap = true })
        end
      })
    end
  }
}
