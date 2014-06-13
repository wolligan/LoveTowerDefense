# A GUI Toolkit for Games

## Introduction

Within the scope of developing a the game we needed a solid GUI Toolkit for automatically positioning of buttons, labels, text entries, etc.
The GUI Toolkit is inspired by the leading GUI Toolkit for the Unity3D Game Engine named "NGUI". 
Every Widget has anchors on the left, right, top and bottom side.
You can snap those anchors to anchors of other widgets or the borders of the screen. By setting the offset of the anchors you can position them freely on the screen.

## Integrate the GUI Toolkit to your löve2D Game
At first you need to require the simple Object Orientation we have written and after that the GUI Toolkit itself:

    require "Utilities.OO"
    require "GUI"
        
Add the render and update function of the GUI Toolkit at the end of löve2D's draw and update function:

    function love.draw()
        
        ...
        
        GUI.render()
    end
    
    function love.update(dt)
        
        ...
        
        GUI.update(dt)
    end

You also want to have key handling (if you do not want to have the key stealing feature then you can just call the last line of each callback)

    -- keypressed callback
    function love.keypressed(key)
    
        if GUI.activeContainer then
            if not GUI.activeContainer.stealKeys then
                -- call here your own key handling
                myKeyPressed(key)    
            end
            
        else
            -- call here your own key handling
            myKeyPressed(key)
        end
        GUI.notifyKey(key)
    end
    
    
    -- keyreleased callback
    function love.keyreleased(key)
    
        if GUI.activeContainer then
            if not GUI.activeContainer.stealKeys then
                -- call here your own key handling
                myKeyReleased(key) 
            end
            
        else
            -- call here your own key handling
            myKeyReleased(key) 
        end
    end
    
    
    -- mousepressed callback
    function love.mousepressed(x, y, button)
    
        if GUI.activeContainer then
            if not GUI.activeContainer.stealKeys then
                -- call here your own key handling
                myMousePressed(x,y,button) 
            end
            
        else
            -- call here your own key handling
            myMousePressed(x,y,button)
        end

        if button == "l" then
            GUI.notifyClick()
        end
    end
    
    
    -- mousereleased callback
    function love.mousereleased(x, y, button)
    
        if GUI.activeContainer then
            if Game.state.activeKeyBinding then
                -- call here your own key handling
                myMouseReleased(x,y,button)
            end
            
        else
            if Game.state.activeKeyBinding[key] then
                -- call here your own key handling
                myMouseReleased(x,y,button)
            end
        end
        GUI.notifyRelease()
    end

## Widgets

Every Widget except Widget itself needs to be derived from the Widget class:
    --- Label Widget
    --@classmod Label

    require "GUI.Widget"

    GUI.Label = {}
    Utilities.OO.createDerivedClass(GUI.Label, GUI.Widget)
    
    -- ...

## Usage
At first you have to create a container to hold your widgets:

    -- create container

After that you can create your widgets

    -- create an example widget

Now you can position the widget. In this example we position it to bottom left corner and dimensions of 200x100

    -- set anchors and offsets
    
At last you have to add the widget to the container

    -- add widget to container

Optionally you can individualize every single widget.

    -- change font and font color