local wez = require("wezterm")
local act = wez.action
local callback = wez.action_callback

local mod = {
	c = "CTRL",
	s = "SHIFT",
	a = "ALT",
	l = "LEADER",
}

local keybind = function(mods, key, action)
	return { mods = table.concat(mods, "|"), key = key, action = action }
end

local M = {}

local leader = { mods = mod.c, key = "b", timeout_miliseconds = 2000 }

local keys = function()
	local keys = {
		-- CTRL-A, CTRL-A sends CTRL-A
		keybind({ mod.l, mod.c }, "a", act.SendString("\x01")),

		-- pane and tabs
		keybind({ mod.l }, "v", act.SplitVertical({ domain = "CurrentPaneDomain" })),
		keybind({ mod.l }, "h", act.SplitHorizontal({ domain = "CurrentPaneDomain" })),
		keybind({ mod.l }, "z", act.TogglePaneZoomState),
		keybind({ mod.l }, "c", act.SpawnTab("CurrentPaneDomain")),
		keybind({ mod.l }, "j", act.ActivatePaneDirection("Left")),
		keybind({ mod.l }, "k", act.ActivatePaneDirection("Down")),
		keybind({ mod.l }, "l", act.ActivatePaneDirection("Up")),
		keybind({ mod.l }, ";", act.ActivatePaneDirection("Right")),
		keybind({ mod.l }, "x", act.CloseCurrentPane({ confirm = true })),
		keybind({ mod.l }, "q", act.CloseCurrentTab({ confirm = true })),
		keybind({ mod.l, mod.s }, "j", act.AdjustPaneSize({ "Left", 5 })),
		keybind({ mod.l, mod.s }, "k", act.AdjustPaneSize({ "Down", 5 })),
		keybind({ mod.l, mod.s }, "l", act.AdjustPaneSize({ "Up", 5 })),
		keybind({ mod.l, mod.s }, ";", act.AdjustPaneSize({ "Right", 5 })),
		keybind(
			{ mod.l },
			"e",
			act.PromptInputLine({
				description = wez.format({
					{ Attribute = { Intensity = "Bold" } },
					{ Foreground = { AnsiColor = "Fuchsia" } },
					{ Text = "Renaming Tab Title...:" },
				}),
				action = callback(function(win, _, line)
					if line == "" then
						return
					end
					win:active_tab():set_title(line)
				end),
			})
		),

		-- workspaces
		keybind({ mod.l }, "w", act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" })),

		-- copy and paste
		keybind({ mod.c, mod.s }, "c", act.CopyTo("Clipboard")),
		keybind({ mod.c, mod.s }, "v", act.PasteFrom("Clipboard")),
	}

	-- tab navigation
	for i = 1, 9 do
		table.insert(keys, keybind({ mod.l }, tostring(i), act.ActivateTab(i - 1)))
	end
	return keys
end

M.apply_to_config = function(c)
	c.leader = leader
	c.keys = keys()
end

return M
