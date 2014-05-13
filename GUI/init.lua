--- Simple GUI-Toolkit

GUI = {}
GUI.widgets = {}
GUI.Root = {}

function GUI.init()
    GUI.font = Game.getFont("assets/fonts/comic.ttf", 12)
end

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

--- renders all loaded widgets
function GUI.render()
    for i,curWidget in pairs(GUI.widgets) do
        curWidget:render()
    end
end

--- updates GUI
function GUI.update(dt)
    for i,curWidget in pairs(GUI.widgets) do
        curWidget:update(dt)
    end
end



require "GUI.Widget"
require "GUI.Label"
