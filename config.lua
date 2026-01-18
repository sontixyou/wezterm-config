-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 40

-- or, changing the font size and color scheme.
config.font_size = 10
config.font = wezterm.font 'SF Mono Square'
config.colors = {
  cursor_bg = '#ff22f0',
  foreground = '#ffffff',
  background = "#24283b"
}

config.default_cwd = os.getenv("HOME") .. "/projects/"

config.scrollback_lines = 100000
config.hide_tab_bar_if_only_one_tab = true

-- Finally, return the configuration to wezterm:
config.keys = {
  {key="Enter", mods="SHIFT", action=wezterm.action{SendString="\x1b\r"}},
}

return config
