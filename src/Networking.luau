local Networking = {}
Networking.__index = Networking

function Networking.invokeClientSafely(remoteFunction: RemoteFunction, timeout: number, player: Player, ...): any
	local result: any = nil
	local args = ... -- we have to do that because we can't use vararg outside of the vararg function
	
	task.spawn(function()
		result = remoteFunction:InvokeClient(player, args)
	end)
	
	for i = 1, timeout * 10 do
		if result ~= nil then
			break
		end
		
		task.wait(0.1) -- 0.1 since we're multiplying the timeout by 10 for better precision
	end
	
	if result == nil then
		warn(`[Networking] Player {player} did not respond to '{remoteFunction:GetFullName()}' | args: {table.unpack({args})} | in {timeout}s`)
	end
	
	return result
end

return Networking
