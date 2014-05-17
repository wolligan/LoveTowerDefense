Testing.SlicedSprite = {}
Testing.SlicedSprite.activeKeyBinding = {}
Testing.SlicedSprite.activeKeyBinding["escape"] = {
    pressed = function()
        Game.changeState(Testing.Menu)
    end
}

function Testing.SlicedSprite.init()
    slicedSprite1 = Utilities.SlicedSprite( "assets/sprites/GUI/slicedShadedBackground_20_20_20_20.png",
                                            100, 100,
                                            300, 400,
                                            0, 30, 0, 50 )
end

function Testing.SlicedSprite.render()
    slicedSprite1:render()
end

function Testing.SlicedSprite.update(dt)

end
