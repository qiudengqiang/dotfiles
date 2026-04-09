local wezterm = require("wezterm")
local act = wezterm.action

return {
	font = wezterm.font("MesloLGL Nerd Font"),
	font_size = 13.5,
	color_scheme = "Kanagawa (Gogh)",
	colors = {
		background = "#1f1f28",
	},
	initial_cols = 80,
	initial_rows = 20,
	scrollback_lines = 100000,
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	native_macos_fullscreen_mode = true,

	-- 渲染
	front_end = "WebGpu",
	max_fps = 120,
	animation_fps = 120,

	-- 右上角显示当前目录
	wezterm.on("update-right-status", function(window)
		local pane = window:active_pane()
		local cwd = pane:get_current_working_dir()
		local dir = ""

		if cwd then
			dir = cwd.file_path:match("[^/]+$") or ""
		end

		window:set_right_status(wezterm.format({
			{ Foreground = { Color = "lightgray" } },
			{ Text = " " .. dir .. " " },
		}))
	end),

	-- inactive pane style（亮度、饱和度）
	inactive_pane_hsb = {
        saturation = 0.7,
		brightness = 0.5,
	},

	keys = {
		-- fullscreen
		{ key = "Enter", mods = "CMD", action = act.ToggleFullScreen },

		-- pane split
		{ key = "\\", mods = "ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "-", mods = "ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

		-- pane shift
		{ key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left") },
		{ key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down") },
		{ key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
		{ key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },

		-- pane resize
		{ key = "H", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
		{ key = "L", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
		{ key = "K", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
		{ key = "J", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },

		-- pane zoom
		{ key = "Enter", mods = "ALT", action = act.TogglePaneZoomState },
	},
}
