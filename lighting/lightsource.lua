require "OO"
require "lighting.shadow"

Lighting.LightSource = {}
OO.createClass(Lighting.LightSource)

function Lighting.LightSource:new(x,y, r,g,b)
    self.position = {}
    self.position[1] = x or 0
    self.position[2] = y or 0

    self.shadows = {}
    self.reflections = {}

    self.enabled = true

    self.color = {r or 255, g or 255, b or 255}
end

--- renders light without shadows and reflections
function Lighting.LightSource:render()
    self:drawLight()

    self:drawReflections()
end

function Lighting.LightSource:renderCircle()
    love.graphics.setColor(unpack(self.color))
    love.graphics.circle( "fill", self.position[1], self.position[2], 10 )

    love.graphics.setColor(0,0,0)
    love.graphics.setLineWidth(1)
    love.graphics.circle( "line", self.position[1], self.position[2], 10 )
end

--- renders a fullscreen quad with inverted stencil with shadows
function Lighting.LightSource:drawLight()
    love.graphics.setInvertedStencil(function() self:drawShadows() end)

    love.graphics.setColor(unpack(self.color))
    love.graphics.rectangle("fill", 0,0,love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setInvertedStencil(nil)
end

--- draws all shadow polygons of lightsource
function Lighting.LightSource:drawShadows()
    for i,curShadow in pairs(self.shadows) do
        curShadow:render()
    end
end

function Lighting.LightSource:drawReflections()
    for i,curMeshReflections in pairs(self.reflections) do
        for j,curReflection in pairs(curMeshReflections) do
            curReflection:render()
        end
    end
end

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

function Lighting.LightSource:updateReflections(scene)
    self.reflections = {}
    for i=1,#scene do
        self.reflections[#self.reflections+1] = self:getReflectionPolygons(scene[i], i )
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
function Lighting.LightSource:getReflectionPolygons(mesh, meshIndexInScene)
    local allReflectionsOfPolygons = {}
    for i=1,#mesh.vertices,2 do
        local curReflections =  {}
        local curSideIndex = (i+1)/2
        if table.contains(mesh.reflectorSides, curSideIndex) then
            local indexCurX = i
            local indexCurY = i + 1

            local indexNextX = (i + 2) % #mesh.vertices
            local indexNextY = (i + 3) % #mesh.vertices
            if indexNextX == 0 then indexNextX = #mesh.vertices end
            if indexNextY == 0 then indexNextY = #mesh.vertices end

            local curX = mesh.vertices[indexCurX]
            local curY = mesh.vertices[indexCurY]

            local nextX = mesh.vertices[indexNextX]
            local nextY = mesh.vertices[indexNextY]

            local refColor = Color.mul(self.color, mesh.color)
            local startingReflection = Lighting.Reflection(self, curX, curY, nextX, nextY, refColor[1], refColor[2], refColor[3], 1, meshIndexInScene)
            if startingReflection.isAReflection then

                curReflections[#curReflections + 1] = startingReflection

                for shadowIndex=1,#self.shadows do
                    if meshIndexInScene ~= shadowIndex then -- do net test against shadow of mesh that is currently being checked
                        for reflectionIndex=1,#curReflections do
                            if curReflections[reflectionIndex] then
                                local curShadow = self.shadows[shadowIndex]
                                if not curShadow.isInMesh then

                                    local shadowVecLeftX, shadowVecLeftY = Vector.subAndNormalize(curShadow.vertices[7], curShadow.vertices[8], curShadow.vertices[1], curShadow.vertices[2])
                                    local shadowVecRightX, shadowVecRightY = Vector.subAndNormalize(curShadow.vertices[5], curShadow.vertices[6], curShadow.vertices[3], curShadow.vertices[4])
                                    local shadowDirX, shadowDirY = Vector.addAndNormalize(shadowVecLeftX, shadowVecLeftY, shadowVecRightX, shadowVecRightY)
                                    local curFromLightX, curFromLightY = Vector.subAndNormalize(curX, curY, self.position[1], self.position[2])
                                    local nextFromLightX, nextFromLightY = Vector.subAndNormalize(nextX, nextY, self.position[1], self.position[2])
                                    local smallShadowBorderX, smallShadowBorderY = Vector.sub(curShadow.vertices[1], curShadow.vertices[2], curShadow.vertices[3], curShadow.vertices[4])
                                    local curFromShadow12X, curFromShadow12Y = Vector.sub(curX, curY, curShadow.vertices[1], curShadow.vertices[2])
                                    local nextFromShadow12X, nextFromShadow12Y = Vector.sub(nextX, nextY, curShadow.vertices[1], curShadow.vertices[2])

                                    -- check if a cur or next could be in shadow
                                    if  Vector.getTurn(smallShadowBorderX, smallShadowBorderY, curFromShadow12X, curFromShadow12Y) == "right" or

                                        Vector.getTurn(smallShadowBorderX, smallShadowBorderY, nextFromShadow12X, nextFromShadow12Y) == "right" then

                                        local nextFromShadowLeftX, nextFromShadowLeftY = Vector.subAndNormalize(nextX, nextY, curShadow.vertices[7], curShadow.vertices[8])
                                        local nextFromShadowRightX, nextFromShadowRightY = Vector.subAndNormalize(nextX, nextY, curShadow.vertices[5], curShadow.vertices[6])
                                        local curFromShadowLeftX, curFromShadowLeftY = Vector.subAndNormalize(curX, curY, curShadow.vertices[7], curShadow.vertices[8])
                                        local curFromShadowRightX, curFromShadowRightY = Vector.subAndNormalize(curX, curY, curShadow.vertices[5], curShadow.vertices[6])

                                        local turnShadowLeftNext = Vector.getTurn(shadowVecLeftX, shadowVecLeftY,  nextFromShadowLeftX, nextFromShadowLeftY)
                                        local turnShadowLeftCur = Vector.getTurn(shadowVecLeftX, shadowVecLeftY,  curFromShadowLeftX, curFromShadowLeftY)
                                        local turnShadowRightNext = Vector.getTurn(shadowVecRightX, shadowVecRightY, nextFromShadowRightX, nextFromShadowRightY)
                                        local turnShadowRightCur = Vector.getTurn(shadowVecRightX, shadowVecRightY, curFromShadowRightX, curFromShadowRightY)

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
                    end -- if meshIndexInScene ~= shadowIndex
                end -- for shadowIndex=1,#self.shadows do
            end
        end

        for i=1,#curReflections do
           allReflectionsOfPolygons[#allReflectionsOfPolygons + 1] = curReflections[i]
        end

    end
    return allReflectionsOfPolygons
end
