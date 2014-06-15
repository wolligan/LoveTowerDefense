--- Adds some more functions to the predefined lua table named "table"

--- Returns the real length of a table
--@param t table to be checked
function table.length(t)
	local length = 0
	for _,value in pairs(t) do
		if value then length = length + 1 end
	end

	return length
end

--- Checks if a table contains an item
--@param t table to be checked
--@param item item to be checked
function table.contains(t, item)
    for _,value in pairs(t) do
       if value == item then
            return true
        end
    end
    return false
end

--- Checks if a table contains an item
--@param t table to be checked
--@param key item to be checked
function table.containsKey(t, key)
    for i,_ in pairs(t) do
       if key == i then
            return true
        end
    end
    return false
end

--- Checks if a table contains an item
--@param t table to be checked
--@param item item to be checked
function table.containsValue(t, item)
    return table.contains(t,item)
end

--- Returns the index of an item in a table
--@param t table to be checked
--@param item item to be checked
function table.indexOf(t, item)
    for i,v in pairs(t) do
       if item == v then
            return i
        end
    end
end

--- Removes an item from a table
--@param t table to be checked
--@param item item to be checked
function table.removeValue(t, item)
    if table.contains(t,item) then
        for i = 1,#t do
            if t[i] == item then
                table.remove(t,i)
            end
        end
    end
end
