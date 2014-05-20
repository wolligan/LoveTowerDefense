Testing.Threading = {}

Testing.Threading.activeKeyBinding = {}
Testing.Threading.activeKeyBinding["escape"] = {
    pressed = function()
        Game.changeState(Testing.Menu)
    end
}

function Testing.Threading.init()
    Testing.Threading.createGUI()
    Testing.Threading.channelThread1 = love.thread.getChannel("Thread1")
    Testing.Threading.channelThread2 = love.thread.getChannel("Thread2")
end

function Testing.Threading.render()

end

function Testing.Threading.update(dt)

end





function Testing.Threading.createGUI()

    Testing.Threading.GUI = GUI.Container(nil,Utilities.Color.white,nil,{255,255,255,200},{255,255,255,200},nil,Utilities.Color.black)
-- create a label
    local label = GUI.Label("Threading Test - Threads make console output only")
-- set anchors
    label:setBottomAnchor(GUI.Root, "top")
-- set offsets
    label.leftAnchorOffset   = 20
    label.rightAnchorOffset  = -20
    label.topAnchorOffset    = 20
    label.bottomAnchorOffset = 60


-- create a button to start thread1
    local button_startThread1 = GUI.Button("Start Thread1", function()
            Testing.Threading.thread1 = love.thread.newThread("Testing/Threads/thread1.lua")
            Testing.Threading.thread1:start()
    end)
-- set anchors
    button_startThread1:setTopAnchor(GUI.Root, "bottom")
    button_startThread1:setRightAnchor(GUI.Root, "center")
-- set offsets
    button_startThread1.leftAnchorOffset   = 20
    button_startThread1.rightAnchorOffset  = -20
    button_startThread1.topAnchorOffset    = -60
    button_startThread1.bottomAnchorOffset = -20


-- create a button to start thread2
    local button_startThread2 = GUI.Button("Start Thread2", function()
            Testing.Threading.thread2 = love.thread.newThread("Testing/Threads/thread2.lua")
            Testing.Threading.thread2:start()
    end)
-- set anchors
    button_startThread2:setTopAnchor(GUI.Root, "bottom")
    button_startThread2:setLeftAnchor(GUI.Root, "center")
-- set offsets
    button_startThread2.leftAnchorOffset   = 20
    button_startThread2.rightAnchorOffset  = -20
    button_startThread2.topAnchorOffset    = -60
    button_startThread2.bottomAnchorOffset = -20


-- create a button to send message thread1
    local button_sendMessageToThread1 = GUI.Button("Send Message to Thread1", function()
        if Testing.Threading.thread1 then
            Testing.Threading.channelThread1:push("hallo!")
        end
    end)
-- set anchors
    button_sendMessageToThread1:setTopAnchor(button_startThread1, "top")
    button_sendMessageToThread1:setBottomAnchor(button_startThread1, "top")
    button_sendMessageToThread1:setRightAnchor(GUI.Root, "center")
-- set offsets
    button_sendMessageToThread1.leftAnchorOffset   = 20
    button_sendMessageToThread1.rightAnchorOffset  = -20
    button_sendMessageToThread1.topAnchorOffset    = -60
    button_sendMessageToThread1.bottomAnchorOffset = -20


-- create a button to kill thread2
    local button_sendKillToThread2 = GUI.Button("Send kill to Thread2", function()
        if Testing.Threading.thread2 then
            Testing.Threading.channelThread2:push("kill")
        end
    end)
-- set anchors
    button_sendKillToThread2:setTopAnchor(button_startThread2, "top")
    button_sendKillToThread2:setBottomAnchor(button_startThread2, "top")
    button_sendKillToThread2:setLeftAnchor(GUI.Root, "center")
-- set offsets
    button_sendKillToThread2.leftAnchorOffset   = 20
    button_sendKillToThread2.rightAnchorOffset  = -20
    button_sendKillToThread2.topAnchorOffset    = -60
    button_sendKillToThread2.bottomAnchorOffset = -20

    Testing.Threading.GUI:addWidget(label)
    Testing.Threading.GUI:addWidget(button_startThread1)
    Testing.Threading.GUI:addWidget(button_startThread2)
    Testing.Threading.GUI:addWidget(button_sendMessageToThread1)
    Testing.Threading.GUI:addWidget(button_sendKillToThread2)
end
