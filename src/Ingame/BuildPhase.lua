require "GUI"

Ingame.BuildPhase = {}
Ingame.BuildPhase.ambientColor = {100,100,100}
Ingame.BuildPhase.duration = 10 --seconds

function Ingame.BuildPhase.activate()
    --Utilities.TextOutput.print("Ingame.BuildPhase activated")
    Ingame.BuildPhase.timeAtActivation = love.timer.getTime()
    Tilemap.pause()
    Ingame.fadeAmbientLight(Ingame.BuildPhase.ambientColor)
    Ingame.BuildPhase.slideInGUI()
    Ingame.activeKeyBinding = Ingame.BuildPhase.KeyBinding
end

function Ingame.BuildPhase.update(dt)
    if love.timer.getTime() - Ingame.BuildPhase.timeAtActivation > Ingame.BuildPhase.duration then
        Ingame.activateNextPhase()
    end
end

function Ingame.BuildPhase.createGUI()
    Ingame.BuildPhase.GUI = GUI.Container(Game.getFont("assets/fonts/nulshock bd.ttf", 30),nil,nil,nil,nil,nil,{255,255,255})

    local phaseLabel = GUI.Label("Bauphase")
    phaseLabel:setBottomAnchor(GUI.Root, "top")
    phaseLabel:setLeftAnchor(GUI.Root, "center")
    phaseLabel:setRightAnchor(GUI.Root, "center")
    phaseLabel.topAnchorOffset = 10
    phaseLabel.bottomAnchorOffset = 50
    phaseLabel.leftAnchorOffset = -100
    phaseLabel.rightAnchorOffset = 100

    Ingame.BuildPhase.GUI:addWidget(phaseLabel)
end

function Ingame.BuildPhase.slideInGUI()
    GUI.activeContainer = Ingame.BuildPhase.GUI
end

function Ingame.BuildPhase.slideOutGUI()

end

Ingame.BuildPhase.KeyBinding = {}
Ingame.BuildPhase.KeyBinding[" "] = {
    pressed = function()
        Utilities.TextOutput.print("Space at Building")
    end
}

Ingame.BuildPhase.KeyBinding["mouse_left"] = {
    pressed = function()
        local x,y = Tilemap.getActiveScene():getTileCoordinatesByCamera(love.mouse.getX(), love.mouse.getY())
        if x > 0 and y > 0 and x <= Tilemap.getActiveScene():getLevelWidth() and y <= Tilemap.getActiveScene():getLevelHeight() and Tilemap.tileDict[Tilemap.getActiveScene().tiles[x][y]].name == "tower build point" then
            Tilemap.getActiveScene().characters[#Tilemap.getActiveScene().characters+1] = Ingame.LightEmitterTower( Tilemap.getActiveScene(),
                                                                                                        x*Tilemap.Settings.tileSize - Tilemap.Settings.tileSize/2,
                                                                                                        y*Tilemap.Settings.tileSize - Tilemap.Settings.tileSize/2)
            Tilemap.getActiveScene().tiles[x][y] = 4
        end
    end
}

Ingame.BuildPhase.KeyBinding["escape"] = {
    pressed = function()
        Game.changeState(Testing.Menu)
    end
}
