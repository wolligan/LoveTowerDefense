--- Vector implements several functions for 2D Vector operations
Vector = {}

--- Dot Product
-- @param x1 x-component of vector1
-- @param y1 y-component of vector1
-- @param x2 x-component of vector2
-- @param y2 y-component of vector2
function Vector.dot(x1,y1, x2,y2)
   return x1*x2 + y1*y2
end

--- Calculates length of vector
-- @param x x-component of vector
-- @param y y-component of vector
function Vector.length(x,y)
    return math.sqrt(math.pow(x,2) + math.pow(y,2))
end


--- Dot Product
-- @param x x-component of vector
-- @param y y-component of vector
function Vector.normalize(x,y)
    local length = Vector.length(x,y)

    return x / length, y / length, length
end

--- Reflects a Vector on a normal
-- @param vx x-component of vector to be reflected
-- @param vy y-component of vector to be reflected
-- @param nx x-component of normal where vector will be reflected
-- @param ny y-component of normal where vector will be reflected
function Vector.reflect(vx, vy, nx, ny)
    local dot = Vector.dot(vx, vy, nx, ny)

    local refX = 2 * dot * nx - vx
    local refY = 2 * dot * ny - vy

    return -refX, -refY
end

--- Calculates direction of vector2 dependant of vector1
-- @param x1 x-component of vector1
-- @param y1 y-component of vector1
-- @param x2 x-component of vector2
-- @param y2 y-component of vector2
-- @return direction of vector2 dependant of vector1
function Vector.getTurn(x1,y1, x2,y2)
	local det = y1*x2 - x1*y2
	if det < 0 then return "right"
	elseif det > 0 then return "left"
	else return "same_direction"
	end
end

--- Componentwise Addition
-- @param x1 x-component of vector1
-- @param y1 y-component of vector1
-- @param x2 x-component of vector2
-- @param y2 y-component of vector2
function Vector.add(x1,y1, x2,y2)
    local x = x1+x2
    local y = y1+y2
    return x,y
end

--- Componentwise Addition with normalization of Sum
-- @param x1 x-component of vector1
-- @param y1 y-component of vector1
-- @param x2 x-component of vector2
-- @param y2 y-component of vector2
function Vector.addAndNormalize(x1,y1, x2,y2)
    local x = x1+x2
    local y = y1+y2
    local x,y,len = Vector.normalize(x,y)
    return x,y,len
end

--- Componentwise Subtraction
-- @param x1 x-component of vector1
-- @param y1 y-component of vector1
-- @param x2 x-component of vector2
-- @param y2 y-component of vector2
function Vector.sub(x1,y1, x2,y2)
    local x = x1-x2
    local y = y1-y2
    return x,y
end

--- Componentwise Addition with normalization of difference
-- @param x1 x-component of vector1
-- @param y1 y-component of vector1
-- @param x2 x-component of vector2
-- @param y2 y-component of vector2
function Vector.subAndNormalize(x1,y1, x2,y2)
    local x = x1-x2
    local y = y1-y2
    local x,y,len = Vector.normalize(x,y)
    return x,y,len
end

--- Componentwise Multiplication
-- @param x1 x-component of vector1
-- @param y1 y-component of vector1
-- @param x2 x-component of vector2
-- @param y2 y-component of vector2
function Vector.mul(x1,y1, x2,y2)
    local x = x1*x2
    local y = y1*y2
    return x,y
end

--- Componentwise Division
-- @param x1 x-component of vector1
-- @param y1 y-component of vector1
-- @param x2 x-component of vector2
-- @param y2 y-component of vector2
function Vector.div(x1,y1, x2,y2)
    local x = x1/x2
    local y = y1/y2
    return x,y
end
