Ingame.Lighting = {}

require "vector"
require "intersection"

Ingame.Lighting.shadowLength = math.sqrt(math.pow(love.graphics.getWidth(), 2) + math.pow(love.graphics.getHeight(), 2))*20
Ingame.Lighting.reflectionLength = Ingame.Lighting.shadowLength

---
function Ingame.Lighting.calculateAllShadowsAndReflections(lightSource, scene)
    local shadows = Ingame.Lighting.getShadowPolygonsOfScene(lightSource, scene)
    local reflections = Ingame.Lighting.getReflectionPolygonsOfScene(lightSource, scene, shadows)
    return shadows, reflections
end

--- calculates the shadow polygons for a list of shadowcasters
-- @param lightSource LightSource object
-- @param scene list of Mesh objects
function Ingame.Lighting.getShadowPolygonsOfScene(lightSource, scene)
    local shadowVolumes = {}
    for i=1,#scene do
        shadowVolumes[i] = Ingame.Lighting.getShadowPolygon(lightSource, scene[i])
    end

    return shadowVolumes
end

--- calculates a the shadow polygon for one shadowcaster
-- @param lightSource LightSource object
-- @param mesh Mesh Object
function Ingame.Lighting.getShadowPolygon(lightSource, mesh)
    local volumeStartPoints = Ingame.Lighting.getShadowVolumeStartPoints(lightSource, mesh)
    if volumeStartPoints[1] and volumeStartPoints[2] and volumeStartPoints[3] and volumeStartPoints[4] then
        local dir1X =(volumeStartPoints[3] - lightSource.position[1])
        local dir1Y =(volumeStartPoints[4] - lightSource.position[2])
        dir1X, dir1Y = Vector.normalize(dir1X, dir1Y)

        local dir2X =(volumeStartPoints[1] - lightSource.position[1])
        local dir2Y =(volumeStartPoints[2] - lightSource.position[2])
        dir2X, dir2Y = Vector.normalize(dir2X, dir2Y)

        return {volumeStartPoints[1], volumeStartPoints[2],
                volumeStartPoints[3], volumeStartPoints[4],
                volumeStartPoints[3] + dir1X * Ingame.Lighting.shadowLength, volumeStartPoints[4] + dir1Y * Ingame.Lighting.shadowLength,
                volumeStartPoints[1] + dir2X * Ingame.Lighting.shadowLength, volumeStartPoints[2] + dir2Y * Ingame.Lighting.shadowLength}
    end
    return {}
end

function Ingame.Lighting.getReflectionPolygonsOfScene(lightSource, scene, shadowsInScene)
    local reflections = {}
    for i=1,#scene do
        reflections[#reflections+1] = Ingame.Lighting.getReflectionPolygons(lightSource, scene[i], shadowsInScene, i )
    end

    return reflections
end

--- Calculates all reflection polygons
-- @param lightSource LightSource object
-- @param mesh Mesh object
-- @param shadowsInScene list of shadows
-- @return list of reflection polygons
function Ingame.Lighting.getReflectionPolygons(lightSource, mesh, shadowsInScene, meshIndexInScene )
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

            local curLinePointX = nextX - curX
            local curLinePointY = nextY - curY

            local curNormalX = -curLinePointY
            local curNormalY = curLinePointX
            curNormalX, curNormalY = Vector.normalize(curNormalX, curNormalY)

            local lightVecToCurX = curX - lightSource.position[1]
            local lightVecToCurY = curY - lightSource.position[2]
            lightVecToCurX, lightVecToCurY = Vector.normalize(lightVecToCurX, lightVecToCurY)

            local lightVecToNextX = nextX - lightSource.position[1]
            local lightVecToNextY = nextY - lightSource.position[2]
            lightVecToNextX, lightVecToNextY = Vector.normalize(lightVecToNextX, lightVecToNextY)

            local dotWithCur = Vector.dot(lightVecToCurX, lightVecToCurY, curNormalX, curNormalY)
            local dotWithNext = Vector.dot(lightVecToNextX, lightVecToNextY, curNormalX, curNormalY)

            if dotWithCur < 0 and dotWithNext < 0 then
                local startingReflection = {}
                startingReflection[1] = nextX
                startingReflection[2] = nextY

                startingReflection[3] = curX
                startingReflection[4] = curY

                local reflectionVecRightX,  reflectionVecRightY  = Vector.reflect(lightVecToCurX, lightVecToCurY, curNormalX, curNormalY)
                local reflectionVecLeftX, reflectionVecLeftY = Vector.reflect(lightVecToNextX, lightVecToNextY, curNormalX, curNormalY)

                startingReflection[5] = curX + reflectionVecRightX * Ingame.Lighting.reflectionLength
                startingReflection[6] = curY + reflectionVecRightY * Ingame.Lighting.reflectionLength

                startingReflection[7] = nextX + reflectionVecLeftX * Ingame.Lighting.reflectionLength
                startingReflection[8] = nextY + reflectionVecLeftY * Ingame.Lighting.reflectionLength

                curReflections[#curReflections + 1] = startingReflection

                if shadowsInScene then
                    for shadowIndex=1,#shadowsInScene do
                        if meshIndexInScene ~= shadowIndex then -- do net test against shadow of mesh that is currently being checked
                            for reflectionIndex=1,#curReflections do
                                if curReflections[reflectionIndex] then
                                    local curShadow = shadowsInScene[shadowIndex]

                                    local shadowVecLeftX = curShadow[7] - curShadow[1]
                                    local shadowVecLeftY = curShadow[8] - curShadow[2]
                                    shadowVecLeftX, shadowVecLeftY = Vector.normalize(shadowVecLeftX, shadowVecLeftY)

                                    local shadowVecRightX = curShadow[5] - curShadow[3]
                                    local shadowVecRightY = curShadow[6] - curShadow[4]
                                    shadowVecRightX, shadowVecRightY = Vector.normalize(shadowVecRightX, shadowVecRightY)

                                    local shadowDirX = shadowVecLeftX + shadowVecRightX
                                    local shadowDirY = shadowVecLeftY + shadowVecRightY
                                    shadowDirX, shadowDirY = Vector.normalize(shadowDirX, shadowDirY)

                                    local curFromLightX = curX - lightSource.position[1]
                                    local curFromLightY = curY - lightSource.position[2]
                                    local curFromLightLength
                                    curFromLightX, curFromLightY, curFromLightLength = Vector.normalize(curFromLightX, curFromLightY)

                                    local nextFromLightX = nextX - lightSource.position[1]
                                    local nextFromLightY = nextY - lightSource.position[2]
                                    local nextFromLightLength
                                    nextFromLightX, nextFromLightY, nextFromLightLength = Vector.normalize(nextFromLightX, nextFromLightY)

                                    local shadow13FromLightX = curShadow[1] - lightSource.position[1]
                                    local shadow13FromLightY = curShadow[3] - lightSource.position[2]
                                    local shadow13FromLightLength
                                    shadow13FromLightX, shadow13FromLightY, shadow13FromLightLength = Vector.normalize(shadow13FromLightX, shadow13FromLightY)

                                    local shadow24FromLightX = curShadow[2] - lightSource.position[1]
                                    local shadow24FromLightY = curShadow[4] - lightSource.position[2]
                                    local shadow24FromLightLength
                                    shadow24FromLightX, shadow24FromLightY, shadow24FromLightLength = Vector.normalize(shadow24FromLightX, shadow24FromLightY)


                                    local blub =    shadow13FromLightLength < curFromLightLength or
                                                    shadow13FromLightLength < nextFromLightLength or
                                                    shadow24FromLightLength < curFromLightLength or
                                                    shadow24FromLightLength < nextFromLightLength

                                    -- check if a cur or next could be in shadow
                                    if  Vector.dot(shadowDirX, shadowDirY, curFromLightX, curFromLightY) > 0 and Vector.dot(shadowDirX, shadowDirY, nextFromLightX, nextFromLightY) > 0 and
                                        blub then

                                        local nextFromShadowLeftX = nextX - curShadow[7]
                                        local nextFromShadowLeftY = nextY - curShadow[8]
                                        nextFromShadowLeftX, nextFromShadowLeftY = Vector.normalize(nextFromShadowLeftX, nextFromShadowLeftY)

                                        local nextFromShadowRightX = nextX - curShadow[5]
                                        local nextFromShadowRightY = nextY - curShadow[6]
                                        nextFromShadowRightX, nextFromShadowRightY = Vector.normalize(nextFromShadowRightX, nextFromShadowRightY)

                                        local curFromShadowLeftX = curX - curShadow[7]
                                        local curFromShadowLeftY = curY - curShadow[8]
                                        curFromShadowLeftX, curFromShadowLeftY = Vector.normalize(curFromShadowLeftX, curFromShadowLeftY)

                                        local curFromShadowRightX = curX - curShadow[5]
                                        local curFromShadowRightY = curY - curShadow[6]
                                        curFromShadowRightX, curFromShadowRightY = Vector.normalize(curFromShadowRightX, curFromShadowRightY)

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
                                            local reflectionOrigin = Intersection.LineLine( curReflections[reflectionIndex][1], curReflections[reflectionIndex][2],
                                                                                            curReflections[reflectionIndex][1] - curReflections[reflectionIndex][7],
                                                                                            curReflections[reflectionIndex][2] - curReflections[reflectionIndex][8],

                                                                                            curReflections[reflectionIndex][3], curReflections[reflectionIndex][4],
                                                                                            curReflections[reflectionIndex][3] - curReflections[reflectionIndex][5],
                                                                                            curReflections[reflectionIndex][4] - curReflections[reflectionIndex][6])



                                            -- cur is outside the shadow, next is inside the shadow -> reflection gets smaller
                                            if      turnShadowLeftCur  == "left" and turnShadowLeftNext  == "right" and
                                                    turnShadowRightCur == "left" and turnShadowRightNext == "left" then

                                                -- next wird durch intersection mit shadow left ersetzt
                                                local newNext = Intersection.LineLineseg(lightSource.position[1], lightSource.position[2], shadowVecLeftX, shadowVecLeftY, curX, curY, nextX, nextY)
                                                if newNext then
                                                    curReflections[reflectionIndex][1] = newNext[1]
                                                    curReflections[reflectionIndex][2] = newNext[2]

                                                    local newRefDirX = newNext[1] - reflectionOrigin[1]
                                                    local newRefDirY = newNext[2] - reflectionOrigin[2]
                                                    newRefDirX, newRefDirY = Vector.normalize(newRefDirX, newRefDirY)

                                                    curReflections[reflectionIndex][7] = newNext[1] + newRefDirX * Ingame.Lighting.reflectionLength
                                                    curReflections[reflectionIndex][8] = newNext[2] + newRefDirY * Ingame.Lighting.reflectionLength
                                                end
                                            -- cur is inside the shadow, next is outside the shadow -> reflection gets smaller
                                            elseif  turnShadowLeftCur  == "right" and turnShadowLeftNext  == "right" and
                                                    turnShadowRightCur == "left" and turnShadowRightNext == "right" then

                                                -- cur wird durch intersection mit shadow right ersetzt
                                                local newCur = Intersection.LineLineseg(lightSource.position[1], lightSource.position[2], shadowVecRightX, shadowVecRightY, curX, curY, nextX, nextY)
                                                if newCur then
                                                    curReflections[reflectionIndex][3] = newCur[1]
                                                    curReflections[reflectionIndex][4] = newCur[2]

                                                    local newRefDirX = newCur[1] - reflectionOrigin[1]
                                                    local newRefDirY = newCur[2] - reflectionOrigin[2]
                                                    newRefDirX, newRefDirY = Vector.normalize(newRefDirX, newRefDirY)

                                                    curReflections[reflectionIndex][5] = newCur[1] + newRefDirX * Ingame.Lighting.reflectionLength
                                                    curReflections[reflectionIndex][6] = newCur[2] + newRefDirY * Ingame.Lighting.reflectionLength
                                                end

                                            -- both outside, but shadow splits the reflection -> two smaller reflections
                                            elseif  turnShadowLeftCur  == "left" and turnShadowLeftNext  == "right" and
                                                    turnShadowRightCur == "left" and turnShadowRightNext == "right" then

                                                -- intersection mit shadowleft und cur bilden reflection
                                                -- next und intersection mit shadowright bilden reflection
                                                local correspondingToCur = Intersection.LineLineseg(lightSource.position[1], lightSource.position[2], shadowVecLeftX, shadowVecLeftY, curX, curY, nextX, nextY)
                                                local correspondingToNext = Intersection.LineLineseg(lightSource.position[1], lightSource.position[2], shadowVecRightX, shadowVecRightY, curX, curY, nextX, nextY)
                                                if correspondingToCur and correspondingToNext then



                                                    local dirCorrespondingToCurX = correspondingToCur[1] - reflectionOrigin[1]
                                                    local dirCorrespondingToCurY = correspondingToCur[2] - reflectionOrigin[2]
                                                    dirCorrespondingToCurX, dirCorrespondingToCurY = Vector.normalize(dirCorrespondingToCurX, dirCorrespondingToCurY)

                                                    local reflectionWithCur = {}
                                                    reflectionWithCur [1] = correspondingToCur[1]
                                                    reflectionWithCur [2] = correspondingToCur[2]

                                                    reflectionWithCur [3] = curX
                                                    reflectionWithCur [4] = curY

                                                    reflectionWithCur [5] = curReflections[reflectionIndex][5]
                                                    reflectionWithCur [6] = curReflections[reflectionIndex][6]

                                                    reflectionWithCur [7] = correspondingToCur[1] + dirCorrespondingToCurX * Ingame.Lighting.reflectionLength
                                                    reflectionWithCur [8] = correspondingToCur[2] + dirCorrespondingToCurY * Ingame.Lighting.reflectionLength



                                                    local dirCorrespondingToNextX = correspondingToNext[1] - reflectionOrigin[1]
                                                    local dirCorrespondingToNextY = correspondingToNext[2] - reflectionOrigin[2]
                                                    dirCorrespondingToNextX, dirCorrespondingToNextY = Vector.normalize(dirCorrespondingToNextX, dirCorrespondingToNextY)

                                                    local reflectionWithNext = {}
                                                    reflectionWithNext[1] = nextX
                                                    reflectionWithNext[2] = nextY

                                                    reflectionWithNext[3] = correspondingToNext[1]
                                                    reflectionWithNext[4] = correspondingToNext[2]

                                                    reflectionWithNext[5] = correspondingToNext[1] + dirCorrespondingToNextX * Ingame.Lighting.reflectionLength
                                                    reflectionWithNext[6] = correspondingToNext[2] + dirCorrespondingToNextY * Ingame.Lighting.reflectionLength

                                                    reflectionWithNext[7] = curReflections[reflectionIndex][7]
                                                    reflectionWithNext[8] = curReflections[reflectionIndex][8]



                                                    curReflections[reflectionIndex]                   = reflectionWithCur
                                                    curReflections[#curReflections+1]   = reflectionWithNext

                                                end
                                            end -- complex cases
                                        end -- both points inside the shadow
                                    end -- check if a cur or next could be in shadow
                                end -- if curReflections[reflectionIndex]
                            end -- for reflectionIndex=1,#curReflections do
                        end -- if meshIndexInScene ~= shadowIndex
                    end -- for shadowIndex=1,#shadowsInScene do
                end
            end
        end

        for i=1,#curReflections do
           allReflectionsOfPolygons[#allReflectionsOfPolygons + 1] = curReflections[i]
        end

    end
    return allReflectionsOfPolygons
end

function Ingame.Lighting.shadowTestOfReflection(lightSource, mesh, shadowsInScene, meshIndexInScene, curReflections)
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
