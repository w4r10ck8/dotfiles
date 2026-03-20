return {
	"folke/snacks.nvim",
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "snacks_dashboard",
			callback = function(ev)
				local nop = { "<ScrollWheelUp>", "<ScrollWheelDown>", "<ScrollWheelLeft>", "<ScrollWheelRight>" }
				for _, key in ipairs(nop) do
					vim.keymap.set({ "n", "i" }, key, "<Nop>", { buffer = ev.buf, silent = true })
				end
			end,
		})
	end,
	opts = {
		styles = {
			dashboard = {
				wo = {
					scrolloff = 999,
					sidescrolloff = 999,
				},
			},
		},
		explorer = {
			enabled = false,
			replace_netrw = false,
		},
		dashboard = {
			preset = {
				header = [[
⠈⠙⠲⢶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣿⡀⠀⠀⠀⠀⠀⠀⠀⡄⠀⠀⡄⠀⠀⠀⠀⠀⠀⠀⣼⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣿⠟⠓⠉
⠀⠀⠀⠀⠈⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⢀⣧⣶⣦⣇⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠉⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣶⣶⣶⣾⣿⣿⣿⣿⣶⣶⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⠛⠛⠛⠛⠛⠛⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⠟⠛⠛⠛⠛⠛⠛⠃⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
				keys = {
					{
						key = "f",
						icon = "󰈞",
						desc = "Find File",
						action = function()
							Snacks.dashboard.pick("files")
						end,
					},
					{
						key = "g",
						icon = "󰊄",
						desc = "Find Text",
						action = function()
							Snacks.dashboard.pick("live_grep")
						end,
					},
					{
						key = "l",
						icon = "",
						desc = "Open Lazygit",
						action = function()
							Snacks.lazygit()
						end,
					},
					{ key = "x", icon = "󰒲", desc = "Lazy Extras", action = ":LazyExtras" },
					{ key = "L", icon = "󰒲", desc = "Lazy", action = ":Lazy" },
					{ key = "q", icon = "󰿅", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				function()
					local git_root = Snacks.git.get_root()
					local project = git_root and vim.fn.fnamemodify(git_root, ":t")
						or vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
					local branch = git_root
							and vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null"):gsub("\n", "")
						or ""
					local stats = git_root
							and vim.fn.system("git diff --stat HEAD 2>/dev/null | tail -1"):gsub("\n", "")
						or ""

					local parts = {}
					table.insert(parts, { "  " .. project, hl = "SnacksDashboardFooter" })
					if branch ~= "" then
						table.insert(parts, { "  |  ", hl = "SnacksDashboardDesc" })
						table.insert(parts, { "  " .. branch, hl = "SnacksDashboardSpecial" })
					end
					if stats ~= "" then
						table.insert(parts, { "  |  ", hl = "SnacksDashboardDesc" })
						table.insert(parts, { "  " .. stats, hl = "SnacksDashboardDesc" })
					end
					return { { text = parts, align = "center", padding = { 1, 1 } } }
				end,
				{ section = "startup" },
			},
		},
	},
}
