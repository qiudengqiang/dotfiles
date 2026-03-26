local wezterm = require("wezterm")
local act = wezterm.action

return {
  font = wezterm.font("MesloLGL Nerd Font"),
  font_size = 13.5,
  color_scheme = "Kanagawa (Gogh)",
  initial_cols = 80,
  initial_rows = 20,
  scrollback_lines = 100000,
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  native_macos_fullscreen_mode = true,

  keys = {
    -- 分屏
    { key = "\\", mods = "ALT", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = "-", mods = "ALT", action = act.SplitVertical { domain = "CurrentPaneDomain" } },

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
