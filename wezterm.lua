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

-- Finally, return the configuration to wezterm:
config.leader = { key = 'w', mods = 'CTRL', timeout_milliseconds = 1000 }

-- ウィンドウタイトルにワークスペース名を表示
wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
  local workspace = wezterm.mux.get_active_workspace()
  return 'wezterm - ' .. workspace
end)

config.keys = {
  {key="Enter", mods="SHIFT", action=wezterm.action{SendString="\x1b\r"}},

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

return config
