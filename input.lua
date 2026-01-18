local js = require("js")
input = {}

-- Mapeamento das teclas
input.key = {
    left = "a",
    right = "d",
    jump = "space"
}

-- Valores padrão
left = -5
right = 5
jump = -0.05

-- Verifica se a tecla foi pressionada (Dica do Miguel: agora funciona!)
function input.ispressed(key)
    local k = input.key[key] or key
    if k == "space" then k = " " end
    return js.global.teclasPressionadas[k] == true
end

-- Verifica se a tecla está sendo segurada (Agora sem o loop que travava!)
function input.iskeyhold(key)
    local k = input.key[key] or key
    
    -- Traduzindo nomes para o que o computador entende
    if k == "a" or k == "left" then k = "a" end
    if k == "d" or k == "right" then k = "d" end
    if k == "space" then k = " " end
    
    -- Verificamos se está apertada no JS
    if js.global.teclasPressionadas[k] == true then
        return true
    else
        return false
    end
end

return input
