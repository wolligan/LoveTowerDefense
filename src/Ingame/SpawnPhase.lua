require "GUI"

Ingame.SpawnPhase = {}
Ingame.SpawnPhase.ambientColor = {10,10,10}
Ingame.SpawnPhase.duration = 10 --seconds
Ingame.SpawnPhase.survivedMobs = 0
Ingame.SpawnPhase.maxSurvivedMobs = 10
Ingame.SpawnPhase.spawnedMobs = 0
Ingame.SpawnPhase.maxSpawnedMobs = 30

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


end

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

function Ingame.SpawnPhase.slideInGUI()
    GUI.activeContainer = Ingame.SpawnPhase.GUI
end

function Ingame.SpawnPhase.slideOutGUI()

end

Ingame.SpawnPhase.KeyBinding = {}
Ingame.SpawnPhase.KeyBinding[" "] = {
    pressed = function()
        Utilities.TextOutput.print("Space at Spawning")
    end
}

Ingame.SpawnPhase.KeyBinding["escape"] = {
    pressed = function()
        Game.changeState(Testing.Menu)
    end
}