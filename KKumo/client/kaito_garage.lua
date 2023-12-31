ESX = nil



TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



local PlayerData = {}



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



RegisterNetEvent('esx:setJob')

AddEventHandler('esx:setJob', function(job2)

	ESX.PlayerData.job2 = job2

end)


function GarageKumo()

    local GarageKumo = RageUI.CreateMenu("Kumo", "Menu Intéraction..")

        RageUI.Visible(GarageKumo, not RageUI.Visible(GarageKumo))

        

            while GarageKumo do

            Citizen.Wait(0)

            RageUI.IsVisible(GarageKumo, true, true, true, function()

        
                RageUI.ButtonWithStyle("Sortir un Dubsta Luxury",nil, {RightLabel = ""},true, function(Hovered, Active, Selected)

                    if (Selected) then  

                    DoScreenFadeOut(3000)

                    Citizen.Wait(3000)

                    DoScreenFadeIn(3000)

                    spawnuniCar("dubsta2")

                    end

                end)

    
                RageUI.ButtonWithStyle("Sortir une Schafter V12",nil, {RightLabel = ""},true, function(Hovered, Active, Selected)

                    if (Selected) then  

                    DoScreenFadeOut(3000)

                    Citizen.Wait(3000)

                    DoScreenFadeIn(3000)

                    spawnuniCar2("schafter3")

                    end

                end)


    

            end, function()

            end, 1)



            if not RageUI.Visible(GarageKumo) then

         GarageKumo = RMenu:DeleteType("GarageKumo", true)

        end

    end

end

---------------------------- MENU VOITURE ----------------------------

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'kumo' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Kaitoooo.pos.Garage.position.x, Kaitoooo.pos.Garage.position.y, Kaitoooo.pos.Garage.position.z)
        if dist3 <= 10.0 and Kaitoooo.genre then
            Timer = 0
            DrawMarker(22, Kaitoooo.pos.Garage.position.x, Kaitoooo.pos.Garage.position.y, Kaitoooo.pos.Garage.position.z,  0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 0, 0 , 255, true, true, p19, true)
            end
            if dist3 <= 1.5 then
                Timer = 0   
                        RageUI.Text({  message = "Appuyez sur [~r~E~w~] pour choisir un véhicule", time_display = 1 })
                        if IsControlJustPressed(1,51) then           
                            GarageKumo()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function spawnuniCar(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, Kaitoooo.pos.SpawnVehicle.position.x, Kaitoooo.pos.SpawnVehicle.position.y, Kaitoooo.pos.SpawnVehicle.position.z, Kaitoooo.pos.SpawnVehicle.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "KAITO"
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1) 
end

function spawnuniCar2(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, Kaitoooo.pos.SpawnVehicle.position.x, Kaitoooo.pos.SpawnVehicle.position.y, Kaitoooo.pos.SpawnVehicle.position.z, Kaitoooo.pos.SpawnVehicle.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "KAITO"
    SetVehicleNumberPlateText(vehicle, plaque) 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1) 
end


------------------ SUPPRIMER VOITURE ----------------

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == 'kumo' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Kaitoooo.pos.RangerVehicule.position.x, Kaitoooo.pos.RangerVehicule.position.y, Kaitoooo.pos.RangerVehicule.position.z)
        if dist3 <= 10.0 and Kaitoooo.genre then
            Timer = 0
            DrawMarker(22, Kaitoooo.pos.RangerVehicule.position.x, Kaitoooo.pos.RangerVehicule.position.y, Kaitoooo.pos.RangerVehicule.position.z,  0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 0, 0 , 255, true, true, p19, true)
            end
            if dist3 <= 1.5 then
                Timer = 0   
                        RageUI.Text({  message = "Appuyez sur [~r~E~w~] pour ranger ton véhicule", time_display = 1 })
                        if IsControlJustPressed(1,51) then     
                            
                    DoScreenFadeOut(3000)

                    Citizen.Wait(3000)

                    DoScreenFadeIn(3000)      
                            okSasuke()
                    end   
                end
                end
            end 
        Citizen.Wait(Timer)
    end
end)


function okSasuke(vehicle)

    local playerPed = GetPlayerPed(-1)

    local vehicle = GetVehiclePedIsIn(playerPed, false)

    local props = ESX.Game.GetVehicleProperties(vehicle)

    local current = GetPlayersLastVehicle(GetPlayerPed(-1), true)

    local engineHealth = GetVehicleEngineHealth(current)



    if IsPedInAnyVehicle(GetPlayerPed(-1), true) then 

        if engineHealth < 890 then

            ESX.ShowNotification("Votre véhicule est trop abimé, vous ne pouvez pas le ranger.")

        else

            ESX.Game.DeleteVehicle(vehicle)

            ESX.ShowNotification("~g~Le véhicule a été rangé .")

        end

    end

end
