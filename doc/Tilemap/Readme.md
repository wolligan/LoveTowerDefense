# Lighted Tilemap
## Usage
To integrate the tilemap engine into your löve2D project you need to require it and call the standard callbacks

    require "Tilemap"
    
    function love.load()
        Tilemap.init()
    end
    
    function love.draw()
        Tilemap.render()
    end
    
    function love.update(dt)
        Tilemap.update(dt)
    end


## Lighting

By doing

    require "Tilemap"

you also require the [Lighting Engine](../../Lighting/manual/Readme.md.html). Simply add a [LightSource](../../Lighting/classes/LightSource.html) to the Lighting Engine as described in its [Documentation](../../Lighting/manual/Readme.md.html) and the Tilemap Engine will do everything for you.

## Structure of Tilemap

[Tilemap](../modules/Tilemap.lua) can hold more than one [Scene](../classes/Scene.html). To add a Scene do the following:
    Tilemap.scenes[#Tilemap.scenes+1] = Tilemap.Scene()

## Tile Dictionary

The [Tile Dictionary](../modules/TileDict.html) brings logic in the tilemap. Every Tile has some fields that you can set. Following fields are allowed in Tile Dictionary:
* name - string with the name of the tile.
* draw - function that gets called for rendering the tile.
* drawParams - parameters of the draw function.
* color - color of the tile as {r,g,b}.
* speed - multiplicator of the speed, 1 changes nothing.
* isObstacle - a character cannot walk of an obstacle.
* update - function that gets called before rendering

To add a simple white tile without logic to your Dictionary do something like this:
    Tilemap.tileDict[#Tilemap.tileDict+1] = {
       name = "my nile name",
       draw = love.graphics.rectangle,
       drawParams = {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize},
       color = {255,255,255},
       speed = 1,
       isObstacle = false,
       update = function(apparentScene, posX, posY, tick)
       -- do stuff
       end
    }
    
### Render function and parameters

As you can see we have

    love.graphics.rectangle

as render function and

    {"fill", 0, 0, Tilemap.Settings.tileSize, Tilemap.Settings.tileSize}

as the parameters for our render function. The engine automatically calls the specified render function with the specified parameters. You can also do the following:

    draw = function()
        love.graphics.circle("fill",
                             Tilemap.Settings.tileSize/2,
                             Tilemap.Settings.tileSize/2,
                             Tilemap.Settings.tileSize/2)
        love.graphics.setColor(0,0,0)
        love.graphics.circle("fill",
                             Tilemap.Settings.tileSize/2,
                             Tilemap.Settings.tileSize/2,
                             Tilemap.Settings.tileSize/2-2)
    end,
    
    drawParams = {}

To render a black circle with a contour that is coloured as specified in the field "color".

### Update function

You can specify an update function to bring some logic into your tiles, for example every tick the engine sends you can let spawn some characters.
The structure of update looks like this:

    update = function(apparentScene, posX, posY, tick)
        -- do stuff
    end

The engine sends in which scene the current tile is located (apparentScene), where in the scene it is located (posX and posY) and if there was a tick.
You can use the tick parameter to do something in intervals, for example you can let spawn enemies.

## Scenes
### Structure of a scene
[Scenes](../classes/Scene.html) hold the following basic tables:

* tiles (The actual tilemap as a 2D table that holds only indices that will reference the Tile Dictionary)
* characters (a list of all characters or objects instantiated from classes that are derived from Tilemap.Character)
* playerIndex (index of the currently activated character in the characters table, you could move this character or upgrade it, ...)
* camera (the camera will transform the map, can follow characters or you can just fly over the map)

### Pathfinding

Every Scene can calculate the shortest path from one tile position to another. The calculated path won't have obstacle in its list of tiles and will try to take the tiles with the least speed factor.

### Characters

[Characters](../classes/Character.html) are non-static objects in the scene. You can create derived classes like NPCs or items that you can collect or towers that attack other characters .....
Every Character has path finding methods for its scene and can have a basic AI.