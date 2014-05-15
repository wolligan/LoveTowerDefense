--- Adds some more functions to the predefined lua table named "table"

---
function table.length(t)
	local length = 0
	for _,value in pairs(t) do
		if value then length = length + 1 end
	end

	return length
end

---
function table.contains(t, item)
    for _,value in pairs(t) do
       if value == item then
            return true
        end
    end
    return false
end
