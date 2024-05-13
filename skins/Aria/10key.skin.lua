local NoteSkinVsrg = require("sphere.models.NoteSkinModel.NoteSkinVsrg")
local BasePlayfield = require("sphere.models.NoteSkinModel.BasePlayfield")

local JustConfig = require("sphere.JustConfig")
local root = (...):match("(.+)/.-")
local config = JustConfig:fromFile(root .. "/7key.config.lua")

local noteskin = NoteSkinVsrg({
	path = ...,
	name = "Aria 10K",
	inputMode = "10key",
	range = {-1, 1},
	unit = 480,
	hitposition = config:get("hitposition"),
	config = config
})

noteskin:setInput({
	"key1",
	"key2",
	"key3",
	"key4",
	"key5",
	"key6",
	"key7",
	"key8",
	"key9",
	"key10",
})


local cs = config:get("columnSize")

noteskin:setColumns({
	offset = 0,
	align = "center",
	width = {cs, cs, cs, cs, cs, cs, cs, cs, cs, cs},
	space = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
})

noteskin:setTextures({
	{pixel = "pixel.png"},
	{body = "body.png"},
	{whiteBar = "notes/white_bar.png"},
    {pinkBar = "notes/pink_bar.png"},
    {aquaBar = "notes/aqua_bar.png"},
    {whiteBody = "notes/white_body.png"},
    {pinkBody = "notes/pink_body.png"},
	{aquaBody = "notes/aqua_body.png"},
	{yellowBar = "notes/yellow_bar.png"},
	{yellowBody = "notes/yellow_body.png"}
})

noteskin:setImagesAuto()

noteskin:setShortNote({
	image = {
		"pinkBar",
		"whiteBar",
		"aquaBar",
		"whiteBar",
		"yellowBar",
		"yellowBar",
		"whiteBar",
		"aquaBar",
		"whiteBar",
		"pinkBar",
	},
	h = 75,
})

noteskin:setLongNote({
	head = {
		"pinkBody",
		"whiteBody",
		"aquaBody",
		"whiteBody",
		"yellowBar",
		"yellowBar",
		"whiteBody",
		"aquaBody",
		"whiteBody",
		"pinkBody",
	},
	body = {
		"pinkBody",
		"whiteBody",
		"aquaBody",
		"whiteBody",
		"yellowBody",
		"yellowBody",
		"whiteBody",
		"aquaBody",
		"whiteBody",
		"pinkBody",
	},
	tail = {
		"pixel",
		"pixel",
		"pixel",
		"pixel",
		"pixel",
		"pixel",
		"pixel",
		"pixel",
		"pixel",
		"pixel",
	},
	h = 1
})

noteskin:setShortNote({
	image = "note",
	h = 24,
	color = {1, 0.25, 0.25, 1},
}, "SoundNote")

noteskin:addMeasureLine({
	h = 2,
	color = {1, 1, 1, 0.5},
	image = "pixel"
})

noteskin:addBga({
	x = 0,
	y = 0,
	w = 1,
	h = 1,
	color = {0.25, 0.25, 0.25, 1}
})

local playfield = BasePlayfield(noteskin)

playfield:addBga({
	transform = {{1 / 2, -16 / 9 / 2}, {0, -7 / 9 / 2}, 0, {0, 16 / 9}, {0, 16 / 9}, 0, 0, 0, 0}
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
		[1] = cs *10, 
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
	h = 24,
	padding = 30,
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

local guidelineTable = {
    mode = "symmetric",
    both = false,
    color = {1, 1, 1, 1}, -- White color (RGBA)
    image = {
        "pixel.png", -- Image for the guideline
    },
    w = {
	[1] = 1,
        [6] = 1, -- Width of the guideline
	[11] = 1,
    },
    h = {
	[1] = 1000,
        [6] = 1000, -- Height of the guideline
	[11] = 1000
    },
    y = {
	[1] = 0,
        [6] = 0, -- Y position of the guideline
	[11] = 0,
    },
}

playfield:addGuidelines(guidelineTable)

playfield:disableCamera()

playfield:addBaseElements({  "match players", "progress" })

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
		transform = playfield:newTransform(1920, 1080, "right")
})

playfield:addScore({
		x = 0,
		baseline = 52,
		limit = 1906,
		align = "right",
	font = { root .. "/Kodchasan-Bold.ttf", 56 },
		transform = playfield:newTransform(1920, 1080, "right")
})


local function HSVToRGB(hue)
	local hue_sector = math.floor(hue / 60);
	local hue_sector_offset = (hue / 60) - hue_sector;
	local q = 1 - 1 * hue_sector_offset;
	local t = 1 - 1 * (1 - hue_sector_offset);
	if hue_sector == 0 then
		return { red = 1, green = t, blue = 0 };
	elseif hue_sector == 1 then
		return { red = q, green = 1, blue = 0 };
	elseif hue_sector == 2 then
		return { red = 0, green = 1, blue = t };
	elseif hue_sector == 3 then
		return { red = 0, green = q, blue = 1 };
	elseif hue_sector == 4 then
		return { red = t, green = 0, blue = 1 };
	elseif hue_sector == 5 then
		return { red = 1, green = 0, blue = q };
	end;
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
		color = { 1, 1, 1, 1 }
	},
	background = {
		color = { 0, 0, 0, 0 }
	},
	unit = 0.12,
	color = hitcolor,
	radius = 2,
	count = 20,
})

return noteskin
