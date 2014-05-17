--- ADD ME
require "Lighting"

Testing.Lighting = {}

Testing.Lighting.activeKeyBinding = {}
Testing.Lighting.activeKeyBinding["escape"] = {
    pressed = function()
        Game.changeState(Testing.Menu)
    end
}


Testing.Lighting.activeKeyBinding["mouse_left"] = {
    pressed = function()
        local mX = love.mouse.getX()
        local mY = love.mouse.getY()

        for i,curLight in pairs(Lighting.lights) do
            if math.abs(mX - curLight.position[1]) < 7 and math.abs(mY - curLight.position[2]) < 7 then
                Testing.Lighting.clickedLightSource = curLight
            end
        end
    end,

    released = function()
        Testing.Lighting.clickedLightSource = nil
    end
}

function Testing.Lighting.init()
    Lighting.init()
    Lighting.lights =  {Lighting.LightSource(love.graphics.getWidth()/3, love.graphics.getHeight()/2, 50,50,50),
                        Lighting.LightSource(love.graphics.getWidth()*2/3, love.graphics.getHeight()/2, 50,50,50)}
    Lighting.ambient = Lighting.AmbientLight(100,100,100)
    --Lighting.ambient = Lighting.AmbientLight(255,255,255)

    Testing.Lighting.background = Game.getSprite("assets/sprites/lighttest/background.png")
    Lighting.drawUnlitBackground = function() love.graphics.draw(Testing.Lighting.background) end
    Testing.Lighting.createShadowCasters()

end

function Testing.Lighting.render()
    Lighting.renderShadedScene()
end

function Testing.Lighting.update(dt)
    if Testing.Lighting.clickedLightSource then
        Testing.Lighting.clickedLightSource.position = {love.mouse.getX(), love.mouse.getY()}
    end
    Lighting.update(dt, Testing.Lighting.shadowCasters)
end

function Testing.Lighting.createShadowCasters()
    -- create list of shadowCasters
    Testing.Lighting.shadowCasters = {}
    local arraySizeX = 5
    local arraySizeY = 4
    local border = 200
    local primitiveSize = 23
    local numSlices = 4

    --local colors = {Color.blue, Color.red, Color.green, Color.yellow}
    local colors = {{60,60,60}}
    curColorIndex = 1

    for x = 1,arraySizeX do
        for y = 1,arraySizeY do

            curColorIndex = curColorIndex % #colors
            if curColorIndex == 0 then curColorIndex = #colors end

            Testing.Lighting.shadowCasters[#Testing.Lighting.shadowCasters + 1] = Geometry.Mesh.createRectangle((love.graphics.getWidth()-border*2)  * ((x-1)/(arraySizeX-1)) + border,
                                                                                              (love.graphics.getHeight()-border*2) * ((y-1)/(arraySizeY-1)) + border,
                                                                                              primitiveSize, colors[curColorIndex])
            curColorIndex = curColorIndex + 1
        end
    end
end
