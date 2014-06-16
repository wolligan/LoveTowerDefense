# Game State Manager

The Game State Manager handles GUI Containers, [Keybindings](../modules/Keys.html) and helps you to structure your game. It also has some useful functions to not let your memory flow over because of sounds, fonts and sprites.
Additionaly it easily handles your coroutines.

## Callback functions of Game States
There are some Callback functions that are automatically called in your Game States if you have defined them:

* init() - gets the first time you start your Game State
* onActivate() -  gets called every time you activate the Game State
* onDeactivate() -  gets called when your Game State is activated you activate another Game State
* render() - do your rendering stuff in this function
* update(dt) - do your update stuff in this function

## Example Game State

In this section we create a simple Game State that creates, counts up and renders a number:

    MyGameState = {}
    
    --- initialize a simple value
    function MyGameState.init()
        MyGameState.value = 0
    end
    
    --- increase the value in update
    function MyGameState.update(dt)
       MyGameState.value = MyGameState.value + 10*dt
    end
    
    --- render the value on screen
    function MyGameState.render()
        love.graphics.print(MyGameState.value, 10, 10)
    end
    
## Keybindings

Now where we have our game state you want to interact with the game. At this step we create a simple keybinding

    MyGameState.activeKeyBinding = {}
    
There are 3 modes of key pushes:

* pressed
* released
* repeated

Let's create three keybindings and explain what each of the three modes does

    MyGameState.activeKeyBinding[" "] = {
       pressed = function()
            print("pressed space")
       end,
       
       released = function()
            print("released space")
       end,
    }
    
    MyGameState.activeKeyBinding["up"] = {
       repeated = function(dt)
            MyGameState.value = MyGameState.value + 2*dt
       end
    }
    
    MyGameState.activeKeyBinding["down"] = {
       repeated = function(dt)
            MyGameState.value = MyGameState.value - 2*dt
       end
    }
    
As you can see each keybind can have several modes (even all three modes are possible).
When you press space the function pressed will be called immediately.
When you release the space button the function released will be called. In this case it just prints something to console.
Pressing and holding up or down will change the MyGameState.value that we have defined in the MyGameState.init() function.
Note that when you define a repeated keybinding you also have a delta time from the current frame.

## Starting the Game State Manager

To start the Game State Manager you have to do the following in your main.lua:

    require "MyGameState"
    
    function love.load()
        Game.init(MyGameState)
    end
    
    function love.draw()
        Game.render()
    end
    
    function love.update(dt)
        Game.update(dt)
    end
    
## Change the Game State

To change a Game State simply call this:

    Game.changeState(AnotherGameState)
    
## GUI

When you create a [GUI Container](../../GUI/classes/Container.html) in a Game State the Game State Manager will automatically recognize that its in the activated Game State.
Changine to another Game State will activate the GUI of the new Game State. Changing back to the old Game State will activate the apparent GUI.

## Coroutines

Read through the [Coroutines Tutorial](http://lua-users.org/wiki/CoroutinesTutorial) if you are not familiar with coroutines.

To start a coroutine do the following:

    Game.startCoroutine(coroutine.create(function()
        -- do stuff
        coroutine.yield()
        -- do more stuff
        coroutine.yield()
        -- do even more stuff
    end)

Game State Manager will yield your coroutines after updating the current frame

## Memory functions

To not have any duplicate sprites, fonts or sounds in memory you can use these three functions:

* [getSprite](../modules/Game.html#getSprite)
* [getSound](../modules/Game.html#getFont)
* [getFont](../modules/Game.html#getSound)