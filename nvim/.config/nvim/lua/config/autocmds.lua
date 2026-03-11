-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

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
