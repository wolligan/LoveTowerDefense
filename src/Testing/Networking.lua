--- Testing module for Networking
Testing.Networking = {}

Testing.Networking.activeKeyBinding = {}
Testing.Networking.activeKeyBinding["escape"] = {
    pressed = function()
        Game.changeState(Testing.Menu)
    end
}

function Testing.Networking.init()
    Testing.Networking.createGUI()
end

function Testing.Networking.render()

end

function Testing.Networking.update(dt)

end

function Testing.Networking.createGUI()

    Testing.Networking.GUI = GUI.Container(nil,Utilities.Color.white,nil,{255,255,255,200},{255,255,255,200},nil,Utilities.Color.black)
-- create a label
    local label = GUI.Label("Networking Test")
-- set anchors
    label:setBottomAnchor(GUI.Root, "top")
-- set offsets
    label.leftAnchorOffset   = 20
    label.rightAnchorOffset  = -20
    label.topAnchorOffset    = 20
    label.bottomAnchorOffset = 60

    Testing.Networking.GUI:addWidget(label)
end
