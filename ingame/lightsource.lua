require "OO"

Ingame.LightSource = {}
OO.createClass(Ingame.LightSource)

function Ingame.LightSource:new(x,y, r,g,b)
    self.position = {}
    self.position[1] = x or 0
    self.position[2] = y or 0

    self.color = {r or 255, g or 255, b or 255}
end
