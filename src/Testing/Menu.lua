--- Menu for choosing a test case
--@author Steve Wolligandt

Testing.Menu = {}

Testing.Menu.activeKeyBinding = {}
Testing.Menu.activeKeyBinding["escape"] = {
    pressed = function()
        love.event.push("quit")
    end
}

function Testing.Menu.init()
    Testing.Menu.createMenuGUI()
end

function Testing.Menu.createMenuGUI()
    Testing.Menu.GUIContainer = GUI.Container()

    local list = GUI.List("horizontal", 40, 20)

    list.leftAnchorOffset = 20
    list.rightAnchorOffset = -20
    list.topAnchorOffset = 20

    list:add(GUI.Button("Start Ingame with test.map", function()
        Game.changeState(Ingame)
        Ingame.startLevel("assets/maps/test.map")
    end))
    list:add(GUI.Button("Credits", function() Game.changeState(Credits) end))
    list:add(GUI.Button("Start Level Editor", function() Game.changeState(LevelEditor) end))
    list:add(GUI.Button("Load GUI Test", function() Game.changeState(Testing.GUI) end))
    --list:add(GUI.Button("Load Intersection Test", function() Game.changeState(Testing.Intersection) end))
    list:add(GUI.Button("Load Lighting Test", function() Game.changeState(Testing.Lighting) end))
    list:add(GUI.Button("Load Tilemap Test", function() Game.changeState(Testing.Tilemap) end))
    list:add(GUI.Button("Load Networking Test", function() Game.changeState(Testing.Networking) end))
    --list:add(GUI.Button("Load Threading Test", function() Game.changeState(Testing.Threading) end))
    list:add(GUI.Button("Load Server-Client Tutorial from Löve Wiki with Threads", function() Game.changeState(Testing.ServerClient) end))
    list:addWidgetsToContainer(Testing.Menu.GUIContainer)

    local buttonAnchorVisToggle = GUI.Button("Toggle Anchor Visualization", function() Testing.Menu.GUIContainer.visualizeAnchors = not Testing.Menu.GUIContainer.visualizeAnchors end)
    Testing.Menu.GUIContainer:addWidget(buttonAnchorVisToggle)

    buttonAnchorVisToggle:setTopAnchor(GUI.Root, "bottom")
    buttonAnchorVisToggle:setRightAnchor(GUI.Root, "center")
    buttonAnchorVisToggle.bottomAnchorOffset = -20
    buttonAnchorVisToggle.topAnchorOffset = -60
    buttonAnchorVisToggle.rightAnchorOffset = -20
    buttonAnchorVisToggle.leftAnchorOffset = 20


    local buttonQuit = GUI.Button("Quit", function() love.event.push("quit") end)
    Testing.Menu.GUIContainer:addWidget(buttonQuit)

    buttonQuit:setTopAnchor(GUI.Root, "bottom")
    buttonQuit:setLeftAnchor(GUI.Root, "center")
    buttonQuit.bottomAnchorOffset = -20
    buttonQuit.topAnchorOffset = -60
    buttonQuit.rightAnchorOffset = -20
    buttonQuit.leftAnchorOffset = 20
end
