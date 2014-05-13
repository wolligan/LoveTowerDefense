--- GUI Test creates two containers with buttons and labels, buttons change containers

require "GUI"
require "TextOutput"

Testing.GUI = {}

--- creates the gui
function Testing.GUI.init()
-- create containers
    local guicont2 = GUI.Container()
    local guicont1 = GUI.Container()

    local b1_cont1 = GUI.Button("Button - Change to Container 2", function()
        TextOutput.print("Button Click From Container 1")
        GUI.activeContainer = guicont2
    end)

-- fill container 1
    -- create a button
    b1_cont1.leftAnchor = GUI.Root.getLeftAnchor
    b1_cont1.rightAnchor = GUI.Root.getRightAnchor
    b1_cont1.topAnchor = GUI.Root.getBottomAnchor
    b1_cont1.bottomAnchor = GUI.Root.getBottomAnchor

    b1_cont1.topAnchorOffset = -70
    b1_cont1.bottomAnchorOffset = -20

    -- create a label
    local l1_cont1 = GUI.Label("Label - Container1")
    l1_cont1.leftAnchor = GUI.Root.getLeftAnchor
    l1_cont1.rightAnchor = GUI.Root.getLeftAnchor
    l1_cont1.topAnchor = GUI.Root.getTopAnchor
    l1_cont1.bottomAnchor = GUI.Root.getTopAnchor

    l1_cont1.leftAnchorOffset = 20
    l1_cont1.rightAnchorOffset = 220
    l1_cont1.topAnchorOffset = 20
    l1_cont1.bottomAnchorOffset = 50

    -- add button and label to container
    guicont1:addWidget(b1_cont1)
    guicont1:addWidget(l1_cont1)

-- fill container 2
    -- create a button
    local b2_cont2 = GUI.Button("Button - Change to Container 1", function()
        TextOutput.print("Button Click From Container 2")
        GUI.activeContainer = guicont1
    end)

    b2_cont2.leftAnchor = GUI.Root.getLeftAnchor
    b2_cont2.rightAnchor = GUI.Root.getRightAnchor
    b2_cont2.topAnchor = GUI.Root.getBottomAnchor
    b2_cont2.bottomAnchor = GUI.Root.getBottomAnchor

    b2_cont2.topAnchorOffset = -70
    b2_cont2.bottomAnchorOffset = -20

    -- create a label
    local l2_cont2 = GUI.Label("Label - Container2")
    l2_cont2.leftAnchor = GUI.Root.getRightAnchor
    l2_cont2.rightAnchor = GUI.Root.getRightAnchor
    l2_cont2.topAnchor = GUI.Root.getTopAnchor
    l2_cont2.bottomAnchor = GUI.Root.getTopAnchor

    l2_cont2.leftAnchorOffset = -220
    l2_cont2.rightAnchorOffset = -20
    l2_cont2.topAnchorOffset = 20
    l2_cont2.bottomAnchorOffset = 50

    -- add button and label to container
    guicont2:addWidget(b2_cont2)
    guicont2:addWidget(l2_cont2)
end

--- renders gui
function Testing.GUI.render()
    GUI.render()
end

--- renders updates gui
-- @param dt delta time
function Testing.GUI.update(dt)
    GUI.update(dt)
end
