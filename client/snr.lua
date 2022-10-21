local spawnedWeeds = 0
local weedPlants = {}
local isPickingUp, isProcessing = false, false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.CircleZones.UzumToplama.coords, true) < 50 then
			SpawnWeedPlants()
			Citizen.Wait(500)
		else
			Citizen.Wait(500)
		end
	end
end)



local zone = false


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #weedPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(weedPlants[i]), false) < 1 then
				nearbyObject, nearbyID = weedPlants[i], i
                zone = true
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				if zone == true then 
				TriggerEvent('cd_drawtextui:ShowUI', 'show', "E - Tutun Topla")
				end

			if not zone then
				TriggerEvent('cd_drawtextui:HideUI')
			end

			if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
				TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
				exports['aex-bar']:taskBar(5000,'Tütün Toplanıyor')

						Citizen.Wait(5000)
						ClearPedTasks(playerPed)
						Citizen.Wait(1000)
		
						ESX.Game.DeleteObject(nearbyObject)
		
						table.remove(weedPlants, nearbyID)
						spawnedWeeds = spawnedWeeds - 1
		
						TriggerServerEvent('snr:pickedUpCannabis')
						TriggerEvent('cd_drawtextui:HideUI')



				
			end

		
		end
	end
end

end)

YikaUzum = function()
	local finished2 = exports["reload-skillbar"]:taskBar(4750,math.random(5,15))
	if finished2 ~= 100 then
		TriggerServerEvent('snr:SilUzum')
		ClearPedTasksImmediately(player)
		exports['mythic_notify']:SendAlert('error', 'Tütünü Ayıklayamadınız! 1 Tane Tütün kaybettiniz.', 2000)
	else 
		TriggerServerEvent("snr:UzumYikama")
	end
	end
Citizen.CreateThread(function()
while true do 
	Wait(0)
	local kordinats = GetEntityCoords(PlayerPedId())
	for k,v in pairs(Config.YikamaUzum) do 
	local dix = #(kordinats - v)
	if dix < 1 then 
	
ESX.ShowHelpNotification('~INPUT_CONTEXT~ - Tütün Sar')
if IsControlJustReleased(0, 38) then
	YikaUzum()
end
	end
	end 
	end 
end)



Citizen.CreateThread(function()
    if Config.BlipAcik then
      local blip = AddBlipForCoord(Config.BlipKordinat)
	  SetBlipSprite(blip, 478)
	  SetBlipDisplay(blip, 4)
	  SetBlipScale(blip, 0.6)
	  SetBlipColour(blip, 50)
      SetBlipAsShortRange(blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString("1.1 Tütün Toplama")
      EndTextCommandSetBlipName(blip)
    end
end)

Citizen.CreateThread(function()
    if Config.BlipAcik then
      local blip = AddBlipForCoord(Config.YikamaUzumBlip)
	  SetBlipSprite(blip, 478)
	  SetBlipDisplay(blip, 4)
	  SetBlipScale(blip, 0.6)
	  SetBlipColour(blip, 1)
      SetBlipAsShortRange(blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString("1.2 Tütün Sarma")
      EndTextCommandSetBlipName(blip)
    end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(weedPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnWeedPlants()
	while spawnedWeeds < 15 do
		Citizen.Wait(0)
		local weedCoords = GenerateWeedCoords()

		ESX.Game.SpawnLocalObject('prop_plant_fern_01a', weedCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(weedPlants, obj)
			spawnedWeeds = spawnedWeeds + 1
		end)
	end
end

function ValidateWeedCoord(plantCoord)
	if spawnedWeeds > 0 then
		local validate = true

		for k, v in pairs(weedPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.UzumToplama.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateWeedCoords()
	while true do
		Citizen.Wait(1)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-20, 20)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-20, 20)

		weedCoordX = Config.CircleZones.UzumToplama.coords.x + modX
		weedCoordY = Config.CircleZones.UzumToplama.coords.y + modY

		local coordZ = GetCoordZWeed(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)

		if ValidateWeedCoord(coord) then
			return coord
		end
	end
end

function GetCoordZWeed(x, y)
	local groundCheckHeights = { 50, 51.0, 52.0, 53.0, 54.0, 55.0, 56.0, 57.0, 58.0, 59.0, 60.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 53.85
end