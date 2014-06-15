--- Some helpful functions concerning Colors and some predefined colors

--- Predefined Colors
--@field red {255,0,0}
--@field green {0,255,0}
--@field blue {0,0,255}
--@field yellow {255,255,0}
--@field cyan {0,255,255}
--@field magenta {255,0,255}
--@field white {255,255,255}
--@field black {0,0,0}
Utilities.Color = {}
Utilities.Color.red     = {255,0,0}
Utilities.Color.green   = {0,255,0}
Utilities.Color.blue    = {0,0,255}
Utilities.Color.yellow  = {255,255,0}
Utilities.Color.cyan    = {0,255,255}
Utilities.Color.magenta = {255,0,255}
Utilities.Color.white   = {255,255,255}
Utilities.Color.black   = {0,0,0}

--- componentwise multiplication of two colors
--@param color1 first color to be multiplied
--@param color2 second color to be multiplied
function Utilities.Color.mul(color1, color2)
     local multipliedColor = {  ((color1[1]/255) * (color2[1]/255))*255,
                                ((color1[2]/255) * (color2[2]/255))*255,
                                ((color1[3]/255) * (color2[3]/255))*255}

    return multipliedColor
end
