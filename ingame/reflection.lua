require "OO"
Ingame.Reflection = {}
OO.createClass(Ingame.Reflection)

Ingame.Reflection.maxBounces = 3
Ingame.Reflection.reflectionLength = math.sqrt(math.pow(love.graphics.getWidth(), 2) + math.pow(love.graphics.getHeight(), 2))*20

function Ingame.Reflection:new(lightSource, rightX, rightY, leftX, leftY, r,g,b, bouncedTimes, meshIndex)
    self.meshIndex = meshIndex
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
function Ingame.Reflection:render()
    self:drawLight()
    self:drawReflections()
    --love.graphics.setColor(255,0,255)
    --self:drawShadows()
end

--- renders a fullscreen quad with inverted stencil with shadows
function Ingame.Reflection:drawLight()
    love.graphics.setInvertedStencil(function() self:drawShadows() end)
    love.graphics.setBlendMode("additive")

    love.graphics.setColor(unpack(self.color))
    --love.graphics.setColor(50,50,50)
    love.graphics.polygon("fill", unpack(self.vertices))

    love.graphics.setBlendMode("alpha")
    love.graphics.setInvertedStencil(nil)
end

--- draws all shadow polygons of Reflection
function Ingame.Reflection:drawShadows()
    for i,curShadow in pairs(self.shadows) do
        curShadow:render()
    end
end

function Ingame.Reflection:drawReflections()
    for i,curReflection in pairs(self.reflections) do
        curReflection:render()
    end
end

function Ingame.Reflection:update(scene)
    self:updateShadows(scene)
    self:updateReflections(scene)
end

--- TODO make faster
function Ingame.Reflection:updateShadows(scene)
    self.shadows = {}
    for i=1,#scene do
        if self.meshIndex ~= i then
            local curShadow = Ingame.Shadow(self, scene[i])
            if not curShadow.isInMesh then
                self.shadows[#self.shadows + 1] = curShadow
            end
        end
    end

    return shadowVolumes
end

--- TODO implement
function Ingame.Reflection:updateReflections(scene)
    if self.bouncedTimes < Ingame.Reflection.maxBounces then

    end
end

--- recalculates reflection polygon, left point converges to right point
function Ingame.Reflection:updateLeftSide(lightSource, shadowVecLeftX, shadowVecLeftY)
    local newLeft = Intersection.LineLineseg(lightSource.position[1], lightSource.position[2], shadowVecLeftX, shadowVecLeftY, self.vertices[1], self.vertices[2], self.vertices[3], self.vertices[4])

    if newLeft then
        self.vertices[1] = newLeft[1]
        self.vertices[2] = newLeft[2]

        local newRefDirX, newRefDirY = Vector.subAndNormalize(newLeft[1], newLeft[2], self.position[1], self.position[2])
        newRefDirX, newRefDirY = Vector.mul(newRefDirX, newRefDirY, Ingame.Reflection.reflectionLength, Ingame.Reflection.reflectionLength)

        self.vertices[7], self.vertices[8] = Vector.add(newLeft[1], newLeft[2], newRefDirX, newRefDirY)
    end
end

--- recalculates reflection polygon, left point converges to right point
function Ingame.Reflection:updateRightSide(lightSource, shadowVecRightX, shadowVecRightY)
    local newRight = Intersection.LineLineseg(lightSource.position[1], lightSource.position[2], shadowVecRightX, shadowVecRightY, self.vertices[1], self.vertices[2], self.vertices[3], self.vertices[4])

    if newRight then
        self.vertices[3] = newRight[1]
        self.vertices[4] = newRight[2]

        local newRefDirX, newRefDirY = Vector.subAndNormalize(newRight[1], newRight[2], self.position[1], self.position[2])
        newRefDirX, newRefDirY = Vector.mul(newRefDirX, newRefDirY, Ingame.Reflection.reflectionLength, Ingame.Reflection.reflectionLength)

        self.vertices[5], self.vertices[6] = Vector.add(newRight[1], newRight[2], newRefDirX, newRefDirY)
    end
end

--- splits reflection in two smaller reflections
function Ingame.Reflection:split(lightSource, shadowVecLeftX, shadowVecLeftY, shadowVecRightX, shadowVecRightY)
    local leftSplit = self
    local rightSplit = Ingame.Reflection(lightSource, self:getRight(), self:getLeft(), unpack(self.color), self.bouncedTimes)

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
function Ingame.Reflection:calculateVertices(lightSource, rightX, rightY, leftX, leftY)
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

    self.vertices[5] = rightX + self.reflectionVecRightX * Ingame.Reflection.reflectionLength
    self.vertices[6] = rightY + self.reflectionVecRightY * Ingame.Reflection.reflectionLength

    self.vertices[7] = leftX + self.reflectionVecLeftX * Ingame.Reflection.reflectionLength
    self.vertices[8] = leftY + self.reflectionVecLeftY * Ingame.Reflection.reflectionLength
end

function Ingame.Reflection:calculateOrigin()
    self.position = Intersection.LineLine(  self.vertices[1], self.vertices[2],
                                            self.reflectionVecLeftX, self.reflectionVecLeftY,

                                            self.vertices[3], self.vertices[4],
                                            self.reflectionVecRightX, self.reflectionVecRightY)
end

function Ingame.Reflection:getRight()
    return self.vertices[3], self.vertices[4]
end

function Ingame.Reflection:getLeft()
    return self.vertices[1], self.vertices[2]
end

--- calculates the shadow polygons for a list of shadowcasters
-- TODO make faster
-- @param lightSource LightSource object
-- @param scene list of Mesh objects
function Ingame.Reflection.getShadowPolygonsOfScene(scene, meshIndexOfReflection)

end
