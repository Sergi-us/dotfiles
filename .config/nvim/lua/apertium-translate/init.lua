local M = {}

-- Plugin State
M.state = {
  active = false,
  source_buf = nil,
  target_buf = nil,
  source_win = nil,
  target_win = nil,
  from_lang = 'deu',
  to_lang = 'eng',
}

-- Config
M.config = {
  default_from = 'deu',
  default_to = 'eng',
  keymaps = {
    translate = '<leader>tt',
    toggle_mode = '<leader>tm',
    close = '<leader>tc',
    swap_direction = '<leader>ts',
  }
}

-- Setup function
function M.setup(opts)
  M.config = vim.tbl_deep_extend('force', M.config, opts or {})

  -- Global keymaps
  vim.keymap.set('n', M.config.keymaps.toggle_mode, M.toggle_mode,
    { desc = 'Toggle Translation Mode' })
end

-- Create split buffers
local function create_split_buffers()
  -- Save current window
  local original_win = vim.api.nvim_get_current_win()

  -- Create vertical split
  vim.cmd('vsplit')

  -- Left window (source)
  M.state.source_win = vim.api.nvim_get_current_win()
  M.state.source_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(M.state.source_win, M.state.source_buf)

  -- Buffer settings
  vim.api.nvim_buf_set_option(M.state.source_buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(M.state.source_buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(M.state.source_buf, 'swapfile', false)

  -- Set initial text
  vim.api.nvim_buf_set_lines(M.state.source_buf, 0, -1, false, {
    '# Translation Mode Active',
    '# Paste your text here',
    '# Press ' .. M.config.keymaps.translate .. ' to translate',
    '# Press ' .. M.config.keymaps.swap_direction .. ' to swap languages',
    '# Press ' .. M.config.keymaps.close .. ' to close',
    '',
  })

  -- Right window (target)
  vim.cmd('wincmd l')
  vim.cmd('vnew')
  M.state.target_win = vim.api.nvim_get_current_win()
  M.state.target_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(M.state.target_win, M.state.target_buf)

  vim.api.nvim_buf_set_option(M.state.target_buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(M.state.target_buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(M.state.target_buf, 'swapfile', false)
  vim.api.nvim_buf_set_option(M.state.target_buf, 'modifiable', false)

  -- Initial target text
  vim.api.nvim_buf_set_option(M.state.target_buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(M.state.target_buf, 0, -1, false, {
    '# Translation will appear here',
    '# ' .. M.state.from_lang .. ' → ' .. M.state.to_lang,
  })
  vim.api.nvim_buf_set_option(M.state.target_buf, 'modifiable', false)

  -- Go back to source window
  vim.api.nvim_set_current_win(M.state.source_win)

  -- Setup buffer-local keymaps
  setup_buffer_keymaps()
end

-- Setup keymaps for translation buffers
function setup_buffer_keymaps()
  local opts = { buffer = M.state.source_buf, silent = true }

  vim.keymap.set('n', M.config.keymaps.translate, M.translate,
    vim.tbl_extend('force', opts, { desc = 'Translate text' }))

  vim.keymap.set('n', M.config.keymaps.close, M.close_mode,
    vim.tbl_extend('force', opts, { desc = 'Close translation mode' }))

  vim.keymap.set('n', M.config.keymaps.swap_direction, M.swap_languages,
    vim.tbl_extend('force', opts, { desc = 'Swap translation direction' }))
end

-- Translate function
function M.translate()
  if not M.state.active then
    vim.notify('Translation mode not active', vim.log.levels.WARN)
    return
  end

  -- Get source text (skip header lines)
  local lines = vim.api.nvim_buf_get_lines(M.state.source_buf, 0, -1, false)
  local text_lines = {}
  local skip_header = true

  for _, line in ipairs(lines) do
    if skip_header and not line:match('^#') and line ~= '' then
      skip_header = false
    end
    if not skip_header then
      table.insert(text_lines, line)
    end
  end

  local text = table.concat(text_lines, '\n')

  if text == '' or text:match('^%s*$') then
    vim.notify('No text to translate', vim.log.levels.WARN)
    return
  end

  -- Run translation
  local lang_pair = M.state.from_lang .. '-' .. M.state.to_lang
  local cmd = string.format('apertium %s', lang_pair)
  local result = vim.fn.system(cmd, text)

  -- Check for errors
  if vim.v.shell_error ~= 0 then
    vim.notify('Translation failed: ' .. result, vim.log.levels.ERROR)
    return
  end

  -- Update target buffer
  vim.api.nvim_buf_set_option(M.state.target_buf, 'modifiable', true)
  local result_lines = vim.split(result, '\n', { trimempty = false })
  vim.api.nvim_buf_set_lines(M.state.target_buf, 0, -1, false, result_lines)
  vim.api.nvim_buf_set_option(M.state.target_buf, 'modifiable', false)

  vim.notify('Translation complete: ' .. lang_pair, vim.log.levels.INFO)
end

-- Swap language direction
function M.swap_languages()
  M.state.from_lang, M.state.to_lang = M.state.to_lang, M.state.from_lang

  -- Update header
  vim.api.nvim_buf_set_option(M.state.target_buf, 'modifiable', true)
  vim.api.nvim_buf_set_lines(M.state.target_buf, 0, -1, false, {
    '# Translation will appear here',
    '# ' .. M.state.from_lang .. ' → ' .. M.state.to_lang,
  })
  vim.api.nvim_buf_set_option(M.state.target_buf, 'modifiable', false)

  vim.notify('Direction: ' .. M.state.from_lang .. ' → ' .. M.state.to_lang,
    vim.log.levels.INFO)
end

-- Toggle translation mode
function M.toggle_mode()
  if M.state.active then
    M.close_mode()
  else
    M.open_mode()
  end
end

-- Open translation mode
function M.open_mode()
  if M.state.active then
    vim.notify('Translation mode already active', vim.log.levels.INFO)
    return
  end

  M.state.active = true
  M.state.from_lang = M.config.default_from
  M.state.to_lang = M.config.default_to

  create_split_buffers()

  vim.notify('Translation Mode activated', vim.log.levels.INFO)
end

-- Close translation mode
function M.close_mode()
  if not M.state.active then
    return
  end

  -- Close windows
  if M.state.source_win and vim.api.nvim_win_is_valid(M.state.source_win) then
    vim.api.nvim_win_close(M.state.source_win, true)
  end

  if M.state.target_win and vim.api.nvim_win_is_valid(M.state.target_win) then
    vim.api.nvim_win_close(M.state.target_win, true)
  end

  -- Reset state
  M.state.active = false
  M.state.source_buf = nil
  M.state.target_buf = nil
  M.state.source_win = nil
  M.state.target_win = nil

  vim.notify('Translation Mode closed', vim.log.levels.INFO)
end

return M
