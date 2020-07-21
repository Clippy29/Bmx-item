function InitTBmx()
    ESX = nil
    Citizen.CreateThread(function()
        while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
        end
    end)
    local entityEnumerator = {
        __gc = function(enum)
            if enum.destructor and enum.handle then
                enum.destructor(enum.handle)
            end

            enum.destructor = nil
            enum.handle = nil
        end
    }

    local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
        return coroutine.wrap(function()
            local iter, id = initFunc()
            if not id or id == 0 then
                disposeFunc(iter)
                return
            end

            local enum = {handle = iter, destructor = disposeFunc}
            setmetatable(enum, entityEnumerator)

            local next = true
            repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
            until not next

            enum.destructor, enum.handle = nil, nil
            disposeFunc(iter)
        end)
    end

    local function EnumerateObjects()
        return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
    end

    local function EnumeratePeds()
        return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
    end

    local function EnumerateVehicles()
        return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
    end

    local function EnumeratePickups()
        return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
    end
    local posachatbmx = {
        {x = -503.84,  y = -671.28, z = 33.08},
    }
    Citizen.CreateThread(function()
        while true do
            Wait(0)
                for k in pairs(posachatbmx) do
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, posachatbmx[k].x, posachatbmx[k].y, posachatbmx[k].z)
                if dist <= 2.0 then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_TALK~ pour acheter un Bmx ? ~g~500$")
                    if IsControlJustPressed(1, 38) then
                        print('^4Clippy bmx add')
                        TriggerServerEvent('clp_bmx:addbmx')
                        ESX.ShowNotification("~g~Bmx\n~s~Achat Effectué.")
                        Citizen.Wait(5000)
                    end
                end
            end
        end
    end)
    local function spawnCar(car)
        local car = GetHashKey(car)
        RequestModel(car)
        while not HasModelLoaded(car) do
            RequestModel(car)
            Citizen.Wait(0)
        end
        local playerPed = GetPlayerPed(-1)
        local heading = GetEntityHeading(playerPed)
        local vehicle = CreateVehicle(car, x, y-0.6, z, heading, true, false)
        SetEntityAsMissionEntity(vehicle, true, true)
        SetVehicleNumberPlateText(vehicle, "LOCATION")
    end
    local function locabmxpos()
        x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
        playerX = tonumber(string.format("%.2f", x))
        playerY = tonumber(string.format("%.2f", y))
        playerZ = tonumber(string.format("%.2f", z))
    end
    local function RangerVeh()
        local vehicle = nil
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), 0)
        else
            vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), 1)
        end
        local plaque = GetVehicleNumberPlateText(vehicle)
        if plaque == "LOCATION" then
            SetEntityAsMissionEntity(vehicle, false, true)
            DeleteVehicle(vehicle)
            TriggerServerEvent('clp_bmx:addbmx')
        else
            ESX.ShowNotification("~r~Ce n'est pas un bmx.")
        end
    end
    RegisterNetEvent('clp_bmx:usebmx')
    AddEventHandler('clp_bmx:usebmx', function()
        print('^4Clippy bmx spawned')
        locabmxpos()
        TriggerServerEvent('clp_bmx:removebmx')
        spawnCar("bmx")
    end)
    local vehicle = {}
    Citizen.CreateThread(function()
        while true do 
            vehicle = {}
            for v in EnumerateVehicles() do 
                table.insert(vehicle, v)
            end
            Wait(3000)
        end
    end)
    Citizen.CreateThread(function()
        local count = 0
        while true do
            Wait(0)
            local pPed = GetPlayerPed(-1)
            local pCoords = GetEntityCoords(pPed)
            for k,v in pairs(vehicle) do 
                local oCoords = GetEntityCoords(v)
                local dst = GetDistanceBetweenCoords(pCoords, oCoords, true)
                local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), 1)
                local plaque = GetVehicleNumberPlateText(vehicle)
                if dst <= 1.8 and plaque == "LOCATION" then 
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~p~ramasser le bmx.")
                    if IsControlJustReleased(1, 38) then 
                        print('^4Clippy bmx removed')
                        TaskLeaveVehicle(PlayerPedId(), vehicle, 0)
                        while IsPedInVehicle(PlayerPedId(), vehicle, true) do
                            Citizen.Wait(0)
                        end
                        RangerVeh()
                    end
                end
            end
        end
    end)
end

InitTBmx()