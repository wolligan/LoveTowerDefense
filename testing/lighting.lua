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
    Testing.Lighting.lights =  {Ingame.LightSource()}

    Testing.Lighting.meshs =    {   Ingame.Mesh.createDiscoCircle(love.graphics.getWidth()/2, love.graphics.getHeight()/2, 50, 100),
                                    {   vertices =          {   love.graphics.getWidth()/3 - 20, love.graphics.getHeight()/3 + 20,
                                                                love.graphics.getWidth()/3 + 20, love.graphics.getHeight()/3 + 20,
                                                                love.graphics.getWidth()/3 + 20, love.graphics.getHeight()/3 - 20,
                                                                love.graphics.getWidth()/3     , love.graphics.getHeight()/3 - 40,
                                                                love.graphics.getWidth()/3 - 30, love.graphics.getHeight()/3 - 30   },
                                        color =             {   255,255,255 },
                                        reflectorSides =    {   2   }
                                    },
                                    {   vertices =          {   love.graphics.getWidth()*2/3 - 3, love.graphics.getHeight()*2/3 + 3,
                                                                love.graphics.getWidth()*2/3 + 3, love.graphics.getHeight()*2/3 + 3,
                                                                love.graphics.getWidth()*2/3 + 3, love.graphics.getHeight()*2/3 - 3,
                                                                love.graphics.getWidth()*2/3 - 3, love.graphics.getHeight()*2/3 - 3  },
                                        color =             {   255,255,255 },
                                        reflectorSides =    {}
                                    }
                                }
end

function Testing.Lighting.render()
    local shadows = {}
    local reflections = {}

    -- create shadows
    for lightIndex=1,#Testing.Lighting.lights do
        shadows[lightIndex], reflections[lightIndex] = Ingame.Lighting.calculateAllShadowsAndReflections(Testing.Lighting.lights[lightIndex], Testing.Lighting.meshs)
    end


    -- draw shadows
    local drawShadows = function ()
        love.graphics.setColor(255,255,255)
        for lightIndex=1,#Testing.Lighting.lights do
            for meshIndex=1,#Testing.Lighting.meshs do
                if (#shadows[lightIndex][meshIndex] > 5) then
                    love.graphics.polygon("fill", unpack(shadows[lightIndex][meshIndex]))
                end
            end
        end
    end

    love.graphics.setInvertedStencil(drawShadows)
    love.graphics.setColor(100,100,100)
    love.graphics.rectangle("fill", 0,0,love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setStencil(nil)

    -- draw reflections
    love.graphics.setBlendMode("additive")
    love.graphics.setColor(100,100,100)
    for j=1,#Testing.Lighting.lights do
        for i=1,#Testing.Lighting.meshs do
            if #reflections[j][i] > 0 then
                for k = 1,#reflections[j][i] do
                    love.graphics.polygon("fill", unpack(reflections[j][i][k]))
                end
            end
        end
    end

    love.graphics.setBlendMode("alpha")
    -- draw polygons
    love.graphics.setColor(255,255,255)
    for i,curPolygon in pairs(Testing.Lighting.meshs) do
        love.graphics.polygon("fill", unpack(curPolygon.vertices))
    end

    -- draw lights
    love.graphics.setColor(255,255,0)
    for i,curLight in pairs(Testing.Lighting.lights) do
        --love.graphics.setColor(curLight[3],curLight[4],curLight[5])
        love.graphics.circle( "fill", curLight.position[1], curLight.position[2], 10 )
    end
end

function Testing.Lighting.update(dt)
    Testing.Lighting.lights[1].position  = {love.mouse.getX(), love.mouse.getY()}
end
