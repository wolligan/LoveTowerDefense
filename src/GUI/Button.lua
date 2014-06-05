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
            love.graphics.setColor(unpack(self.apparentContainer.clickedColor))
            self.clickedImage.position = {self:getLeftAnchor(), self:getTopAnchor()}
            self.clickedImage.width = self:getWidth()
            self.clickedImage.height = self:getHeight()
            self.clickedImage:render()
            return
        end

        if self.isHovered then
            love.graphics.setColor(unpack(self.apparentContainer.hoverColor))
            self.hoveredImage.position = {self:getLeftAnchor(), self:getTopAnchor()}
            self.hoveredImage.width = self:getWidth()
            self.hoveredImage.height = self:getHeight()
            self.hoveredImage:render()
            return
        end

        love.graphics.setColor(unpack(self.apparentContainer.backgroundColor))
        self.backgroundImage.position = {self:getLeftAnchor(), self:getTopAnchor()}
        self.backgroundImage.width = self:getWidth()
        self.backgroundImage.height = self:getHeight()
        self.backgroundImage:render()
    else
        love.graphics.setColor(unpack(self.apparentContainer.borderColor))
        love.graphics.rectangle("line", self:getLeftAnchor(), self:getTopAnchor(), self:getWidth(), self:getHeight())
        love.graphics.setColor(unpack(self.apparentContainer.backgroundColor))
        if self.isHovered then
            love.graphics.setColor(unpack(self.apparentContainer.hoverColor))
        end
        if self.isClicked then
            love.graphics.setColor(unpack(self.apparentContainer.clickedColor))
        end
        love.graphics.rectangle("fill", self:getLeftAnchor(), self:getTopAnchor(), self:getWidth(), self:getHeight())
    end
end
