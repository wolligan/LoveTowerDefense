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

## Usage
At first you have to create a [Container](../classes/Container.html) to hold your widgets:

    -- create container with default colors and font
    local guiContainer = GUI.Container()

After that you can create your widgets

    -- create a label and a button
    local button = GUI.Button("This is a button", function() print("clicked the button") end)
    local label = GUI.Label("This is a label")

Now you can position the widgets. In this example we position the button to the bottom right corner with dimensions of 200x100 and the label to the top left corner with dimensions of 300x100.

    -- set anchors and offsets of the button
    button:setLeftAnchor(GUI.Root, "right")
    button:setRightAnchor(GUI.Root, "right")
    button:setBottomAnchor(GUI.Root, "bottom")
    button:setTopAnchor(GUI.Root, "bottom")
    
    button.leftAnchorOffset = -200
    button.rightAnchorOffset = 0
    button.bottomAnchorOffset = 0
    button.topAnchorOffset = -100
    
    -- set anchors and offsets of the label
    label:setLeftAnchor(GUI.Root, "left")
    label:setRightAnchor(GUI.Root, "left")
    label:setBottomAnchor(GUI.Root, "top")
    label:setTopAnchor(GUI.Root, "top")
    
    label.leftAnchorOffset = 0
    label.rightAnchorOffset = 300
    label.bottomAnchorOffset = 100
    label.topAnchorOffset = 0
    
    
At last you have to add the widget to the container

    -- add widget to container
    guiContainer:addWidget(button)
    guiContainer:addWidget(label)

After adding your widgets to the container you can optionally individualize every single widget.

    -- change font of your label
    label.font = love.graphics.newFont("path/to/your/font.ttf", 15)
    
    -- color of the button will be yellow
    button.fontColor = {255,255,0}

## Widgets
### How to make your own Widgets
Every [Widget](../classes/Widget.html) except Widget itself needs to be derived from the Widget class:

    --- My Widget
    --@classmod MyWidget

    require "GUI.Widget"

    GUI.MyWidget = {}
    Utilities.OO.createDerivedClass(GUI.MyWidget, GUI.Widget)
    
    --- Constructor
    function MyWidget:new()
	   self.label = 0
    end
    
Now we have our basic Widget which can be extended. For example you can overwrite the render and update functions.
(The Widget class has some useful [predefined methods](../classes/Widget.html#Render_functions) that can be used for rendering.)

    --- render overwrite
    -- renders the background and the label
    function MyWidget:render()
        self:renderBackground()
        self:renderLabel()
    end
    
    --- update overwrite
    -- increases the label variable by two per second
    function MyWidget:update(dt)
       self.label = self.label + 2 * dt
    end
    
    -- ...

Here is the list of all appearance settings you can change:

* font
* backgroundColor
* foregroundColor
* hoverColor
* clickedColor
* borderColor
* fontColor

### Callbacks
Every Widget has the following [Callback](../classes/Widget.html#Callback_functions) functions:

* render ()
* update (dt)
* onHover ()
* onClick ()
* onRelease ()
* notifyKey (key)
