GUI.List = {}
Utilities.OO.createDerivedClass(GUI.List, GUI.Widget)

--- Constructor
-- @param alignment {"horizontal", "vertical"}
-- @param widgetSize Space for Widgets
-- @param paddingBetweenWidgets Space between widgets
-- @param paddingTop First widget in list will be moved to left/down a bit
function GUI.List:new(alignment, widgetSize, paddingBetweenWidgets, paddingTop)
    GUI.Widget.new(self)
    self.alignment = alignment or "horizontal"
    self.widgetSize = widgetSize
    self.paddingBetweenWidgets = paddingBetweenWidgets or 1
    self.paddingTop = paddingTop or 0

    self.widgets = {}
end

--- adds a widget to list and positions and resizes it correctly
-- @param widget Widget that shall be added to list
function GUI.List:add(widget)
    if self.alignment == "horizontal" then
        widget:setLeftAnchor(self, "left")
        widget:setRightAnchor(self, "right")
        if #self.widgets > 0 then
            widget:setTopAnchor(self.widgets[#self.widgets], "bottom")
            widget:setBottomAnchor(self.widgets[#self.widgets], "bottom")
            widget.topAnchorOffset = self.paddingBetweenWidgets
            widget.bottomAnchorOffset = self.paddingBetweenWidgets + self.widgetSize
        else
            widget:setTopAnchor(self, "top")
            widget:setBottomAnchor(self, "top")
            widget.topAnchorOffset = self.paddingTop
            widget.bottomAnchorOffset = self.paddingTop + self.widgetSize
        end
    elseif self.alignment == "vertical" then
        widget:setTopAnchor(self, "top")
        widget:setBottomAnchor(self, "bottom")
        if #self.widgets > 0 then
            widget:setLeftAnchor(self.widgets[#self.widgets], "right")
            widget:setRightAnchor(self.widgets[#self.widgets], "right")
            widget.leftAnchorOffset = self.paddingBetweenWidgets
            widget.rightAnchorOffset = self.paddingBetweenWidgets + self.widgetSize
        else
            widget:setLeftAnchor(self, "left")
            widget:setRightAnchor(self, "left")
            widget.leftAnchorOffset = self.paddingTop
            widget.rightAnchorOffset = self.paddingTop + self.widgetSize
        end
    end
    self.widgets[#self.widgets + 1] = widget
    return widget
end

--- Adds all added widgets to a container
-- @usage Call this function when all widgets are added in list
-- @param container GUI.Container that shall be filled with widgets
function GUI.List:addWidgetsToContainer(container)
    for i,curWidget in pairs(self.widgets) do
        container:addWidget(curWidget)
    end
end
