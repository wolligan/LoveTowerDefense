Testing.Menu = {}

function Testing.Menu.init()
    Testing.Menu.createMenuGUI()
end

function Testing.Menu.render()
    GUI.render()
end

function Testing.Menu.update(dt)
    GUI.update(dt)
end

function Testing.Menu.createMenuGUI()
    Testing.Menu.GUIContainer = GUI.Container(nil,Utilities.Color.green,nil,{0,200,0},nil,nil,Utilities.Color.black)

    local buttonLoadGUITest = GUI.Button("Load GUI Test", function() Game.changeState(Testing.GUI) end)
    Testing.Menu.GUIContainer:addWidget(buttonLoadGUITest)

    buttonLoadGUITest.bottomAnchor = GUI.Root.getTopAnchor
    buttonLoadGUITest.bottomAnchorOffset = 60
    buttonLoadGUITest.topAnchorOffset = 20
    buttonLoadGUITest.leftAnchorOffset = 20
    buttonLoadGUITest.rightAnchorOffset = -20



    local buttonLoadIntersectionTest = GUI.Button("Load Intersection Test", function() Game.changeState(Testing.Intersection) end)
    Testing.Menu.GUIContainer:addWidget(buttonLoadIntersectionTest)

    buttonLoadIntersectionTest:setBottomAnchor(buttonLoadGUITest, "bottom")
    buttonLoadIntersectionTest:setTopAnchor(buttonLoadGUITest, "bottom")
    buttonLoadIntersectionTest.bottomAnchorOffset = 60
    buttonLoadIntersectionTest.topAnchorOffset = 20
    buttonLoadIntersectionTest.leftAnchorOffset = 20
    buttonLoadIntersectionTest.rightAnchorOffset = -20



    local buttonLoadLightingTest = GUI.Button("Load Lighting Test", function() Game.changeState(Testing.Lighting) end)
    Testing.Menu.GUIContainer:addWidget(buttonLoadLightingTest)

    buttonLoadLightingTest:setBottomAnchor(buttonLoadIntersectionTest, "bottom")
    buttonLoadLightingTest:setTopAnchor(buttonLoadIntersectionTest, "bottom")
    buttonLoadLightingTest.bottomAnchorOffset = 60
    buttonLoadLightingTest.topAnchorOffset = 20
    buttonLoadLightingTest.leftAnchorOffset = 20
    buttonLoadLightingTest.rightAnchorOffset = -20



    local buttonLoadSlicedSpriteTest = GUI.Button("Load SlicedSprite Test", function() Game.changeState(Testing.SlicedSprite) end)
    Testing.Menu.GUIContainer:addWidget(buttonLoadSlicedSpriteTest)

    buttonLoadSlicedSpriteTest:setBottomAnchor(buttonLoadLightingTest, "bottom")
    buttonLoadSlicedSpriteTest:setTopAnchor(buttonLoadLightingTest, "bottom")
    buttonLoadSlicedSpriteTest.bottomAnchorOffset = 60
    buttonLoadSlicedSpriteTest.topAnchorOffset = 20
    buttonLoadSlicedSpriteTest.leftAnchorOffset = 20
    buttonLoadSlicedSpriteTest.rightAnchorOffset = -20





    local buttonAnchorVisToggle = GUI.Button("Toggle Anchor Visualization", function() Testing.Menu.GUIContainer.visualizeAnchors = not Testing.Menu.GUIContainer.visualizeAnchors end)
    Testing.Menu.GUIContainer:addWidget(buttonAnchorVisToggle)

    buttonAnchorVisToggle:setTopAnchor(GUI.Root, "bottom")
    buttonAnchorVisToggle:setLeftAnchor(GUI.Root, "center")
    buttonAnchorVisToggle.bottomAnchorOffset = -20
    buttonAnchorVisToggle.topAnchorOffset = -60
    buttonAnchorVisToggle.rightAnchorOffset = -20
end
