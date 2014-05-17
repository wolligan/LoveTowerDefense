--- GUI Test creates two containers with buttons and labels, buttons change containers

require "GUI"

Testing.GUI = {}

Testing.GUI.activeKeyBinding = {}
Testing.GUI.activeKeyBinding["escape"] = {
    pressed = function()
        Game.changeState(Testing.Menu)
    end
}

--- creates the gui
function Testing.GUI.init()
-- create containers
    Testing.GUI.createBackground()
    guicont2 = GUI.Container(nil,Utilities.Color.green,nil,{0,200,0},nil,nil,Utilities.Color.black)
    guicont1 = GUI.Container(nil,Utilities.Color.white,nil,{255,255,255,200},{255,255,255,200},nil,Utilities.Color.black)
    Testing.GUI.fillContainer2()
    Testing.GUI.fillContainer1()
end

--- renders gui and some background
function Testing.GUI.render()
    Testing.GUI.renderBackground()
end

--- renders background scene
function Testing.GUI.renderBackground()
    for i=1,30 do
       love.graphics.setColor(unpack(scene[i].color))
       love.graphics.rectangle("fill", scene[i].rect[1],scene[i].rect[2], 100,100)
    end
end

--- creates a scene for some background rendering
function Testing.GUI.createBackground()
   scene = {}
    for i=1,30 do
        scene[i] = {}
        scene[i].color = {math.random(1,3)/0.3*255, math.random(1,3)/0.3*255, math.random(1,3)/0.3*255}

        while scene[i].color[1] == scene[i].color[2] and scene[i].color[1] == scene[i].color[3] do
            scene[i].color = {math.random(1,3)/0.3*255, math.random(1,3)/0.3*255, math.random(1,3)/0.3*255}
        end
        scene[i].rect = {math.random(0,love.graphics.getWidth() - 200), math.random(0,love.graphics.getHeight() - 200)}
    end
end

--- shows how to create container and how to add widgets to it
function Testing.GUI.fillContainer1()

-- create a button
    local b1_cont1 = GUI.Button("Button - Change to Container 2", function()
        GUI.activeContainer = guicont2
    end)

-- set anchors
    b1_cont1:setLeftAnchor(GUI.Root, "left")
    b1_cont1:setRightAnchor(GUI.Root, "right")
    b1_cont1:setTopAnchor(GUI.Root, "bottom")
    b1_cont1:setBottomAnchor(GUI.Root, "bottom")

-- set offsets
    b1_cont1.topAnchorOffset    = -80
    b1_cont1.bottomAnchorOffset = -20
    b1_cont1.leftAnchorOffset   = 20
    b1_cont1.rightAnchorOffset  = -20


-- attach images to button
    b1_cont1:attachImage(Utilities.SlicedSprite( "assets/sprites/GUI/slicedShadedBackground_20_20_20_20.png",
                                            nil,nil,nil,nil,
                                            20, 20, 20, 20 ),
                         Utilities.SlicedSprite( "assets/sprites/GUI/slicedShadedBackgroundPressed_20_20_20_20.png",
                                            nil,nil,nil,nil,
                                            20, 20, 20, 20 ))



    -- create a button
    local b_toggleAnchors = GUI.Button("Toggle Anchor Visualization", function()
        guicont1.visualizeAnchors = not guicont1.visualizeAnchors
    end)

-- set anchors
    b_toggleAnchors:setLeftAnchor(GUI.Root, "right")
    b_toggleAnchors:setRightAnchor(GUI.Root, "right")
    b_toggleAnchors:setTopAnchor(GUI.Root, "top")
    b_toggleAnchors:setBottomAnchor(GUI.Root, "top")

-- set offsets
    b_toggleAnchors.topAnchorOffset    = 20
    b_toggleAnchors.bottomAnchorOffset = 60
    b_toggleAnchors.leftAnchorOffset   = -250
    b_toggleAnchors.rightAnchorOffset  = -20


-- attach images to button
    b_toggleAnchors:attachImage(Utilities.SlicedSprite( "assets/sprites/GUI/slicedShadedBackground_20_20_20_20.png",
                                            nil,nil,nil,nil,
                                            20, 20, 20, 20 ),
                         Utilities.SlicedSprite( "assets/sprites/GUI/slicedShadedBackgroundPressed_20_20_20_20.png",
                                            nil,nil,nil,nil,
                                            20, 20, 20, 20 ))




-- create a label
    local l1_cont1          = GUI.Label("This is Container1")

-- set anchors
    l1_cont1:setLeftAnchor(GUI.Root, "left")
    l1_cont1:setRightAnchor(GUI.Root, "left")
    l1_cont1:setTopAnchor(GUI.Root, "top")
    l1_cont1:setBottomAnchor(GUI.Root, "top")

-- set offsets
    l1_cont1.leftAnchorOffset   = 20
    l1_cont1.rightAnchorOffset  = 200
    l1_cont1.topAnchorOffset    = 20
    l1_cont1.bottomAnchorOffset = 60

-- attach background image
    l1_cont1:attachImage(Utilities.SlicedSprite( "assets/sprites/GUI/slicedShadedBackground_20_20_20_20.png",
                                            nil,nil,nil,nil,
                                            20, 20, 20, 20 ))


-- create 4 more buttons the same way to resize the label
    local b_inc_x_cont1 = GUI.Button(">", function()
        l1_cont1.rightAnchorOffset = l1_cont1.rightAnchorOffset + 2
    end)

    local b_dec_x_cont1 = GUI.Button("<", function()
        l1_cont1.rightAnchorOffset = l1_cont1.rightAnchorOffset - 2
    end)

    local b_inc_y_cont1 = GUI.Button("\\/", function()
        l1_cont1.bottomAnchorOffset = l1_cont1.bottomAnchorOffset + 2
    end)

    local b_dec_y_cont1 = GUI.Button("/\\", function()
        l1_cont1.bottomAnchorOffset = l1_cont1.bottomAnchorOffset - 2
    end)

    b_inc_x_cont1:setLeftAnchor(GUI.Root, "center")
    b_inc_x_cont1:setRightAnchor(GUI.Root, "center")
    b_inc_x_cont1:setTopAnchor(GUI.Root, "center")
    b_inc_x_cont1:setBottomAnchor(GUI.Root, "center")

    b_inc_x_cont1.leftAnchorOffset = 30
    b_inc_x_cont1.rightAnchorOffset = 70
    b_inc_x_cont1.topAnchorOffset = -20
    b_inc_x_cont1.bottomAnchorOffset = 20

    b_dec_x_cont1:setLeftAnchor(GUI.Root, "center")
    b_dec_x_cont1:setRightAnchor(GUI.Root, "center")
    b_dec_x_cont1:setTopAnchor(GUI.Root, "center")
    b_dec_x_cont1:setBottomAnchor(GUI.Root, "center")

    b_dec_x_cont1.leftAnchorOffset = -70
    b_dec_x_cont1.rightAnchorOffset = -30
    b_dec_x_cont1.topAnchorOffset = -20
    b_dec_x_cont1.bottomAnchorOffset = 20

    b_inc_y_cont1:setLeftAnchor(GUI.Root, "center")
    b_inc_y_cont1:setRightAnchor(GUI.Root, "center")
    b_inc_y_cont1:setTopAnchor(GUI.Root, "center")
    b_inc_y_cont1:setBottomAnchor(GUI.Root, "center")

    b_inc_y_cont1.leftAnchorOffset = -20
    b_inc_y_cont1.rightAnchorOffset = 20
    b_inc_y_cont1.topAnchorOffset = 30
    b_inc_y_cont1.bottomAnchorOffset = 70

    b_dec_y_cont1:setLeftAnchor(GUI.Root, "center")
    b_dec_y_cont1:setRightAnchor(GUI.Root, "center")
    b_dec_y_cont1:setTopAnchor(GUI.Root, "center")
    b_dec_y_cont1:setBottomAnchor(GUI.Root, "center")

    b_dec_y_cont1.leftAnchorOffset = -20
    b_dec_y_cont1.rightAnchorOffset = 20
    b_dec_y_cont1.topAnchorOffset = -70
    b_dec_y_cont1.bottomAnchorOffset = -30

-- add buttons and label to container
    guicont1:addWidget(l1_cont1)
    guicont1:addWidget(b1_cont1)
    guicont1:addWidget(b_toggleAnchors)
    guicont1:addWidget(b_inc_x_cont1)
    guicont1:addWidget(b_dec_x_cont1)
    guicont1:addWidget(b_inc_y_cont1)
    guicont1:addWidget(b_dec_y_cont1)
end

--- shows how to create container and how to add widgets to it
function Testing.GUI.fillContainer2()

-- fill container 2
    -- create a button
    local b2_cont2 = GUI.Button("Button - Change to Container 1", function()
        GUI.activeContainer = guicont1
    end)

    b2_cont2:setLeftAnchor(GUI.Root, "left")
    b2_cont2:setRightAnchor(GUI.Root, "right")
    b2_cont2:setTopAnchor(GUI.Root, "bottom")
    b2_cont2:setBottomAnchor(GUI.Root, "bottom")

    b2_cont2.topAnchorOffset = -70
    b2_cont2.bottomAnchorOffset = -20
    b2_cont2.leftAnchorOffset = 20
    b2_cont2.rightAnchorOffset = -20

    -- create a label
    local l2_cont2 = GUI.Label("This is Container2")
    l2_cont2:setLeftAnchor(GUI.Root, "right")
    l2_cont2:setRightAnchor(GUI.Root, "right")
    l2_cont2:setTopAnchor(GUI.Root, "top")
    l2_cont2:setBottomAnchor(GUI.Root, "top")

    l2_cont2.leftAnchorOffset = -220
    l2_cont2.rightAnchorOffset = -20
    l2_cont2.topAnchorOffset = 20
    l2_cont2.bottomAnchorOffset = 50

    -- create list
    local list_cont2 = GUI.List("vertical", 200, 20)

    list_cont2:setLeftAnchor(GUI.Root, "left")
    list_cont2:setRightAnchor(GUI.Root, "left")
    list_cont2:setTopAnchor(GUI.Root, "top")
    list_cont2:setBottomAnchor(b2_cont2, "top")

    list_cont2.leftAnchorOffset = 20
    list_cont2.rightAnchorOffset = 520
    list_cont2.topAnchorOffset = 20
    list_cont2.bottomAnchorOffset = -20

    list_cont2:add(GUI.Label("test1"))
    list_cont2:add(GUI.Label("test2"))
    list_cont2:add(GUI.Label("test3"))
    list_cont2:add(GUI.Label("test4"))
    list_cont2:addWidgetsToContainer(guicont2)


    -- add button and label to container
    guicont2:addWidget(b2_cont2)
    guicont2:addWidget(l2_cont2)
    guicont2:addWidget(list_cont2)
end
