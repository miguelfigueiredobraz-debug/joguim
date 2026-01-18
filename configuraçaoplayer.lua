-- variaveis de movimento
local right = 3
local jumpForce = -0.03
local left = -3
-- Configuração do movimento do Player (Matter.js + Lua)
local js = require("js")


-- Carregando o sistema de teclado
-- Para que o 'require' funcione em arquivos separados, 
-- o Fengari precisa que o projeto esteja rodando em um servidor (Live Server).


-- Referências aos objetos físicos do Matter.js
local personagem = js.global.personagem
local Body = js.global.Body
local engine = js.global.engine
-- Variáveis de controle de movimento
input.iskeyleft = input.iskeyhold("a")
input.iskeyright = input.iskeyhold("d")
input.iskeyjump = input.iskeyhold("space")
-- Essa função será o "cérebro" do boneco
local movimento = function()
    -- Pulo (Tecla Espaço)
    if input.ispressed("space") or input.ispressed("w") then
        Body:applyForce(personagem, personagem.position, {x = 0, y = jumpForce})
    end

    -- Movimento para os lados (Teclas A e D)
      if input.iskeyhold("a") or input.iskeyhold("left") then
        Body:setVelocity(personagem, {x = left, y = personagem.velocity.y})

      end 
        if input.iskeyhold("d") or input.iskeyhold("right") then
        Body:setVelocity(personagem, {x = right, y = personagem.velocity.y})
       end
end


-- Aqui conectamos o nosso código ao motor do jogo
js.global.Matter.Events:on(engine, "beforeUpdate", movimento)

js.global.window.console:log("Lua: Configuração do Player carregada!")