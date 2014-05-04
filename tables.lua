function table.length(t)
	local length = 0
	for _,value in pairs(t) do
		if value then length = length + 1 end
	end

	return length
end
