--- Some helpful functions concerning Colors and some predefined colors
Utilities.Color = {}

--- componentwise multiplication of two colors
function Utilities.Color.mul(color1, color2)
     local multipliedColor = {  ((color1[1]/255) * (color2[1]/255))*255,
                                ((color1[2]/255) * (color2[2]/255))*255,
                                ((color1[3]/255) * (color2[3]/255))*255}

    return multipliedColor
end

Utilities.Color.red     = {255,0,0}
Utilities.Color.green   = {0,255,0}
Utilities.Color.blue    = {0,0,255}
Utilities.Color.yellow  = {255,255,0}
Utilities.Color.cyan    = {0,255,255}
Utilities.Color.magenta = {255,0,255}
Utilities.Color.white   = {255,255,255}
Utilities.Color.black   = {0,0,0}
