Ingame.Lighting = {}

require "vector"
require "color"
require "intersection"
require "ingame.reflection"

Ingame.Lighting.shadowLength = math.sqrt(math.pow(love.graphics.getWidth(), 2) + math.pow(love.graphics.getHeight(), 2))*20

---
function Ingame.Lighting.calculateAllShadowsAndReflections(lightSource, scene)
    local shadows = Ingame.Lighting.getShadowPolygonsOfScene(lightSource, scene)
    local reflections = Ingame.Lighting.getReflectionPolygonsOfScene(lightSource, scene)
    return shadows, reflections
end

--- calculates the shadow polygons for a list of shadowcasters
-- @param lightSource LightSource object
-- @param scene list of Mesh objects
function Ingame.Lighting.getShadowPolygonsOfScene(lightSource, scene, meshIndexOfReflection)
    local shadowVolumes = {}
    for i=1,#scene do
        if meshIndexOfReflection ~= i then
            local curShadowVolume = Ingame.Lighting.getShadowPolygon(lightSource, scene[i])
            if curShadowVolume then
                shadowVolumes[#shadowVolumes + 1] = curShadowVolume
            end
        end
    end

    return shadowVolumes
end

--- calculates a the shadow polygon for one shadowcaster
-- @param lightSource LightSource object
-- @param mesh Mesh Object
function Ingame.Lighting.getShadowPolygon(lightSource, mesh)
    local volumeStartPoints = Ingame.Lighting.getShadowVolumeStartPoints(lightSource, mesh)
    if volumeStartPoints[1] and volumeStartPoints[2] and volumeStartPoints[3] and volumeStartPoints[4] then
        local dir1X, dir1Y = Vector.subAndNormalize(volumeStartPoints[3], volumeStartPoints[4], lightSource.position[1], lightSource.position[2])
        local dir2X, dir2Y = Vector.subAndNormalize(volumeStartPoints[1], volumeStartPoints[2], lightSource.position[1], lightSource.position[2])

        return {volumeStartPoints[1], volumeStartPoints[2],
                volumeStartPoints[3], volumeStartPoints[4],
                volumeStartPoints[3] + dir1X * Ingame.Lighting.shadowLength, volumeStartPoints[4] + dir1Y * Ingame.Lighting.shadowLength,
                volumeStartPoints[1] + dir2X * Ingame.Lighting.shadowLength, volumeStartPoints[2] + dir2Y * Ingame.Lighting.shadowLength}
    end
    return nil
end

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
                                if #curShadow >= 8 then

                                    local shadowVecLeftX, shadowVecLeftY = Vector.subAndNormalize(curShadow[7], curShadow[8], curShadow[1], curShadow[2])
                                    local shadowVecRightX, shadowVecRightY = Vector.subAndNormalize(curShadow[5], curShadow[6], curShadow[3], curShadow[4])
                                    local shadowDirX, shadowDirY = Vector.addAndNormalize(shadowVecLeftX, shadowVecLeftY, shadowVecRightX, shadowVecRightY)
                                    local curFromLightX, curFromLightY = Vector.subAndNormalize(curX, curY, lightSource.position[1], lightSource.position[2])
                                    local nextFromLightX, nextFromLightY = Vector.subAndNormalize(nextX, nextY, lightSource.position[1], lightSource.position[2])
                                    local smallShadowBorderX, smallShadowBorderY = Vector.sub(curShadow[1], curShadow[2], curShadow[3], curShadow[4])
                                    local curFromShadow12X, curFromShadow12Y = Vector.sub(curX, curY, curShadow[1], curShadow[2])
                                    local nextFromShadow12X, nextFromShadow12Y = Vector.sub(nextX, nextY, curShadow[1], curShadow[2])

                                    -- check if a cur or next could be in shadow
                                    if  Vector.getTurn(smallShadowBorderX, smallShadowBorderY, curFromShadow12X, curFromShadow12Y) == "right" or

                                        Vector.getTurn(smallShadowBorderX, smallShadowBorderY, nextFromShadow12X, nextFromShadow12Y) == "right" then

                                        local nextFromShadowLeftX, nextFromShadowLeftY = Vector.subAndNormalize(nextX, nextY, curShadow[7], curShadow[8])
                                        local nextFromShadowRightX, nextFromShadowRightY = Vector.subAndNormalize(nextX, nextY, curShadow[5], curShadow[6])
                                        local curFromShadowLeftX, curFromShadowLeftY = Vector.subAndNormalize(curX, curY, curShadow[7], curShadow[8])
                                        local curFromShadowRightX, curFromShadowRightY = Vector.subAndNormalize(curX, curY, curShadow[5], curShadow[6])

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
                                            if turnShadowLeftCur  == "left" and turnShadowLeftNext  == "right" and turnShadowRightCur == "left" and turnShadowRightNext == "left" then

                                                curReflections[reflectionIndex]:updateLeftSide(lightSource, shadowVecLeftX, shadowVecLeftY)


                                            -- cur is inside the shadow, next is outside the shadow -> reflection gets smaller
                                            elseif turnShadowLeftCur  == "right" and turnShadowLeftNext  == "right" and turnShadowRightCur == "left" and turnShadowRightNext == "right" then

                                                curReflections[reflectionIndex]:updateRightSide(lightSource, shadowVecRightX, shadowVecRightY)

                                            -- both outside, but shadow splits the reflection -> two smaller reflections
                                            elseif turnShadowLeftCur  == "left" and turnShadowLeftNext  == "right" and turnShadowRightCur == "left" and turnShadowRightNext == "right" then
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

function Ingame.Lighting.shadowTestOfReflection(lightSource, mesh, meshIndexInScene, curReflections)
end -- function

---
-- @param lightSource LightSource object
-- @param mesh Mesh Object
-- @return {x1,y1, x2,y2}
function Ingame.Lighting.getShadowVolumeStartPoints(lightSource, mesh)
    local volumeStartPoints = {}
    for i=1,#mesh.vertices,2 do
        -- calculate indices
        local indexCurX = i
        local indexCurY = i + 1

        local indexPrevX = (i - 2 + #mesh.vertices) % #mesh.vertices
        local indexPrevY = (i - 1 + #mesh.vertices) % #mesh.vertices
        if indexPrevX == 0 then indexPrevX = #mesh.vertices end
        if indexPrevY == 0 then indexPrevY = #mesh.vertices end

        local indexNextX = (i + 2) % #mesh.vertices
        local indexNextY = (i + 3) % #mesh.vertices
        if indexNextX == 0 then indexNextX = #mesh.vertices end
        if indexNextY == 0 then indexNextY = #mesh.vertices end

        -- get positions
        local curX = mesh.vertices[indexCurX]
        local curY = mesh.vertices[indexCurY]

        local prevX = mesh.vertices[indexPrevX]
        local prevY = mesh.vertices[indexPrevY]

        local nextX = mesh.vertices[indexNextX]
        local nextY = mesh.vertices[indexNextY]

        local lightVecX = curX - lightSource.position[1]
        local lightVecY = curY - lightSource.position[2]
        lightVecX, lightVecY = Vector.normalize(lightVecX, lightVecY)

        local lineBeforeCurPointX = curX - prevX
        local lineBeforeCurPointY = curY - prevY

        local lineAfterCurPointX = nextX - curX
        local lineAfterCurPointY = nextY - curY

        local normalBeforeCurX =  lineBeforeCurPointY
        local normalBeforeCurY = -lineBeforeCurPointX
        normalBeforeCurX, normalBeforeCurY = Vector.normalize(normalBeforeCurX, normalBeforeCurY)

        local normalAfterCurX =  lineAfterCurPointY
        local normalAfterCurY = -lineAfterCurPointX
        normalAfterCurX, normalAfterCurY = Vector.normalize(normalAfterCurX, normalAfterCurY)

        local dotBefore = Vector.dot(normalBeforeCurX, normalBeforeCurY, lightVecX, lightVecY)
        local dotAfter  = Vector.dot(normalAfterCurX,  normalAfterCurY,  lightVecX, lightVecY)

        if (dotBefore >= 0 and dotAfter <= 0) then
            volumeStartPoints[3] = curX
            volumeStartPoints[4] = curY
        end

        if (dotBefore <= 0 and dotAfter >= 0) then
            volumeStartPoints[1] = curX
            volumeStartPoints[2] = curY
        end
    end

--    love.graphics.setColor(255,0,0)
--    love.graphics.setPointSize(30)
--    love.graphics.point(volumeStartPoints[1], volumeStartPoints[2])
    return volumeStartPoints
end
