XDCore = nil
TriggerEvent('XDCore:GetObject', function(obj) XDCore = obj end)

XDCore.Functions.CreateUseableItem("screwdriverset", function(source, item)
    local Player = XDCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("xd:removeplate", source)
    end
end)


XDCore.Functions.CreateUseableItem("license_plate", function(source, item)
    local Player = XDCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("xd:placeplate", source)
    end
end)
