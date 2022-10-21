ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('snr:canPickUp', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
end)


--/TUTUNBUL--
RegisterCommand('tutunsat', function(source, rawCommand)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local copsOnDuty = 0
    local Players = ESX.GetPlayers()
    for i = 1, #Players do
        local xPlayer = ESX.GetPlayerFromId(Players[i])
        if xPlayer["job"]["name"] == "police" then
            copsOnDuty = copsOnDuty + 1
        end
    end

    if copsOnDuty < Config.MinPolis then
    TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = "Yeteri kadar polis yok. Gerekli polis sayısı: "..Config.MinPolis, length = 10000})
    return
    end

    TriggerClientEvent('snr:OpenMenu', _source)
end)




ESX.RegisterServerCallback('snr:TakeInfo', function(source, cb, pltItem) -- when player interaction to weed, take info from db
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local itemcount = xPlayer.getInventoryItem(pltItem.name).count
    local itemlabel = xPlayer.getInventoryItem(pltItem.name).label
    local cbtable = {}
    if itemcount < 1 then
        table.insert(cbtable,{statu = false, itemlabel = itemlabel , price = pltItem.price})

    else
        local itemamount = math.random((pltItem.price / 10 )* 9, ( pltItem.price / 10 ) * 11)
        table.insert(cbtable,{statu = true, itemlabel = itemlabel,  price = itemamount})
        xPlayer.removeInventoryItem(pltItem.name,1)
        xPlayer.addMoney(itemamount)
    end
    cb(cbtable[1])
    
end)

RegisterServerEvent('snr:udanyzakup')
AddEventHandler('snr:udanyzakup', function(x, y, z)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local infoPsy = math.random(1,100)
    if infoPsy <= 30 then --%30 ihtimalle polisi arıyor
    TriggerClientEvent('snr:infoPolicja', -1, x, y, z)
    Wait(500)
    end
end)

RegisterServerEvent('snr:policeNotify')
AddEventHandler('snr:policeNotify', function(x, y, z)
    local infoPsy = math.random(1,100)
    if infoPsy <= Config.PoliceNotify then --%30 ihtimalle polisi arıyor
    TriggerClientEvent('snr:infoPolicja', -1, x, y, z)
    Wait(500)
    end
end)