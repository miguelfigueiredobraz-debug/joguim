local js = require("js")
input = {}

-- Função genérica para verificar se uma tecla está pressionada
-- Aceita nomes amigáveis ou o código da tecla (e.x: "w", "arrowup", " ")
function input.isDown(key)
    local k = key:lower()
    
    -- Traduções para facilitar a vida
    if k == "space" then k = " " end
    if k == "up" then k = "arrowup" end
    if k == "down" then k = "arrowdown" end
    if k == "left" then k = "arrowleft" end
    if k == "right" then k = "arrowright" end
    
    return js.global.teclasPressionadas[k] == true
end

return input
