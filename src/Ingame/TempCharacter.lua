--- Character that destroys itself after some seconds
--@classmod TempCharacter
--@author Steve Wolligandt



Ingame.TempCharacter = {}
Utilities.OO.createDerivedClass(Ingame.TempCharacter, Ingame.Character)


function Ingame.TempCharacter:new(apparentScene, x, y)
    Ingame.Character.new(self,apparentScene,x,y, {0,0,0})
    self.timeAtCreation = love.timer.getTime()
    self.maxLifeTime = math.random(20,100) --seconds
    self.lifeTime = 0
    if #Ingame.wayPointsForDarkness > 0 then
        self:AI_calculatePathToGoal(unpack(Ingame.wayPointsForDarkness[1]))
    end
end

function Ingame.TempCharacter:update(dt)
    Ingame.Character.update(self, dt)
    if self.lifeTime > self.maxLifeTime then
       self:destroy()
    end
    self.lifeTime = self.lifeTime + dt
end
