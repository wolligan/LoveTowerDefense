--- Basic Widget Class, every Widget needs to inherit from this class


require "Intersection"

require "OO"
GUI.Widget = {}
OO.createClass(GUI.Widget)

--- Constructor
function GUI.Widget:new(name)
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
    self.name = name or "Widget#"..#GUI.widgets + 1

    GUI.widgets[#GUI.widgets + 1] = self

end

--- renders Widget
function GUI.Widget:render()
    love.graphics.setColor(255,255,255)
    love.graphics.rectangle("line", self:getLeftAnchor(), self:getTopAnchor(), self:getWidth(), self:getHeight())
    love.graphics.setColor(255,0,0)
    love.graphics.rectangle("fill", self:getLeftAnchor(), self:getTopAnchor(), self:getWidth(), self:getHeight())
end

--- updates Widget
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

function GUI.Widget:getWidth()
    return self:getRightAnchor() - self:getLeftAnchor()
end

function GUI.Widget:getHeight()
    return self:getBottomAnchor() - self:getTopAnchor()
end

function GUI.Widget:onClick()

end

function GUI.Widget:onHover()
    TextOutput.print("hovered "..self.name)
end
