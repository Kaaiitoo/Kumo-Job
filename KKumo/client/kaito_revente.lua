ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

loadDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job2 == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)



RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2
end)


function OhPetard()
    local OhPetard = RageUI.CreateMenu("Kumo", "Menu Intéraction..")
        RageUI.Visible(OhPetard, not RageUI.Visible(OhPetard))
            while OhPetard do
            Citizen.Wait(0)
            RageUI.IsVisible(OhPetard, true, true, true, function()

                RageUI.ButtonWithStyle("Vendre une cargaison de cocaine","Une Cargaison = ~o~50 pochons", {RightLabel = "~r~35000$"},true, function(Hovered, Active, Selected)
                    if (Selected) then 
                        
                        DoScreenFadeOut(3000)

                        Citizen.Wait(3000)
    
                        DoScreenFadeIn(3000)
                        TriggerServerEvent('ventecoke')
                        ClearPedTasksImmediately(GetPlayerPed(-1))
                    end
                end)

                
                end, function()
                end)
            if not RageUI.Visible(OhPetard) then
            OhPetard = RMenu:DeleteType("OhPetard", true)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'kumo' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Kaitoooo.pos.ReventeDrogue.position.x, Kaitoooo.pos.ReventeDrogue.position.y, Kaitoooo.pos.ReventeDrogue.position.z)
        if dist3 <= 10.0 and Kaitoooo.genre then
            Timer = 0
            DrawMarker(22, Kaitoooo.pos.ReventeDrogue.position.x, Kaitoooo.pos.ReventeDrogue.position.y, Kaitoooo.pos.ReventeDrogue.position.z,  0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 0, 0 , 255, true, true, p19, true)
            end
            if dist3 <= 1.5 then
                Timer = 0   
                        RageUI.Text({  message = "Appuyez sur [~r~E~w~] pour prendre la tablette", time_display = 1 })
                        if IsControlJustPressed(1,51) then  
                            ExecuteCommand'e tablet'         
                            OhPetard()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)



function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)


    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end
