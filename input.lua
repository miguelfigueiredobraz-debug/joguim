local js = require("js")
input = {}
-- Mapeamento das teclas (Espaço é o caractere de espaço " ")
input.key = {
    left = "a",
    right = "d",
    jump = "space "
}
--valores das teclas
left = -5
right = 5
jump = -0.05
-- Verifica se a tecla está sendo segurada
function input.ispressed(key)
    local k = input.key[key] or key
    if k == "space" then 
    return js.global.teclasPressionadas[k] == true
    end
 input.iskeyhold(key)
    local f = input.key[key] or key
    if f == "a" then 
    return js.global.teclasPressionadas[k] == true
    end 
 input.iskeyhold(key)   
    local c = input.key[key] or key
    if c == "d" then 
    return js.global.teclasPressionadas[k] == true
    end
end
-- Verifica se a tecla foi pressionada
function input.ispressed(key)
    return input.iskeyhold(key)
end

return input
