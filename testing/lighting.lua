require "lighting"
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
    Testing.Lighting.lights =  {Lighting.LightSource(0,0, 20,20,20),
                                Lighting.LightSource(0,0, 20,20,20),
                                Lighting.LightSource(0,0, 20,20,20),
                                Lighting.LightSource(0,0, 20,20,20),
                                Lighting.LightSource(0,0, 20,20,20),}
    Testing.Lighting.meshs = {}

    local arraySizeX = 5
    local arraySizeY = 5
    local border = 200
    local primitiveSize = 23
    local numSlices = 7
    local colors = {Color.blue, Color.red, Color.green, Color.yellow}
    curColorIndex = 1
    for x = 1,arraySizeX do
        for y = 1,arraySizeY do
            curColorIndex = curColorIndex % #colors
            if curColorIndex == 0 then curColorIndex = #colors end
            --Testing.Lighting.meshs[#Testing.Lighting.meshs + 1] = Ingame.Mesh.createRectangle((love.graphics.getWidth()-border*2)  * ((x-1)/(arraySizeX-1)) + border,
            --                                                                                  (love.graphics.getHeight()-border*2) * ((y-1)/(arraySizeY-1)) + border,
            --                                                                                  primitiveSize, colors[curColorIndex])
            Testing.Lighting.meshs[#Testing.Lighting.meshs + 1] = Ingame.Mesh.createDiscoCircle((love.graphics.getWidth()-border*2)  * ((x-1)/(arraySizeX-1)) + border,
                                                                                                (love.graphics.getHeight()-border*2) * ((y-1)/(arraySizeY-1)) + border,
                                                                                                primitiveSize, numSlices, colors[curColorIndex])
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
    local distance = 1.5

    Testing.Lighting.lights[1].position  = {love.mouse.getX(), love.mouse.getY()}
    --Testing.Lighting.lights[1].position  = {love.graphics.getWidth()/2 + math.sin(love.timer.getTime()/4)*300, love.graphics.getHeight()/2 + math.cos(love.timer.getTime()/4)*300}

    Testing.Lighting.lights[2].position = {Testing.Lighting.lights[1].position[1]+distance, Testing.Lighting.lights[1].position[2]-distance}
    Testing.Lighting.lights[3].position = {Testing.Lighting.lights[1].position[1]+distance, Testing.Lighting.lights[1].position[2]+distance}
    Testing.Lighting.lights[4].position = {Testing.Lighting.lights[1].position[1]-distance, Testing.Lighting.lights[1].position[2]+distance}
    Testing.Lighting.lights[5].position = {Testing.Lighting.lights[1].position[1]-distance, Testing.Lighting.lights[1].position[2]-distance}

    for lightIndex=1,#Testing.Lighting.lights do
        Testing.Lighting.lights[lightIndex]:update(Testing.Lighting.meshs)
    end
end
