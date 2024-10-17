local isBlackedOut = false
local oldBodyDamage = 0
local oldSpeed = 0
local impact = 0


local function blackout()
	if not isBlackedOut then
		isBlackedOut = true
		Citizen.CreateThread(function()
			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 50.0, 'crash01', 0.5)
			if impact <= 50 then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.4)
			elseif impact > 50 and impact <= 60 then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.7)
			elseif impact > 60 and impact <= 70 then
				ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 1.2)
			elseif impact > 70 and impact <= 80 then
				ShakeGameplayCam('MEDIUM_EXPLOSION_SHAKE', 1.5)
			else 
				ShakeGameplayCam('LARGE_EXPLOSION_SHAKE', 1.5)
			end

			Citizen.Wait(200)
			DoScreenFadeOut(100)
			
			StartScreenEffect("DrugsDrivingIn",3000,false)
			while not IsScreenFadedOut() do
				Citizen.Wait(0)
			end
			
			if impact <= 50 then
				Citizen.Wait(5000)
			elseif impact > 50 and impact <= 60 then
				Citizen.Wait(10000)
				SetEntityHealth(GetPlayerPed(-1), 160)
			elseif impact > 60 and impact <= 70 then
				Citizen.Wait(20000)
				SetEntityHealth(GetPlayerPed(-1), 150)
			elseif impact > 70 and impact <= 80 then
				Citizen.Wait(30000)
				SetEntityHealth(GetPlayerPed(-1), 125)
			else 
				Citizen.Wait(30000)
				SetEntityHealth(GetPlayerPed(-1), 75)
			end
			
			SetFollowVehicleCamViewMode(4)
			
			if not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") then
				RequestAnimSet("MOVE_M@DRUNK@VERYDRUNK")
				while not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") do
					Citizen.Wait(0)
				end
			end	
			SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@VERYDRUNK", 1.0)
			DoScreenFadeIn(1800)
			Citizen.Wait(2000)
			DoScreenFadeOut(1600)
			Citizen.Wait(1800)
			DoScreenFadeIn(1400)
			Citizen.Wait(1600)
			DoScreenFadeOut(1100)
			isBlackedOut = false
			Citizen.Wait(1100)
			DoScreenFadeIn(1000)
			Citizen.Wait(1200)
			DoScreenFadeOut(900)
			Citizen.Wait(900)
			DoScreenFadeIn(800)
			Citizen.Wait(1000)
			DoScreenFadeOut(700)
			Citizen.Wait(700)
			DoScreenFadeIn(600)	
			
			if impact <= 50 then
				Citizen.Wait(1000)
			elseif impact > 50 and impact <= 60 then
				Citizen.Wait(5000)
			elseif impact > 60 and impact <= 70 then
				Citizen.Wait(10000)
			elseif impact > 70 and impact <= 80 then
				Citizen.Wait(15000)
			else 
				Citizen.Wait(23000)
			end			
			
			StopScreenEffect("DrugsDrivingIn")
			
			if impact <= 50 then
				StartScreenEffect("DrugsDrivingOut",1000,false)
				Citizen.Wait(1200)
				ResetPedMovementClipset(GetPlayerPed(-1))
				ResetPedWeaponMovementClipset(GetPlayerPed(-1))
				ResetPedStrafeClipset(GetPlayerPed(-1))
			elseif impact > 50 and impact <= 60 then
				StartScreenEffect("DrugsDrivingOut",4000,false)
				Citizen.Wait(4200)
				ResetPedMovementClipset(GetPlayerPed(-1))
				ResetPedWeaponMovementClipset(GetPlayerPed(-1))
				ResetPedStrafeClipset(GetPlayerPed(-1))
			elseif impact > 60 and impact <= 70 then
				StartScreenEffect("DrugsDrivingOut",8000,false)
				Citizen.Wait(8200)
				ResetPedMovementClipset(GetPlayerPed(-1))
				ResetPedWeaponMovementClipset(GetPlayerPed(-1))
				ResetPedStrafeClipset(GetPlayerPed(-1))
			elseif impact > 70 and impact <= 80 then
				StartScreenEffect("DrugsDrivingOut",10000,false)
				Citizen.Wait(10200)
				ResetPedMovementClipset(GetPlayerPed(-1))
				ResetPedWeaponMovementClipset(GetPlayerPed(-1))
				ResetPedStrafeClipset(GetPlayerPed(-1))
			else 
				StartScreenEffect("DrugsDrivingOut",20000,false)
				Citizen.Wait(20200)
				ResetPedMovementClipset(GetPlayerPed(-1))
				ResetPedWeaponMovementClipset(GetPlayerPed(-1))
				ResetPedStrafeClipset(GetPlayerPed(-1))
			end
		end)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		HideLoadingOnFadeThisFrame()
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		if DoesEntityExist(vehicle) then
			if Config.BlackoutFromDamage then
				local currentDamage = GetVehicleBodyHealth(vehicle)
				if currentDamage ~= oldBodyDamage then
					if not isBlackedOut and (currentDamage < oldBodyDamage) and ((oldBodyDamage - currentDamage) >= Config.BlackoutDamageRequired) then
						blackout()
					end
					oldBodyDamage = currentDamage
				end
			end

			if Config.BlackoutFromSpeed then

				local currentSpeed = GetEntitySpeed(vehicle) * 2.23

				if currentSpeed ~= oldSpeed then
					if not isBlackedOut and (currentSpeed < oldSpeed) and ((oldSpeed - currentSpeed) >= Config.BlackoutSpeedRequired) then
						impact = (oldSpeed - currentSpeed)
						blackout()
					end
					oldSpeed = currentSpeed
				end
			end
		else
			oldBodyDamage = 0
			oldSpeed = 0
		end
		
		if isBlackedOut and Config.DisableControlsOnBlackout then
			DisableControlAction(0,71,true)
			DisableControlAction(0,72,true)
			DisableControlAction(0,63,true)
			DisableControlAction(0,64,true)
			DisableControlAction(0,75,true)
			DisableControlAction(0,0,true)
			DisableControlAction(0,249,true)
		end
	end
end)
