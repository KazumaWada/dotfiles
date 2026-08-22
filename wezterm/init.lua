local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- 基本設定
-- 透過・ブラー・パディング・カーソルは Ghostty (TokyoNight Storm) の設定値と統一
config.automatically_reload_config = true
config.font_size = 12.0
config.use_ime = true
config.window_background_opacity = 0.82
config.macos_window_background_blur = 30
config.window_padding = {
        left = 14,
        right = 14,
        top = 14,
        bottom = 14,
}
config.default_cursor_style = "SteadyBlock"

----------------------------------------------------
-- Tab
----------------------------------------------------
-- タイトルバーを非表示（リサイズ可能だけ残す）
-- INTEGRATED_BUTTONS が無いとタブバーのダブルクリック最大化が効かないため必須
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
-- ボタン自体は非表示にする（見た目は今まで通り）
config.integrated_title_buttons = {}

-- タブバーの表示設定
config.show_tabs_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false

-- タブバーの透過設定
config.window_frame = {
        inactive_titlebar_bg = "none",
        active_titlebar_bg = "none",
}

-- タブバー背景色
-- 鉛のような金属光沢を出すため、放射状グラデーション + ノイズで質感を付与
config.window_background_gradient = {
        orientation = { Linear = { angle = 70 } },
        colors = { "#040807", "#2c3530", "#060b09", "#3d453f", "#0a0f0d", "#1c2320" },
        interpolation = "Basis",
        blend = "Oklab",
        noise = 56,
}

-- タブの追加ボタンを非表示
config.show_new_tab_button_in_tab_bar = false

-- タブ1個あたりの最大幅（狭くしてタブバーの空白＝ダブルクリック最大化領域を広げる）
config.tab_max_width = 20

-- タブ同士の境界線を非表示
-- 配色は Ghostty で使用している TokyoNight Storm テーマと統一
config.colors = {
        foreground = "#c0caf5",
        background = "#24283b",
        cursor_bg = "#c0caf5",
        cursor_fg = "#1d202f",
        cursor_border = "#c0caf5",
        selection_bg = "#364a82",
        selection_fg = "#c0caf5",
        tab_bar = {
                inactive_tab_edge = "none",
        },
        ansi = { "#1d202f", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#bb9af7", "#7dcfff", "#a9b1d6" },
        brights = { "#4e5575", "#f7768e", "#9ece6a", "#e0af68", "#7aa2f7", "#bb9af7", "#7dcfff", "#c0caf5" },
}

-- タブの形をカスタマイズ（Unicode版）
local SOLID_LEFT_ARROW = ""
local SOLID_RIGHT_ARROW = ""

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
        local background = "#5c6d74"
        local foreground = "#FFFFFF"
        local edge_background = "none"

        if tab.is_active then
                background = "#5c6960"
                foreground = "#FFFFFF"
        end

        local edge_foreground = background
        -- パディング込みでも max_width をはみ出さないようにする（はみ出すとタブバーの空白＝ダブルクリック最大化領域が減る）
        local title = " " .. wezterm.truncate_right(tab.active_pane.title, max_width - 2) .. " "

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

---------------------------------------------------
-- Leader / Keybinds は後々追加予定
----------------------------------------------------
-- config.disable_default_key_bindings = true
-- config.key_tables = {}
-- config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

config.keys = {
        -- Cmd+D で左右にペイン分割
        { key = "d", mods = "CMD", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
        -- Cmd+Shift+D で上下にペイン分割
        { key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
        -- Cmd+W はタブ全体ではなく、フォーカス中のペインだけ閉じる（デフォルトは CloseCurrentTab）
        { key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
        -- Cmd+[ / Cmd+] で複数ペイン間をフォーカス移動（Ghostty の goto_split:previous/next と同じ）
        { key = "[", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Prev") },
        { key = "]", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Next") },
        -- Cmd+Shift+[ / Cmd+Shift+] でタブの並び順を入れ替える
        -- （WezTerm はまだドラッグでのタブ並べ替えに未対応のため、キーボードでの代替手段）
        { key = "[", mods = "CMD|SHIFT", action = wezterm.action.MoveTabRelative(-1) },
        { key = "]", mods = "CMD|SHIFT", action = wezterm.action.MoveTabRelative(1) },
}

return config
