local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Launch WSL2 by default
config.default_prog = { "wsl.exe", "--cd", "~", "--exec", "/bin/bash", "-l" }

-- General
config.font_size = 13
config.font = wezterm.font("JetBrains Mono")
config.color_scheme = "Vs Code Dark+ (Gogh)"
config.window_close_confirmation = "NeverPrompt"
config.audible_bell = "Disabled"

config.window_decorations = "RESIZE"
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false

-- Key bindings
config.keys = {
	-- Pane: split and close
	{ key = "-", mods = "ALT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "_", mods = "ALT|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "x", mods = "ALT", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
	-- Pane: zoom toggle
	{ key = "z", mods = "ALT", action = wezterm.action.TogglePaneZoomState },

	-- Tabs: open, close, navigate, rename
	{ key = "c", mods = "ALT", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ key = "w", mods = "ALT", action = wezterm.action.CloseCurrentTab({ confirm = false }) },
	{
		key = ",",
		mods = "ALT",
		action = wezterm.action.PromptInputLine({
			description = "Rename tab",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{ key = "LeftArrow", mods = "ALT", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "RightArrow", mods = "ALT", action = wezterm.action.ActivateTabRelative(1) },
	-- Tabs: move
	{ key = "LeftArrow", mods = "ALT|SHIFT", action = wezterm.action.MoveTabRelative(-1) },
	{ key = "RightArrow", mods = "ALT|SHIFT", action = wezterm.action.MoveTabRelative(1) },

	-- Copy mode (keyboard-driven selection); copy/paste use WezTerm defaults (CTRL+SHIFT+C/V)
	{ key = "Enter", mods = "ALT", action = wezterm.action.ActivateCopyMode },

	-- Search
	{ key = "f", mods = "ALT", action = wezterm.action.Search({ CaseSensitiveString = "" }) },

	-- Window
	{ key = "F11", mods = "", action = wezterm.action.ToggleFullScreen },

	-- Reload config
	{ key = "R", mods = "ALT|SHIFT", action = wezterm.action.ReloadConfiguration },

	-- Scroll
	{ key = "u", mods = "ALT", action = wezterm.action.ScrollByPage(-0.5) },
	{ key = "d", mods = "ALT", action = wezterm.action.ScrollByPage(0.5) },
}

-- Smart splits integration (navigate/resize across nvim splits and wezterm panes)
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
smart_splits.apply_to_config(config, {
	direction_keys = { "LeftArrow", "DownArrow", "UpArrow", "RightArrow" },
	modifiers = {
		move = "CTRL",
		resize = "SHIFT",
	},
})

return config
