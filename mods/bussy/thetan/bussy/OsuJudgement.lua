local class = require("class")
local flux = require("flux")

---@class sphere.JudgementView
---@operator call: sphere.JudgementView
local JudgementView = class()

local judgeAlias = {
	etterna = {
		["1"] = "marvelous",
		["2"] = "perfect",
		["3"] = "great",
		["4"] = "bad",
		["5"] = "boo",
		miss = "miss",
	},
	osuMania = {
		["1"] = "perfect",
		["2"] = "great",
		["3"] = "good",
		["4"] = "ok",
		["5"] = "meh",
		miss = "miss",
	},
	osuLegacy = {
		["1"] = "perfect",
		["2"] = "great",
		["3"] = "good",
		["4"] = "ok",
		["5"] = "meh",
		miss = "miss",
	},
	quaver = {
		["1"] = "marvelous",
		["2"] = "perfect",
		["3"] = "great",
		["4"] = "good",
		["5"] = "okay",
		miss = "miss",
	},
	soundsphere = {
		["1"] = "perfect",
		["2"] = "not perfect",
		miss = "miss",
	},
	lr2 = {
		["1"] = "pgreat",
		["2"] = "great",
		["3"] = "good",
		["4"] = "bad",
		miss = "miss",
	},
}

function JudgementView:load()
	self.lastUpdateTime = -1
	self.judgement = nil

	self.imageJudgement = nil
	self.animationState = "idle"
	self.tween = nil
	self.size = self.normalSize
	self.alpha = 1

	local judgeName = self.game.configModel.configs.select.judgements
	local judgements = self.game.rhythmModel.scoreEngine.scoreSystem.judgements

	self.judge = judgements[judgeName]
end

function JudgementView:animation()
	local current_time = love.timer.getTime()
	local st = self.animationState

	if st == "idle" then
		self.animationState = "start"
		self.tween = flux.to(self, 0.058, { size = self.maxSize }):ease("expoout")
	elseif st == "start" and current_time >= self.lastUpdateTime + 0.058 then
		self.animationState = "back_to_normal"
		self.tween:stop()
		self.tween = flux.to(self, 0.092, { size = self.normalSize }):ease("quartout")
	elseif st == "back_to_normal" and current_time >= self.lastUpdateTime + 0.233 then
		self.animationState = "smol"
		self.tween:stop()
		self.tween = flux.to(self, 0.400, { size = self.minSize }):ease("quartout")
	end

	local image = self.imageJudgement

	if not image then
		return
	end

	image.sx = self.scale * self.size
	image.sy = self.scale * self.size
	image.color = { 1, 1, 1, self.alpha }
end

function JudgementView:stopAnimation()
	if self.tween then
		self.tween:stop()
		self.tween = nil
	end

	self.animationState = "idle"
	self.size = self.normalSize
	self.alpha = 1
end

---@param dt number
function JudgementView:update(dt)
	local judgement = self.judge.lastCounter
	local updateTime = self.judge.lastUpdateTime

	if self.judgement then
		self:animation()
	end

	if updateTime == self.lastUpdateTime then
		return
	end

	self:stopAnimation()

	self.lastUpdateTime = updateTime
	self.judgement = judgement

	if not self.judgement then
		return
	end

	for name, view in pairs(self.judgements) do
		name = judgeAlias[self.judge.scoreSystemName][name]

		if name == judgement then
			view:setTime(0)
			self.imageJudgement = view
		else
			view:setTime(math.huge)
		end
	end
end

return JudgementView