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
function GUI.Container:new(font, backgroundColor, foregroundColor, hoverColor, clickedColor, borderColor, fontColor )
    self.widgets = {}
    self.font = font or Game.getFont("assets/fonts/comic.ttf")
    --self.font = font or Game.getFont("assets/fonts/DejaVuSans-ExtraLight.ttf")
    self.backgroundColor = bgColor or {100,100,100}
    self.foregroundColor = fgColor or {150,150,150}
    self.hoverColor = hoverColor or {80,80,80}
    self.clickedColor = clickedColor or {50,50,50}
    self.borderColor = borderColor or Utilities.Color.white
    self.fontColor = fontColor or Utilities.Color.white

    GUI.activeContainer = self
end

--- renders all widgets in current GUI container
function GUI.Container:render()
    for i,curWidget in pairs(self.widgets) do
        curWidget:render()
    end
end

--- updates current GUI container
function GUI.Container:update(dt)
    for i,curWidget in pairs(self.widgets) do
        curWidget:update(dt)
    end
end

--- notifies a click
function GUI.Container:notifyClick()
   for i,curWidget in pairs(self.widgets) do
        if curWidget.isHovered then
            curWidget.isClicked = true
            curWidget:onClick()
        end
    end
end

--- notifies a release
function GUI.Container:notifyRelease()
    for i,curWidget in pairs(self.widgets) do
        if curWidget.isClicked then
            curWidget.isClicked = false
            curWidget:onRelease()
        end
    end
end

--- adds a widget to container
-- @param widget widget that shall be added to container
function GUI.Container:addWidget(widget)
    self.widgets[#self.widgets + 1] = widget
    widget.apparentContainer = self
end
