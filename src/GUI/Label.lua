--- Label Widget
--@classmod Label

require "GUI.Widget"

GUI.Label = {}
Utilities.OO.createDerivedClass(GUI.Label, GUI.Widget)

--- Constructor of Label
-- @param text Text of Label
function GUI.Label:new(text)
    GUI.Widget.new(self)
    self.text = text or ""
end

--- Renders widget with a text field on top of it
function GUI.Label:render()
    --self:renderBackground()
    self:renderLabel()
end
