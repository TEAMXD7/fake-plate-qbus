XDCore = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if XDCore == nil then
            TriggerEvent("XDCore:GetObject", function(obj) XDCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)


RegisterNetEvent("xd:getplate")
AddEventHandler("xd:getplate", function()
    local nvehicle = XDCore.Functions.GetClosestVehicle()
    local vehicle = GetVehicleNumberPlateText(nvehicle)
    print(vehicle)
end)

RegisterCommand("test123", function()
    local vehicle = XDCore.Functions.GetClosestVehicle()
    local nearbyv = GetEntityCoords(vehicle)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local putDist = GetDistanceBetweenCoords(pos, nearbyv)
    print(vehicle)
    print(putDist)
end)

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        
        Citizen.Wait(1)
    end
end

function checknearby()
    local vehicle = XDCore.Functions.GetClosestVehicle()
    local vehicleplate = GetVehicleNumberPlateText(vehicle)
    local nearbyv = GetEntityCoords(vehicle)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local putDist = GetDistanceBetweenCoords(pos, nearbyv)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
       loadAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
        TaskPlayAnim(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8.0, 25000, 0, 0, false, false, false)    
         XDCore.Functions.Progressbar("hospital_revive", "Unscrewing plates..", math.random(14000, 16000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
        canCancel = true,
        }, {
        animDict = healAnimDict,
        anim = healAnim,
        flags = 1,
        }, {}, {}, function()
        end)
        Citizen.Wait(16000)
        XDCore.Functions.Notify("Your new fake plate : ".. vehicleplate , "success", 2500)
        Citizen.Wait(1000)
        SetVehicleNumberPlateText(vehicle, "")
        TriggerServerEvent('XDCore:Server:AddItem', "license_plate", 1)
        ClearPedTasksImmediately(GetPlayerPed(-1))
    end
end

function replaceplate()
    local vehicle = XDCore.Functions.GetClosestVehicle()
    local vehicleplate = GetVehicleNumberPlateText(vehicle)
    local nearbyv = GetEntityCoords(vehicle)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local putDist = GetDistanceBetweenCoords(pos, nearbyv)
    loadAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
    TaskPlayAnim(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8.0, 25000, 0, 0, false, false, false)    
    XDCore.Functions.Progressbar("hospital_revive", "installing plates..", math.random(14000, 16000), false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
        canCancel = true,
    }, {
        animDict = healAnimDict,
        anim = healAnim,
        flags = 1,
    }, {}, {}, function()
    end)
    Citizen.Wait(16000)
    TriggerServerEvent('XDCore:Server:RemoveItem', "license_plate", 1)
    Citizen.Wait(1000)
   SetVehicleNumberPlateText(vehicle, vehicleplate1)
   ClearPedTasksImmediately(GetPlayerPed(-1))
end

RegisterNetEvent("xd:removeplate")
AddEventHandler("xd:removeplate", function()
    local vehicle = XDCore.Functions.GetClosestVehicle()
    vehicleplate1 =  GetVehicleNumberPlateText(vehicle)
    local test = 0
    local nearbyv = GetEntityCoords(vehicle)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local putDist = GetDistanceBetweenCoords(pos, nearbyv)
    if putDist <= 3 then
    checknearby()
    PoliceCall()
    end
end)



RegisterNetEvent("xd:placeplate")
AddEventHandler("xd:placeplate", function()
    local vehicle = XDCore.Functions.GetClosestVehicle()
    local vehicleplate =  GetVehicleNumberPlateText(vehicle)
    local nearbyv = GetEntityCoords(vehicle)
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local putDist = GetDistanceBetweenCoords(pos, nearbyv)
    if putDist <= 3 then
    replaceplate()
    else
        XDCore.Functions.Notify("There is a plate already unscrew it?" , "error", 2500)
    end
end)

function PoliceCall()
    if not AlertSend then
        local pos = GetEntityCoords(GetPlayerPed(-1))
        local chance = 20
        if GetClockHours() >= 1 and GetClockHours() <= 6 then
            chance = 10
        end
        if math.random(1, 100) <= chance then
            local closestPed = GetNearbyPed(-1)
            if closestPed ~= nil then
                local msg = ""
                local s1, s2 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, pos.x, pos.y, pos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
                local streetLabel = GetStreetNameFromHashKey(s1)
                local street2 = GetStreetNameFromHashKey(s2)
                if street2 ~= nil and street2 ~= "" then 
                    streetLabel = streetLabel .. " " .. street2
                end
                local alertTitle = ""
                if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                    local modelName = GetEntityModel(vehicle)
                    if XDCore.Shared.VehicleModels[modelName] ~= nil then
                        Name = XDCore.Shared.Vehicles[XDCore.Shared.VehicleModels[modelName]["model"]]["brand"] .. ' ' .. XDCore.Shared.Vehicles[XDCore.Shared.VehicleModels[modelName]["model"]]["name"]
                    else
                        Name = "Onbekend"
                    end
                    local modelPlate = GetVehicleNumberPlateText(vehicle)
                    local msg = "Poging voertuigdiefstal bij " ..streetLabel.. ". Voertuig: " .. Name .. ", kenteken: " .. modelPlate
                    local alertTitle = "Poging voertuigdiefstal"
                    TriggerServerEvent("police:server:VehicleCall", pos, msg, alertTitle, streetLabel, modelPlate, Name)
                else
                    local vehicle = XDCore.Functions.GetClosestVehicle()
                    local modelName = GetEntityModel(vehicle)
                    local modelPlate = GetVehicleNumberPlateText(vehicle)
                    if XDCore.Shared.VehicleModels[modelName] ~= nil then
                        Name = XDCore.Shared.Vehicles[XDCore.Shared.VehicleModels[modelName]["model"]]["brand"] .. ' ' .. XDCore.Shared.Vehicles[XDCore.Shared.VehicleModels[modelName]["model"]]["name"]
                    else
                        Name = "Onbekend"
                    end
                    local msg = "Poging inbraak in voertuig bij " ..streetLabel.. ". Voertuig: " .. Name .. ", kenteken: " .. modelPlate
                    local alertTitle = "Poging voertuiginbraak"
                    TriggerServerEvent("police:server:VehicleCall", pos, msg, alertTitle, streetLabel, modelPlate, Name)
                end
            end
        end
        AlertSend = true
        SetTimeout(2 * (60 * 1000), function()
            AlertSend = false
        end)
    end
end
