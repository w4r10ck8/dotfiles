-- LSP servers not covered by LazyVim extras
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      astro = {},
      eslint = {
        settings = {
          codeActionOnSave = {
            enable = true,
            mode = "all",
          },
        },
      },
    },
  },
}
