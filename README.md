# wezterm-config

A custom configuration for [WezTerm](https://wezfurlong.org/wezterm/) terminal emulator with enhanced pane management, workspace support, and a comfortable color scheme.

## Features

- **Custom Color Scheme**: Tokyo Night-inspired theme with custom cursor and split colors
- **Pane Management**: Vim-style keybindings for splitting and navigating panes
- **Workspace Support**: Create and switch between multiple workspaces
- **Auto-copy to Clipboard**: Automatically copy selected text on mouse release
- **Inactive Pane Dimming**: Visual distinction between active and inactive panes
- **Custom Font**: SF Mono Square at 16pt for better readability

## Configuration Overview

- **Window Size**: 120 columns × 40 rows
- **Default Directory**: `~/projects/`
- **Scrollback Lines**: 100,000 lines
- **Leader Key**: `Ctrl+W` (1000ms timeout)

## Keybindings

### Leader Key

The leader key is `Ctrl+W` - press it before any of the following commands.

### Pane Splitting

| Keybinding | Action |
|------------|--------|
| `Ctrl+W` → `%` (Shift+5) | Split pane horizontally (left/right) |
| `Ctrl+W` → `"` (Shift+') | Split pane vertically (up/down) |

### Pane Navigation

| Keybinding | Action |
|------------|--------|
| `Ctrl+W` → `h` | Move to left pane |
| `Ctrl+W` → `j` | Move to bottom pane |
| `Ctrl+W` → `k` | Move to top pane |
| `Ctrl+W` → `l` | Move to right pane |

### Pane Resizing

| Keybinding | Action |
|------------|--------|
| `Ctrl+N` | Enter resize mode |
| `h` or `←` | Resize pane left (in resize mode) |
| `j` or `↓` | Resize pane down (in resize mode) |
| `k` or `↑` | Resize pane up (in resize mode) |
| `l` or `→` | Resize pane right (in resize mode) |
| `Escape` | Exit resize mode |

### Workspace Management

| Keybinding | Action |
|------------|--------|
| `Ctrl+W` → `c` | Create new workspace (prompts for name) |
| `Ctrl+W` → `s` | Show workspace list and switch |

### Other Keybindings

| Keybinding | Action |
|------------|--------|
| `Shift+Enter` | Send Escape+Enter sequence |

## Installation

1. Clone this repository:
   ```bash
   git clone <repository-url> ~/.config/wezterm
   ```

2. Or copy `wezterm.lua` to your WezTerm config directory:
   ```bash
   cp wezterm.lua ~/.config/wezterm/wezterm.lua
   ```

3. Restart WezTerm or reload the configuration

## Customization

Edit `wezterm.lua` to customize:
- Font family and size
- Color scheme
- Window dimensions
- Keybindings
- Default working directory

## Requirements

- WezTerm terminal emulator
- SF Mono Square font (or modify the font setting to use your preferred font)

## License

This configuration is provided as-is for personal use and modification.
