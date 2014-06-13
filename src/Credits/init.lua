--- Credits Game State.
-- Shows the credits.
--@author Steve Wolligandt

Credits = {}

Credits.activeKeyBinding = {}
Credits.activeKeyBinding["escape"] = {
    pressed = function()
        Game.changeState(Testing.Menu)
    end
}

function Credits.init()
    Credits.createGUI()
    Credits.scrollSpeed = 200
end

function Credits.update(dt)
    Credits.creditList.topAnchorOffset = Credits.creditList.topAnchorOffset - Credits.scrollSpeed*dt
    Credits.creditList.bottomAnchorOffset = Credits.creditList.bottomAnchorOffset - Credits.scrollSpeed*dt

    if (Credits.creditList.widgets[#Credits.creditList.widgets]:bottomAnchor() < -love.graphics.getHeight() and Credits.labelThankYou.fontColor[4] < 255) then
        Credits.labelThankYou.fontColor = {255,255,255, math.min(255,Credits.labelThankYou.fontColor[4]+70*dt)}
    end
end

function Credits.createGUI()
    Credits.GUI = GUI.Container(Game.getFont("assets/fonts/nulshock bd.ttf", 30),nil,nil,nil,nil,nil,{255,255,255})

    local h1Font = Game.getFont("assets/fonts/nulshock bd.ttf", 35)
    local h2Font = Game.getFont("assets/fonts/nulshock bd.ttf", 25)
    local normalFont = Game.getFont("assets/fonts/nulshock bd.ttf", 15)

    Credits.labelThankYou = GUI.Label("Thank you for playing our game!")

    local h1Texts = {}
    local h2Texts = {}
    local normalTexts = {}

    Credits.creditList = GUI.List("horizontal", 30)
    Credits.creditList.topAnchorOffset = love.graphics.getHeight()
    Credits.creditList.bottomAnchorOffset = love.graphics.getHeight()*2
    h1Texts[#h1Texts+1] = Credits.creditList:add(GUI.Label("Credits"))

    h1Texts[#h1Texts+1] = Credits.creditList:add(GUI.Label(""))
    h1Texts[#h1Texts+1] = Credits.creditList:add(GUI.Label(""))

    h2Texts[#h2Texts+1] = Credits.creditList:add(GUI.Label("Lighting Engine"))
    normalTexts[#normalTexts+1] = Credits.creditList:add(GUI.Label("Steve Wolligandt"))

    h1Texts[#h1Texts+1] = Credits.creditList:add(GUI.Label(""))
    h1Texts[#h1Texts+1] = Credits.creditList:add(GUI.Label(""))

    h2Texts[#h2Texts+1] = Credits.creditList:add(GUI.Label("Tilemap Engine"))
    normalTexts[#normalTexts+1] = Credits.creditList:add(GUI.Label("Steve Wolligandt"))

    h1Texts[#h1Texts+1] = Credits.creditList:add(GUI.Label(""))
    h1Texts[#h1Texts+1] = Credits.creditList:add(GUI.Label(""))

    h2Texts[#h2Texts+1] = Credits.creditList:add(GUI.Label("GUI Engine"))
    normalTexts[#normalTexts+1] = Credits.creditList:add(GUI.Label("Steve Wolligandt"))

    h1Texts[#h1Texts+1] = Credits.creditList:add(GUI.Label(""))
    h1Texts[#h1Texts+1] = Credits.creditList:add(GUI.Label(""))

    h2Texts[#h2Texts+1] = Credits.creditList:add(GUI.Label("Game Engine and Game Mechanics"))
    normalTexts[#normalTexts+1] = Credits.creditList:add(GUI.Label("Steve Wolligandt"))

    h1Texts[#h1Texts+1] = Credits.creditList:add(GUI.Label(""))
    h1Texts[#h1Texts+1] = Credits.creditList:add(GUI.Label(""))

    h2Texts[#h2Texts+1] = Credits.creditList:add(GUI.Label("Networking Engine"))
    normalTexts[#normalTexts+1] = Credits.creditList:add(GUI.Label("Robert Wlcek"))

    h1Texts[#h1Texts+1] = Credits.creditList:add(GUI.Label(""))
    h1Texts[#h1Texts+1] = Credits.creditList:add(GUI.Label(""))

    h2Texts[#h2Texts+1] = Credits.creditList:add(GUI.Label("Sound Desing"))
    normalTexts[#normalTexts+1] = Credits.creditList:add(GUI.Label("Robert Wlcek"))

    h1Texts[#h1Texts+1] = Credits.creditList:add(GUI.Label(""))
    h1Texts[#h1Texts+1] = Credits.creditList:add(GUI.Label(""))

    h2Texts[#h2Texts+1] = Credits.creditList:add(GUI.Label("Texturing"))
    normalTexts[#normalTexts+1] = Credits.creditList:add(GUI.Label("Stefan Dreier"))



    Credits.creditList:addWidgetsToContainer(Credits.GUI)
    Credits.GUI:addWidget(Credits.labelThankYou)

    Credits.labelThankYou.font = Game.getFont("assets/fonts/nulshock bd.ttf", 50)
    Credits.labelThankYou.fontColor = {255,255,255,0}

    for i,curWidget in pairs(h1Texts) do curWidget.font = h1Font end
    for i,curWidget in pairs(h2Texts) do curWidget.font = h2Font end
    for i,curWidget in pairs(normalTexts) do curWidget.font = normalFont end
end
