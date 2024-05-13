local ImageAnimationView = require("sphere.views.ImageAnimationView")
local OsuJudgement = require("thetan.skin_ui.OsuJudgement")
local HitErrorView = require("thetan.skin_ui.HitError")
local HitInfoView = require("thetan.skin_ui.HitInfo")
local KeyboardView = require("thetan.skin_ui.KeyboardView")

local Bussy = {}

---@param object table
---@return table
function Bussy:addOsuJudgement(object, playfield)
	if not object.transform then
		object.transform = playfield:newLaneCenterTransform(1080)
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
		playfield:add(config)
	end

	return playfield:add(OsuJudgement({
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
function Bussy:addHitError(object, playfield)
	if not object then
		return
	end

	object.subscreen = "gameplay"
	object.transform = object.transform or playfield:newLaneCenterTransform(1080)
	object.count = object.count or 1
	object.key = "game.rhythmModel.scoreEngine.scoreSystem.sequence"
	object.value = "misc.deltaTime"
	object.unit = object.unit or 0.16

	return playfield:add(HitErrorView(object))
end

function Bussy:addHitInfo(object, playfield)
	object.transform = object.transform or playfield:newTransform(1920, 1080, "left")
	return playfield:add(HitInfoView(object))
end

function Bussy:addKeyboard(object, playfield)
	object.transform = object.transform or playfield:newTransform(1920, 1080, "left")
	return playfield:add(KeyboardView(object))
end

return Bussy
