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
end

function Ingame.BuildPhase.update(dt)
    if love.timer.getTime() - Ingame.BuildPhase.timeAtActivation > Ingame.BuildPhase.duration then
        Ingame.activateNextPhase()
    end
end

function Ingame.BuildPhase.createGUI()
    Ingame.BuildPhase.GUI = GUI.Container()

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
