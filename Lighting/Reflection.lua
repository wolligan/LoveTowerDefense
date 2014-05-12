--- ADD ME
require "OO"

Lighting.Reflection = {}
OO.createClass(Lighting.Reflection)

Lighting.Reflection.maxBounces = 3
Lighting.Reflection.reflectionLength = math.sqrt(math.pow(love.graphics.getWidth(), 2) + math.pow(love.graphics.getHeight(), 2))*20

---
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
    --love.graphics.setColor(255,0,255)
    --self:drawShadows()
end

--- renders a fullscreen quad with inverted stencil with shadows
function Lighting.Reflection:drawLight()
    Lighting.sceneLitByCurReflection:clear(0,0,0)
    love.graphics.setCanvas(Lighting.sceneLitByCurReflection)


    love.graphics.setStencil(function()
            love.graphics.setColor(255,255,255)
            love.graphics.polygon("fill", unpack(self.vertices))
        end)

    love.graphics.setColor(unpack(self.color))
    love.graphics.setBlendMode("alpha")
    love.graphics.draw(Lighting.unlitSceneCanvas)
    love.graphics.setStencil(nil)

    love.graphics.setCanvas()
    love.graphics.setInvertedStencil(function() self:drawShadows() end)
    love.graphics.setBlendMode("additive")
    love.graphics.setColor(255,255,255)
    love.graphics.draw(Lighting.sceneLitByCurReflection)
    love.graphics.setInvertedStencil(nil)

    --love.graphics.polygon("fill", unpack(self.vertices))

end

--- draws all shadow polygons of Reflection
function Lighting.Reflection:drawShadows()
    for i,curShadow in pairs(self.shadows) do
        curShadow:render()
    end
end

---
function Lighting.Reflection:drawReflections()
    for i,curReflection in pairs(self.reflections) do
        curReflection:render()
    end
end

---
function Lighting.Reflection:update(scene)
    self:updateShadows(scene)
    self:updateReflections(scene)
end

--- TODO make faster
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

--- TODO implement
function Lighting.Reflection:updateReflections(scene)
    if self.bouncedTimes < Lighting.Reflection.maxBounces then

    end
end

--- recalculates reflection polygon, left point converges to right point
function Lighting.Reflection:updateLeftSide(lightSource, shadowVecLeftX, shadowVecLeftY)
    local newLeft = Intersection.LineLineseg(lightSource.position[1], lightSource.position[2], shadowVecLeftX, shadowVecLeftY, self.vertices[1], self.vertices[2], self.vertices[3], self.vertices[4])

    if newLeft then
        self.vertices[1] = newLeft[1]
        self.vertices[2] = newLeft[2]

        local newRefDirX, newRefDirY = Vector.subAndNormalize(newLeft[1], newLeft[2], self.position[1], self.position[2])
        newRefDirX, newRefDirY = Vector.mul(newRefDirX, newRefDirY, Lighting.Reflection.reflectionLength, Lighting.Reflection.reflectionLength)

        self.vertices[7], self.vertices[8] = Vector.add(newLeft[1], newLeft[2], newRefDirX, newRefDirY)
    end
end

--- recalculates reflection polygon, left point converges to right point
function Lighting.Reflection:updateRightSide(lightSource, shadowVecRightX, shadowVecRightY)
    local newRight = Intersection.LineLineseg(lightSource.position[1], lightSource.position[2], shadowVecRightX, shadowVecRightY, self.vertices[1], self.vertices[2], self.vertices[3], self.vertices[4])

    if newRight then
        self.vertices[3] = newRight[1]
        self.vertices[4] = newRight[2]

        local newRefDirX, newRefDirY = Vector.subAndNormalize(newRight[1], newRight[2], self.position[1], self.position[2])
        newRefDirX, newRefDirY = Vector.mul(newRefDirX, newRefDirY, Lighting.Reflection.reflectionLength, Lighting.Reflection.reflectionLength)

        self.vertices[5], self.vertices[6] = Vector.add(newRight[1], newRight[2], newRefDirX, newRefDirY)
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
    local rightToLeftX, rightToLeftY = Vector.subAndNormalize(leftX, leftY, rightX, rightY)

    local normalX = -rightToLeftY
    local normalY = rightToLeftX

-- calculate reflection vectors

-- calculate reflection vectors
    local lightVecToRightX, lightVecToRightY = Vector.subAndNormalize(rightX, rightY, lightSource.position[1],lightSource.position[2])
    local lightVecToLeftX, lightVecToLeftY = Vector.subAndNormalize(leftX, leftY, lightSource.position[1],lightSource.position[2])
    self.reflectionVecRightX, self.reflectionVecRightY = Vector.reflect(lightVecToRightX, lightVecToRightY, normalX, normalY)
    self.reflectionVecLeftX,  self.reflectionVecLeftY  = Vector.reflect(lightVecToLeftX, lightVecToLeftY, normalX, normalY)


-- check if lightsource is in front of reflection
    local dotWithRight = Vector.dot(lightVecToRightX, lightVecToRightY, normalX, normalY)
    local dotWithLeft = Vector.dot(lightVecToLeftX, lightVecToLeftY, normalX, normalY)

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
    self.position = Intersection.LineLine(  self.vertices[1], self.vertices[2],
                                            self.reflectionVecLeftX, self.reflectionVecLeftY,

                                            self.vertices[3], self.vertices[4],
                                            self.reflectionVecRightX, self.reflectionVecRightY)
    if self.position then
        self.positionBorderCenter  = {(self.vertices[1] + self.vertices[3])/2, (self.vertices[2] + self.vertices[4])/2}
        self.distancePositionToBorderCenter = Vector.length(self.position[1] - self.positionBorderCenter[1], self.position[2] - self.positionBorderCenter[2])
    else
        self.isAReflection = false
    end
end

---
function Lighting.Reflection:getRight()
    return self.vertices[3], self.vertices[4]
end

---
function Lighting.Reflection:getLeft()
    return self.vertices[1], self.vertices[2]
end
