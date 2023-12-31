ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local Ekip = nil

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job2)  
	PlayerData.job2 = job2  
	Citizen.Wait(5000) 
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


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job2)
	ESX.PlayerData.job2 = job2
end)


function bahjepensse()
    local tgay = RageUI.CreateMenu("Kumo", "Menu Intéraction..")
      RageUI.Visible(tgay, not RageUI.Visible(tgay))
  
              while tgay do
                  Citizen.Wait(0)
                      RageUI.IsVisible(tgay, true, true, true, function()

                        if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'kumo' and ESX.PlayerData.job2.grade_name == 'boss' then 
            if Ekip ~= nil then
                RageUI.ButtonWithStyle("Argent société :", nil, {RightLabel = "$" .. Ekip}, true, function()
                end)
            end
        end

            if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'kumo' and ESX.PlayerData.job2.grade_name == 'boss' then 
            RageUI.ButtonWithStyle("Retirer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    local amount = KeyboardInput("Montant", "", 10)
                    amount = tonumber(amount)
                    if amount == nil then
                        RageUI.Popup({message = "Montant invalide"})
                    else
                        TriggerServerEvent('esx_society:withdrawMoney', 'kumo', amount)
                        ExecuteCommand'e keyfob'
                        RefreshKaitoBA()
                    end
                end
            end)
        end

            if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'kumo' and ESX.PlayerData.job2.grade_name == 'boss' then 
            RageUI.ButtonWithStyle("Déposer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    local amount = KeyboardInput("Montant", "", 10)
                    amount = tonumber(amount)
                    if amount == nil then
                        RageUI.Popup({message = "Montant invalide"})
                    else
                        TriggerServerEvent('esx_society:depositMoney', 'kumo', amount)
                        ExecuteCommand'e keyfob'
                        RefreshKaitoBA()
                    end
                end
            end) 
        end

            if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'kumo' and ESX.PlayerData.job2.grade_name == 'boss' then 
           RageUI.ButtonWithStyle("Accéder aux actions de Management",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    aboss()
                    RageUI.CloseAll()
                end
            end)
        end


        end, function()
        end)
        if not RageUI.Visible(tgay) then
        tgay = RMenu:DeleteType("tgay", true)
    end
end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'kumo' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Kaitoooo.pos.ActionsBoss.position.x, Kaitoooo.pos.ActionsBoss.position.y, Kaitoooo.pos.ActionsBoss.position.z)
        if dist3 <= 10.0 and Kaitoooo.genre then
            Timer = 0
            DrawMarker(22, Kaitoooo.pos.ActionsBoss.position.x, Kaitoooo.pos.ActionsBoss.position.y, Kaitoooo.pos.ActionsBoss.position.z,  0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 0, 0 , 255, true, true, p19, true)
            end
            if dist3 <= 1.5 then
                Timer = 0   
                        RageUI.Text({  message = "Appuyez sur [~r~E~w~] pour gérer ton organisation", time_display = 1 })
                        if IsControlJustPressed(1,51) then           
                            RefreshKaitoBA()
                            bahjepensse()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function RefreshKaitoBA()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateKaitoBA(money)
        end, ESX.PlayerData.job2.name)
    end
end

function UpdateKaitoBA(money)
    Ekip = ESX.Math.GroupDigits(money)
end

function aboss()
    TriggerEvent('esx_society:openBossMenu', 'kumo', function(data, menu)
        menu.close()
    end, {wash = false})
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end
