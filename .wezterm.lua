local wezterm = require("wezterm")
local act = wezterm.action

return {
	font = wezterm.font("MesloLGL Nerd Font"),
	font_size = 13.5,
	color_scheme = "Kanagawa (Gogh)",
	colors = {
		background = "#18333c",
		foreground = "#839496",
		cursor_bg = "#e6e1cf",
		cursor_fg = "#18333c",
		selection_bg = "#2f5d6a",
		selection_fg = "#e6e1cf",

		ansi = {
			"#18333c",
			"#dc322f",
			"#859900",
			"#b58900",
			"#268bd2",
			"#d33682",
			"#2aa198",
			"#839496",
		},

		brights = {
			"#657b83",
			"#ff6b6b",
			"#a6e22e",
			"#ffd866",
			"#66d9ef",
			"#f92672",
			"#56c8d8",
			"#e6e1cf",
		},
	},
	initial_cols = 80,
	initial_rows = 20,
	scrollback_lines = 100000,
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	native_macos_fullscreen_mode = true,

	keys = {
		-- 分屏
		{ key = "\\", mods = "ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "-", mods = "ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

		-- pane 切换
		{ key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left") },
		{ key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down") },
		{ key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
		{ key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },

		-- pane resize
		{ key = "H", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
		{ key = "L", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
		{ key = "K", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
		{ key = "J", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },

		--  pane zoom
		{ key = "Enter", mods = "ALT", action = act.TogglePaneZoomState },
		{ key = "Enter", mods = "CMD", action = act.ToggleFullScreen },
	},
}
