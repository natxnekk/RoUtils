--!strict
local Switch = {}
Switch.__index = Switch

export type SwitchData<T> = {
	variable: T,
	_matched: boolean
}

export type Switch<T> = SwitchData<T> & {
	case: (self: Switch<T>, match: T, func: () -> ()) -> Switch<T>,
	default: (self: Switch<T>, func: () -> ()) -> (),
}

export type SwitchClass = {
	new: <T>(variable: T) -> Switch<T>,
}

function Switch.new<T>(variable: T): Switch<T>
	return setmetatable({
		variable = variable,
		_matched = false,
	}, Switch) :: any
end

function Switch:case<T>(match: T, func: () -> ()): Switch<T>
	--we unfortunatelly have to cast this to any, since roblox doesn't allow to compare generic types :(
	if (self.variable :: any) == (match :: any) then
		self._matched = true
		func()
	end
	
	return self
end

function Switch.default<T>(self: Switch<T>, func: () -> ()): ()
	if not self._matched then
		func()
		self._matched = true --just in case although nothing should happen since we're not returning self
	end
end

return Switch :: SwitchClass