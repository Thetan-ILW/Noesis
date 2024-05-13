local NoteSkinVsrg = require("sphere.models.NoteSkinModel.NoteSkinVsrg")
local BasePlayfield = require("sphere.models.NoteSkinModel.BasePlayfield")
local bussy = require("thetan.skin_ui.Bussy")

local JustConfig = require("sphere.JustConfig")
local root = (...):match("(.+)/.-")
local config = JustConfig:fromFile(root .. "/4key.config.lua")

local noteskin = NoteSkinVsrg({
	path = ...,
	name = "Aria 4K",
	inputMode = "4key",
	range = { -1, 1 },
	unit = 480,
	hitposition = config:get("hitposition"),
	config = config,
})

noteskin:setInput({
	"key1",
	"key2",
	"key3",
	"key4",
})

local cs = config:get("columnSize")

noteskin:setColumns({
	offset = 0,
	align = "center",
	width = { cs, cs, cs, cs },
	space = { 0, 0, 0, 0, 0 },
})

noteskin:setTextures({
	{ pixel = "pixel.png" },
	{ empty = "empty.png" },
	{ body = "4k/body.png" },
	{ note = "4k/note.png" },
	{ accent_note = "4k/accent.png" },
})

noteskin:setImagesAuto()

noteskin:setShortNote({
	image = {
		"note",
		"note",
		"accent_note",
		"note",
	},
	h = config:get("noteHeight"),
})

noteskin:setLongNote({
	head = {
		"note",
		"note",
		"note",
		"note",
	},
	body = {
		"body",
		"body",
		"body",
		"body",
	},
	tail = {
		"empty",
		"empty",
		"empty",
		"empty",
	},
	h = config:get("noteHeight"),
})

if config:get("measureLine") then
	noteskin:addMeasureLine({
		h = 2,
		color = { 1, 1, 1, 0.5 },
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

playfield:addBga({
	transform = { { 1 / 2, -16 / 9 / 2 }, { 0, -7 / 9 / 2 }, 0, { 0, 16 / 9 }, { 0, 16 / 9 }, 0, 0, 0, 0 },
})
playfield:enableCamera()

local bigAssGuideline = {
	mode = "symmetric",
	both = false,
	color = { 0, 0, 0, 1 },
	image = {
		"pixel.png",
	},
	w = {
		[1] = cs * 4,
	},
	h = {
		[1] = 1000,
	},
	y = {
		[1] = 0,
	},
}

playfield:addGuidelines(bigAssGuideline)

playfield:addNotes()
playfield:addKeyImages({
	h = 30,
	padding = noteskin.unit - config:get("hitposition"),
	pressed = {
		"keys/key.png",
		"keys/key.png",
		"keys/key.png",
		"keys/key.png",
	},
	released = {
		"keys/key.png",
		"keys/key.png",
		"keys/key.png",
		"keys/key.png",
	},
})

playfield:disableCamera()

playfield:addBaseElements({ "match players", "progress" })

playfield:addCombo({
	x = -540,
	baseline = 700,
	limit = 1080,
	align = "center",
	font = { root .. "/font/static/ChivoMono-Medium.ttf", 80 },
	transform = playfield:newLaneCenterTransform(1080),
	color = { 1, 1, 1, 0.4 },
})

local accuracy = playfield:addAccuracy({
	x = 0,
	baseline = 110,
	limit = 1905,
	format = "%0.02f%%",
	align = "right",
	font = { root .. "/font/static/ChivoMono-Regular.ttf", 56 },
	transform = playfield:newTransform(1920, 1080, "right"),
})

accuracy.key = ("game.rhythmModel.scoreEngine.scoreSystem.judgements.%s.accuracy"):format("osu!legacy OD9")

accuracy.multiplier = 100

local score = playfield:addScore({
	x = 0,
	baseline = 52,
	limit = 1906,
	align = "right",
	format = "%iK",
	font = { root .. "/font/static/ChivoMono-Regular.ttf", 56 },
	transform = playfield:newTransform(1920, 1080, "right"),
})

function score:value()
	local s = self.game.rhythmModel.scoreEngine.scoreSystem.judgements["osu!legacy OD9"].score
	return s / 1000
end

bussy:addHitError({
	x = 0,
	y = 50 * 1080 / 100,
	w = cs * 4,
	h = 40,
	origin = {
		w = 1,
		h = 40 * 2,
		color = { 1, 1, 1, 1 },
	},
	unit = 0.12,
	radius = 4,
	count = 3,
}, playfield)

local judges = {
	{ "miss", "judgements/miss.png" },
	{ "meh", "judgements/bad.png" },
	{ "ok", "judgements/good.png" },
	{ "good", "judgements/great.png" },
	{ "great", "judgements/perfect.png" },
	{ "perfect", "judgements/marvelous.png" },
}

bussy:addOsuJudgement({
	x = 8,
	y = 203,
	ox = 0.5,
	oy = 0.5,
	maxSize = 1.05,
	size = 1,
	minSize = 0.75,
	scale = 0.4,
	transform = playfield:newLaneCenterTransform(480),
	judge = "osu!legacy OD9",
	rate = 1,
	judgements = judges,
}, playfield)

bussy:addHitInfo({
	x = cs * 4 + 100,
	y = 500,
	transform = playfield:newLaneCenterTransform(1080),
	font = { root .. "/font/static/ChivoMono-Regular.ttf", 24 },
	fontColor = { 1, 1, 1, 1 },
}, playfield)

bussy:addKeyboard({
	lineWidth = 4,
	keySize = 35,
	y = 840,
	font = { root .. "/font/static/ChivoMono-Bold.ttf", 10 },
}, playfield)

return noteskin
