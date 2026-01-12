local toggle_key = "<M-,>"

return {
	"coder/claudecode.nvim",
	keys = { { toggle_key, "<cmd>ClaudeCodeFocus<cr>", desc = "Toggle Claude", mode = { "n", "x" } } },
	opts = function(_, opts)
		opts.terminal = {
			---@module "snacks"
			---@type snacks.win.Config|{}
			snacks_win_opts = {
				position = "bottom",
				height = 0.6,
				keys = {
					claude_hide = {
						toggle_key,
						function(self)
							self:hide()
						end,
						mode = "t",
						desc = "Hide",
					},
				},
			},
		}
	end,
}
