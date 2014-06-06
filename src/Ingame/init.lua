--- Game Mechanics
Ingame = {}

require "Ingame.BuildPhase"
require "Ingame.SpawnPhase"

require "Ingame.Character"
require "Ingame.TempCharacter"

Ingame.mode = ""
Ingame.ambientColor = {255,255,255}
Ingame.PhaseOrder = {Ingame.BuildPhase, Ingame.SpawnPhase}
Ingame.activePhaseIndex = 0
Ingame.coroutines = {}

--- Initializer
function Ingame.init()
    Tilemap.init()
    Tilemap.addScene():loadMap("test.map")
    Lighting.ambient = Lighting.AmbientLight(255,255,255)
    Lighting.lights =  {Lighting.LightSource(love.graphics.getWidth()/3, love.graphics.getHeight()/2, 50,50,50)}


    Ingame.BuildPhase.createGUI()
    Ingame.SpawnPhase.createGUI()

    Ingame.activateNextPhase()
end

--- Renderer
function Ingame.render()
    Tilemap.render()
end

--- updater
-- @param dt delta time
function Ingame.update(dt)
    Ingame.PhaseOrder[Ingame.activePhaseIndex].update(dt)

    Lighting.lights[1].position = {love.mouse.getX()+0.00001, love.mouse.getY()+0.00001}
    Tilemap.update(dt)
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
