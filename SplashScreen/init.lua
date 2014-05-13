--- ADD ME
SplashScreen = {}

SplashScreen.timeToDisplay = 2 -- seconds
SplashScreen.fadeTime = 1
SplashScreen.alpha = 255


---
function SplashScreen.init()
    SplashScreen.timeWhenInited = love.timer.getTime()

    SplashScreen.splashScreen = Game.getSprite("assets/sprites/splashscreen/logo.png")

    SplashScreen.ratio = SplashScreen.splashScreen:getWidth() / SplashScreen.splashScreen:getHeight()

    SplashScreen.scale = math.min(  love.graphics.getWidth()/SplashScreen.splashScreen:getWidth(),
                                    love.graphics.getHeight()/SplashScreen.splashScreen:getHeight())

    SplashScreen.posX = love.graphics.getWidth()  / 2 - SplashScreen.splashScreen:getWidth()  * SplashScreen.scale / 2
    SplashScreen.posY = love.graphics.getHeight() / 2 - SplashScreen.splashScreen:getHeight() * SplashScreen.scale / 2
end

---
function SplashScreen.render()
    love.graphics.setColor(255,255,255,SplashScreen.alpha)
    love.graphics.draw(SplashScreen.splashScreen, SplashScreen.posX, SplashScreen.posY, 0, SplashScreen.scale, SplashScreen.scale)
end

---
function SplashScreen.update(dt)
    local timePassed = love.timer.getTime() - SplashScreen.timeWhenInited
    SplashScreen.alpha = 255

    if timePassed < SplashScreen.fadeTime then
        SplashScreen.alpha = 255 - (SplashScreen.timeToDisplay - timePassed / SplashScreen.fadeTime)*255
    end

    if timePassed > SplashScreen.timeToDisplay - SplashScreen.fadeTime then
        SplashScreen.alpha = 255 - (timePassed  / SplashScreen.fadeTime)*255
    end

    if timePassed > SplashScreen.timeToDisplay then
        Game.changeState(Ingame)
    end

end
