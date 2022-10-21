Keys = {
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

ESX = nil
local menuOpen = false
local wasOpen = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if menuOpen then
			ESX.UI.Menu.CloseAll()
		end
	end
end)


function CreateBlipCircle(coords, text, radius, color, sprite)
	
	if Config.EnableMapsBlimps then
		local blip = AddBlipForRadius(coords, radius)

		SetBlipHighDetail(blip, true)
		SetBlipColour(blip, 1)
		SetBlipAlpha (blip, 128)

		-- create a blip in the middle
		blip = AddBlipForCoord(coords)

		SetBlipHighDetail(blip, true)
		SetBlipSprite (blip, sprite)
		SetBlipScale  (blip, 0.5)
		SetBlipColour (blip, color)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(text)
		EndTextCommandSetBlipName(blip)
	end
end

Citizen.CreateThread(function()
		for k,zone in pairs(Config.CircleZones) do
			if zone.enabled then
				CreateBlipCircle(zone.blimpcoords, zone.name, zone.radius, zone.color, zone.sprite)
			end
		end
end)



--/TUTUNSAT--
function DrawText3D(x,y,z,d)
    local e,f,g=World3dToScreen2d(x,y,z)
    local h,i,j=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.37,0.37)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255,255,255,215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(d)
    DrawText(f,g)
    local k=string.len(d)/370;DrawRect(f,g+0.0125,0.015+k,0.03,33,33,33,133)
end;

local l;
local m=-10;
local n=-10;
local o=0;
local b;
local p;
local q=200;
local r='a_m_m_bevhills_01'
local pedBlip = nil
local sipDrumu = false


RegisterNetEvent('snr:OpenMenu')
AddEventHandler('snr:OpenMenu',function()
    ESX.UI.Menu.CloseAll()
    if not sipDrumu then
        elements = {}
        for k,v in pairs(Config.ItemInfo) do
            table.insert(elements, {label = v.MenuLabel, value = k})
        end
        table.insert(elements, {label = "Menüyü Kapat", value = "close"})
        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'order_menu',
            {
                title    = "Sipariş Türünü Seçin",
                align    = 'right',
                elements = elements

            },
           
            function(data, menu)
                if data.current.value == "close" then
                    ESX.UI.Menu.CloseAll()
                else 
                    local pltItem = Config.ItemInfo[data.current.value].itemInfo[math.random(1,#Config.ItemInfo[data.current.value].itemInfo)]
                    print(pltItem.name)
                    TriggerEvent('snr:getcustomer', pltItem)
                    ESX.UI.Menu.CloseAll() 
                end
                ESX.UI.Menu.CloseAll()
        end)
    else
        exports['mythic_notify']:DoCustomHudText('error',"Şuan Zaten Bir Şiparişin var",7000)
    end
end)

local pedCoord = nil
RegisterNetEvent('snr:getcustomer')
AddEventHandler('snr:getcustomer',function(pltItem)
    pedCoord = nil
    if IsPedOnFoot(PlayerPedId()) then
    TaskStartScenarioInPlace(GetPlayerPed(-1),"WORLD_HUMAN_STAND_MOBILE",0,true)
    end
    exports['mythic_notify']:DoCustomHudText('inform', "Tütüncüler derneği facebook grubuna satış yaptığına dair gönderi paylaşıyorsun.", 5000)
    exports['progressBars']:startUI(5000, "Gönderi Paylaşıyorsun.")
    Citizen.Wait(5000)
    exports['mythic_notify']:DoCustomHudText('inform', "Sipariş veren olursa GPS'inde işaretlenecek .", 5000)
    ClearPedTasks(GetPlayerPed(-1))
    Citizen.Wait(math.random(30000,60000))
    if not sipDrumu then
        sipDrumu = true
        local rndmNum = math.random(1,#Config.KoordList)
        local pedcoord = Config.KoordList[rndmNum]	
        local plyrOrdrDis = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pedcoord, false)
        local minCloseness = 1000
        local maxDistance  = 2000
        while  plyrOrdrDis < minCloseness  or plyrOrdrDis > maxDistance do Citizen.Wait(10)
            rndmNum = math.random(1,#Config.KoordList)
            pedcoord = Config.KoordList[rndmNum]	
            plyrOrdrDis = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), pedcoord, false)
            minCloseness = minCloseness - 1
            maxDistance  = maxDistance + 3
        end
        pedCoord = pedcoord
        exports['mythic_notify']:DoCustomHudText('success', "Müşteri Bulundu Konum Haritada İşaretlendi.", 7500)
        SetNewWaypoint(pedCoord.x,pedCoord.y)
        BlipKoy(pedCoord)
        Citizen.Wait(1000)
        x,y,z=table.unpack(pedCoord)
        pedX=tonumber(string.format("%.2f",x))
        pedY=tonumber(string.format("%.2f",y))
        pedZ=tonumber(string.format("%.2f",z))
        TriggerServerEvent("snr:policeNotify",pedX,pedY,pedZ)Citizen.Wait(500)
        local qq = true
        local oo = 0
        while qq do Citizen.Wait(1000)
            local players = GetEntityCoords(GetPlayerPed(-1))
            local D = Vdist(pedCoord.x,pedCoord.y,pedCoord.z,players.x,players.y,players.z)
            oo=oo+1;
            if D<=200.5 then 
                qq = false 
            end
            if oo>=300 then 
                sipDrumu = false
                exports['mythic_notify']:DoCustomHudText('error', "Müşteri çok beklediği için gitti.", 7500)
                qq = false 
            end
        end
        exports['mythic_notify']:DoCustomHudText('error', "Müşteriye yaklaştın.", 1900)
    end
    if sipDrumu then
        local s=math.random(1,2)
        if s==1 then 
            RequestModel("a_f_m_bevhills_02")
            while not HasModelLoaded("a_f_m_bevhills_02")do Wait(10)end
            r="a_f_m_bevhills_02"
        else 
            RequestModel("a_m_m_bevhills_01")
            while not HasModelLoaded("a_m_m_bevhills_01")do Wait(10)end
            r="a_m_m_bevhills_01"
        end;

        l = CreatePed(26,r,pedCoord,268.9422,true,true)
        PlaceObjectOnGroundProperly(l)
        SetEntityAsMissionEntity(l)
        SetBlockingOfNonTemporaryEvents(l,true)
        SetPedKeepTask(l,true)
        local cooldown = 0
        while GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), GetEntityCoords(l), false) > 10  or cooldown > 300 do cooldown = cooldown + 1 Citizen.Wait(1000)  end
        if cooldown < 300 then
            while not IsPedOnFoot(PlayerPedId()) do Citizen.Wait(2000)
                exports['mythic_notify']:DoCustomHudText('error', "Araçtan inmelisin", 5000)
            end
        end
        TaskGoToEntity(l,GetPlayerPed(-1),-1,3.5,2.0,1073741824.0,0) 
        
        SetPedKeepTask(l,true)
        o=0;
        local B=true;
        while B do Citizen.Wait(500)
            local C=GetEntityCoords(l)
            local t=GetEntityCoords(GetPlayerPed(-1))
            q=GetEntityHealth(l)
            local D=Vdist(C.x,C.y,C.z,t.x,t.y,t.z)
            o=o+1;
            if D<=1.5 or o>=75 or q<100 then B=false end
        end;
        
        if o>=75 or q<1.0 then 
            exports['mythic_notify']:DoCustomHudText('error', "Müşteri siparişi son anda iptal etti. Yeni bir müşteri arayabilirsin.", 7500)
            TriggerServerEvent("snr:clientpassed")
            TaskWanderStandard(l,10.0,10)
            SetPedAsNoLongerNeeded(l)
            FreezeEntityPosition(PlayerPedId(), false)
        else 
            ESX.TriggerServerCallback('snr:TakeInfo', function(cb)
                if cb.statu then
                    FreezeEntityPosition(PlayerPedId(), true)
                    SetEntityHeading(GetPlayerPed(-1),GetEntityHeading(l)-180.0)
                    SetEntityHeading(l,GetEntityHeading(GetPlayerPed(-1))-180.0)
                    RequestAnimDict("mp_common")
                    while not HasAnimDictLoaded("mp_common")do Citizen.Wait(0)end;
                    b=CreateObject(GetHashKey('prop_weed_bottle'),0,0,0,true)
                    AttachEntityToEntity(b,PlayerPedId(),GetPedBoneIndex(PlayerPedId(),57005),0.13,0.02,0.0,-90.0,0,0,1,1,0,1,0,1)
                    TaskPlayAnim(GetPlayerPed(-1),"mp_common","givetake1_a",8.0,-8.0,-1,0,0,false,false,false)
                    DeleteEntity(b)
                    exports['progressBars']:startUI(15000, "Müşteri Sarılmış tütünü tadıyor.")
                    Citizen.Wait(15000)
                    p=CreateObject(GetHashKey('hei_prop_heist_cash_pile'),0,0,0,true)
                    AttachEntityToEntity(p,l,GetPedBoneIndex(l,57005),0.13,0.02,0.0,-90.0,0,0,1,1,0,1,0,1)
                    TaskPlayAnim(l,"mp_common","givetake1_a",8.0,-8.0,-1,0,0,false,false,false)Wait(1550)
                    DeleteEntity(p)
                    ClearPedTasks(l)
                    exports['mythic_notify']:DoCustomHudText('success', "Bir adet: Sarılmış tütün Sattın. "..cb.price.."$ aldın.", 7500)
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    exports['mythic_notify']:DoCustomHudText('error', "Müşteri Sarılmış tütün istiyor ancak sizde yok.", 7500)
                end
                TaskWanderStandard(l,10.0,10)
                SetPedAsNoLongerNeeded(l)
                RemoveBlip(pedBlip)
                DeleteWaypoint()

            end, pltItem)
            sipDrumu = false
        end 
    else
        exports['mythic_notify']:DoCustomHudText('error',"Şuan Zaten Bir Şiparişin var",7000)
    end

end)


    
RegisterNetEvent('snr:infoPolicja')
AddEventHandler('snr:infoPolicja',function(x,y,z)
    if PlayerData.job~=nil and PlayerData.job.name == 'police' then 
        local E=GetStreetNameAtCoord(x,y,z)
        local F=GetStreetNameFromHashKey(E)
        exports['mythic_notify']:DoCustomHudText('error', "Bölgede illegal ticaret yapılacak!!! "..F.."!'" ,10000)
        PlaySoundFrontend(-1,"Bomb_Disarmed","GTAO_Speed_Convoy_Soundset",0)
        local G=AddBlipForCoord(x,y,z)
        SetBlipSprite(G,161)
        SetBlipScale(G,1.2)
        SetBlipColour(G,25)
        SetBlipAlpha(G,180)
        SetBlipHighDetail(G,true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('illegal Ticaret')
        EndTextCommandSetBlipName(G)
        Citizen.Wait(60000)
        RemoveBlip(G)
    end 
end)


function BlipKoy(coord)
	if pedBlip then RemoveBlip(pedBlip); end
    local blip = AddBlipForCoord(coord)

    SetBlipSprite               (blip, 1)
	SetBlipScale                (blip, 0.7)
    SetBlipColour               (blip, 16742399)
    
	BeginTextCommandSetBlipName ("STRING")
	AddTextComponentString      ("Alıcı Adresi")
	EndTextCommandSetBlipName   (blip)
	pedBlip = blip
  end
