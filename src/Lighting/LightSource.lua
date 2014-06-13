---
--@classmod LightSource
--@author Steve Wolligandt

require "Lighting.Shadow"
require "Utilities.Intersection"

Lighting.LightSource = {}
Utilities.OO.createClass(Lighting.LightSource)

---
function Lighting.LightSource:new(x,y, r,g,b, range)
    self.position = {}
    self.position[1] = x or 0
    self.position[2] = y or 0

    self.shadows = {}
    self.reflections = {}

    self.enabled = true

    self.range = range

    self.color = {r or 255, g or 255, b or 255}
    self.canvas = love.graphics.newCanvas()
end

--- renders light without shadows and reflections
function Lighting.LightSource:render(translateX, translateY)
    self:drawLight(translateX, translateY)

    self:drawReflections(translateX, translateY)
end

--- renders a fullscreen quad with inverted stencil with shadows
function Lighting.LightSource:drawLight(translateX, translateY)

    love.graphics.setBlendMode("additive")
    love.graphics.setInvertedStencil(function() self:drawShadows(translateX, translateY) end)
    love.graphics.setColor(unpack(self.color))
    love.graphics.draw(Lighting.unlitBackground)
    love.graphics.setInvertedStencil()
    --love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())

    --love.graphics.setInvertedStencil(nil)
end

--- draws all shadow polygons of lightsource
function Lighting.LightSource:drawShadows(translateX, translateY)
    for i,curShadow in pairs(self.shadows) do
        curShadow:render(translateX, translateY)
    end
end

---
function Lighting.LightSource:drawReflections(translateX, translateY)

    for i,curMeshReflections in pairs(self.reflections) do
        for j,curReflection in pairs(curMeshReflections) do
            self.canvas:clear()
            love.graphics.setBlendMode("alpha")
            love.graphics.setCanvas(self.canvas)
            curReflection:drawLight(translateX, translateY)

            love.graphics.setCanvas()
            love.graphics.setInvertedStencil(function() curReflection:drawShadows(translateX, translateY) end)
            love.graphics.setBlendMode("additive")
            love.graphics.draw(self.canvas)
            love.graphics.setInvertedStencil()
        end
    end
end

---
function Lighting.LightSource:renderCircle()
    love.graphics.setColor(unpack(self.color))
    love.graphics.circle( "fill", self.position[1], self.position[2], 10 )

    love.graphics.setColor(0,0,0)
    love.graphics.setLineWidth(1)
    love.graphics.circle( "line", self.position[1], self.position[2], 10 )
end

---
function Lighting.LightSource:update(scene)
    self:updateShadows(scene)
    self:updateReflections(scene)
end

--- calculates the shadow polygons for a list of shadowcasters
-- @param scene list of Mesh objects
function Lighting.LightSource:updateShadows(scene)
    self.shadows = {}
    for i=1,#scene do
        local curShadow = Lighting.Shadow(self, scene[i])
        if not curShadow.isInMesh then
            self.shadows[#self.shadows + 1] = curShadow
        end
    end
end

---
function Lighting.LightSource:updateReflections(scene)
    self.reflections = {}
    for i=1,#scene do
        self.reflections[#self.reflections+1] = self:getReflectionPolygons(scene[i])
    end


    for i,curMeshReflections in pairs(self.reflections) do
        for j,curReflection in pairs(curMeshReflections) do
            curReflection:update(scene)
        end
    end


end


--- Calculates all reflection polygons
-- @param mesh Mesh object
-- @return list of reflection polygons
function Lighting.LightSource:getReflectionPolygons(mesh)
    local allReflectionsOfPolygons = {}
    local meshWorldVertices = mesh:getWorldVertices()
    for i=1,#meshWorldVertices,2 do
        local curReflections =  {}
        local curSideIndex = (i+1)/2
        if table.contains(mesh.reflectorSides, curSideIndex) then
            local indexCurX = i
            local indexCurY = i + 1

            local indexNextX = (i + 2) % #meshWorldVertices
            local indexNextY = (i + 3) % #meshWorldVertices
            if indexNextX == 0 then indexNextX = #meshWorldVertices end
            if indexNextY == 0 then indexNextY = #meshWorldVertices end

            local curX = meshWorldVertices[indexCurX]
            local curY = meshWorldVertices[indexCurY]

            local nextX = meshWorldVertices[indexNextX]
            local nextY = meshWorldVertices[indexNextY]

            local refColor = Utilities.Color.mul(self.color, mesh.color)
            local startingReflection = Lighting.Reflection(self, curX, curY, nextX, nextY, refColor[1], refColor[2], refColor[3], 1)
            if startingReflection.isAReflection then

                curReflections[#curReflections + 1] = startingReflection

                for shadowIndex=1,#self.shadows do
                    for reflectionIndex=1,#curReflections do
                        if curReflections[reflectionIndex] then
                            local curShadow = self.shadows[shadowIndex]
                            if not curShadow.isInMesh then

                                local shadowVecLeftX, shadowVecLeftY = Utilities.Vector.subAndNormalize(curShadow.vertices[7], curShadow.vertices[8], curShadow.vertices[1], curShadow.vertices[2])
                                local shadowVecRightX, shadowVecRightY = Utilities.Vector.subAndNormalize(curShadow.vertices[5], curShadow.vertices[6], curShadow.vertices[3], curShadow.vertices[4])
                                local shadowDirX, shadowDirY = Utilities.Vector.addAndNormalize(shadowVecLeftX, shadowVecLeftY, shadowVecRightX, shadowVecRightY)
                                local curFromLightX, curFromLightY = Utilities.Vector.subAndNormalize(curX, curY, self.position[1], self.position[2])
                                local nextFromLightX, nextFromLightY = Utilities.Vector.subAndNormalize(nextX, nextY, self.position[1], self.position[2])
                                local smallShadowBorderX, smallShadowBorderY = Utilities.Vector.sub(curShadow.vertices[1], curShadow.vertices[2], curShadow.vertices[3], curShadow.vertices[4])
                                local curFromShadow12X, curFromShadow12Y = Utilities.Vector.sub(curX, curY, curShadow.vertices[1], curShadow.vertices[2])
                                local nextFromShadow12X, nextFromShadow12Y = Utilities.Vector.sub(nextX, nextY, curShadow.vertices[1], curShadow.vertices[2])

                                -- check if a cur or next could be in shadow
                                if  Utilities.Vector.getTurn(smallShadowBorderX, smallShadowBorderY, curFromShadow12X, curFromShadow12Y) == "right" or

                                    Utilities.Vector.getTurn(smallShadowBorderX, smallShadowBorderY, nextFromShadow12X, nextFromShadow12Y) == "right" then

                                    local nextFromShadowLeftX, nextFromShadowLeftY = Utilities.Vector.subAndNormalize(nextX, nextY, curShadow.vertices[7], curShadow.vertices[8])
                                    local nextFromShadowRightX, nextFromShadowRightY = Utilities.Vector.subAndNormalize(nextX, nextY, curShadow.vertices[5], curShadow.vertices[6])
                                    local curFromShadowLeftX, curFromShadowLeftY = Utilities.Vector.subAndNormalize(curX, curY, curShadow.vertices[7], curShadow.vertices[8])
                                    local curFromShadowRightX, curFromShadowRightY = Utilities.Vector.subAndNormalize(curX, curY, curShadow.vertices[5], curShadow.vertices[6])

                                    local turnShadowLeftNext = Utilities.Vector.getTurn(shadowVecLeftX, shadowVecLeftY,  nextFromShadowLeftX, nextFromShadowLeftY)
                                    local turnShadowLeftCur = Utilities.Vector.getTurn(shadowVecLeftX, shadowVecLeftY,  curFromShadowLeftX, curFromShadowLeftY)
                                    local turnShadowRightNext = Utilities.Vector.getTurn(shadowVecRightX, shadowVecRightY, nextFromShadowRightX, nextFromShadowRightY)
                                    local turnShadowRightCur = Utilities.Vector.getTurn(shadowVecRightX, shadowVecRightY, curFromShadowRightX, curFromShadowRightY)

                                    -- both points inside the shadow -> no reflection
                                    if  turnShadowRightNext == "left"  and turnShadowRightCur == "left" and
                                        turnShadowLeftNext  == "right"  and turnShadowLeftCur  == "right" then

                                        curReflections[reflectionIndex] = nil
                                    -- reflection changes
                                    else
                                        -- cur is outside the shadow, next is inside the shadow -> reflection gets smaller
                                        if turnShadowLeftCur  == "left" and turnShadowLeftNext  == "right"
                                            and turnShadowRightCur == "left" and turnShadowRightNext == "left" then

                                            curReflections[reflectionIndex]:updateLeftSide(self, shadowVecLeftX, shadowVecLeftY)


                                        -- cur is inside the shadow, next is outside the shadow -> reflection gets smaller
                                        elseif  turnShadowLeftCur  == "right" and turnShadowLeftNext  == "right" and
                                                turnShadowRightCur == "left" and turnShadowRightNext == "right" then

                                            curReflections[reflectionIndex]:updateRightSide(self, shadowVecRightX, shadowVecRightY)

                                        -- both outside, but shadow splits the reflection -> two smaller reflections
                                        elseif  turnShadowLeftCur  == "left" and turnShadowLeftNext  == "right" and
                                                turnShadowRightCur == "left" and turnShadowRightNext == "right" then
                                            local leftSplit, rightSplit = curReflections[reflectionIndex]:split(self, shadowVecLeftX, shadowVecLeftY, shadowVecRightX, shadowVecRightY)


                                            curReflections[reflectionIndex]     = leftSplit
                                            curReflections[#curReflections + 1]   = rightSplit

                                        end -- complex cases
                                    end -- both points inside the shadow
                                end -- check if a cur or next could be in shadow
                            end -- if #curShadow >= 8 then
                        end -- if curReflections[reflectionIndex]
                    end -- for reflectionIndex=1,#curReflections do
                end -- for shadowIndex=1,#self.shadows do
            end
        end

        for i=1,#curReflections do
           allReflectionsOfPolygons[#allReflectionsOfPolygons + 1] = curReflections[i]
        end

    end
    return allReflectionsOfPolygons
end


function Lighting.LightSource:isPointInLight(x,y)
    for i, curShadow in pairs(self.shadows) do
        if Utilities.Intersection.checkPointPolygon(x,y, curShadow.vertices) then
            return false
        end
    end
    return true
    -- Utilities.Intersection.checkPointPolygon(x,y, polygon)

end
