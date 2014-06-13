---
--@author Steve Wolligandt

require "GUI"

Ingame.BuildPhase = {}
Ingame.BuildPhase.ambientColor = {100,100,100}
Ingame.BuildPhase.duration = 10 --seconds

Ingame.BuildPhase.buildTowerAt = function(x,y)
    Tilemap.getActiveScene().characters[#Tilemap.getActiveScene().characters+1] =
        Ingame.LightEmitterTower(Tilemap.getActiveScene(),
                                 x*Tilemap.Settings.tileSize - Tilemap.Settings.tileSize/2,
                                 y*Tilemap.Settings.tileSize - Tilemap.Settings.tileSize/2)
end

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

    local towerList = GUI.List("horizontal", 60)
    towerList.setLeftAnchor(GUI.Root, "right")
    towerList.topAnchorOffset = 150

    local buttonEmitter = towerList:add(GUI.Button("Lichtemitter", function()
                Ingame.BuildPhase.buildTowerAt = function(x,y)
                    Tilemap.getActiveScene().characters[#Tilemap.getActiveScene().characters+1] =
                    Ingame.LightEmitterTower(Tilemap.getActiveScene(),
                                             x*Tilemap.Settings.tileSize - Tilemap.Settings.tileSize/2,
                                             y*Tilemap.Settings.tileSize - Tilemap.Settings.tileSize/2)
                end
            end
        )
    )

    local buttonReflector = towerList:add(GUI.Button("Reflector", function()
                Ingame.BuildPhase.buildTowerAt = function(x,y)
                    Tilemap.getActiveScene().characters[#Tilemap.getActiveScene().characters+1] =
                    Ingame.ReflectorTower(Tilemap.getActiveScene(),
                                          x*Tilemap.Settings.tileSize - Tilemap.Settings.tileSize/2,
                                          y*Tilemap.Settings.tileSize - Tilemap.Settings.tileSize/2)
                end
            end
        )
    )

    towerList:addWidgetsToContainer(Ingame.BuildPhase.GUI)
    Ingame.BuildPhase.GUI:addWidget(phaseLabel)

    buttonEmitter.backgroundColor = {255,255,255,100}
    buttonReflector.backgroundColor = {255,255,255,100}
    buttonEmitter.borderColor = {50,50,50}
    buttonReflector.borderColor = {50,50,50}
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
            Ingame.BuildPhase.buildTowerAt(x,y)
            Tilemap.getActiveScene().tiles[x][y] = 4
        end
    end
}

Ingame.BuildPhase.KeyBinding["escape"] = {
    pressed = function()
        Game.changeState(Testing.Menu)
    end
}

Ingame.BuildPhase.KeyBinding["left"] = {
    repeated = function(dt)
        Tilemap.getActiveScene().camera.x = Tilemap.getActiveScene().camera.x - dt * Ingame.cameraSpeed
    end
}


Ingame.BuildPhase.KeyBinding["right"] = {
    repeated = function(dt)
        Tilemap.getActiveScene().camera.x = Tilemap.getActiveScene().camera.x + dt * Ingame.cameraSpeed
    end
}


Ingame.BuildPhase.KeyBinding["up"] = {
    repeated = function(dt)
        Tilemap.getActiveScene().camera.y = Tilemap.getActiveScene().camera.y - dt * Ingame.cameraSpeed
    end
}


Ingame.BuildPhase.KeyBinding["down"] = {
    repeated = function(dt)
        Tilemap.getActiveScene().camera.y = Tilemap.getActiveScene().camera.y + dt * Ingame.cameraSpeed
    end
}
