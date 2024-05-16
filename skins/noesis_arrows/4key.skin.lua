local NoteSkinVsrg = require("sphere.models.NoteSkinModel.NoteSkinVsrg")
local BasePlayfield = require("sphere.models.NoteSkinModel.BasePlayfield")
local ImageValueView = require("sphere.views.ImageValueView")
local CircleProgressView = require("sphere.views.GameplayView.CircleProgressView")
local Bussy = require("thetan.bussy")

local JustConfig = require("sphere.JustConfig")
local root = (...):match("(.+)/.-")
local config = JustConfig:fromFile(root .. "/4key.config.lua")

local noteskin = NoteSkinVsrg({
	path = ...,
	name = "Myuka 4K Clone",
	inputMode = "4key",
	range = { -1, 1 },
	unit = 480,
	hitposition = config:get("hitposition"),
	config = config,
})

noteskin:setInput({ "key1", "key2", "key3", "key4" })

local cs = config:get("noteSize")

noteskin:setColumns({
	offset = config:get("conveyorPosition"),
	align = "center",
	width = { cs, cs, cs, cs },
	space = { 32, 0, 0, 0, 32 },
})

noteskin:setTextures({
	{ pixel = "pixel.png" },
	{ empty = "empty.png" },
	{ tail = "4key_notes/tail.png" },
	{ body = "4key_notes/body.png" },
	{ cheat_body = "4key_notes/cheat_body.png" },
	{ left = "4key_notes/left.png" },
	{ down = "4key_notes/down.png" },
	{ up = "4key_notes/up.png" },
	{ right = "4key_notes/right.png" },
	{ head_left = "4key_notes/head_left.png" },
	{ head_down = "4key_notes/head_down.png" },
	{ head_up = "4key_notes/head_up.png" },
	{ head_right = "4key_notes/head_right.png" },
})

noteskin:setImages({
	pixel = { "pixel" },
	empty = { "empty" },
	body = { "body" },
	cheat_body = { "cheat_body" },
	tail = { "tail" },
	left = { "left" },
	down = { "down" },
	up = { "up" },
	right = { "right" },
	head_left = { "head_left" },
	head_down = { "head_down" },
	head_up = { "head_up" },
	head_right = { "head_right" },
})

noteskin:setShortNote({
	image = { "left", "down", "up", "right" },
	h = cs,
})

if config:get("cheatLns") then
	noteskin:setLongNote({
		head = { "head_left", "head_down", "head_up", "head_right" },
		body = "cheat_body",
		tail = "empty",
		h = cs,
	})
else
	noteskin:setLongNote({
		head = { "head_left", "head_down", "head_up", "head_right" },
		body = "body",
		tail = "tail",
		h = cs,
	})
end

if config:get("measureLine") then
	noteskin:addMeasureLine({
		h = 4,
		color = { 0.5, 0.5, 0.5, 1 },
		image = "pixel",
	})
end

noteskin:addBga({
	x = 0,
	y = 0,
	w = 1,
	h = 1,
	color = { 0.25, 0.25, 0.25, 1 },
})

local playfield = BasePlayfield(noteskin)
local bussy = Bussy(playfield)

playfield:addBga({
	transform = { { 1 / 2, -16 / 9 / 2 }, { 0, -7 / 9 / 2 }, 0, { 0, 16 / 9 }, { 0, 16 / 9 }, 0, 0, 0, 0 },
})
playfield:enableCamera()

local background_colors = {
	{ 0, 0, 0, 0.8 },
	{ 0, 0, 0, 0.8 },
	{ 0, 0, 0, 0.8 },
	{ 0, 0, 0, 0.8 },
}
playfield:addColumnsBackground({
	color = background_colors,
})

playfield:addNotes()
playfield:addKeyImages({
	h = cs,
	padding = 480 - config:get("hitposition"),
	pressed = {
		"4key_notes/key_left.png",
		"4key_notes/key_down.png",
		"4key_notes/key_up.png",
		"4key_notes/key_right.png",
	},
	released = {
		"4key_notes/r_key_left.png",
		"4key_notes/r_key_down.png",
		"4key_notes/r_key_up.png",
		"4key_notes/r_key_right.png",
	},
})

local judges = {
	{ "miss", "judgements/miss.png" },
	{ "5", "judgements/5.png" },
	{ "4", "judgements/4.png" },
	{ "3", "judgements/3.png" },
	{ "2", "judgements/2.png" },
	{ "1", "judgements/1.png" },
}

local max_size = 1.05
local min_size = 0.75

if not config:get("animatedJudge") then
	max_size = 1
	min_size = 1
end

playfield:addCombo(ImageValueView({
	transform = playfield:newLaneCenterTransform(480),
	x = 0,
	y = config:get("comboPosition"),
	oy = 0.5,
	align = "center",
	scale = 0.8,
	overlap = 1,
	files = bussy:getImageFont(root .. "/fonts/score/score"),
}))

bussy:addOsuJudgement({
	x = 0,
	y = config:get("judgePosition"),
	ox = 0.5,
	oy = 0.5,
	maxSize = max_size,
	size = 1,
	minSize = min_size,
	scale = config:get("judgeScale"),
	transform = playfield:newLaneCenterTransform(480),
	rate = 1,
	judgements = judges,
}, playfield)

playfield:disableCamera()

local score = ImageValueView({
	transform = playfield:newTransform(1024, 768, "right"),
	x = 1010,
	y = 0,
	scale = 1,
	format = "%07d",
	align = "right",
	overlap = 0,
	files = bussy:getImageFont(root .. "/fonts/score/score"),
})

function score:value()
	local judge = bussy:getJudge(self.game)

	if not judge.score then
		judge = bussy:getOsuOD9(self.game)
	end

	return judge.score
end

playfield:add(score)

local accuracy = playfield:addAccuracy(ImageValueView({
	transform = playfield:newTransform(1024, 768, "right"),
	x = config:get("accuracyX"),
	y = config:get("accuracyY"),
	scale = 0.8,
	align = config:get("accuracyAlign"),
	format = "%0.2f%%",
	overlap = 0,
	files = bussy:getImageFont(root .. "/fonts/accuracy/font"),
}))

accuracy.multiplier = 100

function accuracy:value()
	local judge = bussy:getJudge(self.game)
	return judge.accuracy or 1
end

playfield:add(accuracy)

playfield:addBaseElements({ "match players" })

if config:get("circleProgressBar") then
	playfield:addCircleProgressBar({
		x = 0,
		y = 0,
		r = 10 * 1.6,
		transform = playfield:newTransform(1024, 768, "right"),
		backgroundColor = { 1, 1, 1, 0.6 },
		foregroundColor = { 1, 1, 1, 1 },
		draw = function(_self)
			_self.y = accuracy.y + accuracy.height / 2 - 4
			_self.x = accuracy.x - (accuracy.scale * 140) - _self.r - 4
			CircleProgressView.draw(_self)
		end,
	})
else
	playfield:addBaseElements({ "progress" })
end

bussy:addHitError({
	transform = playfield:newLaneCenterTransform(480),
	x = 0,
	y = config:get("hitErrorPosition"),
	w = config:get("hitErrorWidth"),
	h = config:get("hitErrorHeight"),
	origin = {
		w = 2,
		h = config:get("hitErrorHeight") / 0.8,
		color = { 1, 1, 1, 1 },
	},
	background = {
		color = { 0.1, 0.1, 0.1, config:get("hitErrorBackground") / 100 },
	},
	unit = 0.12,
	radius = config:get("hitErrorRadius"),
	count = config:get("hitErrorCount"),
})

return noteskin
