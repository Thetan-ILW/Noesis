---@param file string
---@return boolean
---@return string?
local function exists(file)
	local ok, err, code = os.rename(file, file)
	if not ok then
		if code == 13 then
			-- Permission denied, but it exists
			return true
		end
	end
	return ok, err
end

---@param path string
---@return boolean
---@return string?
local function dirExists(path)
	return exists(path .. "/")
end

if not dirExists("build/soundsphere") then
	print("Error: download soundsphere and unpack it into `build/soundsphere`")
	return
end

if dirExists("build/noesis_client") then
	os.execute("rm -r build/noesis_client")
end

if dirExists("build/temp") then
	os.execute("rm -r build/temp")
end

os.execute("mkdir build/noesis_client/")

os.execute("cp -r build/soundsphere/bin build/noesis_client/bin")
os.execute("cp -r build/soundsphere/userdata build/noesis_client/userdata")
os.execute("cp build/soundsphere/conf.lua build/noesis_client/")
os.execute("cp build/soundsphere/game-linux build/noesis_client/")
os.execute("cp build/soundsphere/game-win64.bat build/noesis_client/")

os.execute("cp -r skins/. build/noesis_client/userdata/skins")
os.execute("cp -r backgrounds build/noesis_client/userdata/backgrounds/")
os.execute("cp icons/game_icon.png build/noesis_client/userdata/")

os.execute("mkdir build/temp/")
os.execute("unzip build/soundsphere/game.love -d build/temp/")
os.execute("cp main.lua build/temp/")
os.execute("cp glue.lua build/temp/")
os.execute("cp -r build/soundsphere/resources/ build/temp/resources")

os.execute("cp mods/ModulePatcher/ModulePatcher.lua build/temp/")
os.execute("cp -r mods/Irizz-Theme/* build/temp/")
os.execute("cp -r mods/bussy/* build/temp/")
os.execute("cp -rf mods/Discord/* build/temp/")
os.execute("cp -rf mods/DefaultSettings/* build/temp/")
os.execute("cp -rf mods/MinaCalc-soundsphere/libchart/* build/temp/libchart/")
os.execute("cp -rf mods/MinaCalc-soundsphere/sphere/* build/temp/sphere")
os.execute("cp -r mods/MinaCalc-soundsphere/bin/linux64/* build/noesis_client/bin/linux64/")
os.execute("cp -r mods/MinaCalc-soundsphere/bin/win64/* build/noesis_client/bin/win64/")
os.execute("cd build/temp && zip -r ../noesis_client/game.love .")
