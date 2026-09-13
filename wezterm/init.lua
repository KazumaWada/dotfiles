local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- 基本設定
config.automatically_reload_config = true
config.font_size = 12.0
config.font = wezterm.font_with_fallback({
	"JetBrains Mono",
	"Hiragino Sans",
})
config.use_ime = true
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20

----------------------------------------------------
-- Tab
----------------------------------------------------
-- タイトルバーを非表示（リサイズ可能だけ残す）
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

-- タブバーの表示設定
config.show_tabs_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

-- タブバーの透過設定
config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}

-- タブバー背景色
config.window_background_gradient = {
	colors = { "#000000" },
}

-- タブの追加ボタンを非表示
config.show_new_tab_button_in_tab_bar = false

-- タブ同士の境界線を非表示
config.colors = {
	tab_bar = {
		inactive_tab_edge = "none",
	},
}

-- タブの形をカスタマイズ（Unicode版）
local SOLID_LEFT_ARROW = ""
local SOLID_RIGHT_ARROW = ""

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#5c6d74"
	local foreground = "#FFFFFF"
	local edge_background = "none"

	if tab.is_active then
		background = "#ae8b2d"
		foreground = "#FFFFFF"
	end

	local edge_foreground = background
	local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

----------------------------------------------------
-- Leader / Keybinds は省略
----------------------------------------------------
-- config.disable_default_key_bindings = true
-- config.key_tables = {}
-- config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

config.keys = {
  -- 左右分割
  { key = '|', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  -- 上下分割
  { key = '-', mods = 'CTRL|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
}

return config
