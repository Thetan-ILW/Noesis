local class = require("class")

local PlayInfoView = class()

local x = 0
local y = 0
local w = 0

local difficulty = 0
local difficulty_name = ""
local mods = ""

function PlayInfoView:load() end
function PlayInfoView:update(dt) end
function PlayInfoView:draw() end

return PlayInfoView
