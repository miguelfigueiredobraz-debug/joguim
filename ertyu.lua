local js = require("js")

local Body = js.global.Body
local boss = js.global.boss
local p1 = js.global.personagem
local p2 = js.global.personagem2
local bossSpeed = 0.8 -- Mais lento, mas implacável
local bossVida = 10 -- Boss precisa de 10 golpes!

-- Função para o Boss perseguir os jogadores
local processarBoss = function()
    if not boss or bossVida <= 0 then return end
    
    -- Persegue o player mais próximo
    local alvo = p1
    local distP1 = math.abs(boss.position.x - p1.position.x)
    local distP2 = math.abs(boss.position.x - p2.position.x)
    if distP2 < distP1 then alvo = p2 end

    if boss.position.x < alvo.position.x then
        Body.setVelocity(boss, {x = bossSpeed, y = boss.velocity.y})
    else
        Body.setVelocity(boss, {x = -bossSpeed, y = boss.velocity.y})
    end

    -- Pulo gigante ocasional
    if math.random(1, 100) > 98 then
        Body.applyForce(boss, boss.position, {x = 0, y = -0.5})
    end

    -- Verificação de dano (precisa de muitos golpes)
    local dist = math.abs(boss.position.x - alvo.position.x)
    if dist < 120 then
        local animP1 = js.global.animAtualP1
        local animP2 = js.global.animAtualP2
        
        if (alvo == p1 and (animP1 == "espada" or animP1 == "arco")) or
           (alvo == p2 and (animP2 == "espada" or animP2 == "arco")) then
            
            bossVida = bossVida - 1
            js.global.window.console:log("BOSS ATINGIDO! Vida restante: " .. bossVida)
            
            -- Empurra o boss para trás ao ser atingido
            Body.applyForce(boss, boss.position, {x = (boss.position.x < alvo.position.x and -0.2 or 0.2), y = -0.1})

            if bossVida <= 0 then
                Body.setPosition(boss, {x = -2000, y = -2000}) -- Boss derrotado!
                js.global.window.console:log("O BOSS FOI DERROTADO! VITÓRIA!")
            end
        end
    end
end

-- Conecta ao motor do jogo
js.global.Matter.Events:on(js.global.engine, "beforeUpdate", processarBoss)

js.global.window.console:log("Lua: O Boss Final (ertyu.lua) despertou!")
