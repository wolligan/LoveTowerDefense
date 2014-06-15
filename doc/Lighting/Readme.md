#Lighting Engine
With help of the lighting engine you can render a lighted scene. You can create light sources and shadow casters to create your unlit rendered scene.

TODO

* implement mutli reflections with raytracing

## Usage
    require "Lighting"
    
    --- love init function
    function love.init()
        -- initialize lighting
        Lighting.init()
        
        -- create 4 shadowcasters with two reflector sides
        myShadowCasters = {
            Lighting.ShadowCaster.createRectangle(100,100, 40, {255,0,0}, {1,3}),
            Lighting.ShadowCaster.createRectangle(200,100, 40, {255,0,0}, {1,3}),
            Lighting.ShadowCaster.createRectangle(100,200, 40, {255,0,0}, {1,3}),
            Lighting.ShadowCaster.createRectangle(200,200, 40, {255,0,0}, {1,3})
        }
        
        -- create a lightsource
        Lighting.lights = {
            Lighting.LightSource(150,150, 100,100,100)
        }
        
        -- camera coordinates, you can translate the whole lighting
        cameraX = 0
        cameraY = 0
        
    end
    
    --- love update callback
    function love.update(dt)
        -- send the myShadowCasters table to the lighting
        Lighting.update(dt, myShadowCasters)
    end
    
    --- love draw callback
    function love.draw()
        Lighting.renderShadedScene(cameraX, cameraY)
    end
    
    function Lighting.drawUnlitBackground()
        -- draw your scene here
        
        -- draw shadowcasters
        for i,curShadowCaster in pairs(myShadowCasters) do
            curShadowCaster:render()
        end
    end
    
## Data that needs to be defined by the user
### Ambient Light
[Ambient Light](../classes/AmbientLight.html) is a light source that will not cast any shadows.
If you want your scene to be ambiently lighted then do the following:
    Lighting.ambient = Lighting.Ambient(100,100,100)
### Light Source
Add a [LightSource](../classes/LightSource.html) object to the Lighting.lights table to have a light source in your scene that casts shadows to all shadowcasters you add to your update function of update.
### Shadowcaster
A [ShadowCaster](../classes/ShadowCaster.html) will occlude all light sources and can have reflector sides. You have to send a table with shadowcasters to the [update function](file:///home/steve/Projekte/Softwareprojekt/doc/Lighting/modules/init.html#Lighting.update) of Lighting
## Internal classes
The following objects will automatically created by lightsources and shadowcasters

* [Shadow](../classes/Shadow.html)
* [Reflection](../classes/Reflection.html)