--- Container that holds a list of widgets

GUI.Container = {}
Utilities.OO.createClass(GUI.Container)

--- Constructor
-- @param font
-- @param backgroundColor
-- @param foregroundColor
-- @param hoverColor
-- @param clickedColor
-- @param borderColor
-- @param fontColor
function GUI.Container:new(font, backgroundColor, foregroundColor, hoverColor, clickedColor, borderColor, fontColor)
    self.widgets = {}
    --self.font = font or Game.getFont("assets/fonts/comic.ttf")
    self.font = font or Game.getFont("assets/fonts/DejaVuSans.ttf")
    self.backgroundColor = backgroundColor or Utilities.Color.white
    self.foregroundColor = foregroundColor or {150,150,150}
    self.hoverColor = hoverColor or {230,230,230}
    self.clickedColor = clickedColor or {200,200,200}
    self.borderColor = borderColor or {20,20,20}
    self.fontColor = fontColor or {20,20,20}

    self.stencil = function() love.graphics.rectangle("fill", 0,0,love.graphics.getWidth(), love.graphics.getHeight()) end
    GUI.activeContainer = self
end

--- renders all widgets in current GUI container
function GUI.Container:render()
    for i,curWidget in pairs(self.widgets) do
        love.graphics.setStencil(self.stencil)
        curWidget:render()
        if self.visualizeAnchors then
            curWidget:visualizeAnchors()
        end
    end
    love.graphics.setStencil()
end

--- updates current GUI container
function GUI.Container:update(dt)
    for i,curWidget in pairs(self.widgets) do
        if curWidget:isCursorOverWidget() then
            if not curWidget.isHovered then
               curWidget:onHover()
            end
            curWidget.isHovered = true
        else
            curWidget.isHovered = false
        end

        curWidget:update(dt)
        if curWidget.isClicked then
            if love.timer.getTime() - curWidget.timeWhenClicked > GUI.clickTimeDelay and curWidget:isCursorOverWidget() then
               curWidget:onRelease()
            end
        end
    end
end

--- notifies a click
function GUI.Container:notifyClick()
    for i,curWidget in pairs(self.widgets) do
        curWidget.isActive = false
        if curWidget.isHovered then
            curWidget.isClicked = true
            curWidget.isActive = true
            curWidget:onClick()
            curWidget.timeWhenClicked = love.timer.getTime()
        end
    end
end

--- notifies a release
function GUI.Container:notifyRelease()
    for i,curWidget in pairs(self.widgets) do
        if curWidget.isClicked then
            curWidget.isClicked = false
            if curWidget:isCursorOverWidget() then
                curWidget:onRelease()
            end
        end
    end
end

function GUI.Container:notifyKey(key)
    for i,curWidget in pairs(self.widgets) do
        curWidget:notifyKey(key)
    end
end

--- adds a widget to container
-- @param widget widget that shall be added to container
function GUI.Container:addWidget(widget)
    self.widgets[#self.widgets + 1] = widget
    widget:setApparentContainer(self)
end
