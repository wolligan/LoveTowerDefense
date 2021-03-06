---
--@author Steve Wolligandt

Lighting = {}

require "Lighting.LightSource"
require "Lighting.AmbientLight"
require "Lighting.Reflection"
require "Lighting.Shadow"
require "Lighting.ShadowCaster"

Lighting.lights = {}
Lighting.curShadowCasters = {}
Lighting.ambient = nil

--- initializes everything used for lighting
function Lighting.init()
    Lighting.unlitBackground = love.graphics.newCanvas()

    Lighting.shadercode = [[
        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
        {
            vec4 texcolor = Texel(texture, texture_coords);
            return texcolor * color;//vec4(1.0f, 0.0f, 0.0f, 1.0f);
        }

        vec4 position( mat4 transform_projection, vec4 vertex_position )
        {
            return transform_projection * vertex_position;
        }
    ]]

end

--- Renders a shaded scene
--@param translateX You can use this value for camera translation.
--@param translateY You can use this value for camera translation.
function Lighting.renderShadedScene(translateX, translateY)
    Lighting.unlitBackground:clear(0,0,0)

    -- render background
    love.graphics.setCanvas(Lighting.unlitBackground)
    Lighting.drawUnlitBackground()
    love.graphics.setCanvas()

    -- render ambient
    --love.graphics.setShader(Lighting.shader)
    love.graphics.setBlendMode("additive")
    if Lighting.ambient then
        Lighting.ambient:render()
    end

    -- render lights
    for i,curLight in pairs(Lighting.lights) do
        if curLight.enabled then
            curLight:render(translateX or 0, translateY or 0)
        end
    end

    love.graphics.setBlendMode("alpha")

    -- draw ShadowCasters over shaded Scene
    love.graphics.setColor(255,255,255)
    for i,curShadowCaster in pairs(Lighting.curShadowCasters) do
        --curShadowCaster:render()
    end

    -- draw lights
    --[[for i,curLight in pairs(Lighting.lights) do
        if curLight.enabled then
            curLight:renderCircle()
        end
    end]]
end

--- This function needs to be overwritten. It renders the unlit background
function Lighting.drawUnlitBackground()

end

--- updates lightsources
--@param dt delta time
--@param shadowCasters list of the shadow casters you want to have in your lit scene
function Lighting.update(dt, shadowCasters)
    for lightIndex=1,#Lighting.lights do
        Lighting.lights[lightIndex]:update(shadowCasters)
    end
    Lighting.curShadowCasters = shadowCasters
end
