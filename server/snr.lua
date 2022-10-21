local playersProcessingCannabis = {}

RegisterServerEvent('snr:pickedUpCannabis')
AddEventHandler('snr:pickedUpCannabis', function()
  local xPlayer = ESX.GetPlayerFromId(source)
  xPlayer.addInventoryItem('tutun', Config.kactane)
  TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = Config.kactane..' Tane Tütün Topladınız'})

end)

function CancelProcessing(playerID)
	if playersProcessingCannabis[playerID] then
		ESX.ClearTimeout(playersProcessingCannabis[playerID])
		playersProcessingCannabis[playerID] = nil
	end
end

RegisterServerEvent('snr:cancelProcessing')
AddEventHandler('snr:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)

RegisterServerEvent("snr:UzumYikama")
AddEventHandler("snr:UzumYikama", function()
local src = source 
local player = ESX.GetPlayerFromId(src)
if player.getQuantity('tutun') >= 1 then
   player.removeInventoryItem('tutun', 1) 
   player.addInventoryItem('sarilmistutun', 1)
   TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = '1 Tane Tütün Sardınız', 2000})
   TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = '/tutunsat ile müşteri bulabilirsin.', 1000})
else 
	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Yeterli Tütününüz yok!', 2000})
end
end)

RegisterServerEvent("snr:SilUzum")
AddEventHandler("snr:SilUzum", function()
local src = source 
local player = ESX.GetPlayerFromId(src)
player.removeInventoryItem('tutun', 1)


end)
