require "Keybindings"

Testing.Tilemap = {}

Testing.Tilemap.activeKeyBinding = KeyBindings.TilemapTestKeyBinding


function Testing.Tilemap.init()
    Tilemap.activeSceneIndex = 1
    for i=1,3 do
        Tilemap.loadedScenes[#Tilemap.loadedScenes + 1] = Tilemap.Scene()
        Tilemap.loadedScenes[i]:createRandomLevel()
    end
end

function Testing.Tilemap.render()
    Tilemap.render()
end

function Testing.Tilemap.update(dt)
    Tilemap.update(dt)
end
