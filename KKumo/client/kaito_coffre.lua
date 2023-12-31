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


function CoffrKumo()
    local CoffrKumo = RageUI.CreateMenu("Kumo", "Menu Intéraction..")
        RageUI.Visible(CoffrKumo, not RageUI.Visible(CoffrKumo))
            while CoffrKumo do
            Citizen.Wait(0)
            RageUI.IsVisible(CoffrKumo, true, true, true, function()

                RageUI.Separator("↓ ~y~   Gestion des stocks  ~s~↓")

                    RageUI.ButtonWithStyle("Retirer un objet(s)",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            KBARetire()
                            RageUI.CloseAll()
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Déposer un objet(s)",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            KBADepose()
                            RageUI.CloseAll()
                        end
                    end)
                    
                    
                RageUI.Separator("↓ ~o~   Gestion des armes  ~s~↓")

                RageUI.ButtonWithStyle("Prendre une arme",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        OpenGetWeaponMenu()
                        RageUI.CloseAll()
                    end
                end)
    
                RageUI.ButtonWithStyle("Déposer une arme",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        OpenPutWeaponMenu()
                        RageUI.CloseAll()
                    end
                end)

                
                end, function()
                end)
            if not RageUI.Visible(CoffrKumo) then
            CoffrKumo = RMenu:DeleteType("CoffrKumo", true)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'kumo' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Kaitoooo.pos.Coffre.position.x, Kaitoooo.pos.Coffre.position.y, Kaitoooo.pos.Coffre.position.z)
        if dist3 <= 10.0 and Kaitoooo.genre then
            Timer = 0
            DrawMarker(22, Kaitoooo.pos.Coffre.position.x, Kaitoooo.pos.Coffre.position.y, Kaitoooo.pos.Coffre.position.z,  0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 0, 0 , 255, true, true, p19, true)
            end
            if dist3 <= 1.5 then
                Timer = 0   
                        RageUI.Text({  message = "Appuyez sur [~r~E~w~] pour accéder au coffre", time_display = 1 })
                        if IsControlJustPressed(1,51) then           
                            CoffrKumo()
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


function OpenGetWeaponMenu()

	ESX.TriggerServerCallback('KKumo:getArmoryWeapons', function(weapons)
		local elements = {}

		for i=1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
					value = weapons[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon',
		{
			title    = 'Armurerie',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			menu.close()

			ESX.TriggerServerCallback('KKumo:removeArmoryWeapon', function()
				OpenGetWeaponMenu()
			end, data.current.value)

		end, function(data, menu)
			menu.close()
		end)
	end)

end

function OpenPutWeaponMenu()
	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {
				label = weaponList[i].label,
				value = weaponList[i].name
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon',
	{
		title    = 'Armurerie',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		menu.close()

		ESX.TriggerServerCallback('KKumo:addArmoryWeapon', function()
			OpenPutWeaponMenu()
		end, data.current.value, true)

	end, function(data, menu)
		menu.close()
	end)
end


itemstock = {}
function KBARetire()
    local KBARetire = RageUI.CreateMenu("Kumo", "Menu Intéraction..")
    ESX.TriggerServerCallback('KKumo:getStockItems', function(items) 
    itemstock = items
    RageUI.Visible(KBARetire, not RageUI.Visible(KBARetire))
        while KBARetire do
            Citizen.Wait(0)
                RageUI.IsVisible(KBARetire, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count ~= 0 then
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local count = KeyboardInput("Combien ?", '' , 8)
                                    TriggerServerEvent('KKumo:getStockItem', v.name, tonumber(count))
                                    ExecuteCommand'e pickup'
                                    KBARetire()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(KBARetire) then
            KBARetire = RMenu:DeleteType("Coffre", true)
        end
    end
end)
end

local PlayersItem = {}
function KBADepose()
    local KBADepose = RageUI.CreateMenu("Kumo", "Menu Intéraction..")
    ESX.TriggerServerCallback('KKumo:getPlayerInventory', function(inventory)
        RageUI.Visible(KBADepose, not RageUI.Visible(KBADepose))
    while KBADepose do
        Citizen.Wait(0)
            RageUI.IsVisible(KBADepose, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                            local item = inventory.items[i]
                            if item.count > 0 then
                                        RageUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local count = KeyboardInput("Combien ?", '' , 8)
                                            TriggerServerEvent('KKumo:putStockItems', item.name, tonumber(count))
                                            ExecuteCommand'e pickup'
                                            KBADepose()
                                        end
                                    end)
                                end
                            else
                                RageUI.Separator('Chargement en cours')
                            end
                        end
                    end, function()
                    end)
                if not RageUI.Visible(KBADepose) then
                KBADepose = RMenu:DeleteType("Coffre", true)
            end
        end
    end)
end
