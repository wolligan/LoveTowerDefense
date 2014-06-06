--- Character that destroys itself after some seconds

Ingame.TempCharacter = {}
Utilities.OO.createDerivedClass(Ingame.TempCharacter, Ingame.Character)


function Ingame.TempCharacter:new(appropriateScene, x, y)
    Ingame.Character.new(self,appropriateScene,x,y, {0,0,0})
    self.timeAtCreation = love.timer.getTime()
    self.maxLifeTime = math.random(3,6) --seconds
    self.lifeTime = 0
end

function Ingame.TempCharacter:update(dt)
    Ingame.Character.update(self, dt)
    if self.lifeTime > self.maxLifeTime then
       self:destroy()
    end
    self.lifeTime = self.lifeTime + dt
end
