-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- -- Copy relative path to clipboard

local wk = require("which-key")

wk.add({
  { "<leader>c", group = "code" }, -- <Space>c as "code" group
  { "<leader>cy", group = " yank" }, -- <Space>cy as "yank" subgroup
  {
    "<leader>cyr", -- Full keybinding: <Space>cyr
    function()
      local relative_path = vim.fn.expand("%")
      vim.fn.setreg("+", relative_path)
      print("Copied relative path: " .. relative_path)
    end,
    desc = " Copy relative path", -- Description for which-key
    mode = "n", -- Normal mode
  },
  {
    "<leader>cyf",
    function()
      local full_path = vim.fn.expand("%:p")
      vim.fn.setreg("+", full_path)
      print("Copied full path: " .. full_path)
    end,
    desc = " Copy full path",
    mode = "n",
  },
  {
    "<leader>cyd",
    function()
      local dir_path = vim.fn.expand("%:p:h")
      vim.fn.setreg("+", dir_path)
      print("Copied directory path: " .. dir_path)
    end,
    desc = " Copy directory path",
    mode = "n",
  },
})
