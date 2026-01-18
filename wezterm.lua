-- Pull in the wezterm API
local wezterm = require 'wezterm'

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
config.hide_tab_bar_if_only_one_tab = true

-- 選択した文字列を自動的にクリップボードにコピー
config.selection_word_boundary = " \t\n{}[]()\"'`"

-- マウスで選択した文字列をクリップボードにコピー
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action_callback(function(window, pane)
      window:perform_action(wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection', pane)
    end),
  },
}

-- Finally, return the configuration to wezterm:
config.leader = { key = 'w', mods = 'CTRL', timeout_milliseconds = 1000 }

-- ウィンドウタイトルにワークスペース名を表示
wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
  local workspace = wezterm.mux.get_active_workspace()
  return 'wezterm - ' .. workspace
end)

config.keys = {
  {key="Enter", mods="SHIFT", action=wezterm.action{SendString="\x1b\r"}},

  -- ペイン分割
  -- Ctrl+W, % で左右に分割
  {
    key = '%',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- Ctrl+W, " で上下に分割
  {
    key = '"',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },

  -- ペイン移動
  -- Ctrl+W, h で左のペインへ移動
  {
    key = 'h',
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  -- Ctrl+W, j で下のペインへ移動
  {
    key = 'j',
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
  -- Ctrl+W, k で上のペインへ移動
  {
    key = 'k',
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  -- Ctrl+W, l で右のペインへ移動
  {
    key = 'l',
    mods = 'LEADER',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },

  -- ペインサイズ変更モードを有効化
  -- Ctrl+N でリサイズモードに入る
  {
    key = 'n',
    mods = 'CTRL',
    action = wezterm.action.ActivateKeyTable {
      name = 'resize_pane',
      one_shot = false,
    },
  },

  -- Ctrl+W, C でワークスペースを作成
  {
    key = 'c',
    mods = 'LEADER',
    action = wezterm.action.PromptInputLine {
      description = 'Enter name for new workspace',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(
            wezterm.action.SwitchToWorkspace {
              name = line,
            },
            pane
          )
        end
      end),
    },
  },

  -- Ctrl+W, S でワークスペース一覧を表示して切り替え
  {
    key = 's',
    mods = 'LEADER',
    action = wezterm.action.ShowLauncherArgs {
      flags = 'FUZZY|WORKSPACES',
    },
  },
}

-- ペインリサイズモード用のキーテーブル
config.key_tables = {
  resize_pane = {
    { key = 'LeftArrow', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
    { key = 'h', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
    { key = 'RightArrow', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },
    { key = 'l', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },
    { key = 'UpArrow', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
    { key = 'k', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
    { key = 'DownArrow', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
    { key = 'j', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },
    -- Escapeキーでリサイズモードを終了
    { key = 'Escape', action = 'PopKeyTable' },
  },
}

return config
