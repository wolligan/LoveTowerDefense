#require "ingame.lighting"

LightTest = {}
LightTest.activeKeyBinding = KeyBindings.LightTestKeyBinding

function LightTest.init()
    LightTest.lights = {{0,0,255,255,255}}
    LightTest.polygons = {{ love.graphics.getWidth()/2 - 20, love.graphics.getHeight()/2 - 20,
                            love.graphics.getWidth()/2     , love.graphics.getHeight()/2 - 40,
                            love.graphics.getWidth()/2 + 20, love.graphics.getHeight()/2 - 20,
                            love.graphics.getWidth()/2 + 20, love.graphics.getHeight()/2 + 20,
                            love.graphics.getWidth()/2 - 20, love.graphics.getHeight()/2 + 20},
                          { love.graphics.getWidth()/3 - 20, love.graphics.getHeight()/3 - 20,
                            love.graphics.getWidth()/3     , love.graphics.getHeight()/3 - 40,
                            love.graphics.getWidth()/3 + 20, love.graphics.getHeight()/3 - 20,
                            love.graphics.getWidth()/3 + 20, love.graphics.getHeight()/3 + 20,
                            love.graphics.getWidth()/3 - 20, love.graphics.getHeight()/3 + 20}
    }

end

function LightTest.render()
    local shadows = {}
    local rawReflections = {}

    -- create shadows
    for j=1,#LightTest.lights do
        shadows[j] = {}
        for i=1,#LightTest.polygons do
            shadows[j][i] = Ingame.Lighting.getShadowPolygon(LightTest.lights[j], LightTest.polygons[i])
        end
    end

    -- create reflections
    for j=1,#LightTest.lights do
        rawReflections[j] = {}
        for i=1,#LightTest.polygons do
            rawReflections[j][i] = Ingame.Lighting.getReflectionPolygon(LightTest.lights[j], LightTest.polygons[i], {1,2,3,4,5})
        end
    end


    -- draw shadows
    local drawShadows = function ()
    love.graphics.setColor(255,255,255)
        for j=1,#LightTest.lights do
            for i=1,#LightTest.polygons do
                if #shadows[j][i] > 5 then
                    love.graphics.polygon("fill", unpack(shadows[j][i]))
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
    for j=1,#LightTest.lights do
        for i=1,#LightTest.polygons do
            if #rawReflections[j][i] > 0 then
                for k = 1,#rawReflections[j][i],8 do
                    love.graphics.polygon("fill",   rawReflections[j][i][k  ], rawReflections[j][i][k+1],
                                                    rawReflections[j][i][k+2], rawReflections[j][i][k+3],
                                                    rawReflections[j][i][k+4], rawReflections[j][i][k+5],
                                                    rawReflections[j][i][k+6], rawReflections[j][i][k+7])
                end
            end
        end
    end

    love.graphics.setBlendMode("alpha")
    -- draw polygons
    love.graphics.setColor(255,255,255)
    for i,curPolygon in pairs(LightTest.polygons) do
        love.graphics.polygon("fill", unpack(curPolygon))
    end

    -- draw lights
    love.graphics.setColor(255,255,0)
    for i,curLight in pairs(LightTest.lights) do
        --love.graphics.setColor(curLight[3],curLight[4],curLight[5])
        love.graphics.circle( "fill", curLight[1], curLight[2], 10 )
    end
end

function LightTest.update(dt)
    LightTest.lights[1]  = {love.mouse.getX(), love.mouse.getY()}
end
