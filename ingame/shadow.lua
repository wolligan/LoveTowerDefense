require "OO"

Ingame.Shadow = {}
OO.createClass(Ingame.Shadow)

function Ingame.Shadow:new(lightSource, )
function Ingame.Reflection:new(lightSource, rightX, rightY, leftX, leftY)
    self.vertices  = {}
    self:calculateVertices(lightSource, rightX, rightY, leftX, leftY)

    self.position = {}

    self:calculateOrigin()
end

function Ingame.Shadow:render()
    love.graphics.polygon("fill", unpack(self.vertices))
end

function Ingame.Shadow.calculateOrigin()
    self.position = Intersection.LineLine(  self.vertices[1], self.vertices[2],
                                            self.reflectionVecLeftX, self.reflectionVecLeftY,

                                            self.vertices[3], self.vertices[4],
                                            self.reflectionVecRightX, self.reflectionVecRightY)
end

--- calculates the reflection polygon
-- @param lightSource LightSource object that shall be reflected
-- @param rightX x-coordinate of right point that shall be reflected
-- @param rightY y-coordinate of right point that shall be reflected
-- @param leftX x-coordinate of left point that shall be reflected
-- @param leftY y-coordinate of left point that shall be reflected
function Ingame.Shadow:calculateVertices(lightSource, rightX, rightY, leftX, leftY)
-- calculate direction vectors
    local lightVecToRightX, lightVecToRightY = Vector.subAndNormalize(rightX, rightY, lightSource.position[1],lightSource.position[2])
    local lightVecToLeftX, lightVecToLeftY = Vector.subAndNormalize(leftX, leftY, lightSource.position[1],lightSource.position[2])

-- set vertices
    self.vertices[1] = leftX
    self.vertices[2] = leftY

    self.vertices[3] = rightX
    self.vertices[4] = rightY

    self.vertices[5] = rightX + lightVecToRightX * Ingame.Reflection.reflectionLength
    self.vertices[6] = rightY + lightVecToRightY * Ingame.Reflection.reflectionLength

    self.vertices[7] = leftX + lightVecToLeftX * Ingame.Reflection.reflectionLength
    self.vertices[8] = leftY + lightVecToLeftY * Ingame.Reflection.reflectionLength
end
