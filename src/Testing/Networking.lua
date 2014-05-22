--- Testing module for Networking
require "Networking"

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

function startServer() -- TODO make port as user input
    Networking.spawnServer()
end

function connectToServer()

end

function Testing.Networking.createGUI()

    Testing.Networking.GUI = GUI.Container(nil,Utilities.Color.white,nil,{255,255,255,200},{255,255,255,200},nil,Utilities.Color.black)
-- create a label
    local label = GUI.Label("Networking Test")
    label:setBottomAnchor(GUI.Root, "top")
    label.leftAnchorOffset   = 20
    label.rightAnchorOffset  = -20
    label.topAnchorOffset    = 20
    label.bottomAnchorOffset = 60

-- create server start button
    local startServerButton = GUI.Button("Start Server", function()
            startServer() end
        )
-- create server stop button
    local serverStopButton = GUI.Button("Stop Server", function()
            stopServer() end
        )
-- create client start button
    local connectButton = GUI.Button("Connect to IP", function()
            connectToServer() end
        )

    startServerButton:setTopAnchor(GUI.Root, "bottom")
    startServerButton:setRightAnchor(GUI.Root, "center")
    startServerButton.leftAnchorOffset   = 20
    startServerButton.rightAnchorOffset  = -20
    startServerButton.topAnchorOffset    = -60
    startServerButton.bottomAnchorOffset = -20

    connectButton:setTopAnchor(GUI.Root, "bottom")
    connectButton:setLeftAnchor(GUI.Root, "center")
    connectButton.leftAnchorOffset   = 20
    connectButton.rightAnchorOffset  = -20
    connectButton.topAnchorOffset    = -60
    connectButton.bottomAnchorOffset = -20

    serverStopButton:setTopAnchor(startServerButton, "top")
    serverStopButton:setBottomAnchor(startServerButton, "top")
    serverStopButton:setRightAnchor(GUI.Root, "center")
    serverStopButton.leftAnchorOffset   = 20
    serverStopButton.rightAnchorOffset  = -20
    serverStopButton.topAnchorOffset    = -60
    serverStopButton.bottomAnchorOffset = -20

    Testing.Networking.GUI:addWidget(startServerButton)
    Testing.Networking.GUI:addWidget(connectButton)
    Testing.Networking.GUI:addWidget(serverStopButton)
end
