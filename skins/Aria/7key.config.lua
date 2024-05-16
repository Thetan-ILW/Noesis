local JustConfig = require("sphere.JustConfig")
local imgui = require("imgui")
local just = require("just")

local config = JustConfig()

config.data = --[[data]] {
	autosave = true,
	columnSize = 48,
	hitposition = 450,
	measureLine = true,
	noteHeight = 75
} --[[/data]]

function config:draw(w, h)
	local data = self.data

	just.indent(10)
	just.text("The best skin.")

	imgui.setSize(w, h, w / 2, 55)
	data.hitposition = imgui.slider1("hitposition", data.hitposition, "%d", 240, 480, 1, "Hit position")
	data.columnSize = imgui.slider1("columnSize", data.columnSize, "%d", 16, 128, 1, "Column size")
	data.noteHeight = imgui.slider1("noteHeight", data.noteHeight, "%d", 16, 128, 1, "Note height")
	data.measureLine = imgui.checkbox("measureLine", data.measureLine, "Measure line")

	imgui.separator()
	if imgui.button("Write config file", "Write") then
		self:write()
	end
	data.autosave = imgui.checkbox("autosave", data.autosave, "Autosave")
end

return config
