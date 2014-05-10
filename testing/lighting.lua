require "ingame.lighting"
require "ingame.lightsource"
require "ingame.mesh"

Testing.Lighting = {}

Testing.Lighting.activeKeyBinding = {}
Testing.Lighting.activeKeyBinding["escape"] = {
    mode = "single",
    fun = function()
        love.event.push("quit")
    end
}

function Testing.Lighting.init()
    Testing.Lighting.lights =  {Ingame.LightSource(0,0, 100,100,100)}
    Testing.Lighting.meshs = {}

    local arraySize = 3
    local border = 180
    local rectSize = 20
    local colors = {Color.blue, Color.red, Color.green, Color.yellow}
    curColorIndex = 1
    for x = 1,arraySize do
        for y = 1,arraySize do
            curColorIndex = curColorIndex % #colors
            if curColorIndex == 0 then curColorIndex = #colors end
            Testing.Lighting.meshs[#Testing.Lighting.meshs + 1] = Ingame.Mesh.createRectangle((love.graphics.getWidth()-border*2)  * ((x-1)/(arraySize-1)) + border,
                                                                                              (love.graphics.getHeight()-border*2) * ((y-1)/(arraySize-1)) + border,
                                                                                              rectSize, colors[curColorIndex])
            curColorIndex = curColorIndex + 1
        end
    end
end

function Testing.Lighting.render()
    local shadows = {}
    local reflections = {}

    -- render lights
    for lightIndex=1,#Testing.Lighting.lights do
        Testing.Lighting.lights[lightIndex]:render()
    end

    -- draw polygons
    love.graphics.setColor(255,255,255)
    for i,curPolygon in pairs(Testing.Lighting.meshs) do
        love.graphics.setColor(unpack(curPolygon.color))
        love.graphics.polygon("fill", unpack(curPolygon.vertices))
    end

    -- draw lights
    for i,curLight in pairs(Testing.Lighting.lights) do
        curLight:renderCircle()
    end
end

function Testing.Lighting.update(dt)
    --Testing.Lighting.lights[1].position  = {love.mouse.getX(), love.mouse.getY()}
    Testing.Lighting.lights[1].position  = {love.graphics.getWidth()/2 + math.sin(love.timer.getTime()/4)*300, love.graphics.getHeight()/2 + math.cos(love.timer.getTime()/4)*300}
    for lightIndex=1,#Testing.Lighting.lights do
        Testing.Lighting.lights[lightIndex]:update(Testing.Lighting.meshs)
    end
end
