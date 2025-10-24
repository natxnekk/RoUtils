--!strict
local Loader = {}
Loader.__index = Loader

type Loadable = {
	load: () -> ()
}

local function isFunctionInTable(t: {[any]: any}, f: string): boolean
	return t[f] ~= nil and typeof(t[f]) == 'function'
end

function Loader.load(base: BaseScript, log: boolean?)
	assert(base, '[Loader] Load error, no base script specified')
	
	log = log == nil and true or log --default log variable to true
	
	local loaderStartTime = os.clock()
	for _, moduleScriptInstance in base:GetChildren() do
		if not moduleScriptInstance:IsA('ModuleScript') or string.sub(moduleScriptInstance.Name, 1, 1) == '!' then --don't load any scripts containing "!" at the start
			continue
		end
		
		local moduleLoadStartTime = os.clock()
		local module = require(moduleScriptInstance) :: Loadable --just for the autocomplete
		
		--						roblox typesolver :(
		if not isFunctionInTable(module :: any, 'load') then
			warn(`[Loader] Module [{moduleScriptInstance:GetFullName()}] doesn't have a load function, skipping`)
			continue
		end
		
		module.load()
		
		if log then
			local timeTaken = os.clock() - moduleLoadStartTime
			print(`[Loader] [{base.Name}] Loaded [{moduleScriptInstance.Name}] in {timeTaken}ms`)
		end
	end

	if log then
		print(`[Loader] [{base.Name}] Was loaded in {os.clock() - loaderStartTime}ms`)
	end
end

return Loader