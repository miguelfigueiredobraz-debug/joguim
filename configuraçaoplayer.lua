-- Configuração do movimento do Player e IA dos Inimigos
local js = require("js")

-- Configurações de Física
local speed = 4
local jumpForce = -0.04
local enemySpeed = 1.5

-- Referências aos objetos químicos
local Body = js.global.Body
local engine = js.global.engine
local p1 = js.global.personagem
local p2 = js.global.personagem2
local inimigos = js.global.inimigos

-- Definição dos frames
local frames = {
    correr = {0, 1, 2, 3},
    arco   = {4, 5, 6, 7},
    espada = {8, 9, 10, 11},
    parado = {0}
}

-- Estados dos jogadores
local estadoP1 = { frameIdx = 1, timer = 0, anim = "parado" }
local estadoP2 = { frameIdx = 1, timer = 0, anim = "parado" }

-- IA dos Inimigos
local atualizarInimigos = function()
    if not inimigos then return end
    
    for i = 0, inimigos.length - 1 do
        local inimi = inimigos[i]
        if inimi then
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
            
            -- Lógica de "Dano": se o player estiver atacando perto do inimigo
            local dist = math.abs(inimi.position.x - alvo.position.x)
            if dist < 60 then
                local estadoAlvo = (alvo == p1) and estadoP1 or estadoP2
                if estadoAlvo.anim == "espada" or estadoAlvo.anim == "arco" then
                    -- Inimigo some ao ser atingido (move para longe por enquanto)
                    Body.setPosition(inimi, {x = -1000, y = -1000})
                    js.global.window.console:log("Inimigo derrotado!")
                end
            end
        end
    end
end

-- Função para trocar o frame
local atualizarAnimacao = function(corpo, estado)
    if not js.global.p1Frames or #js.global.p1Frames == 0 then return end
    
    estado.timer = estado.timer + 1
    if estado.timer > 8 then
        estado.timer = 0
        estado.frameIdx = estado.frameIdx + 1
        
        local lista = frames[estado.anim]
        if estado.frameIdx > #lista then 
            if estado.anim == "arco" or estado.anim == "espada" then
                estado.anim = "parado"
            end
            estado.frameIdx = 1 
        end
        
        local frameReal = frames[estado.anim][estado.frameIdx]
        corpo.render.sprite.texture = js.global.p1Frames[frameReal + 1]
    end
end

-- Controle de Player
local controlarPlayer = function(corpo, estado, teclas)
    if not corpo then return end

    if estado.anim ~= "arco" and estado.anim ~= "espada" then
        estado.anim = "parado"
    end

    if input.isDown(teclas.espada) then estado.anim = "espada" end
    if input.isDown(teclas.arco) then estado.anim = "arco" end

    if input.isDown(teclas.pular) then
        Body.applyForce(corpo, corpo.position, {x = 0, y = jumpForce})
    end

    if input.isDown(teclas.esquerda) then
        Body.setVelocity(corpo, {x = -speed, y = corpo.velocity.y})
        corpo.render.sprite.xScale = -0.5
        if estado.anim == "parado" then estado.anim = "correr" end
    elseif input.isDown(teclas.direita) then
        Body.setVelocity(corpo, {x = speed, y = corpo.velocity.y})
        corpo.render.sprite.xScale = 0.5
        if estado.anim == "parado" then estado.anim = "correr" end
    end

    atualizarAnimacao(corpo, estado)
end

-- Loop principal
local loop = function()
    controlarPlayer(p1, estadoP1, {
        pular = "w", esquerda = "a", direita = "d",
        espada = "f", arco = "g"
    })

    controlarPlayer(p2, estadoP2, {
        pular = "up", esquerda = "left", direita = "right",
        espada = "k", arco = "l"
    })
    
    atualizarInimigos()
end

-- Conectar
js.global.Matter.Events:on(engine, "beforeUpdate", loop)

js.global.window.console:log("Lua: Players e Inimigos carregados!")