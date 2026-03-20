-- LSP servers not covered by LazyVim extras
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      astro = {},
      eslint = {
        settings = {
          experimental = {
            useFlatConfig = true,
          },
        },
      },
    },
    setup = {
      eslint = function()
        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client.name == "eslint" then
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = args.buf,
                callback = function()
                  local ok, err = pcall(vim.cmd, "LspEslintFixAll")
                  if not ok then
                    vim.notify("LspEslintFixAll failed: " .. tostring(err), vim.log.levels.WARN)
                  end
                end,
              })
            end
          end,
        })
      end,
    },
  },
}
