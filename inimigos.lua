local js = require("js")

local Body = js.global.Body
local inimigos = js.global.inimigos
local p1 = js.global.personagem
local p2 = js.global.personagem2
local enemySpeed = 1.5

-- Função para atualizar a IA de todos os inimigos
local atualizarIA = function()
    if not inimigos then return end
    
    for i = 0, inimigos.length - 1 do
        local inimi = inimigos[i]
        if inimi and inimi.position.x > -500 then -- Verifica se não foi "derrotado"
            -- Encontra o player mais próximo
            local alvo = p1
            local distP1 = math.abs(inimi.position.x - p1.position.x)
            local distP2 = math.abs(inimi.position.x - p2.position.x)
            if distP2 < distP1 then alvo = p2 end

            -- Move em direção ao player
            if inimi.position.x < alvo.position.x then
                Body.setVelocity(inimi, {x = enemySpeed, y = inimi.velocity.y})
            else
                Body.setVelocity(inimi, {x = -enemySpeed, y = inimi.velocity.y})
            end
            
            -- Lógica de "Dano" (Verifica se algum player próximo está atacando)
            local dist = math.abs(inimi.position.x - alvo.position.x)
            if dist < 60 then
                -- Precisamos checar os estados que estão no outro arquivo ou via global
                -- Por simplicidade, vamos checar se a animação atual é de ataque
                local animP1 = js.global.animAtualP1
                local animP2 = js.global.animAtualP2
                
                if (alvo == p1 and (animP1 == "espada" or animP1 == "arco")) or
                   (alvo == p2 and (animP2 == "espada" or animP2 == "arco")) then
                    Body.setPosition(inimi, {x = -1000, y = -1000}) -- Remove o inimigo
                    js.global.window.console:log("Inimigo derrotado pela IA separada!")
                end
            end
        end
    end
end

-- Conecta a IA ao motor do jogo
js.global.Matter.Events:on(js.global.engine, "beforeUpdate", atualizarIA)

js.global.window.console:log("Lua: Arquivo de Inimigos carregado com sucesso!")
