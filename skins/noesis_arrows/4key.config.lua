local JustConfig = require("sphere.JustConfig")
local imgui = require("thetan.irizz.imgui")
local just = require("just")

local config = JustConfig()

config.data = --[[data]]
	{
		accuracyAlign = "right",
		accuracyX = 1010,
		accuracyY = 42,
		acuracyAlign = "right",
		animatedJudge = true,
		autosave = true,
		cheatLns = false,
		circleProgressBar = true,
		comboPosition = 135,
		conveyorPosition = 0,
		hitErrorBackground = 24,
		hitErrorCount = 10,
		hitErrorHeight = 20,
		hitErrorPosition = 460,
		hitErrorRadius = 2,
		hitErrorWidth = 222,
		hitposition = 460,
		judgePosition = 155,
		judgeScale = 0.5,
		measureLine = false,
		noteSize = 69,
	} --[[/data]]

local alignList = {
	"left",
	"center",
	"right",
}

function config:draw(w, h)
	local data = self.data

	just.text("Myuka 4K Clone skin settings:")

	imgui.setSize(w, h, w / 2, 55)
	just.next(0, 10)
	data.conveyorPosition =
		imgui.slider1("conveyorPosition", data.conveyorPosition, "%d", -240, 240, 1, "Conveyor position")
	data.hitposition = imgui.slider1("hitposition", data.hitposition, "%d", 240, 480, 1, "Hit position")
	data.noteSize = imgui.slider1("noteSize", data.noteSize, "%d", 16, 128, 1, "Note size / Column size")
	data.comboPosition = imgui.slider1("comboPosition", data.comboPosition, "%d", 0, 480, 1, "Combo position")
	data.cheatLns = imgui.checkbox("cheatLns", data.cheatLns, "Cheat LNs / Short LNs")
	data.circleProgressBar = imgui.checkbox("circleProgressBar", data.circleProgressBar, "Circle progress bar")
	data.measureLine = imgui.checkbox("measureLine", data.measureLine, "Measure line")

	imgui.separator()
	just.text("Judgement:")
	just.next(0, 10)
	data.animatedJudge = imgui.checkbox("animatedJudge", data.animatedJudge, "Judge animation")
	data.judgePosition = imgui.slider1("judgePosition", data.judgePosition, "%d", 0, 480, 1, "Judge position")
	data.judgeScale = imgui.slider1("judgeScale", data.judgeScale * 100, "%d%%", 0, 200, 1, "Judge scale") / 100

	imgui.separator()
	just.text("Accuracy:")
	just.next(0, 10)
	data.accuracyAlign = imgui.combo("accuracyAlign", data.accuracyAlign, alignList, nil, "Accuracy align")
	data.accuracyX = imgui.slider1("accuracyX", data.accuracyX, "%d", 0, 1010, 1, "Accuracy X position")
	data.accuracyY = imgui.slider1("accuracyY", data.accuracyY, "%d", 0, 768, 1, "Accuracy X position")

	imgui.separator()
	just.text("Hit error:")
	just.next(0, 10)
	data.hitErrorPosition =
		imgui.slider1("hitErrorPosition", data.hitErrorPosition, "%d", 0, 480, 1, "Hit error position")
	data.hitErrorWidth = imgui.slider1("hitErrorWidth", data.hitErrorWidth, "%d", 0, 720, 1, "Hit error width")
	data.hitErrorHeight = imgui.slider1("hitErrorHeight", data.hitErrorHeight, "%d", 0, 50, 1, "Hit error height")
	data.hitErrorBackground =
		imgui.slider1("hitErrorBackground", data.hitErrorBackground, "%d%%", 0, 100, 1, "Hit error BG alpha")
	data.hitErrorCount = imgui.slider1("hitErrorCount", data.hitErrorCount, "%d", 1, 64, 1, "Hit error count")
	data.hitErrorRadius = imgui.slider1("hitErrorRadius", data.hitErrorRadius, "%d", 1, 8, 1, "Hit error radius")

	imgui.separator()
	just.next(0, 5)
	if imgui.button("Write config file", "Write") then
		self:write()
	end

	just.sameline()
	just.next(10)
	just.sameline()
	just.text("<< Don't forget to press this button!")
end

return config
