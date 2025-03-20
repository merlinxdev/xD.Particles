ESX = exports["es_extended"]:getSharedObject()

local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
local UICallback = RegisterNuiCallback
local ResourceName = GetCurrentResourceName()
Wait(200)
Particlex = ParticlesClass.new(Particles)
Citizen.CreateThread(function()
    Particlex:UpdateNUI()
    while true do
        Citizen.Wait(300)
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        Particlex:setObject(pedCoords)
    end
end)

UICallback("NEXT_PARTICLE",function()
    Particlex:Next()
    Particlex:UpdateNUI()
end)

UICallback("PREV_PARTICLE",function()
    Particlex:Prev()
    Particlex:UpdateNUI()
end)

UICallback("AUTO_PARTICLE",function(data)
    Particlex:autoPlayParticles()
    
end)

UICallback("CLOSE_MENU",function(data)
    XD.XD_NUI("__",{},false)
end)

UICallback("PLAY_PARTICLE",function(data)
    Particlex.particleonPlay = data.particle_play
end)

RegisterNetEvent(ResourceName..":UI:Toggle",function()
    if not XD.NUI then
        XD.XD_NUI("XD_NUI_SHOW",{ ui = true},true)
    else
        XD.XD_NUI("XD_NUI_SHOW",{ ui = false},false)
    end
end)

Citizen.CreateThread(function()
    while true do
        if Particlex.particleonPlay then
            local dict , name = Particlex:getParticles()
            Particlex:playParticle(dict , name, 1.0)
        end
        Citizen.Wait(1000)
    end
end)

function playParticle(dict,name,coords,size)
    Particlex:setObject(coords)
    Particlex:playParticle(dict,name,size)
end

exports("playParticle",playParticle)
exports("getParticle",function() return Particlex.processedParticles end)