--- Button Widget

require "GUI.Label"

GUI.Button = {}
Utilities.OO.createDerivedClass(GUI.Button, GUI.Label)

--- Constructor
-- @param name label text
-- @param onClickFunc function that will be called on release
function GUI.Button:new(name, onClickFunc)
    GUI.Label.new(self, name)

    self.onRelease = onClickFunc
end

--- renders button
function GUI.Button:render()
    self:renderButton()
    self:renderLabel()
end

--- renders the background
function GUI.Button:renderButton()
    if self.backgroundIsImaged then

        if self.isClicked then
            love.graphics.setColor(unpack(self.clickedColor))
            self.clickedImage.position = {self:getLeftAnchor(), self:getTopAnchor()}
            self.clickedImage.width = self:getWidth()
            self.clickedImage.height = self:getHeight()
            self.clickedImage:render()
            return
        end

        if self.isHovered then
            love.graphics.setColor(unpack(self.hoverColor))
            self.hoveredImage.position = {self:getLeftAnchor(), self:getTopAnchor()}
            self.hoveredImage.width = self:getWidth()
            self.hoveredImage.height = self:getHeight()
            self.hoveredImage:render()
            return
        end

        love.graphics.setColor(unpack(self.backgroundColor))
        self.backgroundImage.position = {self:getLeftAnchor(), self:getTopAnchor()}
        self.backgroundImage.width = self:getWidth()
        self.backgroundImage.height = self:getHeight()
        self.backgroundImage:render()
    else
        love.graphics.setColor(unpack(self.borderColor))
        love.graphics.rectangle("line", self:getLeftAnchor(), self:getTopAnchor(), self:getWidth(), self:getHeight())
        love.graphics.setColor(unpack(self.backgroundColor))
        if self.isHovered then
            love.graphics.setColor(unpack(self.hoverColor))
        end
        if self.isClicked then
            love.graphics.setColor(unpack(self.clickedColor))
        end
        love.graphics.rectangle("fill", self:getLeftAnchor(), self:getTopAnchor(), self:getWidth(), self:getHeight())
    end
end
