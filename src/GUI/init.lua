--- Simple GUI-Toolkit

GUI = {}

GUI.Root = {}
GUI.activeContainer = nil
GUI.clickTimeDelay = 0.5 -- in seconds

--- Left Anchor Point of Screen
function GUI.Root.getLeftAnchor()
    return 0
end

--- Right Anchor Point of Screen
function GUI.Root.getRightAnchor()
    return love.graphics.getWidth()
end

--- Top Anchor Point of Screen
function GUI.Root.getTopAnchor()
    return 0
end

--- Bottom Anchor Point of Screen
function GUI.Root.getBottomAnchor()
    return love.graphics.getHeight()
end

--- Horizontal Center Anchor Point of Screen
function GUI.Root.getCenterHorAnchor()
    return love.graphics.getWidth()/2
end

--- Vertical Center Anchor Point of Screen
function GUI.Root.getCenterVerAnchor()
    return love.graphics.getHeight()/2
end

--- renders active container
function GUI.render()
    if GUI.activeContainer then
        GUI.activeContainer:render()
    end
end

--- updates active container
function GUI.update(dt)
    if GUI.activeContainer then
        GUI.activeContainer:update(dt)
    end
end

--- notifies click to active container
function GUI.notifyClick()
    if GUI.activeContainer then
        GUI.activeContainer:notifyClick()
    end
end

--- notifies release to active container
function GUI.notifyRelease()
    if GUI.activeContainer then
        GUI.activeContainer:notifyRelease()
    end
end

--- notifies that a key has been pressed
function GUI.notifyKey(key)
    if GUI.activeContainer then
        GUI.activeContainer:notifyKey(key)
    end
end


require "GUI.Container"
require "GUI.Widget"
require "GUI.Label"
require "GUI.Button"
require "GUI.List"
require "GUI.TextEntry"
