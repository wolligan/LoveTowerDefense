---
--@author Steve Wolligandt

require "Tilemap"

Ingame.Character = {}
Utilities.OO.createDerivedClass(Ingame.Character, Tilemap.Character)

function Ingame.Character:new(apparentScene,x,y, color, goalX, goalY)
    Tilemap.Character.new(self,apparentScene,x,y)
    self.mesh.color = color

    self.goalX = goalX
    self.goalY = goalY
    --self:AI_calculatePathToGoal(1,1)

    Ingame.mobs[#Ingame.mobs+1] = self
end

function Ingame.Character:update(dt)

    if #self.pathToGoal <= 0 and not self.dead then
        Ingame.SpawnPhase.survivedMobs = Ingame.SpawnPhase.survivedMobs + 1
        self:destroy()
    end
    if not self.dead then
        Tilemap.Character.update(self,dt)
    end
end

function Ingame.Character:render()
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    if self.deadScaleX and self.deadScaleX then
        love.graphics.push()
        love.graphics.scale(self.deadScaleX, self.deadScaleY)
    end

    love.graphics.setColor(255,255,255)
    --love.graphics.circle("fill", 0, 0, Tilemap.Settings.playerSize/2+2)
    love.graphics.draw( Game.getSprite("assets/sprites/Ingame/circle.png"), -Tilemap.Settings.playerSize/2-1,-Tilemap.Settings.playerSize/2-1, 0,
                        (Tilemap.Settings.playerSize+2)/Game.getSprite("assets/sprites/Ingame/circle.png"):getWidth(),
                        (Tilemap.Settings.playerSize+2)/Game.getSprite("assets/sprites/Ingame/circle.png"):getHeight())
    love.graphics.setColor(unpack(self.mesh.color))
    love.graphics.draw( Game.getSprite("assets/sprites/Ingame/circle.png"), -Tilemap.Settings.playerSize/2,-Tilemap.Settings.playerSize/2, 0,
                        (Tilemap.Settings.playerSize)/Game.getSprite("assets/sprites/Ingame/circle.png"):getWidth(),
                        (Tilemap.Settings.playerSize)/Game.getSprite("assets/sprites/Ingame/circle.png"):getHeight())
    --self.mesh:render()

    if self.deadScaleX and self.deadScaleX then love.graphics.pop() end
    love.graphics.pop()
end

function Ingame.Character:takeDamage(r,g,b)
    self.mesh.color = { self.mesh.color[1] + r,
                        self.mesh.color[2] + g,
                        self.mesh.color[3] + b}

    if r >255 and b > 255 and g > 255 then
        self:destroy()
    end
end

function Ingame.Character:destroy()
    self.dead = true
    Game.startCoroutine(coroutine.create(function()
                self.deadScaleX = 1
                self.deadScaleY = 1

                while self.deadScaleY > 0 do
                    self.deadScaleY = self.deadScaleY - love.timer.getDelta()*20
                    self.deadScaleX = self.deadScaleX + love.timer.getDelta()*100
                    coroutine.yield()
                end

                table.removeValue(self.apparentScene.characters, self)
                table.removeValue(Ingame.mobs, self)
            end
        )
    )
end

---
function Tilemap.Character:AI_think(dt)
	self:AI_walkToGoal(dt)
end
