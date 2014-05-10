Ingame.Lighting = {}

require "vector"
require "color"
require "intersection"
require "ingame.reflection"
require "ingame.shadow"

function Ingame.Lighting.getReflectionPolygonsOfScene(lightSource, scene)
    local reflections = {}
    for i=1,#scene do
        reflections[#reflections+1] = Ingame.Lighting.getReflectionPolygons(lightSource, scene[i], i )
    end

    return reflections
end

--- Calculates all reflection polygons
-- @param lightSource LightSource object
-- @param mesh Mesh object
-- @return list of reflection polygons
function Ingame.Lighting.getReflectionPolygons(lightSource, mesh, meshIndexInScene )
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

            local refColor = Color.mul(lightSource.color, mesh.color)
            local startingReflection = Ingame.Reflection(lightSource, curX, curY, nextX, nextY, refColor[1], refColor[2], refColor[3], 1, meshIndexInScene)
            if startingReflection.isAReflection then

                curReflections[#curReflections + 1] = startingReflection

                for shadowIndex=1,#lightSource.shadows do
                    if meshIndexInScene ~= shadowIndex then -- do net test against shadow of mesh that is currently being checked
                        for reflectionIndex=1,#curReflections do
                            if curReflections[reflectionIndex] then
                                local curShadow = lightSource.shadows[shadowIndex]
                                if not curShadow.isInMesh then

                                    local shadowVecLeftX, shadowVecLeftY = Vector.subAndNormalize(curShadow.vertices[7], curShadow.vertices[8], curShadow.vertices[1], curShadow.vertices[2])
                                    local shadowVecRightX, shadowVecRightY = Vector.subAndNormalize(curShadow.vertices[5], curShadow.vertices[6], curShadow.vertices[3], curShadow.vertices[4])
                                    local shadowDirX, shadowDirY = Vector.addAndNormalize(shadowVecLeftX, shadowVecLeftY, shadowVecRightX, shadowVecRightY)
                                    local curFromLightX, curFromLightY = Vector.subAndNormalize(curX, curY, lightSource.position[1], lightSource.position[2])
                                    local nextFromLightX, nextFromLightY = Vector.subAndNormalize(nextX, nextY, lightSource.position[1], lightSource.position[2])
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

                                                curReflections[reflectionIndex]:updateLeftSide(lightSource, shadowVecLeftX, shadowVecLeftY)


                                            -- cur is inside the shadow, next is outside the shadow -> reflection gets smaller
                                            elseif  turnShadowLeftCur  == "right" and turnShadowLeftNext  == "right" and
                                                    turnShadowRightCur == "left" and turnShadowRightNext == "right" then

                                                curReflections[reflectionIndex]:updateRightSide(lightSource, shadowVecRightX, shadowVecRightY)

                                            -- both outside, but shadow splits the reflection -> two smaller reflections
                                            elseif  turnShadowLeftCur  == "left" and turnShadowLeftNext  == "right" and
                                                    turnShadowRightCur == "left" and turnShadowRightNext == "right" then
                                                local leftSplit, rightSplit = curReflections[reflectionIndex]:split(lightSource, shadowVecLeftX, shadowVecLeftY, shadowVecRightX, shadowVecRightY)


                                                curReflections[reflectionIndex]     = leftSplit
                                                curReflections[#curReflections + 1]   = rightSplit

                                            end -- complex cases
                                        end -- both points inside the shadow
                                    end -- check if a cur or next could be in shadow
                                end -- if #curShadow >= 8 then
                            end -- if curReflections[reflectionIndex]
                        end -- for reflectionIndex=1,#curReflections do
                    end -- if meshIndexInScene ~= shadowIndex
                end -- for shadowIndex=1,#lightSource.shadows do
            end
        end

        for i=1,#curReflections do
           allReflectionsOfPolygons[#allReflectionsOfPolygons + 1] = curReflections[i]
        end

    end
    return allReflectionsOfPolygons
end
