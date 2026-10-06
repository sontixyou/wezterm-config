-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 40

-- or, changing the font size and color scheme.
config.font_size = 16
config.font = wezterm.font 'SF Mono Square'
config.colors = {
  cursor_bg = '#ff22f0',
  foreground = '#ffffff',
  background = "#24283b",
  split = '#5c9f5c',
}

-- 非アクティブなペインを暗くしてアクティブなペインを目立たせる
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.6,
}

config.default_cwd = os.getenv("HOME") .. "/projects/"

config.scrollback_lines = 100000

-- タブバー: 2枚以上で表示。タブ番号を出して Alt+数字 と対応させる
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_max_width = 24

-- 左Altは修飾キーとして送る（Alt+hjkl 等のため）。右Altは記号・日本語入力用に残す
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

-- URLクリックでブラウザを開く（tmux内でも動作）
config.hyperlink_rules = wezterm.default_hyperlink_rules()

config.selection_word_boundary = " \t\n{}[]()\"'`"

-- 選択を離したらクリップボードにコピー。選択でなくURL上のクリックならブラウザで開く
-- マウス報告中のアプリ内では Shift+クリックで WezTerm 側が処理する
local select_or_open = wezterm.action_callback(function(window, pane)
  window:perform_action(act.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection', pane)
end)

config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = select_or_open,
  },
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'SHIFT',
    action = select_or_open,
  },
}

-- ウィンドウタイトルにワークスペース名を表示
wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
  local workspace = wezterm.mux.get_active_workspace()
  return 'wezterm - ' .. workspace
end)

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = tab.tab_title
  if not title or #title == 0 then
    title = tab.active_pane.title
  end
  return ' ' .. (tab.tab_index + 1) .. ': ' .. title .. ' '
end)

config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  {key="Enter", mods="SHIFT", action=wezterm.action{SendString="\x1b\r"}},

  -- Ctrl+b, Ctrl+b でアプリに Ctrl+b を送る
  { key = 'b', mods = 'LEADER|CTRL', action = act.SendKey { key = 'b', mods = 'CTRL' } },

  -- ペイン分割
  { key = '%', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '"', mods = 'LEADER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- ペイン移動
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'h', mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'ALT', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },

  -- ペインを閉じる / ズーム
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },

  -- ペインリサイズモード（Esc で終了）
  {
    key = 'n',
    mods = 'ALT',
    action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false },
  },

  -- タブ
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  {
    key = ',',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'Enter new tab name',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
  { key = '1', mods = 'ALT', action = act.ActivateTab(0) },
  { key = '2', mods = 'ALT', action = act.ActivateTab(1) },
  { key = '3', mods = 'ALT', action = act.ActivateTab(2) },
  { key = '4', mods = 'ALT', action = act.ActivateTab(3) },
  { key = '5', mods = 'ALT', action = act.ActivateTab(4) },
  { key = '6', mods = 'ALT', action = act.ActivateTab(5) },
  { key = '7', mods = 'ALT', action = act.ActivateTab(6) },
  { key = '8', mods = 'ALT', action = act.ActivateTab(7) },
  { key = '9', mods = 'ALT', action = act.ActivateTab(8) },

  -- スクロールバック: コピーモード / 検索
  { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
  { key = 'f', mods = 'SUPER', action = act.Search { CaseInSensitiveString = '' } },

  -- Ctrl+b, C でワークスペースを作成
  {
    key = 'C',
    mods = 'LEADER|SHIFT',
    action = act.PromptInputLine {
      description = 'Enter name for new workspace',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(act.SwitchToWorkspace { name = line }, pane)
        end
      end),
    },
  },

  -- Ctrl+b, s でワークスペース一覧を表示して切り替え
  {
    key = 's',
    mods = 'LEADER',
    action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' },
  },
}

-- ペインリサイズモード用のキーテーブル
config.key_tables = {
  resize_pane = {
    { key = 'LeftArrow', action = act.AdjustPaneSize { 'Left', 5 } },
    { key = 'h', action = act.AdjustPaneSize { 'Left', 5 } },
    { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 5 } },
    { key = 'l', action = act.AdjustPaneSize { 'Right', 5 } },
    { key = 'UpArrow', action = act.AdjustPaneSize { 'Up', 5 } },
    { key = 'k', action = act.AdjustPaneSize { 'Up', 5 } },
    { key = 'DownArrow', action = act.AdjustPaneSize { 'Down', 5 } },
    { key = 'j', action = act.AdjustPaneSize { 'Down', 5 } },
    { key = 'Escape', action = 'PopKeyTable' },
  },
}

return config
