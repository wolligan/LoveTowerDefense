--- ADD ME
Lighting = {}

require "Geometry"
require "Lighting.LightSource"
require "Lighting.AmbientLight"
require "Lighting.Reflection"
require "Lighting.Shadow"

Lighting.lights = {}
Lighting.curShadowCasters = {}
Lighting.ambient = Lighting.AmbientLight(255,255,255)
Lighting.unlitSceneCanvas = love.graphics.newCanvas()
Lighting.sceneLitByCurReflection = love.graphics.newCanvas()

---
function Lighting.renderShadedScene()
    Lighting.unlitSceneCanvas:clear(255,255,255)

    -- render background
    love.graphics.setColor(255, 255, 255)
    love.graphics.setCanvas(Lighting.unlitSceneCanvas)
    Lighting.drawUnlitBackground()

    -- render ambient
    love.graphics.setCanvas()

    if Lighting.ambient then
        Lighting.ambient:render()
    end

    -- render lights
    love.graphics.setBlendMode("additive")
    for lightIndex=1,#Lighting.lights do
        Lighting.lights[lightIndex]:render()

    end
    love.graphics.setBlendMode("alpha")

    -- draw ShadowCasters over shaded Scene
    love.graphics.setColor(255,255,255)
    for i,curShadowCaster in pairs(Lighting.curShadowCasters) do
        curShadowCaster:render()
    end

    -- draw lights
    for i,curLight in pairs(Lighting.lights) do
        curLight:renderCircle()
    end
end

---
function Lighting.drawUnlitBackground()

end

---
function Lighting.update(dt, shadowCasters)
    for lightIndex=1,#Lighting.lights do
        Lighting.lights[lightIndex]:update(shadowCasters)
    end
    Lighting.curShadowCasters = shadowCasters
end
