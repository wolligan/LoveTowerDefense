--- Contains some helpful functions to check if and where two primitives collide
require "Utilities.Vector"
Utilities.Intersection = {}

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
function Utilities.Intersection.LineLine(p1x, p1y, v1x, v1y, p2x, p2y, v2x, v2y)
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
    return {0,0}
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
function Utilities.Intersection.LineLineseg(p1x, p1y, v1x, v1y, p2x, p2y, p3x, p3y)
    local v2x = p3x-p2x
    local v2y = p3y-p2y
    local intersection = Utilities.Intersection.LineLine(p1x,p1y, v1x,v1y, p2x,p2y, v2x,v2y)
    if intersection then
        local linesegLength = Utilities.Vector.length(v2x, v2y)

        local vecP2IntersecX = intersection[1] - p2x
        local vecP2IntersecY = intersection[2] - p2y

        local vecP2IntersecLength = Utilities.Vector.length(vecP2IntersecX, vecP2IntersecY)

        if vecP2IntersecLength <= linesegLength and Utilities.Vector.dot(v2x,v2y, vecP2IntersecX, vecP2IntersecY) > 0 then
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
function Utilities.Intersection.checkPointRectangle(x,y,left,right,top,bottom)
    return left <= x and right >= x and top <= y and bottom >= y
end

--- Checks if two rectangles collide
-- @param left1 left coordinate of rectangle1
-- @param right1 right coordinate of rectangle1
-- @param top1 top coordinate of rectangle1
-- @param bottom1 bottom coordinate of rectangle1
-- @param left2 left coordinate of rectangle2
-- @param right2 right coordinate of rectangle2
-- @param top2 top coordinate of rectangle2
-- @param bottom2 bottom coordinate of rectangle2
function Utilities.Intersection.checkRectangleRectangle(left1,right1,top1,bottom1, left2,right2,top2,bottom2)
    return left1 <= right2 and right1 >= left2 and top1 <= bottom2 and bottom1 >= top2
end

--- Checks if a point is in a convex polygon
-- @param x x-coordinate of point
-- @param y y-coordinate of point
-- @param polygon {x1, y1, x2, y2, ..., xn, yn}
function Utilities.Intersection.checkPointPolygon(x,y, polygon)
    for i = 1,#polygon,2 do
        local curIndexX, curIndexY, nextIndexX, nextIndexY
        local curX, curY, nextX, nextY
        local curLineX, curLineY
        local pointFromLineX, pointFromLineY

        curIndexX = i
        curIndexY = i+1
        nextIndexX = (i+2) % #polygon; if nextIndexX == 0 then nextIndexX = #polygon end
        nextIndexY = (i+3) % #polygon; if nextIndexY == 0 then nextIndexY = #polygon end

        curX = polygon[curIndexX]
        curY = polygon[curIndexY]

        nextX = polygon[nextIndexX]
        nextY = polygon[nextIndexY]

        curLineX = nextX - curX
        curLineY = nextY - curY

        pointFromLineX = x - nextX
        pointFromLineY = y - nextY

        if Utilities.Vector.getTurn(curLineX, curLineY, pointFromLineX, pointFromLineY) == "right" then
           return false
        end
    end

    return true
end
