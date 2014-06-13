---
--@author Steve Wolligandt

SplashScreen = {}

SplashScreen.activeKeyBinding = {}
SplashScreen.activeKeyBinding["escape"] = {
    pressed = function()
        Game.changeState(Testing.Menu)
    end
}

function SplashScreen.init()
    SplashScreen.createGUI()
    SplashScreen.mode = "fadeIn"
    SplashScreen.fadeSpeed = 120
    SplashScreen.duration = 2 -- seconds
end

--- updates active container
function SplashScreen.update(dt)
    if SplashScreen.mode == "fadeIn" then
        SplashScreen.labelFirmName.fontColor = {SplashScreen.labelFirmName.fontColor[1],
                                                SplashScreen.labelFirmName.fontColor[2],
                                                SplashScreen.labelFirmName.fontColor[3],
                                                SplashScreen.labelFirmName.fontColor[4] + SplashScreen.fadeSpeed*dt}
        if SplashScreen.labelFirmName.fontColor[4] >= 255 then
            SplashScreen.labelFirmName.fontColor[4] = 255
            SplashScreen.mode = "startWaiting"
        end

    elseif SplashScreen.mode == "startWaiting" then
        SplashScreen.startTime = love.timer.getTime()
        SplashScreen.mode = "wait"

    elseif SplashScreen.mode == "wait" then
        if love.timer.getTime() - SplashScreen.startTime > SplashScreen.duration then
            SplashScreen.mode = "fadeOut"
        end

    elseif SplashScreen.mode == "fadeOut" then
        SplashScreen.labelFirmName.fontColor = {SplashScreen.labelFirmName.fontColor[1],
                                                SplashScreen.labelFirmName.fontColor[2],
                                                SplashScreen.labelFirmName.fontColor[3],
                                                SplashScreen.labelFirmName.fontColor[4] - SplashScreen.fadeSpeed*dt}
        if SplashScreen.labelFirmName.fontColor[4] <= 0 then
            Game.changeState(Testing.Menu)
        end
    end
end

function SplashScreen.createGUI()
    SplashScreen.GUI = GUI.Container(Game.getFont("assets/fonts/nulshock bd.ttf", 50),nil,nil,nil,nil,nil,{255,255,255})
    SplashScreen.labelFirmName = GUI.Label("Robert and Steve Entertainment")
    SplashScreen.GUI:addWidget(SplashScreen.labelFirmName)
    SplashScreen.labelFirmName.fontColor = {255,255,255,0}
end
