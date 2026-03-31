-- Options are automatically loaded before lazy.nvim startup
-- Default options: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

vim.lsp.inlay_hint.enable(false)

opt.wrap = false

if vim.fn.has("nvim-0.10") == 1 then
  opt.foldexpr = "v:lua.require'lazyvim.util'.treesitter.foldexpr()"
  opt.foldmethod = "expr"
  opt.foldtext = ""
else
  opt.foldmethod = "indent"
  opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
end
