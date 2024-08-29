local wez = require("wezterm")

local M = {}

M.apply_to_config = function(c)
	c.color_scheme = "Catppuccin Macchiato"
	local scheme = wez.color.get_builtin_schemes()["Catppuccin Macchiato"]
	c.colors = {
		split = scheme.ansi[2],
	}
	c.inactive_pane_hsb = { brightness = 0.9 }
	c.window_decorations = "RESIZE"
	c.show_new_tab_button_in_tab_bar = false
end

return M
