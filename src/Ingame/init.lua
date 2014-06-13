--- Game Mechanics
Ingame = {}

require "Ingame.BuildPhase"
require "Ingame.SpawnPhase"

require "Ingame.Character"
require "Ingame.TempCharacter"
require "Ingame.Tower"
require "Ingame.LightEmitterTower"
require "Ingame.ReflectorTower"

Ingame.mode = ""
Ingame.ambientColor = {255,255,255}
Ingame.PhaseOrder = {Ingame.BuildPhase, Ingame.SpawnPhase}
Ingame.activePhaseIndex = 0
Ingame.cameraSpeed = 500

--- Initializer
function Ingame.init()
    Ingame.lightEmitterTowers = {}
    Ingame.mobs = {}

    Tilemap.init()

    Ingame.BuildPhase.createGUI()
    Ingame.SpawnPhase.createGUI()
end

function Ingame.startLevel(filePath)
    Ingame.lightEmitterTowers = {}
    Ingame.ReflectorTowers = {}
    Ingame.mobs = {}

    Lighting.lights = {}
    Lighting.curShadowCasters = {}

    Tilemap.addScene():loadMap(filePath)
    Lighting.ambient = Lighting.AmbientLight(255,255,255)
    Ingame.wayPointsForLighting = {}
    Ingame.wayPointsForDarkness = {}

    for x = 1,Tilemap.getActiveScene():getLevelWidth() do
        for y = 1,Tilemap.getActiveScene():getLevelHeight() do
            if Tilemap.tileDict[Tilemap.getActiveScene().tiles[x][y]].name == "waypoint for lighting" then
                Ingame.wayPointsForLighting[#Ingame.wayPointsForLighting+1] = {x,y}
            elseif Tilemap.tileDict[Tilemap.getActiveScene().tiles[x][y]].name == "waypoint for darkness" then
                Ingame.wayPointsForDarkness[#Ingame.wayPointsForDarkness+1] = {x,y}
            end
        end
    end

    Ingame.activePhaseIndex = 0
    Ingame.activateNextPhase()
end

--- Renderer
function Ingame.render()
    if Ingame.activePhaseIndex > 0 then
        Tilemap.render()
    end
end

--- updater
-- @param dt delta time
function Ingame.update(dt)
    if Ingame.activePhaseIndex > 0 then
        for i,curTower in pairs(Ingame.lightEmitterTowers) do
            curTower:shake(dt)
        end

        Ingame.PhaseOrder[Ingame.activePhaseIndex].update(dt)

        Tilemap.update(dt)
    end
    Ingame.mouseCameraMovement(dt)
end

function Ingame.mouseCameraMovement(dt, speed)
    if love.mouse.getX() <= 1 then
        Tilemap.getActiveScene().camera.x = Tilemap.getActiveScene().camera.x - dt * Ingame.cameraSpeed
    elseif love.mouse.getX() >= love.graphics.getWidth()-2 then
        Tilemap.getActiveScene().camera.x = Tilemap.getActiveScene().camera.x + dt * Ingame.cameraSpeed
    end
    if love.mouse.getY() <= 1 then
        Tilemap.getActiveScene().camera.y = Tilemap.getActiveScene().camera.y - dt * Ingame.cameraSpeed
    elseif love.mouse.getY() >= love.graphics.getHeight()-2 then
        Tilemap.getActiveScene().camera.y = Tilemap.getActiveScene().camera.y + dt * Ingame.cameraSpeed
    end
end

function Ingame.activateNextPhase()
    Ingame.activePhaseIndex = Ingame.activePhaseIndex + 1
    Ingame.activePhaseIndex = Ingame.activePhaseIndex % #Ingame.PhaseOrder
    if Ingame.activePhaseIndex == 0 then Ingame.activePhaseIndex = #Ingame.PhaseOrder end
    Ingame.PhaseOrder[Ingame.activePhaseIndex].activate()
end

function Ingame.fadeAmbientLight(ambientColor)
    Game.startCoroutine(coroutine.create(function()
            local factorR, factorG, factorB
            if ambientColor[1] - Lighting.ambient.color[1] < 0 then factorR = -1 else factorR = 1 end
            if ambientColor[2] - Lighting.ambient.color[2] < 0 then factorG = -1 else factorG = 1 end
            if ambientColor[3] - Lighting.ambient.color[3] < 0 then factorB = -1 else factorB = 1 end


            local steps = 100

            while   ambientColor[1] ~= Lighting.ambient.color[1] or
                    ambientColor[2] ~= Lighting.ambient.color[2] or
                    ambientColor[3] ~= Lighting.ambient.color[3] do
                -- change red
                if ambientColor[1] ~= Lighting.ambient.color[1] then
                    local dr = steps * love.timer.getDelta() * factorR

                    if factorR < 0 then
                        if Lighting.ambient.color[1] + dr < ambientColor[1] then
                            Lighting.ambient.color[1] = ambientColor[1]
                            dr = 0
                        end
                    else
                        if Lighting.ambient.color[1] + dr > ambientColor[1] then
                            Lighting.ambient.color[1] = ambientColor[1]
                            dr = 0
                        end
                    end

                    Lighting.ambient.color[1] = Lighting.ambient.color[1] + dr
                end

                -- change green
                if ambientColor[2] ~= Lighting.ambient.color[2] then
                    local dg = steps * love.timer.getDelta() * factorG

                    if factorG < 0 then
                        if Lighting.ambient.color[2] + dg < ambientColor[2] then
                            Lighting.ambient.color[2] = ambientColor[2]
                            dg = 0
                        end
                    else
                        if Lighting.ambient.color[2] + dg > ambientColor[2] then
                            Lighting.ambient.color[2] = ambientColor[2]
                            dg = 0
                        end
                    end


                    Lighting.ambient.color[2] = Lighting.ambient.color[2] + dg
                end

                -- change blue
                if ambientColor[3] ~= Lighting.ambient.color[3] then
                    local db = steps * love.timer.getDelta() * factorB

                    if factorB < 0 then
                        if Lighting.ambient.color[3] + db < ambientColor[3] then
                            Lighting.ambient.color[3] = ambientColor[3]
                            db = 0
                        end
                    else
                        if Lighting.ambient.color[3] + db > ambientColor[3] then
                            Lighting.ambient.color[3] = ambientColor[3]
                            db = 0
                        end
                    end


                    Lighting.ambient.color[3] = Lighting.ambient.color[3] + db
                end

                coroutine.yield()
            end
        end))
end
