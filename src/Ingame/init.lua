--- ADD ME
Ingame = {}

---
function Ingame.init()
    Tilemap.init()
    Tilemap.addScene():loadMap("test.map")
    Lighting.ambient = Lighting.AmbientLight(10,10,10)
    Lighting.lights =  {Lighting.LightSource(0,0, 50,50,50)}
end

---
function Ingame.render()
    Tilemap.render()
end

---
function Ingame.update(dt)
    Lighting.lights[1].position = {love.mouse.getX()+0.00001, love.mouse.getY()+0.00001}
    Tilemap.update(dt)
end
