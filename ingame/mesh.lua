require "OO"

Ingame.Mesh = {}
OO.createClass(Ingame.Mesh)

function Ingame.Mesh:new(vertices, color, reflectorSides)
   self.vertices = vertices or {}
   self.color = color or {255, 255, 255}
   self.reflectorSides = reflectorSides or {}
end

function Ingame.Mesh.createDiscoCircle(x,y, size, slices)
    local vertices = {}
    local reflectorSides = {}

    for i = 0,(slices-1) do
        local percentage = i/slices

        local curVertX =  math.cos(percentage * math.pi * 2)*size + x
        local curVertY = -math.sin(percentage * math.pi * 2)*size + y

        vertices[i*2 + 1] = curVertX
        vertices[i*2 + 2] = curVertY

        reflectorSides[i+1] = i+1

    end

    return Ingame.Mesh(vertices, {255,255,255}, reflectorSides)
end
