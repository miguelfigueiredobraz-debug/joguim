key = require("key")
index.html = require("index.html")
index.html.connect.on("fullscreen", fullscreen)

function fullscreen() 
    if fullscreen = true and ispressed("ç") then
        window.exitFullscreen()
        fullscreen = false
    else
    if fullscreen = false and ispressed("ç") then
        fullscreen = true
        window.requestFullscreen(true)
       
    end
end
