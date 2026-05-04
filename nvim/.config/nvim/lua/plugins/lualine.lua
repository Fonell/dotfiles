return {
	"nvim-lualine/lualine.nvim",
	opts = {
		options = {
			component_separators = "",
			section_separators = "",
		},
		sections = {
			lualine_a = {},
			lualine_b = { "branch" },
			lualine_c = { { "filename", path = 1 } },
			lualine_x = { "diff" },
			lualine_y = {},
			lualine_z = {
				function()
					local clients = vim.lsp.get_clients({ bufnr = 0 })
					if #clients == 0 then
						return ""
					end
					local names = {}
					for _, client in ipairs(clients) do
						table.insert(names, client.name)
					end
					return table.concat(names, ", ")
				end,
			},
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { { "filename", path = 1 } },
			lualine_x = {},
			lualine_y = {},
			lualine_z = {},
		},
	},
}
