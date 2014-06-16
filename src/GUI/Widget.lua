--- Basic Widget Class - every Widget needs to inherit from this class.
-- The dimensions and positions are calculated by the anchors of the widget. At default every widget's anchors are at GUI.Root (means every widget is fullscreened).
-- Every Widget gets its apparentContainer, font, backgroundColor, foregroundColor, hoverColor, clickedColor, borderColor and fontColor after adding it to a container.
-- After adding a widget to a container you can change all of the colors or fonts, so that only the widget you change has the new color or font, not the other widgets of the container.
-- Widget provides methods to render label and background.
-- You can attach a sprite as a label or a sliced sprite as a background.
--@classmod Widget


GUI.Widget = {}
GUI.Widget.counter = 0
Utilities.OO.createClass(GUI.Widget)

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

    self.image = nil

    self.name = name or "Widget#"..GUI.Widget.counter
    GUI.Widget.counter = GUI.Widget.counter + 1
end

function GUI.Widget:setApparentContainer(apparentContainer)
    self.apparentContainer = apparentContainer
    self.font = apparentContainer.font
    self.backgroundColor = apparentContainer.backgroundColor
    self.foregroundColor = apparentContainer.foregroundColor
    self.hoverColor = apparentContainer.hoverColor
    self.clickedColor = apparentContainer.clickedColor
    self.borderColor = apparentContainer.borderColor
    self.fontColor = apparentContainer.fontColor
end

function GUI.Widget:isCursorOverWidget()
    return Utilities.Intersection.checkPointRectangle(love.mouse.getX(), love.mouse.getY(), self:getLeftAnchor(), self:getRightAnchor(), self:getTopAnchor(), self:getBottomAnchor())
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

--- sets top anchor position
-- @param widget Widget where topAnchor shall snap
-- @param anchorPos {"bottom", "top", "center"} - anchor pos of widget
function GUI.Widget:setTopAnchor(widget, anchorPos)
    if anchorPos == "bottom" then
        self.topAnchor = function() return widget:getBottomAnchor() end
    elseif anchorPos == "top" then
        self.topAnchor = function() return widget:getTopAnchor() end
    elseif anchorPos == "center" then
        self.topAnchor = function() return widget:getCenterVerAnchor() end
    end
end

--- sets bottom anchor position
-- @param widget Widget where bottomAnchor shall snap
-- @param anchorPos {"bottom", "top", "center"} - anchor pos of widget
function GUI.Widget:setBottomAnchor(widget, anchorPos)
    if anchorPos == "bottom" then
        self.bottomAnchor = function() return widget:getBottomAnchor() end
    elseif anchorPos == "top" then
        self.bottomAnchor = function() return widget:getTopAnchor() end
    elseif anchorPos == "center" then
        self.bottomAnchor = function() return widget:getCenterVerAnchor() end
    end
end

--- sets left anchor position
-- @param widget Widget where leftAnchor shall snap
-- @param anchorPos {"left", "right", "center"} - anchor pos of widget
function GUI.Widget:setLeftAnchor(widget, anchorPos)
    if anchorPos == "left" then
        self.leftAnchor = function() return widget:getLeftAnchor() end
    elseif anchorPos == "right" then
        self.leftAnchor = function() return widget:getRightAnchor() end
    elseif anchorPos == "center" then
        self.leftAnchor = function() return widget:getCenterHorAnchor() end
    end
end

--- sets right anchor position
-- @param widget Widget where rightAnchor shall snap
-- @param anchorPos {"left", "right", "center"} - anchor pos of widget
function GUI.Widget:setRightAnchor(widget, anchorPos)
    if anchorPos == "left" then
        self.rightAnchor = function() return widget:getLeftAnchor() end
    elseif anchorPos == "right" then
        self.rightAnchor = function() return widget:getRightAnchor() end
    elseif anchorPos == "center" then
        self.rightAnchor = function() return widget:getCenterHorAnchor() end
    end
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
    --self:renderBackground()
end

--- updates Widget
-- @param dt delta time
function GUI.Widget:update(dt)

end

--- gets called when mouse cursor hovers
function GUI.Widget:onHover()
    --Utilities.TextOutput.print("hovered "..self.name)
end

--- gets called when clicked on widget
function GUI.Widget:onClick()
    --Utilities.TextOutput.print("clicked "..self.name)
end

--- gets called when was click and now released
function GUI.Widget:onRelease()
    --Utilities.TextOutput.print("released "..self.name)
end

--- notifies that a key has been pressed
function GUI.Widget:notifyKey(key)

end

--- If you call this function the background of the widget will be a sliced sprite that will be positioned automatically
--@param slicedBackgroundSprite Background image that will be rendered centered on the widget
--@param slicedClickedSprite Label image that will be rendered centered on the widget when the widget is clicked
--@param slicedHoveredSprite Label image that will be rendered centered on the widget when the widget is hovered and not clicked
function GUI.Widget:attachBackgroundImage(slicedBackgroundSprite, slicedClickedSprite, slicedHoveredSprite)
    self.backgroundIsImaged = true
    self.backgroundImage = slicedBackgroundSprite
    self.clickedImage = slicedClickedSprite or slicedBackgroundSprite
    self.hoveredImage = slicedHoveredSprite or slicedBackgroundSprite
end

--- If you call this function the label of the widget will be a centered sprite
--@param labelImage Label image that will be rendered centered on the widget
function GUI.Widget:attachLabelImage(labelImage)
    self.labelIsImaged = true
    self.labelImage = labelImage
end

--- Visualize the anchors of this widget
function GUI.Widget:visualizeAnchors()
-- left anchor
    love.graphics.setColor(150,150,0)
    love.graphics.setPointSize(10)
    love.graphics.point(self:getLeftAnchor(), (self:getTopAnchor() + self:getBottomAnchor()) / 2)
    love.graphics.point(self:leftAnchor(), (self:getTopAnchor() + self:getBottomAnchor()) / 2)
    love.graphics.line(self:getLeftAnchor(), (self:getTopAnchor() + self:getBottomAnchor()) / 2, self:leftAnchor(), (self:getTopAnchor() + self:getBottomAnchor()) / 2)

-- right anchor
    love.graphics.setPointSize(10)
    love.graphics.point(self:getRightAnchor(), (self:getTopAnchor() + self:getBottomAnchor()) / 2)
    love.graphics.point(self:rightAnchor(), (self:getTopAnchor() + self:getBottomAnchor()) / 2)
    love.graphics.line(self:getRightAnchor(), (self:getTopAnchor() + self:getBottomAnchor()) / 2, self:rightAnchor(), ((self:getTopAnchor() + self:getBottomAnchor()) / 2))

-- top anchor
    love.graphics.setPointSize(10)
    love.graphics.point((self:getLeftAnchor() + self:getRightAnchor()) / 2, self:getTopAnchor())
    love.graphics.point((self:getLeftAnchor() + self:getRightAnchor()) / 2, self:topAnchor())
    love.graphics.line((self:getLeftAnchor() + self:getRightAnchor()) / 2, self:topAnchor(), (self:getLeftAnchor() + self:getRightAnchor()) / 2, self:getTopAnchor())

-- bottom anchor
    love.graphics.setPointSize(10)
    love.graphics.point((self:getLeftAnchor() + self:getRightAnchor()) / 2, self:getBottomAnchor())
    love.graphics.point((self:getLeftAnchor() + self:getRightAnchor()) / 2, self:bottomAnchor())
    love.graphics.line((self:getLeftAnchor() + self:getRightAnchor()) / 2, self:bottomAnchor(), (self:getLeftAnchor() + self:getRightAnchor()) / 2, self:getBottomAnchor())
end

--- Render functions
-- @section renderf

--- renders background
function GUI.Widget:renderBackground()
    if self.backgroundIsImaged then
        love.graphics.setColor(unpack(self.backgroundColor))
        self.backgroundImage.position = {self:getLeftAnchor(), self:getTopAnchor()}
        self.backgroundImage.width = self:getWidth()
        self.backgroundImage.height = self:getHeight()
        self.backgroundImage:render()
    else
        love.graphics.setLineWidth(0.5)
        love.graphics.setColor(unpack(self.backgroundColor))
        love.graphics.rectangle("fill", self:getLeftAnchor(), self:getTopAnchor(), self:getWidth(), self:getHeight())
        love.graphics.setColor(unpack(self.borderColor))
        love.graphics.rectangle("line", self:getLeftAnchor(), self:getTopAnchor(), self:getWidth(), self:getHeight())
    end
end

--- renders text at center of label
function GUI.Widget:renderLabel()
    if self.labelIsImaged then
        local imageWidth = self.labelImage:getWidth()
        local imageHeight = self.labelImage:getHeight()
        local imagePosX = math.floor(self:getLeftAnchor() + self:getWidth()/2 - imageWidth/2)
        local imagePosY = math.floor(self:getTopAnchor() + self:getHeight()/2 - imageHeight/2)

        love.graphics.setColor(255,255,255)
        love.graphics.draw(self.labelImage, imagePosX, imagePosY)
    else
        local textWidth = self.font:getWidth(self.text)
        local textHeight = self.font:getHeight(self.text)
        local textPosX = math.floor(self:getLeftAnchor() + self:getWidth()/2 - textWidth/2)
        local textPosY = math.floor(self:getTopAnchor() + self:getHeight()/2 - textHeight/2)

        love.graphics.setFont(self.font)
        love.graphics.setColor(unpack(self.fontColor))
        love.graphics.print(self.text, textPosX, textPosY)
    end
end
