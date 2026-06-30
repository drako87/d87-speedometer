isHudVisible = false
engineStatus = true
cruiseStatus = false
cruiseSpeed = 0.0

-- Variables compartidas globales (Sin el 'local' para que conecte con features.lua)
lastVehicleCoords = nil
lastEngineState = nil 

-- 🚗 BUCLE PRINCIPAL: Telemetría, Control de Crucero, Adaptación de Tipo y Odómetro
CreateThread(function()
    while true do
        local sleep = 500
        local ped = PlayerPedId()
        
        if IsPedInAnyVehicle(ped, false) and not IsPauseMenuActive() then
            sleep = 100
            local veh = GetVehiclePedIsIn(ped, false)
            
            if GetPedInVehicleSeat(veh, -1) == ped then
                local rawEngineHealth = GetVehicleEngineHealth(veh)
                local enginePct = math.floor((rawEngineHealth / 1000) * 100)
                if enginePct < 0 then enginePct = 0 elseif enginePct > 100 then enginePct = 100 end

                -- 🛠️ SOLUCIÓN AL BUCLE DE ENCENDIDO/PARPADEO: Sincronización estricta de estados
                if enginePct > 15 then
                    if lastEngineState ~= engineStatus then
                        SetVehicleEngineOn(veh, engineStatus, true, true)
                        SetVehicleUndriveable(veh, not engineStatus)
                        lastEngineState = engineStatus
                    end
                else
                    if lastEngineState ~= false then
                        SetVehicleUndriveable(veh, true)
                        lastEngineState = false
                    end
                end

                -- ADAPTACIÓN DEL TIPO DE VEHÍCULO
                local class = GetVehicleClass(veh)
                local vehType = "car"
                if class == 8 then vehType = "bike"
                elseif class == 14 then vehType = "boat"
                elseif class == 15 then vehType = "heli"
                elseif class == 16 then vehType = "plane" end

                -- CÁLCULO DEL CUENTAKILÓMETROS (ODÓMETRO)
                local currentCoords = GetEntityCoords(veh)
                if lastVehicleCoords then
                    local dist = #(currentCoords - lastVehicleCoords)
                    if dist > 0.0 and dist < 100.0 then
                        local conversion = Config.UseMPH and 0.000621371 or 0.001
                        local currentOdo = Entity(veh).state.odometer or 0.0
                        Entity(veh).state:set('odometer', currentOdo + (dist * conversion), true)
                    end
                end
                lastVehicleCoords = currentCoords

                local totalOdometer = math.floor(Entity(veh).state.odometer or 0.0)

                -- Control de Crucero Activo
                if cruiseStatus and vehType ~= "plane" and vehType ~= "heli" and vehType ~= "boat" then
                    local currentSpeed = GetEntitySpeed(veh)
                    if IsControlPressed(0, 72) or (currentSpeed < (cruiseSpeed - 3.0)) then
                        cruiseStatus = false
                        SendNUIMessage({ action = "cruise", status = false })
                        lib.notify({title = 'Crucero', description = 'Control de crucero desactivado.', type = 'error'})
                    else
                        SetVehicleForwardSpeed(veh, cruiseSpeed)
                    end
                end

                -- Conversión de velocidades dinámicas
                local speedMultiplier = Config.UseMPH and 2.236936 or 3.6
                local speedUnit = Config.UseMPH and "MPH" or "KM/H"
                local speedHUD = math.floor(GetEntitySpeed(veh) * speedMultiplier)

                local rpm = 0
                -- Si el juego reporta que el motor está realmente apagado (por un script de llaves), forzamos rpm a 0
                if GetIsVehicleEngineRunning(veh) and engineStatus and enginePct > 15 then
                    rpm = math.floor(GetVehicleCurrentRpm(veh) * 100)
                else
                    rpm = 0
                end
                
                local gear = GetVehicleCurrentGear(veh)
                local gearStr = tostring(gear)
                if gear == 0 then gearStr = "R" end
                
                local fuel = GetVehicleFuel(veh)

                local _, lightsOn, highBeamsOn = GetVehicleLightsState(veh)
                local lightStatus = "off"
                if highBeamsOn == 1 then lightStatus = "high" elseif lightsOn == 1 then lightStatus = "normal" end

                -- CORREGIDO: Definición nativa del nombre del modelo para evitar caídas de HUD
                local modelName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
                if modelName == "NULL" then modelName = GetDisplayNameFromVehicleModel(GetEntityModel(veh)) end

                -- 🛠️ SOLUCIÓN AL BLOQUEO DE MOTOS: Ajustamos de forma nativa para que sea un cierre virtual estable
                local isLocked = GetVehicleDoorLockStatus(veh) == 2 or GetVehicleDoorsLockedForPlayer(veh, ped)

                if not isHudVisible then
                    isHudVisible = true
                    SendNUIMessage({ 
                        action = "show",
                        size = Config.Size or 1.0,
                        bottom = Config.BottomMargin or 40,
                        right = Config.RightMargin or 40,
                        showName = Config.ShowVehicleName,
                        showRpm = Config.ShowRpmBar,
                        showFuel = Config.ShowFuelBar,
                        showEngine = Config.ShowEngineBar,
                        showGear = Config.ShowGearBox,
                        vehicleName = modelName,
                        hideSeatbelt = false, -- Control reactivo en el ui.js
                        fuelLimit = Config.FuelAlertPercent,
                        engineLimit = Config.EngineAlertPercent
                    })
                    SendNUIMessage({ action = "seatbelt", status = seatbeltStatus })
                    SendNUIMessage({ action = "cruise", status = cruiseStatus })
                end

                SendNUIMessage({
                    action = "update",
                    speed = speedHUD,
                    gear = gearStr,
                    unit = speedUnit,
                    rpm = rpm,
                    fuel = fuel,
                    engine = enginePct,
                    locked = isLocked,
                    lights = lightStatus,
                    radar = activeRadar,
                    radarSpeed = activeRadarSpeed,
                    vehType = vehType,       
                    odo = totalOdometer      
                })
            else
                if isHudVisible then ResetHudStates() end
            end
        else
            if isHudVisible then ResetHudStates() end
            engineStatus = true
            lastVehicleCoords = nil
            lastEngineState = nil
            sleep = 1000
        end
        Wait(sleep)
    end
end)

function ResetHudStates()
    isHudVisible = false
    seatbeltStatus = false
    cruiseStatus = false
    lastEngineState = nil
    SendNUIMessage({ action = "hide" })
end
