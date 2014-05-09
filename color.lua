Color = {}

function Color.mul(color1, color2)
     local multipliedColor = {  ((color1[1]/255) * (color2[1]/255))*255,
                                ((color1[2]/255) * (color2[2]/255))*255,
                                ((color1[3]/255) * (color2[3]/255))*255}

    return multipliedColor
end

Color.red = {255,0,0}
Color.green = {0,255,0}
Color.blue = {0,0,255}
Color.yellow = {255,255,0}
Color.cyan = {0,255,255}
Color.magenta = {255,0,255}
Color.white = {255,255,255}
Color.black = {0,0,0}
