--
-- Vars
--
ESX = nil

job = false
job2 = false
job3 = false

Bus = {
    ['station'] = {
        ['npc'] = vector4(453.91, -600.7, 27.58, 252.48),
        ['npcL'] = vector3(453.91, -600.7, 29.58),
        ['blip'] = vector3(453.91, -600.7, 28.58),
        ['spawnVeh'] = vector3(465.9, -603.32, 28.5),
        ['label'] = "[~b~E~w~] Para hablar con carl",
        ['noBus'] = "~r~No eres conductor de autobus"
    },
    ['rute'] = {
        ['passagers'] = vector3(-1024.11, -2728.89, 12.66),
        ['passagersL'] = vector3(-1024.11, -2728.89, 14.66),
        ['goto'] = vector3(-211.18, 6213.12, 30.49),
        ['gotoL'] = vector3(-211.18, 6213.12, 33.49)
    },
    ['return'] = {
        ['bus'] = vector3(465.9, -603.32, 27.5),
        ['busL'] = vector3(465.9, -603.32, 29.5)
    }
}

--
-- ESX Callbacks
--
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job2 == nil do
		Citizen.Wait(100)
    end
    
    PlayerData = ESX.GetPlayerData()
    
    SpawnNPC('a_m_m_eastsa_02', 'world_human_clipboard', Bus['station']['npc'])
    while true do
        local s = 1000
        local ply = PlayerPedId()
        local plyc = GetEntityCoords(ply)
        if #(plyc - Bus['station']['npcL']) < 5.0 then
            s = 5
            if #(plyc - Bus['station']['npcL']) < 2.5 then
                s = 0
                if PlayerData.job2 ~= nil and PlayerData.job2.name == 'bus' then
                    if job == false then
                        ESX.ShowFloatingHelpNotification(Bus['station']['label'], Bus['station']['npcL'])
                        if IsControlJustPressed(0, 38) then
                            TriggerServerEvent('InteractSound_SV:PlayOnSource', 'bus', 0.9)
                            TriggerEvent('oa-bus:StartTutorial')
                            blip = AddBlipForCoord(Bus['rute']['passagers'])
                            SetBlipRoute(blip, true)
                            job = true
                            ESX.Game.SpawnVehicle('coach', Bus['station']['spawnVeh'], 173.61, function(v)
                                exports['oa-fuel']:SetFuel(v, 100)
                            end)
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                                if skin.sex == 0 then
                                    TriggerEvent('skinchanger:change', 'tshirt_1', 15)
                                    TriggerEvent('skinchanger:change', 'tshirt_2', 0)
                                    TriggerEvent('skinchanger:change', 'torso_1', 8)
                                    TriggerEvent('skinchanger:change', 'torso_2', 0)
                                    TriggerEvent('skinchanger:change', 'pants_1', 26)
                                    TriggerEvent('skinchanger:change', 'pants_2', 2)
                                    TriggerEvent('skinchanger:change', 'shoes_1', 10)
                                    TriggerEvent('skinchanger:change', 'shoes_2', 0)
                                    TriggerEvent('skinchanger:change', 'helmet_1', 61)
                                    TriggerEvent('skinchanger:change', 'helmet_2', 2)
                                    TriggerEvent('skinchanger:change', 'arms', 58)
                                    TriggerEvent('skinchanger:change', 'chain_1', 23)
                                    TriggerEvent('skinchanger:change', 'chain_2', 6)
                                    TriggerEvent('skinchanger:change', 'decals_1', 0)
                                else
                                    TriggerEvent('skinchanger:change', 'tshirt_1', 38)
                                    TriggerEvent('skinchanger:change', 'tshirt_2', 0)
                                    TriggerEvent('skinchanger:change', 'torso_1', 58)
                                    TriggerEvent('skinchanger:change', 'torso_2', 2)
                                    TriggerEvent('skinchanger:change', 'pants_1', 37)
                                    TriggerEvent('skinchanger:change', 'pants_2', 2)
                                    TriggerEvent('skinchanger:change', 'shoes_1', 0)
                                    TriggerEvent('skinchanger:change', 'shoes_2', 0)
                                    TriggerEvent('skinchanger:change', 'helmet_1', -1)
                                    TriggerEvent('skinchanger:change', 'helmet_2', -1)
                                    TriggerEvent('skinchanger:change', 'chain_1', 87)
                                    TriggerEvent('skinchanger:change', 'chain_2', 2)
                                    TriggerEvent('skinchanger:change', 'arms', 7)
                                    TriggerEvent('skinchanger:change', 'decals_1', 0)
                                end
                            end)
                        end
                    else
                        ESX.ShowFloatingHelpNotification("~r~Termina tu ruta antes de coger otra", Bus['station']['npcL'])
                    end
                else
                    ESX.ShowFloatingHelpNotification(Bus['station']['noBus'], Bus['station']['npcL'])
                end
            end
        end
        Citizen.Wait(s)
    end
end)

Citizen.CreateThread(function()
    while true do
        local _msec = 250
        if job == true then
            _msec = 0
            if IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1)), GetHashKey('coach')) then
                DrawText("Recoge a los ~g~pasajeros")
            elseif not IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1)), GetHashKey('coach')) then
                DrawText("Sube al ~y~bus")
            end
            if #(GetEntityCoords(PlayerPedId()) - Bus['rute']['passagers']) < 30.0 then
                DrawMarker(1, Bus['rute']['passagers'], 0, 0, 0, 0, 0, 0, 3.5001, 3.5001, 0.3001,0,223,0, 200, 0, 0, 0, 0)
                if #(GetEntityCoords(PlayerPedId()) - Bus['rute']['passagers']) < 5.0 then
                    ESX.ShowFloatingHelpNotification("[~g~E~w~] Para recoger a los pasajeros", Bus['rute']['passagersL'])
                    if IsControlJustPressed(0, 38) and IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1)), GetHashKey('coach')) then
                        SetBlipRoute(blip, false)
                        RemoveBlip(blip)
                        blip2 = AddBlipForCoord(Bus['rute']['goto'])
                        SetBlipRoute(blip2, true)
                        FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId()), true)
                        TriggerEvent("pNotify:SendNotification",{
                            text = "<center><strong><b style='color:#df03fc'>CONDOR BUS</b><strong><br /> <br /> Espera un momento... Se estan subiendo los pasajeros al bus!<center>",
                            type = "success",
                            timeout = (6000),
                            layout = "CenterRight",
                            queue = "global"
                        })
                        Citizen.Wait(5000)
                        FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId()), false)
                        job = false
                        job2 = true
                    elseif IsControlJustPressed(0, 38) and not IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1)), GetHashKey('coach')) then
                        TriggerEvent('chatMessage', 'Jefe', {255, 0, 0}, ' Hey Debes estar arriba del bus!')
                    end
                end
            end
        end
        if job2 == true then
            _msec = 0
            DrawText("Deja a los ~b~pasajeros")
            if #(GetEntityCoords(PlayerPedId()) - Bus['rute']['goto']) < 30.0 then
                DrawMarker(1, Bus['rute']['goto'], 0, 0, 0, 0, 0, 0, 3.5001, 3.5001, 0.3001,0,223,0, 200, 0, 0, 0, 0)
                if #(GetEntityCoords(PlayerPedId()) - Bus['rute']['goto']) < 5.0 then
                    ESX.ShowFloatingHelpNotification("[~g~E~w~] Para dejar a los pasajeros", Bus['rute']['gotoL'])
                    if IsControlJustPressed(0, 38) and IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1)), GetHashKey('coach')) then
                        SetBlipRoute(blip2, false)
                        RemoveBlip(blip2)
                        blip3 = AddBlipForCoord(Bus['return']['bus'])
                        SetBlipRoute(blip3, true)
                        FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId()), true)
                        TriggerEvent("pNotify:SendNotification",{
                            text = "<center><strong><b style='color:#df03fc'>CONDOR BUS</b><strong><br /> <br /> Espera, los pasajeros se estan bajando del bus!<center>",
                            type = "success",
                            timeout = (2000),
                            layout = "CenterRight",
                            queue = "global"
                        })
                        TriggerEvent("pNotify:SendNotification",{
                            text = "<center><strong><b style='color:#df03fc'>CONDOR BUS</b><strong><br /> <br /> Espera, los pasajeros estan sacando las maletas!<center>",
                            type = "success",
                            timeout = (9000),
                            layout = "CenterRight",
                            queue = "global"
                        })
                        Citizen.Wait(7000)
                        FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId()), false)
                        job2 = false
                        job3 = true
                    elseif IsControlJustPressed(0, 38) and not IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1)), GetHashKey('coach')) then
                        TriggerEvent('chatMessage', 'Jefe', {255, 0, 0}, ' Hey Debes estar arriba del bus! ')
                    end
                end
            end
        end
        if job3 == true then
            _msec = 0
            DrawText("Deja el ~r~bus")
            if #(GetEntityCoords(PlayerPedId()) - Bus['return']['bus']) < 30.0 then
                DrawMarker(1, Bus['return']['bus'], 0, 0, 0, 0, 0, 0, 3.5001, 3.5001, 0.3001,0,223,0, 200, 0, 0, 0, 0)
                if #(GetEntityCoords(PlayerPedId()) - Bus['return']['bus']) < 5.0 then
                    ESX.ShowFloatingHelpNotification("[~g~E~w~] Para dejar el bus", Bus['return']['busL'])
                    if IsControlJustPressed(0, 38) and IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1)), GetHashKey('coach')) then
                        SetBlipRoute(blip3, false)
                        RemoveBlip(blip3)
                        job3 = false
                        DeleteEntity(GetVehiclePedIsIn(PlayerPedId()))
                        ESX.TriggerServerCallback('oa-bus:giveMoney', function()
                        
                        end, math.random(40000, 90000)) 
                        --exports.oa_xp:ESXP_Add(70)
                        TriggerEvent("pNotify:SendNotification",{
                            text = "<center><strong><b style='color:#df03fc'>CONDOR BUS</b><strong><br /> <br /> Buen trabajo, aqui tienes tu recompensa <center>",
                            type = "success",
                            timeout = (6000),
                            layout = "CenterRight",
                            queue = "global"
                        })
                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                            local model = nil
                
                            if skin.sex == 0 then
                                model = GetHashKey("mp_m_freemode_01")
                            else
                                model = GetHashKey("mp_f_freemode_01")
                            end
                
                            RequestModel(model)
                            while not HasModelLoaded(model) do
                                RequestModel(model)
                                Citizen.Wait(1)
                            end
                
                            SetPlayerModel(PlayerId(), model)
                            SetModelAsNoLongerNeeded(model)
                
                            TriggerEvent('skinchanger:loadSkin', skin)
                            TriggerEvent('esx:restoreLoadout')
                            local playerPed = GetPlayerPed(-1)
                            SetPedArmour(playerPed, 0)
                            ClearPedBloodDamage(playerPed)
                            ResetPedVisibleDamage(playerPed)
                            ClearPedLastWeaponDamage(playerPed)
                        end)
                    elseif IsControlJustPressed(0, 38) and not IsVehicleModel(GetVehiclePedIsIn(GetPlayerPed(-1)), GetHashKey('coach')) then
                        TriggerEvent('chatMessage', 'Jefe', {255, 0, 0}, ' y mi bus?')
                    end
                end
            end
        end
        Citizen.Wait(_msec)
    end
end)

--
-- Funcs
--
SpawnNPC = function(modelo, anim, x,y,z,h)
    hash = GetHashKey(modelo)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(1)
    end
    crearNPC = CreatePed(5, hash, x,y,z,h, false, true)
    FreezeEntityPosition(crearNPC, true)
    SetEntityInvincible(crearNPC, true)
    SetBlockingOfNonTemporaryEvents(crearNPC, true)
    TaskStartScenarioInPlace(crearNPC, anim, 0, false)
end

DrawText = function(text)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(0, 1)
end

DrawText = function(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(0, time)
end

Citizen.CreateThread(function()
    blip = AddBlipForCoord(Bus['return']['bus'])
    SetBlipSprite(blip, 106)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, 30)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Estación de bus")
    EndTextCommandSetBlipName(blip)
end)

--
-- Job callbakc
--

RegisterNetEvent('oa-bus:forceEnd')
AddEventHandler('oa-bus:forceEnd', function()
    job = false
    job2 = false
    job3 = false
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	PlayerData.job2 = job2
end)

----HUI
Citizen.CreateThread(function()
    while true do
        if guiEnabled then
            DisableControlAction(0, 1, guiEnabled) -- LookLeftRight
            DisableControlAction(0, 2, guiEnabled) -- LookUpDown

            DisableControlAction(0, 142, guiEnabled) -- MeleeAttackAlternate

            DisableControlAction(0, 106, guiEnabled) -- VehicleMouseControlOverride

            if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
                SendNUIMessage({
                    type = "click"
                })
            end
        end
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('oa-bus:StartTutorial')
AddEventHandler('oa-bus:StartTutorial',function()
	EnableGui(true)
end)

RegisterNUICallback('closeNUI', function(data, cb)
    EnableGui(false)
end) 

function EnableGui(enable)
    SetNuiFocus(enable)
    guiEnabled = enable

    SendNUIMessage({
        type = "enabledBus",
        enable = enable
    })
end