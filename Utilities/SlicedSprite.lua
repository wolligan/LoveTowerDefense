Utilities.SlicedSprite = {}
Utilities.OO.createClass(Utilities.SlicedSprite)

function Utilities.SlicedSprite:new(pathToImage, x,y, width, height, borderLeft, borderRight, borderTop, borderBottom)
    self.image = Game.getSprite(pathToImage)
    self.position = {x or 0, y or 0}

    self.width = width or self.image:getWidth()
    self.height = height or self.image:getHeight()

    self.borderLeft = borderLeft or 0
    self.borderRight = borderRight or 0
    self.borderTop = borderTop or 0
    self.borderBottom = borderBottom or 0
end

function Utilities.SlicedSprite:getWidth()
    return math.max(self.width, self.borderLeft+self.borderRight)
end

function Utilities.SlicedSprite:getHeight()
    return math.max(self.height, self.borderTop+self.borderBottom)
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

    local posX3 = self.position[1] + self:getWidth() - self.borderRight
    local posY3 = self.position[2] + self:getHeight() - self.borderBottom

    -- render top left
    if self.borderTop > 0 or self.borderLeft > 0 then
        love.graphics.draw( self.image,
                            love.graphics.newQuad(0,0,self.borderLeft, self.borderTop, self.image:getWidth(), self.image:getHeight()),
                            posX1, posY1)
    end

    -- render top right
    if self.borderTop > 0 or self.borderRight > 0 then
        love.graphics.draw( self.image,
                            love.graphics.newQuad(self.image:getWidth() - self.borderRight, 0, self.borderRight, self.borderTop, self.image:getWidth(), self.image:getHeight()),
                            posX3, posY1)
    end

    -- render bottom left
    if self.borderBottom > 0 or self.borderLeft > 0 then
        love.graphics.draw( self.image,
                            love.graphics.newQuad(0, self.image:getHeight() - self.borderBottom, self.borderLeft, self.borderBottom, self.image:getWidth(), self.image:getHeight()),
                            posX1, posY3)
    end

    -- render bottom right
    if self.borderBottom > 0 or self.borderRight > 0 then
        love.graphics.draw( self.image,
                            love.graphics.newQuad(self.image:getWidth() - self.borderRight, self.image:getHeight() - self.borderBottom, self.borderRight, self.borderBottom, self.image:getWidth(), self.image:getHeight()),
                            posX3, posY3)
    end

    -- render center
    love.graphics.draw( self.image,
                        love.graphics.newQuad(self.borderLeft, self.borderTop, self.image:getWidth() - self.borderLeft - self.borderRight, self.image:getHeight() - self.borderTop - self.borderBottom, self.image:getWidth(), self.image:getHeight()),
                        posX2, posY2, 0,
                        (self:getWidth() - self.borderLeft - self.borderRight) / (self.image:getWidth() - self.borderLeft - self.borderRight),
                        (self:getHeight() - self.borderTop - self.borderBottom) / (self.image:getHeight() - self.borderTop - self.borderBottom))

    -- render top
    if self.borderTop > 0 then
        love.graphics.draw( self.image,
                            love.graphics.newQuad(self.borderLeft, 0, self.image:getWidth() - self.borderLeft - self.borderRight, self.borderTop, self.image:getWidth(), self.image:getHeight()),
                            posX2, posY1, 0,
                            (self:getWidth() - self.borderLeft - self.borderRight) / (self.image:getWidth() - self.borderLeft - self.borderRight),
                            1)
    end

    -- render bottom
    if self.borderBottom > 0 then
        love.graphics.draw( self.image,
                            love.graphics.newQuad(self.borderLeft, self.image:getHeight() - self.borderBottom, self.image:getWidth() - self.borderLeft - self.borderRight, self.borderBottom, self.image:getWidth(), self.image:getHeight()),
                            posX2, posY3, 0,
                            (self:getWidth() - self.borderLeft - self.borderRight) / (self.image:getWidth() - self.borderLeft - self.borderRight),
                            1)
    end

    -- render left
    if self.borderLeft > 0 then
        love.graphics.draw( self.image,
                            love.graphics.newQuad(0, self.borderTop, self.borderLeft, self.image:getHeight() - self.borderTop - self.borderBottom, self.image:getWidth(), self.image:getHeight()),
                            posX1, posY2, 0,
                            1,
                            (self:getHeight() - self.borderTop - self.borderBottom) / (self.image:getHeight() - self.borderTop - self.borderBottom))
    end

    -- render right
    if self.borderRight > 0 then
        love.graphics.draw( self.image,
                            love.graphics.newQuad(self.image:getWidth() - self.borderRight, self.borderTop, self.borderRight, self.image:getHeight() - self.borderTop - self.borderBottom, self.image:getWidth(), self.image:getHeight()),
                            posX3, posY2, 0,
                            1,
                            (self:getHeight() - self.borderTop - self.borderBottom) / (self.image:getHeight() - self.borderTop - self.borderBottom))
    end
end
