Ingame.Lighting = {}

require "vector"


Ingame.Lighting.shadowLength = math.sqrt(math.pow(love.graphics.getWidth(), 2) + math.pow(love.graphics.getHeight(), 2))
Ingame.Lighting.reflectionLength = Ingame.Lighting.shadowLength

---
-- @param lightPos lightPos = {x,y}
-- @param polygon shadowCasterPolygon = {x1,y1, x2,y2, ... ,x_n, y_n}
function Ingame.Lighting.getShadowPolygon(lightPos, shadowCasterPolygon)
    local volumeStartPoints = Ingame.Lighting.getShadowVolumeStartPoints(lightPos, shadowCasterPolygon)
    if volumeStartPoints[1] and volumeStartPoints[2] and volumeStartPoints[3] and volumeStartPoints[4] then
        return {volumeStartPoints[1], volumeStartPoints[2],
                volumeStartPoints[3], volumeStartPoints[4],
                volumeStartPoints[3] + (volumeStartPoints[3] - lightPos[1]) * Ingame.Lighting.shadowLength, volumeStartPoints[4] + (volumeStartPoints[4] - lightPos[2]) * Ingame.Lighting.shadowLength,
                volumeStartPoints[1] + (volumeStartPoints[1] - lightPos[1]) * Ingame.Lighting.shadowLength, volumeStartPoints[2] + (volumeStartPoints[2] - lightPos[2]) * Ingame.Lighting.shadowLength}
    end
    return {}
end

---
function Ingame.Lighting.getReflectionPolygon(lightPos, reflectorPolygon, reflectorSides)
    local reflectionPolygon = {}
    local numReflections = 0
    for i=1,#reflectorPolygon,2 do
        local indexCurX = i
        local indexCurY = i + 1

        local indexNextX = (i + 2) % #reflectorPolygon
        local indexNextY = (i + 3) % #reflectorPolygon
        if indexNextX == 0 then indexNextX = #reflectorPolygon end
        if indexNextY == 0 then indexNextY = #reflectorPolygon end

        local curX = reflectorPolygon[indexCurX]
        local curY = reflectorPolygon[indexCurY]

        local nextX = reflectorPolygon[indexNextX]
        local nextY = reflectorPolygon[indexNextY]

        local curLinePointX = nextX - curX
        local curLinePointY = nextY - curY

        local curNormalX =  curLinePointY
        local curNormalY = -curLinePointX
        curNormalX, curNormalY = Vector.normalize(curNormalX, curNormalY)

        local lightVecToCurX = curX - lightPos[1]
        local lightVecToCurY = curY - lightPos[2]
        lightVecToCurX, lightVecToCurY = Vector.normalize(lightVecToCurX, lightVecToCurY)

        local lightVecToNextX = nextX - lightPos[1]
        local lightVecToNextY = nextY - lightPos[2]
        lightVecToNextX, lightVecToNextY = Vector.normalize(lightVecToNextX, lightVecToNextY)

        local dotWithCur = Vector.dot(lightVecToCurX, lightVecToCurY, curNormalX, curNormalY)
        local dotWithNext = Vector.dot(lightVecToNextX, lightVecToNextY, curNormalX, curNormalY)

        if dotWithCur < 0 and dotWithNext < 0 and table.contains(reflectorSides, (i+1)/2) then
            reflectionPolygon[1 + 8*numReflections] = nextX
            reflectionPolygon[2 + 8*numReflections] = nextY

            reflectionPolygon[3 + 8*numReflections] = curX
            reflectionPolygon[4 + 8*numReflections] = curY

            local refWithCurX,  refWithCurY  = Vector.reflect(lightVecToCurX, lightVecToCurY, curNormalX, curNormalY)
            local refWithNextX, refWithNextY = Vector.reflect(lightVecToNextX, lightVecToNextY, curNormalX, curNormalY)

            reflectionPolygon[5 + 8*numReflections] = curX + refWithCurX * Ingame.Lighting.reflectionLength
            reflectionPolygon[6 + 8*numReflections] = curY + refWithCurY * Ingame.Lighting.reflectionLength

            reflectionPolygon[7 + 8*numReflections] = nextX + refWithNextX * Ingame.Lighting.reflectionLength
            reflectionPolygon[8 + 8*numReflections] = nextY + refWithNextY * Ingame.Lighting.reflectionLength

            numReflections = numReflections + 1
        end
    end

    return reflectionPolygon
end

---
-- @param lightPos lightPos = {x,y}
-- @param polygon polygon = {x1,y1, x2,y2, ..., x_n,y_n}
-- @return {x1,y1, x2,y2}
function Ingame.Lighting.getShadowVolumeStartPoints(lightPos, shadowCasterPolygon)
    local volumeStartPoints = {}
    for i=1,#shadowCasterPolygon,2 do
        -- calculate indices
        local indexCurX = i
        local indexCurY = i + 1

        local indexPrevX = (i - 2 + #shadowCasterPolygon) % #shadowCasterPolygon
        local indexPrevY = (i - 1 + #shadowCasterPolygon) % #shadowCasterPolygon
        if indexPrevX == 0 then indexPrevX = #shadowCasterPolygon end
        if indexPrevY == 0 then indexPrevY = #shadowCasterPolygon end

        local indexNextX = (i + 2) % #shadowCasterPolygon
        local indexNextY = (i + 3) % #shadowCasterPolygon
        if indexNextX == 0 then indexNextX = #shadowCasterPolygon end
        if indexNextY == 0 then indexNextY = #shadowCasterPolygon end

        -- get positions
        local curX = shadowCasterPolygon[indexCurX]
        local curY = shadowCasterPolygon[indexCurY]

        local prevX = shadowCasterPolygon[indexPrevX]
        local prevY = shadowCasterPolygon[indexPrevY]

        local nextX = shadowCasterPolygon[indexNextX]
        local nextY = shadowCasterPolygon[indexNextY]

        local lightVecX = curX - lightPos[1]
        local lightVecY = curY - lightPos[2]
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
            volumeStartPoints[1] = curX
            volumeStartPoints[2] = curY
        end

        if (dotBefore <= 0 and dotAfter >= 0) then
            volumeStartPoints[3] = curX
            volumeStartPoints[4] = curY
        end
    end
    return volumeStartPoints
end
