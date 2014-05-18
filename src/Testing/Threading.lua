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


function love.threaderror(thread, errortext)
    error(errortext) -- Makes sure any errors that happen in the thread are displayed onscreen.
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
    local button1 = GUI.Button("Start Thread1", function()
            Testing.Threading.thread1 = love.thread.newThread("Utilities/thread.lua")
            Testing.Threading.thread1:start()
    end)
-- set anchors
    button1:setTopAnchor(GUI.Root, "bottom")
    button1:setRightAnchor(GUI.Root, "center")
-- set offsets
    button1.leftAnchorOffset   = 20
    button1.rightAnchorOffset  = -20
    button1.topAnchorOffset    = -60
    button1.bottomAnchorOffset = -20


-- create a button to start thread2
    local button2 = GUI.Button("Start Thread2", function()
            Testing.Threading.thread2 = love.thread.newThread("Testing/Threads/thread2.lua")
            Testing.Threading.thread2:start()
    end)
-- set anchors
    button2:setTopAnchor(GUI.Root, "bottom")
    button2:setLeftAnchor(GUI.Root, "center")
-- set offsets
    button2.leftAnchorOffset   = 20
    button2.rightAnchorOffset  = -20
    button2.topAnchorOffset    = -60
    button2.bottomAnchorOffset = -20


-- create a button to pause thread1
    local button3 = GUI.Button("Send Message to Thread1", function()
        if Testing.Threading.thread1 then
            Testing.Threading.channelThread1:push("hallo!")
        end
    end)
-- set anchors
    button3:setTopAnchor(button1, "top")
    button3:setBottomAnchor(button1, "top")
    button3:setRightAnchor(GUI.Root, "center")
-- set offsets
    button3.leftAnchorOffset   = 20
    button3.rightAnchorOffset  = -20
    button3.topAnchorOffset    = -60
    button3.bottomAnchorOffset = -20


-- create a button to pause thread1
    local button4 = GUI.Button("Send kill to Thread2", function()
        if Testing.Threading.thread2 then
            Testing.Threading.channelThread2:push("kill")
        end
    end)
-- set anchors
    button4:setTopAnchor(button2, "top")
    button4:setBottomAnchor(button2, "top")
    button4:setLeftAnchor(GUI.Root, "center")
-- set offsets
    button4.leftAnchorOffset   = 20
    button4.rightAnchorOffset  = -20
    button4.topAnchorOffset    = -60
    button4.bottomAnchorOffset = -20

    Testing.Threading.GUI:addWidget(label)
    Testing.Threading.GUI:addWidget(button1)
    Testing.Threading.GUI:addWidget(button2)
    Testing.Threading.GUI:addWidget(button3)
    Testing.Threading.GUI:addWidget(button4)
end
