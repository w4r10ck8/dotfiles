return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- Don't replace netrw — neo-tree handles directory opens
  opts = {
    default_file_explorer = false,
    columns = { "icon", "permissions", "size" },
    view_options = { show_hidden = true },
  },
  keys = {
    { "<leader>o", "<cmd>Oil<cr>", desc = "Open Oil (parent dir)" },
  },
}
