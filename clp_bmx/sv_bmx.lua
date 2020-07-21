ESX              = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
ESX.RegisterUsableItem('bmx', function(source)
	TriggerClientEvent('clp_bmx:usebmx', source)
end)
RegisterNetEvent('clp_bmx:removebmx')
AddEventHandler('clp_bmx:removebmx', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bmx', 1)
end)
RegisterNetEvent('clp_bmx:addbmx')
AddEventHandler('clp_bmx:addbmx', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem('bmx', 1)
end)