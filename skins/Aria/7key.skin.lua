local NoteSkinVsrg = require("sphere.models.NoteSkinModel.NoteSkinVsrg")
local BasePlayfield = require("sphere.models.NoteSkinModel.BasePlayfield")

local JustConfig = require("sphere.JustConfig")
local root = (...):match("(.+)/.-")
local config = JustConfig:fromFile(root .. "/7key.config.lua")

local JudgeCountView = require(root .. "/JudgeCountView")

local noteskin = NoteSkinVsrg({
	path = ...,
	name = "Aria 7K",
	inputMode = "7key",
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
	"key5",
	"key6",
	"key7",
})

local cs = config:get("columnSize")

noteskin:setColumns({
	offset = 0,
	align = "center",
	width = { cs, cs, cs, cs, cs, cs, cs },
	space = { 0, 0, 0, 0, 0, 0, 0, 0 },
})

noteskin:setTextures({
	{ pixel = "pixel.png" },
	{ body = "body.png" },
	{ whiteBar = "notes/white_bar.png" },
	{ pinkBar = "notes/white_bar.png" },
	{ aquaBar = "notes/white_bar.png" },
	{ whiteBody = "notes/white_body.png" },
	{ pinkBody = "notes/white_body.png" },
	{ aquaBody = "notes/white_body.png" },
	{ yellowBar = "notes/white_bar.png" },
	{ yellowBody = "notes/white_body.png" },
})

noteskin:setImagesAuto()

local function rainbow(x)
	local r = math.abs(math.sin(x * 2 * math.pi))
	local g = math.abs(math.sin((x + 1 / 3) * 2 * math.pi))
	local b = math.abs(math.sin((x + 2 / 3) * 2 * math.pi))
	local a = 1
	return { r, g, b, a }
end

local function beatTime(noteTime, timePointTime, beatDuration)
	local delta = (noteTime - timePointTime) % beatDuration
	local t = delta / (beatDuration * 2)

	return t - 0.0625
end

local colors = noteskin.colors

function noteskin.color(timeState, noteView, column)
	local logicalState = noteView.graphicalNote:getLogicalState()
	local startTimeState = timeState.startTimeState or timeState

	local tempoData = noteView.graphicalNote.startNoteData.timePoint.tempoData
	local timePointTime = tempoData.timePoint.absoluteTime

	local noteTime = timeState.absoluteTime
	local beatDuration = tempoData:getBeatDuration()

	local miss = logicalState == "missed"

	if logicalState == "clear" or logicalState == "skipped" then
		return rainbow(beatTime(noteTime, timePointTime, beatDuration))
	elseif miss then
		return colors.transparent
	elseif logicalState == "passed" then
		return colors.passed
	elseif logicalState == "startPassedPressed" then
		return rainbow(beatTime(timeState.currentTime, timePointTime, beatDuration))
	end

	local endTimeState = timeState.endTimeState or timeState
	local sdt = timeState.scaledFakeVisualDeltaTime or timeState.scaledVisualDeltaTime

	if startTimeState.fakeCurrentVisualTime >= endTimeState.fakeCurrentVisualTime then
		return colors.transparent
	elseif logicalState == "clear" then
		return rainbow(timeState.currentTime)
	elseif colors[logicalState] then
		return colors[logicalState]
	end

	return colors.clear
end

noteskin:setShortNote({
	image = {
		"whiteBar",
		"aquaBar",
		"whiteBar",
		"yellowBar",
		"whiteBar",
		"aquaBar",
		"whiteBar",
	},
	h = config:get("noteHeight"),
})

noteskin:setLongNote({
	head = {
		"whiteBody",
		"aquaBody",
		"whiteBody",
		"yellowBody",
		"whiteBody",
		"aquaBody",
		"whiteBody",
	},
	body = {
		"whiteBody",
		"aquaBody",
		"whiteBody",
		"yellowBody",
		"whiteBody",
		"aquaBody",
		"whiteBody",
	},
	tail = {
		"pixel",
		"pixel",
		"pixel",
		"pixel",
		"pixel",
		"pixel",
		"pixel",
	},
	h = 1,
})

noteskin:setShortNote({
	image = "note",
	h = 24,
	color = { 1, 0.25, 0.25, 1 },
}, "SoundNote")

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
	color = { 0, 0, 0, 1 }, -- White color (RGBA)
	image = {
		"pixel.png", -- Image for the guideline
	},
	w = {
		[1] = cs * 7,
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
		"keys/key.png",
		"keys/key.png",
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
		"keys/key.png",
		"keys/key.png",
		"keys/key.png",
		"keys/key.png",
		"keys/key.png",
		"keys/key.png",
	},
})

playfield:disableCamera()

local guidelineTable = {
	mode = "symmetric",
	both = false,
	color = { 1, 1, 1, 1 }, -- White color (RGBA)
	image = {
		"pixel.png", -- Image for the guideline
	},
	w = {
		[1] = 1,
		[8] = 1, -- Width of the guideline
	},
	h = {
		[1] = 1000,
		[8] = 1000, -- Height of the guideline
	},
	y = {
		[1] = 0,
		[8] = 0, -- Y position of the guideline
	},
}

playfield:addGuidelines(guidelineTable)

playfield:addBaseElements({ "match players", "progress" })

playfield:addCombo({
	x = -540,
	baseline = 476,
	limit = 1080,
	align = "center",
	font = { root .. "/Kodchasan-Bold.ttf", 120 },
	transform = playfield:newLaneCenterTransform(1080),
	color = { 1, 1, 1, 0.4 },
})

playfield:addAccuracy({
	x = 0,
	baseline = 110,
	limit = 1905,
	align = "right",
	font = { root .. "/Kodchasan-Bold.ttf", 56 },
	transform = playfield:newTransform(1920, 1080, "right"),
})

playfield:addScore({
	x = 0,
	baseline = 52,
	limit = 1906,
	align = "right",
	font = { root .. "/Kodchasan-Bold.ttf", 56 },
	transform = playfield:newTransform(1920, 1080, "right"),
})

local function HSVToRGB(hue)
	local hue_sector = math.floor(hue / 60)
	local hue_sector_offset = (hue / 60) - hue_sector
	local q = 1 - 1 * hue_sector_offset
	local t = 1 - 1 * (1 - hue_sector_offset)
	if hue_sector == 0 then
		return { red = 1, green = t, blue = 0 }
	elseif hue_sector == 1 then
		return { red = q, green = 1, blue = 0 }
	elseif hue_sector == 2 then
		return { red = 0, green = 1, blue = t }
	elseif hue_sector == 3 then
		return { red = 0, green = q, blue = 1 }
	elseif hue_sector == 4 then
		return { red = t, green = 0, blue = 1 }
	elseif hue_sector == 5 then
		return { red = 1, green = 0, blue = q }
	end
end

local function VALtoRGB(val)
	local avalue = math.abs(val)
	if avalue > 0.08 then
		return { 1, 0, 0, 1 }
	end
	local hue = (0.08 - avalue) * 2250
	local clr = HSVToRGB(hue)
	return { clr.red, clr.green, clr.blue, 1 }
end

local function hitcolor(value, unit)
	return VALtoRGB(value)
end

playfield:addHitError({
	x = 0,
	y = 50 * 1080 / 100,
	w = cs * 4,
	h = 40,
	origin = {
		w = 1,
		h = 40 * 2,
		color = { 1, 1, 1, 1 },
	},
	background = {
		color = { 0, 0, 0, 0 },
	},
	unit = 0.12,
	color = hitcolor,
	radius = 2,
	count = 20,
})

local TempoSyncedImage = require("thetan.skinUi.TempoSyncedImage")

local ts = { { 1 / 2, -16 / 9 / 2 }, { 0, -7 / 9 / 2 }, 0, { 0, 16 / 9 }, { 0, 16 / 9 }, 0, 0, 0, 0 }

local flandre = TempoSyncedImage({
	x = 0, -- Coordinates from 0 to 1
	y = 0.25,
	w = 0.15,
	h = 0.15,
	transform = ts,
	image = "flandre.png",
	imageTransform = { 0, 0, 498, 498 }, -- x, y, width of frame, height of frame
	frames = 12, -- How many frames is in your image
	speed = 6, -- How many frames will be shown in one beat? 1 SPEED = 1 BEAT. Flandre claps two times in the animation, so I set this value to 6.
})
playfield:add(flandre)

local cat = TempoSyncedImage({
	x = 0,
	y = 0.25 + 0.15,
	w = 0.15,
	h = 0.15,
	transform = ts,
	image = "cat.png",
	imageTransform = { 0, 0, 432, 432 },
	frames = 8,
	speed = 8,
})
playfield:add(cat)

local paimon = TempoSyncedImage({
	x = 0,
	y = 0.25 + 0.3,
	w = 0.15,
	h = 0.15,
	transform = ts,
	image = "paimon.png",
	imageTransform = { 0, 0, 343, 343 },
	frames = 16,
	speed = 8,
})

playfield:add(paimon)

playfield:add(JudgeCountView({
	x = cs * 7 + 100,
	y = 800,
	transform = playfield:newLaneCenterTransform(1080),
	font = { root .. "/Kodchasan-Bold.ttf", 24 },
	judgeName = "osu!legacy OD9",
}))

noteskin.pauseScreen = {
	type = "osu",
	overlay = root .. "/pause/pause-overlay@2x.png",
	overlayFail = root .. "/pause/pause-overlay@2x.png",
	continue = root .. "/pause/pause-continue@2x.png",
	retry = root .. "/pause/pause-retry@2x.png",
	back = root .. "/pause/pause-back@2x.png",
	loop = root .. "/pause/pause-loop.ogg",
	continueClick = root .. "/pause/pause-continue-click.ogg",
	backClick = root .. "/pause/pause-back-click.ogg",
	retryClick = root .. "/pause/pause-retry-click.ogg",
}

return noteskin
