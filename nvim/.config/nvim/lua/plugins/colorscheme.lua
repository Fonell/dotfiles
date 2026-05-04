return {
	{
		"Mofiqul/vscode.nvim",
		opts = {
			group_overrides = {
				DiffAdd    = { bg = "#34402a", fg = "NONE" },
				DiffDelete = { bg = "#4A2323", fg = "NONE" },
				DiffChange = { bg = "#34402a", fg = "NONE" },
				DiffText   = { bg = "#435f2b", fg = "NONE" },
			},
		},
	},
	{
		"LazyVim/LazyVim",
		opts = { colorscheme = "vscode" },
	},
}
