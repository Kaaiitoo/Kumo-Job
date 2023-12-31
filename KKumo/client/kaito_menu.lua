ESX = nil

local IsHandcuffed, DragStatus = false, {}

DragStatus.IsDragged          = false

closestDistance, closestEntity = -1, nil


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


-------------- FONCTION DE LA FOUILLE -()
local Items = {} 
local Armes = {}
local ArgentSale = {}
local IsHandcuffed, DragStatus = false, {}
DragStatus.IsDragged          = false

local PlayerData = {}

local function MarquerJoueur()
        local ped = GetPlayerPed(ESX.Game.GetClosestPlayer())
        local pos = GetEntityCoords(ped)
        local target, distance = ESX.Game.GetClosestPlayer()
end

local function getPlayerInv(player)
    Items = {}
    Armes = {}
    ArgentSale = {}
    
    ESX.TriggerServerCallback('KKumo:getOtherPlayerData', function(data)
        for i=1, #data.accounts, 1 do
            if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
                table.insert(ArgentSale, {
                    label    = ESX.Math.Round(data.accounts[i].money),
                    value    = 'black_money',
                    itemType = 'item_account',
                    amount   = data.accounts[i].money
                })
    
                break
            end
        end
    
        for i=1, #data.inventory, 1 do
            if data.inventory[i].count > 0 then
                table.insert(Items, {
                    label    = data.inventory[i].label,
                    right    = data.inventory[i].count,
                    value    = data.inventory[i].name,
                    itemType = 'item_standard',
                    amount   = data.inventory[i].count
                })
            end
        end


        for i=1, #data.weapons, 1 do

            table.insert(Armes, {
    
                label    = ESX.GetWeaponLabel(data.weapons[i].name),
    
                value    = data.weapons[i].name,
    
                right    = data.weapons[i].ammo,
    
                itemType = 'item_weapon',
    
                amount   = data.weapons[i].ammo
    
            })
    
        end
    
    end, GetPlayerServerId(player))
    end
----------- FIN DE LA FONCTION ----------------------


    ------------- COMMENCEMENT MENU F6 ----------------------

function KKumo()
    local genantftg = RageUI.CreateMenu("Kumo", "Menu Intéraction..")
    genantftg:SetRectangleBanner(0, 0, 0)
    local lasecteapeshit = RageUI.CreateSubMenu(genantftg, "Kumo", "Menu Intéraction..")
    local InteractionP = RageUI.CreateSubMenu(genantftg, "Kumo", "Menu Intéraction..")
    InteractionP:SetRectangleBanner(0, 0, 0)
    lasecteapeshit:SetRectangleBanner(0, 0, 0)
        RageUI.Visible(genantftg, not RageUI.Visible(genantftg))
            while genantftg do
                Citizen.Wait(0)
                    RageUI.IsVisible(genantftg, true, true, true, function()


            RageUI.ButtonWithStyle("Intéraction Citoyen", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if (Selected) then
                end
            end, InteractionP) 
    
        end, function()
        end)

        RageUI.IsVisible(lasecteapeshit, true, true, true, function()
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

            RageUI.Separator("↓ ~r~Argent non déclaré ~s~↓")
            for k,v  in pairs(ArgentSale) do
                RageUI.ButtonWithStyle("Argent non déclaré :", nil, {RightLabel = "~g~"..v.label.."$"}, true, function(_, _, s)
                    if s then
                        local combien = KeyboardInput("Combien ?", '' , '', 8)
                        if tonumber(combien) > v.amount then
                            RageUI.Popup({message = "~r~Quantité invalide"})
                        else
                            TriggerServerEvent('KKumo:confiscatePlayerItem', GetPlayerServerId(closestPlayer), v.itemType, v.value, tonumber(combien))
                        end
                        RageUI.GoBack()
                    end
                end)
            end
    
            RageUI.Separator("↓ ~r~Objets~s~↓")
            for k,v  in pairs(Items) do
                RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "~g~x"..v.right}, true, function(_, _, s)
                    if s then
                        local combien = KeyboardInput("Combien ?", '' , '', 8)
                        if tonumber(combien) > v.amount then
                            RageUI.Popup({message = "~r~Quantité invalide"})
                        else
                            TriggerServerEvent('KKumo:confiscatePlayerItem', GetPlayerServerId(closestPlayer), v.itemType, v.value, tonumber(combien))
                        end
                        RageUI.GoBack()
                    end
                end)
            end

            RageUI.Separator("↓ ~r~Armes~s~↓")
            
			for k,v  in pairs(Armes) do

				RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "avec ~g~"..v.right.. " ~s~balle(s)"}, true, function(_, _, s)

					if s then

						local combien = KeyboardInput("Combien ?", '' , '', 9999999)

						if tonumber(combien) > v.amount then

							RageUI.Popup({message = "~r~Quantité invalide"})

						else

							TriggerServerEvent('KKumo:confiscatePlayerItem', GetPlayerServerId(closestPlayer), v.itemType, v.value, tonumber(combien))

						end

						RageUI.GoBack()

					end

				end)

			end
    
            end, function() 
            end)

                                  RageUI.IsVisible(InteractionP, true, true, true, function()

                                    

                                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                    local target, distance = ESX.Game.GetClosestPlayer()
                                    playerheading = GetEntityHeading(GetPlayerPed(-1))
                                    playerlocation = GetEntityForwardVector(PlayerPedId())
                                    playerCoords = GetEntityCoords(GetPlayerPed(-1))
                                    local target_id = GetPlayerServerId(target)
                                    local searchPlayerPed = GetPlayerPed(target)
                                
                        
                                    RageUI.ButtonWithStyle('Fouiller la personne', nil, {RightLabel = "→"}, closestPlayer ~= -1 and closestDistance <= 3.0, function(_, a, s)
                                        if a then
                                            MarquerJoueur()
                                            if s then
                                            getPlayerInv(closestPlayer)
                        
                                        end
                                    end
                                    end, lasecteapeshit)
                            
            
                        local searchPlayerPed = GetPlayerPed(target)
                    RageUI.ButtonWithStyle("Menotter/démenotter", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            local target, distance = ESX.Game.GetClosestPlayer()
                            playerheading = GetEntityHeading(GetPlayerPed(-1))
                            playerlocation = GetEntityForwardVector(PlayerPedId())
                            playerCoords = GetEntityCoords(GetPlayerPed(-1))
                            local target_id = GetPlayerServerId(target)
                            if closestPlayer ~= -1 and closestDistance <= 3.0 then   
                            TriggerServerEvent('KKumo:handcuff', GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification('Aucun joueurs à proximité')
                        end
                        end
                    end)
            
                        local searchPlayerPed = GetPlayerPed(target)
                        RageUI.ButtonWithStyle("Escorter", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                local target, distance = ESX.Game.GetClosestPlayer()
                                playerheading = GetEntityHeading(GetPlayerPed(-1))
                                playerlocation = GetEntityForwardVector(PlayerPedId())
                                playerCoords = GetEntityCoords(GetPlayerPed(-1))
                                local target_id = GetPlayerServerId(target)
                                if closestPlayer ~= -1 and closestDistance <= 3.0 then  
                            TriggerServerEvent('KKumo:drag', GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification('Aucun joueurs à proximité')
                        end
                        end
                    end)
                    
                        local searchPlayerPed = GetPlayerPed(target)
                        RageUI.ButtonWithStyle("Mettre dans un véhicule", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                local target, distance = ESX.Game.GetClosestPlayer()
                                playerheading = GetEntityHeading(GetPlayerPed(-1))
                                playerlocation = GetEntityForwardVector(PlayerPedId())
                                playerCoords = GetEntityCoords(GetPlayerPed(-1))
                                local target_id = GetPlayerServerId(target)
                                if closestPlayer ~= -1 and closestDistance <= 3.0 then  
                            TriggerServerEvent('KKumo:putInVehicle', GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification('Aucun joueurs à proximité')
                        end
                            end
                        end)
                    
                        local searchPlayerPed = GetPlayerPed(target)
                        RageUI.ButtonWithStyle("Sortir du véhicule", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                local target, distance = ESX.Game.GetClosestPlayer()
                                playerheading = GetEntityHeading(GetPlayerPed(-1))
                                playerlocation = GetEntityForwardVector(PlayerPedId())
                                playerCoords = GetEntityCoords(GetPlayerPed(-1))
                                local target_id = GetPlayerServerId(target)
                                if closestPlayer ~= -1 and closestDistance <= 3.0 then  
                            TriggerServerEvent('KKumo:OutVehicle', GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification('Aucun joueurs à proximité')
                        end
                        end
                    end)

                                            
                end, function() 
                end)

         
            if not RageUI.Visible(InteractionP) and not RageUI.Visible(lasecteapeshit) and not RageUI.Visible(genantftg)  then
                genantftg = RMenu:DeleteType("Kumo", true)
            end
        end
    end

------------------------- FIN DU MENU F6 ------------------------------




    --- OUVERTURE DU MENU

Keys.Register('F7', 'Menu', 'Ouvrir le Menu Kumo', function()
if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'kumo' then
    KKumo()
end
end)

--------- Imput

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

-------------------------- Intéraction  ----------------------------

RegisterNetEvent('KKumo:handcuff')
AddEventHandler('KKumo:handcuff', function()

  IsHandcuffed    = not IsHandcuffed;
  local playerPed = GetPlayerPed(-1)

  Citizen.CreateThread(function()

    if IsHandcuffed then

        RequestAnimDict('mp_arresting')
        while not HasAnimDictLoaded('mp_arresting') do
            Citizen.Wait(100)
        end

      TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
      DisableControlAction(2, 37, true)
      SetEnableHandcuffs(playerPed, true)
      SetPedCanPlayGestureAnims(playerPed, false)
      FreezeEntityPosition(playerPed,  true)
      DisableControlAction(0, 24, true) -- Attack
      DisableControlAction(0, 257, true) -- Attack 2
      DisableControlAction(0, 25, true) -- Aim
      DisableControlAction(0, 263, true) -- Melee Attack 1
      DisableControlAction(0, 37, true) -- Select Weapon
      DisableControlAction(0, 47, true)  -- Disable weapon
      

    else

      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed,  true)
      FreezeEntityPosition(playerPed, false)

    end

  end)
end)

RegisterNetEvent('KKumo:drag')
AddEventHandler('KKumo:drag', function(cop)
  TriggerServerEvent('esx:clientLog', 'starting dragging')
  IsDragged = not IsDragged
  CopPed = tonumber(cop)
end)

Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsHandcuffed then
      if IsDragged then
        local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
        local myped = GetPlayerPed(-1)
        AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
      else
        DetachEntity(GetPlayerPed(-1), true, false)
      end
    end
  end
end)

RegisterNetEvent('KKumo:putInVehicle')
AddEventHandler('KKumo:putInVehicle', function()

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)

    if DoesEntityExist(vehicle) then

      local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
      local freeSeat = nil

      for i=maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(vehicle,  i) then
          freeSeat = i
          break
        end
      end

      if freeSeat ~= nil then
        TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
      end

    end

  end

end)

RegisterNetEvent('KKumo:OutVehicle')
AddEventHandler('KKumo:OutVehicle', function(t)
  local ped = GetPlayerPed(t)
  ClearPedTasksImmediately(ped)
  plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
  local xnew = plyPos.x+2
  local ynew = plyPos.y+2

  SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
end)
------------------------ FIN INTERACTION --------------------------

-- MENOTTER TOUCHER DESAC

Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsHandcuffed then
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      DisableControlAction(0, 30,  true) -- MoveLeftRight
      DisableControlAction(0, 31,  true) -- MoveUpDown
    end
  end
end)
