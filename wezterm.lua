local wezterm = require 'wezterm'
local config = wezterm.config_builder()
config.font_dirs = { 'fonts' }
config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = 'Medium' })
config.font_size = 13.0
config.color_scheme = 'OneDark (Gogh)'
config.colors = { 
    foreground = '#E0E0E0',
    cursor_bg = '#FFFFFF', 
    cursor_fg = '#000000',
}
config.enable_tab_bar = false
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
local function ShuffleInPlace(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end
local bg_dir = wezterm.executable_dir .. '\\backgrounds'
local images = wezterm.glob(bg_dir .. '\\*.{jpg,jpeg,png,gif,bmp,webp}')
ShuffleInPlace(images)
local current_bg_index = 0
config.keys = {
    {
    key = 'c',
    mods = 'ALT',
    action = wezterm.action_callback(function(window, pane)
      local overrides = window:get_config_overrides() or {}
      overrides.window_background_image = nil
      overrides.background = nil
      window:set_config_overrides(overrides)
      wezterm.log_info('Background cleared.')
    end),
  },
    {
        key = 'n',
        mods = 'ALT',
        action = wezterm.action_callback(function(window, pane)
            if #images == 0 then
                wezterm.log_error('No images found in ' .. bg_dir)
                return
            end
            current_bg_index = current_bg_index + 1
            if current_bg_index > #images then
                current_bg_index = 1
            end
            local next_image = images[current_bg_index]
            window:set_config_overrides({
                window_background_image = nil, 
                background = {
                    {
                        source = { File = next_image },
                        hsb = { saturation = 0.8 }, 
                    },
                    {
                        source = { Color = '#000000' },
                        opacity = 0.85,
                        width = '100%',
                        height = '100%',
                    },
                }
            })
            wezterm.log_info('Switched background to: ' .. next_image)
        end),
    },
}
for i = 1, 8 do
    table.insert(config.keys, {
        key = tostring(i),
        mods = 'CTRL|ALT',
        action = wezterm.action.MoveTab(i - 1),
    })
end

config.max_fps = 240
config.animation_fps = 1
config.cursor_blink_rate = 800

config.window_background_opacity = 1.0--0.95
config.text_background_opacity = 1.0

config.window_decorations = "RESIZE"
config.check_for_updates = false
config.default_cursor_style = 'BlinkingBlock'

return config
