--- ADD ME
require "Vector"
Intersection = {}

--- Calculates the intersection point of two lines
-- line1 = p1 + r * v1
-- line2 = p2 + s * v2

-- @param p1x x-coordinate of p1
-- @param p1y y-coordinate of p1

-- @param v1x x-coordinate of v1
-- @param v1y y-coordinate of v1

-- @param p2x x-coordinate of p2
-- @param p2y y-coordinate of p2

-- @param v2x x-coordinate of v2
-- @param v2y y-coordinate of v2

-- @return if there is an intersection point: function returns {intersecX, intersecY} otherwise it returns nil
function Intersection.LineLine(p1x, p1y, v1x, v1y, p2x, p2y, v2x, v2y)
    local ps1x = p1x
    local ps1y = p1y

    local pe1x = p1x + v1x
    local pe1y = p1y + v1y

    local ps2x = p2x
    local ps2y = p2y

    local pe2x = p2x + v2x
    local pe2y = p2y + v2y

    local a1 = pe1y - ps1y
    local b1 = ps1x - pe1x
    local c1 = a1*ps1x + b1*ps1y

    local a2 = pe2y - ps2y
    local b2 = ps2x - pe2x
    local c2 = a2*ps2x + b2*ps2y

    local delta = a1*b2 - a2*b1
    if delta ~= 0 then
        local intersecX = (b2*c1 - b1*c2)/delta
        local intersecY = (a1*c2 - a2*c1)/delta

        return {intersecX, intersecY}
    end
end

--- returns intersection point of a line and a line segment
-- line = p1 + r * v1
-- line segment = from p2 to p3

-- @param p1x x-coordinate of p1
-- @param p1y y-coordinate of p1

-- @param v1x x-coordinate of v1
-- @param v1y y-coordinate of v1

-- @param p2x x-coordinate of p2
-- @param p2y y-coordinate of p2

-- @param p3x x-coordinate of p3
-- @param p3y y-coordinate of p3

-- @return if there is an intersection point: function returns {intersecX, intersecY} otherwise it returns nil
function Intersection.LineLineseg(p1x, p1y, v1x, v1y, p2x, p2y, p3x, p3y)
    local v2x = p3x-p2x
    local v2y = p3y-p2y
    local intersection = Intersection.LineLine(p1x,p1y, v1x,v1y, p2x,p2y, v2x,v2y)
    if intersection then
        local linesegLength = Vector.length(v2x, v2y)

        local vecP2IntersecX = intersection[1] - p2x
        local vecP2IntersecY = intersection[2] - p2y

        local vecP2IntersecLength = Vector.length(vecP2IntersecX, vecP2IntersecY)

        if vecP2IntersecLength <= linesegLength and Vector.dot(v2x,v2y, vecP2IntersecX, vecP2IntersecY) > 0 then
           return intersection
        end
    end
end

--- Checks if a point is in a rectangle
-- @param x x-coordinate of point
-- @param y y-coordinate of point
-- @param left left coordinate of rectangle
-- @param right right coordinate of rectangle
-- @param top top coordinate of rectangle
-- @param bottom bottom coordinate of rectangle
function Intersection.checkPointRectangle(x,y,left,right,top,bottom)
    return left <= x and right >= x and top <= y and bottom >= y
end
