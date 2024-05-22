ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('oa-bus:giveMoney', function(source, cb, money)
    local user = ESX.GetPlayerFromId(source)
    user.addMoney(money)
end)