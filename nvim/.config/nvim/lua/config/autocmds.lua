-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Workaround for Neovim 0.11.x bug: inlay hint renderer doesn't clamp col
-- positions, causing "Invalid 'col': out of range" errors from tsserver hints.
local orig_inlay_hint_handler = vim.lsp.handlers["textDocument/inlayHint"]
vim.lsp.handlers["textDocument/inlayHint"] = function(err, result, ctx, config)
  if result and ctx.bufnr and vim.api.nvim_buf_is_valid(ctx.bufnr) then
    result = vim.tbl_filter(function(hint)
      local line = hint.position.line
      local col = hint.position.character
      local ok, lines = pcall(vim.api.nvim_buf_get_lines, ctx.bufnr, line, line + 1, false)
      return ok and lines[1] ~= nil and col <= #lines[1]
    end, result)
  end
  if orig_inlay_hint_handler then
    return orig_inlay_hint_handler(err, result, ctx, config)
  end
end

-- Open neo-tree instead of fzf when launching nvim with a directory (nvim .)
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    if vim.fn.isdirectory(data.file) == 1 then
      vim.cmd.cd(data.file)
      vim.schedule(function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.fn.getcwd() })
      end)
    end
  end,
})
