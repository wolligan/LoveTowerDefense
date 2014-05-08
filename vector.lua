Vector = {}

function Vector.dot(x1,y1, x2,y2)
   return x1*x2 + y1*y2
end

function Vector.length(x,y)
    return math.sqrt(math.pow(x,2) + math.pow(y,2))
end

function Vector.normalize(x,y)
    local length = Vector.length(x,y)

    return x / length, y / length, length
end

function Vector.reflect(vx, vy, nx, ny)
    local dot = Vector.dot(vx, vy, nx, ny)

    local refX = 2 * dot * nx - vx
    local refY = 2 * dot * ny - vy

    return -refX, -refY
end

--- returns whether vector b looks in right direction of vector a or in left direction
-- @return
function Vector.getTurn(x1,y1, x2,y2)
	local det = y1*x2 - x1*y2
	if det < 0 then return "right"
	elseif det > 0 then return "left"
	else return "same_direction"
	end
end
