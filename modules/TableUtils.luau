--!strict
local TableUtil = {}
TableUtil.__index = TableUtil

--Converts a dictionary {[Key]: Value} into a list {Value}
function TableUtil.dictionaryToList<V>(t: { [any]: V }): {V}
	assert(t, 'Tried to convert a dictionary into a list, but t is nil')
	local temp = {}
	
	for _, v in t do
		table.insert(temp, v)
	end
	
	--roblox typesolver 😍
	return temp :: {any}
end

--Converts a dictionary {[Key]: Value} into a list containing Key value of the passed dictionary {Key}
function TableUtil.dictionaryKeyToList<K>(t: { [K]: any }): {K}
	assert(t, 'Tried to convert a dictionary into a list of keys, but t is nil')
	local temp: {K} = {}

	for k: K, _ in t do
		table.insert(temp, k)
	end

	--roblox typesolver 😍
	return temp
end

--Deep clones a table, leaving all the variables the same but changing the values to be a new instance instead of a reference to the passed table
function TableUtil.deepCopyTable<T>(original: T & { [any]: any }): T
	assert(original, 'Tried to deep copy a table, but table is nil')
	local clone = {}
	for key, value in original :: any do
		if typeof(value) == "table" then
			clone[key] = TableUtil.deepCopyTable(value :: any)
			continue
		end

		clone[key] = value;
	end

	--roblox typesolver 😍
	return (clone :: any) :: T
end

--Filters an array using the passed in predicate function, loops through a table and for each component, 
--it checks if the item should still be in a table using the predicate function
--TODO/FIXME-LATER value is unknown because the typesolver can't solve bidirectional inference generics as of 21.09.25
function TableUtil.filterArray<T>(input: {T}, predicate: (index: number, value: T) -> boolean): {T} 
	assert(input and predicate, 'Tried to filter an array, but input or predicate function is nil')
	
	local finalTable = {}
	for i, v in input do
		if not predicate(i, v) then
			continue
		end
		
		table.insert(finalTable, v)
	end
	
	return finalTable
end

return TableUtil
