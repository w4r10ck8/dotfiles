return {
  "zbirenbaum/copilot.lua",
  opts = {
    copilot_node_command = vim.fn.expand("~/.nvm/versions/node/v22.22.0/bin/node"),
    panel = {
      enabled = true,
      auto_refresh = true,
      keymap = { open = false },
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = { accept = "<Tab>" },
    },
  },
}
