require "GUI"
require "TextOutput"

Testing.GUI = {}

function Testing.GUI.init()
    GUI.init()
    --[[
    local w1 = GUI.Widget()
    w1.topAnchor = GUI.Root.getBottomAnchor
    w1.topAnchorOffset = -100
    w1.leftAnchorOffset = 100
    w1.rightAnchorOffset = -100

    local w2 = GUI.Widget()
    w2.bottomAnchor = GUI.Root.getTopAnchor
    w2.bottomAnchorOffset = 100
    w2.leftAnchorOffset = 100
    w2.rightAnchorOffset = -100

    local w3 = GUI.Widget()
    w3.leftAnchor = GUI.Root.getCenterHorAnchor
    w3.rightAnchor = GUI.Root.getCenterHorAnchor
    w3.topAnchor = GUI.Root.getCenterVerAnchor
    w3.bottomAnchor = GUI.Root.getCenterVerAnchor

    w3.leftAnchorOffset = -100
    w3.rightAnchorOffset = 100
    w3.topAnchorOffset = -100
    w3.bottomAnchorOffset = 100
    ]]


    local l1 = GUI.Label("test")
    l1.leftAnchor = GUI.Root.getCenterHorAnchor
    l1.rightAnchor = GUI.Root.getCenterHorAnchor
    l1.topAnchor = GUI.Root.getCenterVerAnchor
    l1.bottomAnchor = GUI.Root.getCenterVerAnchor

    l1.leftAnchorOffset = -100
    l1.rightAnchorOffset = 100
    l1.topAnchorOffset = -50
    l1.bottomAnchorOffset = 50
end

function Testing.GUI.render()
    GUI.render()
end

function Testing.GUI.update(dt)
    GUI.update(dt)
end
