--- Phase to spawn enemies
--@author Steve Wolligandt

require "GUI"

Ingame.SpawnPhase = {}
Ingame.SpawnPhase.ambientColor = {10,10,10}
Ingame.SpawnPhase.duration = 10 --seconds
Ingame.SpawnPhase.survivedMobs = 0
Ingame.SpawnPhase.maxSurvivedMobs = 10
Ingame.SpawnPhase.spawnedMobs = 0
Ingame.SpawnPhase.maxSpawnedMobs = 30

--- Activates Spawn Phase
function Ingame.SpawnPhase.activate()
    --Utilities.TextOutput.print("Ingame.SpawnPhase activated")
    Ingame.SpawnPhase.timeAtActivation = love.timer.getTime()
    Tilemap.resume()
    Ingame.fadeAmbientLight(Ingame.SpawnPhase.ambientColor)
    Ingame.SpawnPhase.slideInGUI()
    Ingame.SpawnPhase.spawnedMobs = 0
    Ingame.SpawnPhase.survivedMobs = 0
    Ingame.activeKeyBinding = Ingame.SpawnPhase.KeyBinding
end

--- Updates Spawn Phase
--@param dt delta time
function Ingame.SpawnPhase.update(dt)
    Ingame.SpawnPhasemobCounterLabel.text = Ingame.SpawnPhase.survivedMobs .. " / " .. Ingame.SpawnPhase.maxSurvivedMobs
    --if love.timer.getTime() - Ingame.SpawnPhase.timeAtActivation > Ingame.SpawnPhase.duration then
    if Ingame.SpawnPhase.survivedMobs >= Ingame.SpawnPhase.maxSurvivedMobs then
        Ingame.activateNextPhase()
    elseif Ingame.SpawnPhase.spawnedMobs >= Ingame.SpawnPhase.maxSpawnedMobs then
        for i,curChar in pairs(Ingame.mobs) do
            curChar:destroy()
        end
        Ingame.activateNextPhase()
    end

    for i,curLightSource in pairs(Lighting.lights) do
        for j,curMob in pairs(Ingame.mobs) do
            if curLightSource:isPointInLight(curMob.x, curMob.y) then
                curMob:takeDamage(curLightSource.color[1]*dt, curLightSource.color[2]*dt, curLightSource.color[3]*dt)
            end
        end
    end
end

--- Creates the GUI of the Build Phase
function Ingame.SpawnPhase.createGUI()
    Ingame.SpawnPhase.GUI = GUI.Container(Game.getFont("assets/fonts/nulshock bd.ttf", 30),nil,nil,nil,nil,nil,{255,255,255})

    local phaseLabel = GUI.Label("Gegnerischer Angriff")
    phaseLabel:setBottomAnchor(GUI.Root, "top")
    phaseLabel:setLeftAnchor(GUI.Root, "center")
    phaseLabel:setRightAnchor(GUI.Root, "center")
    phaseLabel.topAnchorOffset = 10
    phaseLabel.bottomAnchorOffset = 50
    phaseLabel.leftAnchorOffset = -100
    phaseLabel.rightAnchorOffset = 100

    Ingame.SpawnPhasemobCounterLabel = GUI.Label(Ingame.SpawnPhase.survivedMobs .. " / " .. Ingame.SpawnPhase.maxSurvivedMobs)
    Ingame.SpawnPhasemobCounterLabel:setTopAnchor(GUI.Root, "bottom")
    Ingame.SpawnPhasemobCounterLabel.bottomAnchorOffset = -10
    Ingame.SpawnPhasemobCounterLabel.topAnchorOffset = -50
    Ingame.SpawnPhasemobCounterLabel.leftAnchorOffset = 10
    Ingame.SpawnPhasemobCounterLabel.rightAnchorOffset = -10

    Ingame.SpawnPhase.GUI:addWidget(phaseLabel)
    Ingame.SpawnPhase.GUI:addWidget(Ingame.SpawnPhasemobCounterLabel)
end

--- Activates the GUI
-- TODO animate GUI activation
function Ingame.SpawnPhase.slideInGUI()
    GUI.activeContainer = Ingame.SpawnPhase.GUI
end

--- Deactivates the GUI
-- TODO animate GUI deactivation
function Ingame.SpawnPhase.slideOutGUI()

end

--- Key Bindings
--@section keys

--- Keybindings
--@field escape open pause menu
--@field left,right,up,down move camera

Ingame.SpawnPhase.KeyBinding = {}

Ingame.SpawnPhase.KeyBinding["escape"] = {
    pressed = function()
        Game.changeState(Testing.Menu)
    end
}

Ingame.SpawnPhase.KeyBinding["left"] = {
    repeated = function(dt)
        Tilemap.getActiveScene().camera.x = Tilemap.getActiveScene().camera.x - dt * Ingame.cameraSpeed
    end
}


Ingame.SpawnPhase.KeyBinding["right"] = {
    repeated = function(dt)
        Tilemap.getActiveScene().camera.x = Tilemap.getActiveScene().camera.x + dt * Ingame.cameraSpeed
    end
}


Ingame.SpawnPhase.KeyBinding["up"] = {
    repeated = function(dt)
        Tilemap.getActiveScene().camera.y = Tilemap.getActiveScene().camera.y - dt * Ingame.cameraSpeed
    end
}


Ingame.SpawnPhase.KeyBinding["down"] = {
    repeated = function(dt)
        Tilemap.getActiveScene().camera.y = Tilemap.getActiveScene().camera.y + dt * Ingame.cameraSpeed
    end
}

