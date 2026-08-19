return {
	"mfussenegger/nvim-lint",
	opts = {
		linters = {
			markdownlint = {
				args = { "--disable", "MD013", "--" },
			},
		},
	},
	keys = {
		{
			"<leader>xA",
			function()
				vim.fn.setqflist({})
				local lines = {}
				vim.fn.jobstart("npm run typecheck 2>&1", {
					cwd = vim.fn.getcwd(),
					stdout_buffered = true,
					on_stdout = function(_, data)
						lines = data
					end,
					on_exit = function()
						vim.fn.setqflist({}, " ", {
							lines = lines,
							efm = "%f(%l\\,%c): error TS%n: %m,%f(%l\\,%c): warning TS%n: %m,%-G%.%#",
						})
						require("fzf-lua").quickfix()
					end,
				})
			end,
			desc = "All Project Errors (tsc)",
		},
	},
}
