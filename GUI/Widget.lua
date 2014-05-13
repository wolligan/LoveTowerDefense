--- Basic Widget Class - every Widget needs to inherit from this class


require "Intersection"

require "OO"
GUI.Widget = {}
GUI.Widget.counter = 0
OO.createClass(GUI.Widget)

--- Constructor
function GUI.Widget:new()
    self.leftAnchor = GUI.Root.getLeftAnchor
    self.rightAnchor = GUI.Root.getRightAnchor
    self.topAnchor = GUI.Root.getTopAnchor
    self.bottomAnchor = GUI.Root.getBottomAnchor

    self.leftAnchorOffset = 0
    self.rightAnchorOffset = 0
    self.topAnchorOffset = 0
    self.bottomAnchorOffset = 0

    self.isHovered = false
    self.isEnabled = true
    self.isActive = false
    self.isClicked = false

    self.apparentContainer = nil

    self.name = name or "Widget#"..GUI.Widget.counter
    GUI.Widget.counter = GUI.Widget.counter + 1
end

--- renders background
function GUI.Widget:renderBackground()
    love.graphics.setColor(unpack(self.apparentContainer.backgroundColor))
    love.graphics.rectangle("fill", self:getLeftAnchor(), self:getTopAnchor(), self:getWidth(), self:getHeight())
end

--- Anchor functions
-- @section anchor

--- Left Anchor Point of Screen
function GUI.Widget:getLeftAnchor()
    return self:leftAnchor() + self.leftAnchorOffset
end

--- Right Anchor Point of Screen
function GUI.Widget:getRightAnchor()
    return self:rightAnchor() + self.rightAnchorOffset
end

--- Top Anchor Point of Screen
function GUI.Widget:getTopAnchor()
    return self:topAnchor() + self.topAnchorOffset
end

--- Bottom Anchor Point of Screen
function GUI.Widget:getBottomAnchor()
    return self:bottomAnchor() + self.bottomAnchorOffset
end

--- Horizontal Center Anchor Point of Screen
function GUI.Widget:getCenterHorAnchor()
    return (self:leftAnchor() + self.leftAnchorOffset + self:rightAnchor() + self.rightAnchorOffset) / 2
end

--- Vertical Center Anchor Point of Screen
function GUI.Widget:getCenterVerAnchor()
    return (self:topAnchor() + self.topAnchorOffset + self:bottomAnchor() + self.bottomAnchorOffset) / 2
end

--- Functions related to size
-- @section size

--- returns width of widget
function GUI.Widget:getWidth()
    return self:getRightAnchor() - self:getLeftAnchor()
end

--- returns height of widget
function GUI.Widget:getHeight()
    return self:getBottomAnchor() - self:getTopAnchor()
end

--- Callback functions
-- @section callback

--- renders widget
function GUI.Widget:render()
    self:renderBackground()
end

--- updates Widget
-- @param dt delta time
function GUI.Widget:update(dt)
    if Intersection.checkPointRectangle(love.mouse.getX(), love.mouse.getY(), self:getLeftAnchor(),self:getRightAnchor(), self:getTopAnchor(), self:getBottomAnchor()) then
        if not self.isHovered then
           self:onHover()
        end
        self.isHovered = true
    else
        self.isHovered = false
    end
end

--- gets called when mouse cursor hovers
function GUI.Widget:onHover()
    --TextOutput.print("hovered "..self.name)
end

--- gets called when clicked on widget
function GUI.Widget:onClick()
    --TextOutput.print("clicked "..self.name)
end

--- gets called when was click and now released
function GUI.Widget:onRelease()
    --TextOutput.print("released "..self.name)
end
