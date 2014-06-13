---
--@classmod Shadow
--@author Steve Wolligandt

require "Utilities"

Lighting.Shadow = {}
Lighting.Shadow.shadowLength = math.sqrt(math.pow(love.graphics.getWidth(), 2) + math.pow(love.graphics.getHeight(), 2))*20
Utilities.OO.createClass(Lighting.Shadow)

---
function Lighting.Shadow:new(lightSource, mesh)
    self.lightSource = lightSource
    self.mesh = mesh

    self.color = {10,10,10}

    self.vertices  = {}
    self:calculateVertices(lightSource, mesh)
    self:calculateDirection()

    self.position = {}
    self:calculateOrigin()
end

---
function Lighting.Shadow:render(translateX, translateY)
    if not self.isInMesh then
        love.graphics.push()
        love.graphics.translate(translateX, translateY)
        love.graphics.setColor(255,255,255)
        love.graphics.polygon("fill", unpack(self.vertices))
        love.graphics.pop()
    end
end

---
function Lighting.Shadow:calculateOrigin()
    if not self.isInMesh then
        self.position = Utilities.Intersection.LineLine(  self.vertices[1], self.vertices[2],
                                                self.directionLeftX, self.directionLeftY,

                                                self.vertices[3], self.vertices[4],
                                                self.directionRightX, self.directionRightY)

        self.positionBorderCenter  = {(self.vertices[1] + self.vertices[3])/2, (self.vertices[2] + self.vertices[4])/2}
        self.distancePositionToBorderCenter = Utilities.Vector.length(self.position[1] - self.positionBorderCenter[1], self.position[2] - self.positionBorderCenter[2])
    end
end

--- calculates the reflection polygon
-- @param lightSource LightSource object that will get a shadow
-- @param mesh Mesh object that casts a shadow
function Lighting.Shadow:calculateVertices(lightSource, mesh)
    local volumeStartPoints = self:getVolumeStartPoints(lightSource, mesh)
    if not self.isInMesh then
        self.directionLeftX, self.directionLeftY = Utilities.Vector.subAndNormalize(volumeStartPoints[3], volumeStartPoints[4], lightSource.position[1], lightSource.position[2])
        self.directionRightX, self.directionRightY = Utilities.Vector.subAndNormalize(volumeStartPoints[1], volumeStartPoints[2], lightSource.position[1], lightSource.position[2])

        self.vertices = {   volumeStartPoints[1], volumeStartPoints[2],
                            volumeStartPoints[3], volumeStartPoints[4],
                            volumeStartPoints[3] + self.directionLeftX * Lighting.Shadow.shadowLength, volumeStartPoints[4] + self.directionLeftY * Lighting.Shadow.shadowLength,
                            volumeStartPoints[1] + self.directionRightX * Lighting.Shadow.shadowLength, volumeStartPoints[2] + self.directionRightY * Lighting.Shadow.shadowLength}
    end
end

---
-- @param lightSource LightSource object
-- @param mesh Mesh Object
-- @return {x1,y1, x2,y2}
function Lighting.Shadow:getVolumeStartPoints(lightSource, mesh)
    local volumeStartPoints = {}
    local meshWorldVertices = mesh:getWorldVertices()

    for i=1,#meshWorldVertices,2 do
        -- calculate indices
        local indexCurX = i
        local indexCurY = i + 1

        local indexPrevX = (i - 2 + #meshWorldVertices) % #meshWorldVertices
        local indexPrevY = (i - 1 + #meshWorldVertices) % #meshWorldVertices
        if indexPrevX == 0 then indexPrevX = #meshWorldVertices end
        if indexPrevY == 0 then indexPrevY = #meshWorldVertices end

        local indexNextX = (i + 2) % #meshWorldVertices
        local indexNextY = (i + 3) % #meshWorldVertices
        if indexNextX == 0 then indexNextX = #meshWorldVertices end
        if indexNextY == 0 then indexNextY = #meshWorldVertices end

        -- get positions
        local curX = meshWorldVertices[indexCurX]
        local curY = meshWorldVertices[indexCurY]

        local prevX = meshWorldVertices[indexPrevX]
        local prevY = meshWorldVertices[indexPrevY]

        local nextX = meshWorldVertices[indexNextX]
        local nextY = meshWorldVertices[indexNextY]

        local lightVecX, lightVecY = Utilities.Vector.subAndNormalize(curX, curY, lightSource.position[1], lightSource.position[2])

        local lineBeforeCurPointX, lineBeforeCurPointY = Utilities.Vector.sub(curX, curY, prevX, prevY)
        local lineAfterCurPointX, lineAfterCurPointY = Utilities.Vector.sub(nextX, nextY, curX, curY)

        local normalBeforeCurX =  lineBeforeCurPointY
        local normalBeforeCurY = -lineBeforeCurPointX
        normalBeforeCurX, normalBeforeCurY = Utilities.Vector.normalize(normalBeforeCurX, normalBeforeCurY)

        local normalAfterCurX =  lineAfterCurPointY
        local normalAfterCurY = -lineAfterCurPointX
        normalAfterCurX, normalAfterCurY = Utilities.Vector.normalize(normalAfterCurX, normalAfterCurY)

        local dotBefore = Utilities.Vector.dot(normalBeforeCurX, normalBeforeCurY, lightVecX, lightVecY)
        local dotAfter  = Utilities.Vector.dot(normalAfterCurX,  normalAfterCurY,  lightVecX, lightVecY)

        if (dotBefore > 0 and dotAfter < 0) then
            volumeStartPoints[3] = curX
            volumeStartPoints[4] = curY
        end

        if (dotBefore < 0 and dotAfter > 0) then
            volumeStartPoints[1] = curX
            volumeStartPoints[2] = curY
        end

        self.isInMesh = not(volumeStartPoints[1] and volumeStartPoints[2] and volumeStartPoints[3] and volumeStartPoints[4])

    end
    return volumeStartPoints
end

---
function Lighting.Shadow:calculateDirection()
    if not self.isInMesh then
        self.directionX, self.directionY = Utilities.Vector.addAndNormalize(self.directionLeftX, self.directionLeftY, self.directionRightX, self.directionRightY)
    end
end
