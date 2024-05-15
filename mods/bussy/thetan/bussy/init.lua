local class = require("class")

local ImageAnimationView = require("sphere.views.ImageAnimationView")
local OsuJudgement = require("thetan.bussy.OsuJudgement")
local HitErrorView = require("thetan.bussy.HitError")
local HitInfoView = require("thetan.bussy.HitInfo")
local KeyboardView = require("thetan.bussy.KeyboardView")

local Bussy = class()

function Bussy:new(playfield)
	self.playfield = playfield
end

---@param object table
---@return table
function Bussy:addOsuJudgement(object)
	if not object.transform then
		object.transform = self.playfield:newLaneCenterTransform(1080)
	end

	local judgements = {}
	for _, judgement in ipairs(object.judgements) do
		local config = ImageAnimationView({
			x = object.x,
			y = object.y,
			w = object.w,
			h = object.h,
			sx = object.sx or object.scale,
			sy = object.sy or object.scale,
			ox = object.ox,
			oy = object.oy,
			transform = object.transform,
			image = judgement[2],
			range = judgement[3],
			quad = judgement[4],
			rate = judgement.rate or object.rate,
			cycles = judgement.cycles or object.cycles,
		})
		judgements[judgement[1]] = config
		self.playfield:add(config)
	end

	return self.playfield:add(OsuJudgement({
		judgements = judgements,
		subscreen = "gameplay",
		maxSize = object.maxSize or 1.05,
		minSize = object.minSize or 0.75,
		normalSize = object.normalSize or 1,
		scale = object.scale,
	}))
end

---@param object table?
---@return table?
function Bussy:addHitError(object)
	if not object then
		return
	end

	object.subscreen = "gameplay"
	object.transform = object.transform or self.playfield:newLaneCenterTransform(1080)
	object.count = object.count or 1
	object.key = "game.rhythmModel.scoreEngine.scoreSystem.sequence"
	object.value = "misc.deltaTime"
	object.unit = object.unit or 0.16

	return self.playfield:add(HitErrorView(object))
end

function Bussy:addHitInfo(object)
	object.subscreen = "gameplay"
	object.transform = object.transform or self.playfield:newTransform(1920, 1080, "left")
	return self.playfield:add(HitInfoView(object))
end

function Bussy:addKeyboard(object)
	object.subscreen = "gameplay"
	object.transform = object.transform or self.playfield:newTransform(1920, 1080, "left")
	return self.playfield:add(KeyboardView(object))
end

local audioExt = { ".wav", ".ogg", ".mp3" }
local imageExt = { ".png", ".jpg", ".jpeg", ".bmp", ".tga" }

local characters = {
	"0",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"comma",
	"dot",
	"percent",
	"x",
}

local char_alias = {
	comma = ",",
	dot = ".",
	percent = "%",
}

local function findImage(path)
	for _, format in ipairs(imageExt) do
		local normal = path .. format
		local double = path .. "@2x" .. format

		if love.filesystem.getInfo(double) then
			return double
		end

		if love.filesystem.getInfo(normal) then
			return normal
		end

		if love.filesystem.getInfo(double:lower()) then
			return double:lower()
		end

		if love.filesystem.getInfo(normal:lower()) then
			return normal:lower()
		end
	end

	return nil
end

local function findAudio(path)
	for _, format in ipairs(audioExt) do
		local audio_path = path .. format

		if love.filesystem.getInfo(audio_path) then
			return audio_path
		end
	end
end

function Bussy:getImageFont(group)
	local font = {}

	for _, v in ipairs(characters) do
		local file = findImage(("%s-%s"):format(group, v))

		if file then
			local key = char_alias[v] and char_alias[v] or v
			font[key] = file
		end
	end

	return font
end

function Bussy:getJudge(game)
	local judgeName = game.configModel.configs.select.judgements
	local judgements = game.rhythmModel.scoreEngine.scoreSystem.judgements

	return judgements[judgeName]
end

function Bussy:getOsuOD9(game)
	local judgements = game.rhythmModel.scoreEngine.scoreSystem.judgements
	return judgements["osu!legacy OD9"]
end

return Bussy
