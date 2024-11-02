local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = "Argonaut"

config.font = wezterm.font("MesloLGS NF")
config.font_size = 11

config.hide_tab_bar_if_only_one_tab = true
 -- config.enable_tab_bar = false

config.window_decorations = "RESIZE"

config.window_background_opacity = 0.8
config.macos_window_background_blur = 10
config.adjust_window_size_when_changing_font_size = false

return config
