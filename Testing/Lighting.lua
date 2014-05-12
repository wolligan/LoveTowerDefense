--- ADD ME
require "Lighting"

Testing.Lighting = {}

Testing.Lighting.activeKeyBinding = {}
Testing.Lighting.activeKeyBinding["escape"] = {
    mode = "single",
    fun = function()
        love.event.push("quit")
    end
}

function Testing.Lighting.init()
    Lighting.lights =  {Lighting.LightSource(0,0, 30,30,30)}
    Lighting.ambient = Lighting.AmbientLight(50,50,50)

    Testing.Lighting.background = Game.getSprite("assets/sprites/lighttest/background.png")
    Lighting.drawUnlitBackground = function() love.graphics.draw(Testing.Lighting.background) end
    Testing.Lighting.createShadowCasters()

end

function Testing.Lighting.render()
    Lighting.renderShadedScene()
end

function Testing.Lighting.update(dt)

    --Testing.Lighting.lights[1].position  = {love.mouse.getX(), love.mouse.getY()}
    Lighting.lights[1].position  = {love.graphics.getWidth()/2 + math.sin(love.timer.getTime()/4)*300, love.graphics.getHeight()/2 + math.cos(love.timer.getTime()/4)*300}

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
