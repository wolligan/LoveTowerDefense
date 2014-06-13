--- Mesh Class can be used for lighting or just for rendering
--@author Steve Wolligandt

Geometry.Mesh = {}
Utilities.OO.createClass(Geometry.Mesh)

--- Constructor
-- @param x Y-coordinate
-- @param y x-coordinate
-- @param vertices {x1,y1, x2, y2, x3, y3, ...}
-- @param color {r,g,b}
-- @param reflectorSides {sideIndex1, sideIndex2, ...}
function Geometry.Mesh:new(x,y, vertices, color, reflectorSides)
    self.position = {x,y}
    self.vertices = vertices or {}
    self.color = color or {255, 255, 255}
    self.reflectorSides = reflectorSides or {}
end

--- Creates a circle-like mesh, all sides are reflectorSides
-- @param x x-coordinate
-- @param y y-coordinate
-- @param size radius of mesh
-- @param slices number of slices the "circle" will have
-- @param color color of the mesh
function Geometry.Mesh.createDiscoCircle(x,y, size, slices, color)
    local vertices = {}
    local reflectorSides = {}

    for i = 0,(slices-1) do
        local percentage = i/slices

        local curVertX =   math.cos(percentage * math.pi * 2)*size
        local curVertY = - math.sin(percentage * math.pi * 2)*size

        vertices[i*2 + 1] = curVertX
        vertices[i*2 + 2] = curVertY

        reflectorSides[i+1] = i+1

    end

    return Geometry.Mesh(x,y, vertices, color, reflectorSides)
end

--- Creates a circle-like mesh
-- @param x x-coordinate
-- @param y y-coordinate
-- @param size radius of mesh
-- @param color color of the mesh
-- @param reflectorSides {sideIndex1, sideIndex2, ...}
function Geometry.Mesh.createRectangle(x,y, size, color, reflectorSides)
    local vertices = {}
    color = color or Color.white
    reflectorSides = reflectorSides or {1,2,3,4}
    vertices = {- size,   size,
                  size,   size,
                  size, - size,
                - size, - size}

    return Geometry.Mesh(x,y, vertices, color, reflectorSides)
end

--- renders the mesh
function Geometry.Mesh:render()
    love.graphics.push()
    love.graphics.translate(unpack(self.position))
    love.graphics.setColor(unpack(self.color))
    love.graphics.polygon("fill", self.vertices)
    love.graphics.pop()
end

--- returns a list of all vertices in world coordinates
-- @return {x1,y1, x2,y2, x3,y3, ...}
function Geometry.Mesh:getWorldVertices()
    local worldVertices = {}
    for i=1,#self.vertices,2 do
        worldVertices[i]   = self.vertices[i]   + self.position[1]
        worldVertices[i+1] = self.vertices[i+1] + self.position[2]
    end

    return worldVertices
end
