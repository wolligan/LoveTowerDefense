---
--@classmod Reflection
--@author Steve Wolligandt

Lighting.Reflection = {}
Utilities.OO.createClass(Lighting.Reflection)

Lighting.Reflection.maxBounces = 3
Lighting.Reflection.reflectionLength = math.sqrt(math.pow(love.graphics.getWidth(), 2) + math.pow(love.graphics.getHeight(), 2))*20

--- Constructor
--@param lightSource lightsource that casts this reflection
--@param rightX x-coordinte of the right point of the reflection
--@param rightY y-coordinte of the right point of the reflection
--@param leftX x-coordinte of the left point of the reflection
--@param leftY y-coordinte of the left point of the reflection
--@param r red color value
--@param g green color value
--@param b blue color value
--@param bouncedTimes number of bounces of this reflection
function Lighting.Reflection:new(lightSource, rightX, rightY, leftX, leftY, r,g,b, bouncedTimes)
    self.vertices  = {}
    self:calculateVertices(lightSource, rightX, rightY, leftX, leftY)

    self.position = {}

    self.shadows = {}
    self.reflections = {}
    self.bouncedTimes = bouncedTimes or 1

    self.color = {r or 255, g or 255, b or 255}

    self:calculateOrigin()
end

--- renders reflection with inverted stencil with shadows
function Lighting.Reflection:render()
    self:drawLight()
    self:drawReflections()
end

--- renders a fullscreen quad with inverted stencil with shadows
function Lighting.Reflection:drawLight(translateX, translateY)
    love.graphics.setStencil(function()
            love.graphics.push()
            love.graphics.translate(translateX, translateY)
            love.graphics.polygon("fill", unpack(self.vertices))
            love.graphics.pop()
        end)
    love.graphics.setColor(unpack(self.color))
    love.graphics.draw(Lighting.unlitBackground)
    love.graphics.setStencil()
end

--- draws all shadow polygons of Reflection
function Lighting.Reflection:drawShadows(translateX, translateY)
    for i,curShadow in pairs(self.shadows) do
        curShadow:render(translateX, translateY)
    end
end

--- draws the reflection's reflections
function Lighting.Reflection:drawReflections(translateX, translateX)
    for i,curReflection in pairs(self.reflections) do
        curReflection:render(translateX, translateX)
    end
end

--- updates reflection's shadows and reflections
function Lighting.Reflection:update(scene)
    self:updateShadows(scene)
    self:updateReflections(scene)
end

--- updates shadows
-- TODO make faster
function Lighting.Reflection:updateShadows(scene)
    self.shadows = {}
    for i=1,#scene do
        local curShadow = Lighting.Shadow(self, scene[i])
        if not curShadow.isInMesh then
            if self.distancePositionToBorderCenter < curShadow.distancePositionToBorderCenter then
                self.shadows[#self.shadows + 1] = curShadow
            end
        end
    end

    return shadowVolumes
end

--- updates reflections
-- TODO implement
function Lighting.Reflection:updateReflections(scene)
    if self.bouncedTimes < Lighting.Reflection.maxBounces then

    end
end

--- recalculates reflection polygon, left point converges to right point
function Lighting.Reflection:updateLeftSide(lightSource, shadowVecLeftX, shadowVecLeftY)
    local newLeft = Utilities.Intersection.LineLineseg(lightSource.position[1], lightSource.position[2], shadowVecLeftX, shadowVecLeftY, self.vertices[1], self.vertices[2], self.vertices[3], self.vertices[4])

    if newLeft then
        self.vertices[1] = newLeft[1]
        self.vertices[2] = newLeft[2]

        local newRefDirX, newRefDirY = Utilities.Vector.subAndNormalize(newLeft[1], newLeft[2], self.position[1], self.position[2])
        newRefDirX, newRefDirY = Utilities.Vector.mul(newRefDirX, newRefDirY, Lighting.Reflection.reflectionLength, Lighting.Reflection.reflectionLength)

        self.vertices[7], self.vertices[8] = Utilities.Vector.add(newLeft[1], newLeft[2], newRefDirX, newRefDirY)
    end
end

--- recalculates reflection polygon, left point converges to right point
function Lighting.Reflection:updateRightSide(lightSource, shadowVecRightX, shadowVecRightY)
    local newRight = Utilities.Intersection.LineLineseg(lightSource.position[1], lightSource.position[2], shadowVecRightX, shadowVecRightY, self.vertices[1], self.vertices[2], self.vertices[3], self.vertices[4])

    if newRight then
        self.vertices[3] = newRight[1]
        self.vertices[4] = newRight[2]

        local newRefDirX, newRefDirY = Utilities.Vector.subAndNormalize(newRight[1], newRight[2], self.position[1], self.position[2])
        newRefDirX, newRefDirY = Utilities.Vector.mul(newRefDirX, newRefDirY, Lighting.Reflection.reflectionLength, Lighting.Reflection.reflectionLength)

        self.vertices[5], self.vertices[6] = Utilities.Vector.add(newRight[1], newRight[2], newRefDirX, newRefDirY)
    end
end

--- splits reflection in two smaller reflections
function Lighting.Reflection:split(lightSource, shadowVecLeftX, shadowVecLeftY, shadowVecRightX, shadowVecRightY)
    local leftSplit = self
    local rightSplit = Lighting.Reflection(lightSource, self:getRight(), self:getLeft(), unpack(self.color), self.bouncedTimes)

    leftSplit:updateRightSide(lightSource, shadowVecLeftX, shadowVecLeftY)
    rightSplit:updateLeftSide(lightSource, shadowVecRightX, shadowVecRightY)

    return leftSplit, rightSplit
end

--- calculates the reflection polygon
-- @param lightSource LightSource object that shall be reflected
-- @param rightX x-coordinate of right point that shall be reflected
-- @param rightY y-coordinate of right point that shall be reflected
-- @param leftX x-coordinate of left point that shall be reflected
-- @param leftY y-coordinate of left point that shall be reflected
function Lighting.Reflection:calculateVertices(lightSource, rightX, rightY, leftX, leftY)
-- calculate normal
    local rightToLeftX, rightToLeftY = Utilities.Vector.subAndNormalize(leftX, leftY, rightX, rightY)

    local normalX = -rightToLeftY
    local normalY = rightToLeftX

-- calculate reflection vectors

-- calculate reflection vectors
    local lightVecToRightX, lightVecToRightY = Utilities.Vector.subAndNormalize(rightX, rightY, lightSource.position[1],lightSource.position[2])
    local lightVecToLeftX, lightVecToLeftY = Utilities.Vector.subAndNormalize(leftX, leftY, lightSource.position[1],lightSource.position[2])
    self.reflectionVecRightX, self.reflectionVecRightY = Utilities.Vector.reflect(lightVecToRightX, lightVecToRightY, normalX, normalY)
    self.reflectionVecLeftX,  self.reflectionVecLeftY  = Utilities.Vector.reflect(lightVecToLeftX, lightVecToLeftY, normalX, normalY)


-- check if lightsource is in front of reflection
    local dotWithRight = Utilities.Vector.dot(lightVecToRightX, lightVecToRightY, normalX, normalY)
    local dotWithLeft = Utilities.Vector.dot(lightVecToLeftX, lightVecToLeftY, normalX, normalY)

    self.isAReflection = (dotWithRight < 0 and dotWithLeft < 0)

-- set vertices
    self.vertices[1] = leftX
    self.vertices[2] = leftY

    self.vertices[3] = rightX
    self.vertices[4] = rightY

    self.vertices[5] = rightX + self.reflectionVecRightX * Lighting.Reflection.reflectionLength
    self.vertices[6] = rightY + self.reflectionVecRightY * Lighting.Reflection.reflectionLength

    self.vertices[7] = leftX + self.reflectionVecLeftX * Lighting.Reflection.reflectionLength
    self.vertices[8] = leftY + self.reflectionVecLeftY * Lighting.Reflection.reflectionLength
end

---
function Lighting.Reflection:calculateOrigin()
    self.position = Utilities.Intersection.LineLine(  self.vertices[1], self.vertices[2],
                                            self.reflectionVecLeftX, self.reflectionVecLeftY,

                                            self.vertices[3], self.vertices[4],
                                            self.reflectionVecRightX, self.reflectionVecRightY)
    if self.position then
        self.positionBorderCenter  = {(self.vertices[1] + self.vertices[3])/2, (self.vertices[2] + self.vertices[4])/2}
        self.distancePositionToBorderCenter = Utilities.Vector.length(self.position[1] - self.positionBorderCenter[1], self.position[2] - self.positionBorderCenter[2])
    else
        self.isAReflection = false
    end
end

--- return coordintates of the right point
function Lighting.Reflection:getRight()
    return self.vertices[3], self.vertices[4]
end

--- return coordintates of the left point
function Lighting.Reflection:getLeft()
    return self.vertices[1], self.vertices[2]
end
