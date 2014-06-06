require "Tilemap"

Ingame.Character = {}
Utilities.OO.createDerivedClass(Ingame.Character, Tilemap.Character)

function Ingame.Character:new(appropriateScene,x,y, color, goalX, goalY)
    Tilemap.Character.new(self,appropriateScene,x,y)
    self.mesh.color = color

    self.goalX = goalX
    self.goalY = goalY
    self:AI_calculatePathToGoal(1,1)
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
    love.graphics.circle("fill", 0, 0, Tilemap.Settings.playerSize/2+2)
    love.graphics.setColor(unpack(self.mesh.color))
    love.graphics.circle("fill", 0, 0, Tilemap.Settings.playerSize/2)
    --self.mesh:render()

    if self.deadScaleX and self.deadScaleX then love.graphics.pop() end
    love.graphics.pop()
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

                table.removeValue(self.appropriateScene.characters, self)
            end
        )
    )
end

---
function Tilemap.Character:AI_think(dt)
	self:AI_walkToGoal(dt)
end
