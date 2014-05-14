Utilities.SlicedSprite = {}
Utilities.OO.createClass(Utilities.SlicedSprite)

function Utilities.SlicedSprite:new(pathToImage, x,y, width, height, borderLeft, borderRight, borderTop, borderBottom)
    self.image = Game.getSprite(pathToImage)
    self.position = {x or 0, y or 0}

    self.width = width or self.image.getWidth()
    self.height = height or self.image.getHeight()

    self.borderLeft = borderLeft or 0
    self.borderRight = borderRight or 0
    self.borderTop = borderTop or 0
    self.borderBottom = borderBottom or 0
end

function Utilities.SlicedSprite:render()


    --[[

    posX1       posX3
       posX2
    |--|--------|--|    posY1
    |  |        |  |
  --+--+--------+--+-   posY2
    |  |        |  |
    |  |        |  |
    |  |        |  |
  --+--+--------+--+-   posY3
    |  |        |  |
    |--|--------|--|


    ]]

    local posX1 = self.position[1]
    local posY1 = self.position[2]

    local posX2 = self.position[1] + self.borderLeft
    local posY2 = self.position[2] + self.borderTop

    local posX3 = self.position[1] + self.width - self.borderRight
    local posY3 = self.position[2] + self.height - self.borderBottom



    love.graphics.setColor(255,0,0)
    love.graphics.setPointSize(10)
    love.graphics.point(unpack(self.position))

    love.graphics.setColor(255,255,255)
    -- render top left
    love.graphics.draw( self.image,
                        love.graphics.newQuad(0,0,self.borderLeft, self.borderTop, self.image:getWidth(), self.image:getHeight()),
                        posX1, posY1)

    -- render top right
    love.graphics.draw( self.image,
                        love.graphics.newQuad(self.image:getWidth() - self.borderRight, 0, self.borderRight, self.borderTop, self.image:getWidth(), self.image:getHeight()),
                        posX3, posY1)

    -- render bottom left
    love.graphics.draw( self.image,
                        love.graphics.newQuad(0, self.image:getHeight() - self.borderBottom, self.borderLeft, self.borderBottom, self.image:getWidth(), self.image:getHeight()),
                        posX1, posY3)

    -- render bottom right
    love.graphics.draw( self.image,
                        love.graphics.newQuad(self.image:getWidth() - self.borderRight, self.image:getHeight() - self.borderBottom, self.borderRight, self.borderBottom, self.image:getWidth(), self.image:getHeight()),
                        posX3, posY3)

    -- render center
    love.graphics.draw( self.image,
                        love.graphics.newQuad(self.borderLeft, self.borderTop, self.image:getWidth() - self.borderLeft - self.borderRight, self.image:getHeight() - self.borderTop - self.borderBottom, self.image:getWidth(), self.image:getHeight()),
                        posX2, posY2, 0,
                        (self.width - self.borderLeft - self.borderRight) / (self.image:getWidth() - self.borderLeft - self.borderRight),
                        (self.height - self.borderTop - self.borderBottom) / (self.image:getHeight() - self.borderTop - self.borderBottom))

    -- render top
    love.graphics.draw( self.image,
                        love.graphics.newQuad(self.borderLeft, 0, self.image:getWidth() - self.borderLeft - self.borderRight, self.borderTop, self.image:getWidth(), self.image:getHeight()),
                        posX2, posY1, 0,
                        (self.width - self.borderLeft - self.borderRight) / (self.image:getWidth() - self.borderLeft - self.borderRight),
                        1)

    -- render bottom
    love.graphics.draw( self.image,
                        love.graphics.newQuad(self.borderLeft, self.image:getHeight() - self.borderBottom, self.image:getWidth() - self.borderLeft - self.borderRight, self.borderBottom, self.image:getWidth(), self.image:getHeight()),
                        posX2, posY3, 0,
                        (self.width - self.borderLeft - self.borderRight) / (self.image:getWidth() - self.borderLeft - self.borderRight),
                        1)

    -- render left
    love.graphics.draw( self.image,
                        love.graphics.newQuad(0, self.borderTop, self.borderLeft, self.image:getHeight() - self.borderTop - self.borderBottom, self.image:getWidth(), self.image:getHeight()),
                        posX1, posY2, 0,
                        1,
                        (self.height - self.borderTop - self.borderBottom) / (self.image:getHeight() - self.borderTop - self.borderBottom))

    -- render right
    love.graphics.draw( self.image,
                        love.graphics.newQuad(self.image:getWidth() - self.borderRight, self.borderTop, self.borderRight, self.image:getHeight() - self.borderTop - self.borderBottom, self.image:getWidth(), self.image:getHeight()),
                        posX3, posY2, 0,
                        1,
                        (self.height - self.borderTop - self.borderBottom) / (self.image:getHeight() - self.borderTop - self.borderBottom))
end
