local holdingup = false
local store = ""
local blipclaim = nil
local omistus = nil
local hahaatable = {}
local jengissa = false
local ryostetaan = {}
ESX = nil

local Keys = {
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

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	Citizen.Wait(10000)
	
	while PlayerData == nil do
		PlayerData = ESX.GetPlayerData()
		Citizen.Wait(1000)
	end
	
	for i = 1, #Jobit, 1 do
		if PlayerData.job.name == Jobit[i] then
			jengissa = true
			break
		end
	end
	
	if jengissa then
		TriggerServerEvent('arp_jengialueet:fetchmestat')
	end
end)


RegisterNetEvent('arp_jengialueet:mestat')
AddEventHandler('arp_jengialueet:mestat', function(result)
	if jengissa then
		hahaatable = result
		if blipit then
			for i = 1, #Areas do
				RemoveBlip(Areas[i].nameofarea)
			end
			blipit = false
		end
		if not blipit then
			blipit = true
			for i = 1, #Areas do
				local ve = Areas[i].position
				Areas[i].nameofarea = AddBlipForRadius(ve.x, ve.y, ve.z, 500.0)  --350 alkuperänen
				SetBlipColour(Areas[i].nameofarea,69)
				if hahaatable[i].omistaja == PlayerData.job.name then
					SetBlipColour(Areas[i].nameofarea,69)
				else
					SetBlipColour(Areas[i].nameofarea,4)
				end
				SetBlipAlpha(Areas[i].nameofarea,33)
			end
		end
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function()
	jengissa = false
	PlayerData = ESX.GetPlayerData()
	for i = 1, #Jobit, 1 do
		if PlayerData.job.name == Jobit[i] then
			jengissa = true
			break
		end
	end
	if blipit then
		for i = 1, #Areas do
			RemoveBlip(Areas[i].nameofarea)
		end
		blipit = false
	end
	if jengissa then
		TriggerServerEvent('arp_jengialueet:fetchmestat')
	end
end)

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
   SetTextFont(4)
   SetTextProportional(1)
   SetTextScale(0.6, 0.6)
   SetTextColour(128, 128, 128, 255)
   SetTextDropshadow(0, 0, 0, 0, 255)
   SetTextEdge(1, 0, 0, 0, 150)
   SetTextDropshadow()
   SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)

end

RegisterNetEvent('arp_jengialueet:currentlyclaiming')
AddEventHandler('arp_jengialueet:currentlyclaiming', function(mesta)
	alueenperkele = mesta
	holdingup = true
end)

RegisterNetEvent('arp_jengialueet:menetetty')
AddEventHandler('arp_jengialueet:menetetty', function(kohte)
	SetBlipColour(Areas[kohte].nameofarea,4)
end)

RegisterNetEvent('arp_jengialueet:killblip')
AddEventHandler('arp_jengialueet:killblip', function(kohte)
	SetBlipColour(Areas[kohte].nameofarea,69)
end)

RegisterNetEvent('arp_jengialueet:setblip')
AddEventHandler('arp_jengialueet:setblip', function(kohte)
	SetBlipColour(Areas[kohte].nameofarea,59)
end)

RegisterNetEvent('arp_jengialueet:toofarlocal')
AddEventHandler('arp_jengialueet:toofarlocal', function()
	holdingup = false
	claimingName = ""
end)

RegisterNetEvent('arp_jengialueet:muille')
AddEventHandler('arp_jengialueet:muille', function(alue)
	ESX.ShowNotification('Jengisi on vallannut alueen')
	SetBlipColour(Areas[alue].nameofarea,69)
end)

RegisterNetEvent('arp_jengialueet:claimcomplete')
AddEventHandler('arp_jengialueet:claimcomplete', function()
	holdingup = false
	alueenperkele = ""
end)

RegisterNetEvent('arp_jengialueet:valloitusilmoitus') --testi 28.5
AddEventHandler('arp_jengialueet:valloitusilmoitus', function(notifikaatio)
	if not ryostetaan[notifikaatio] then
		ryostetaan[notifikaatio] = true
	else
		ryostetaan[notifikaatio] = false
	end
	while ryostetaan[notifikaatio] == true do
		local halytys = Areas[notifikaatio].position
		local sijainti = GetEntityCoords(PlayerPedId(), true)
		if Vdist(sijainti.x, sijainti.y, sijainti.z, halytys.x, halytys.y, halytys.z) < Config.MaxDistance then
			drawTxt(0.66, 1.40, 1.0,1.0,0.4, '~r~VAROITUS ~w~- ALUETTASI VALLATAAN !', 255, 255, 255, 255)
		end
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('arp_jengialueet:starttimer')
AddEventHandler('arp_jengialueet:starttimer', function()
	timer = Config.Valtausaika
	laskuri = 0
	Citizen.CreateThread(function()
		while timer > 0 do

			Citizen.Wait(1000)
			if timer > 0 then
				timer = timer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if holdingup then
				if not poistumassa then
					drawTxt(0.66, 1.44, 1.0,1.0,0.4, '~w~Sinulla on ~r~'..timer..' ~w~sekuntia aikaa kovistella alueella asuvia kansalaisia. ~g~'..laskuri..' / '..Config.Montakoalistetaan, 255, 255, 255, 255)
				else
					drawTxt(0.66, 1.44, 1.0,1.0,0.4, '~r~VAROITUS ~w~- OLET POISTUMASSA ALUEELTA !', 255, 255, 255, 255)
				end
			else
				Citizen.Wait(1000)
			end
		end
	end)
end)


laskuri = 0
Citizen.CreateThread(function()
Citizen.Wait(21000) --aika hakea työpaikka 8.5
	while true do
		Citizen.Wait(5)
		local pos = GetEntityCoords(PlayerPedId(), true)
		
		if not holdingup then
			
			for i = 1, #Areas do
				local pos2 = Areas[i].position
				local area = i
				if Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 3.0 then
					if hahaatable[i].omistaja ~= nil and hahaatable[i].omistaja == PlayerData.job.name then
						ESX.ShowHelpNotification('Paina ~INPUT_CONTEXT~ kerätäksesi suojelurahat - ~g~'..Areas[i].nameofree) -- ilmoitus paina E
					elseif PlayerData.job.name == "police" then
						ESX.ShowHelpNotification('Paina ~INPUT_CONTEXT~ vapauttaaksesi alue - ~g~'..Areas[i].nameofree) -- ilmoitus paina E
					else
						ESX.ShowHelpNotification('Paina ~INPUT_CONTEXT~ vallataksesi alue - ~g~'..Areas[i].nameofree) -- ilmoitus paina E
					end
					if IsControlJustReleased(0, Keys['E']) then -- käynnistä ryöstö
						Citizen.Wait(2000)
						if IsPedArmed(PlayerPedId(), 7) then
							if not jengissa then-- onko asetta								
								ESX.ShowNotification('Et kuulu jengiin')
							else
								TriggerServerEvent('arp_jengialueet:claim', area)
							end
						else
							ESX.ShowNotification('Paljainkäsinkö ajattelit pelotella kansalaisia?!?') -- ei välineitä mukana
						end
					end
				end
			end
			
		else
			if IsControlPressed(0, 25) then
				local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))
				if aiming then
					local playerPed = GetPlayerPed(-1)
					local pCoords = GetEntityCoords(playerPed, true)
					local tCoords = GetEntityCoords(targetPed, true)
					if not IsPedInAnyVehicle(playerPed, false) and IsPedArmed(playerPed, 7) then
						if DoesEntityExist(targetPed) and IsEntityAPed(targetPed) and not IsPedAPlayer(targetPed) and targetPed ~= oldped and not IsPedDeadOrDying(targetPed, true) and not IsPedCuffed(targetPed) then
							if IsPedInAnyVehicle(targetPed, false) then
								if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, tCoords.x, tCoords.y, tCoords.z, true) < 25 then									
									if GetEntitySpeed(targetPed)*3.6 < 20 then
										TaskLeaveVehicle(targetPed, GetVehiclePedIsUsing(targetPed), 1)
										robbedRecently = true
										Citizen.Wait(1500)
										if not IsPedInAnyVehicle(targetPed, false) then
											TaskSmartFleePed(targetPed, GetPlayerPed(-1), 1000.0, -1, true, true)
											SetPedAsNoLongerNeeded(targetPed)
											laskuri = laskuri + 1
										end
										robbedRecently = false
									end
								end
							else
								if not robbedRecently then
									robNpc(targetPed)
								end
							end
						end
					end
				end
			end
			local pos2 = Areas[alueenperkele].position
			if Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > Config.MaxDistance then
				TriggerServerEvent('arp_jengialueet:toofar', alueenperkele)
				timer = 0
			end

			if Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > Config.MaxDistance - 50 then
				poistumassa = true
			else
				poistumassa = false
			end

			if IsPedDeadOrDying(GetPlayerPed(-1)) then
				timer = 0
				TriggerServerEvent('arp_jengialueet:toofar', alueenperkele)
			end

			if timer == 0 then
				TriggerServerEvent('arp_jengialueet:toofar', alueenperkele)
				holdingup = false
			end
			
			if laskuri == Config.Montakoalistetaan then
				TriggerServerEvent('arp_jengialueet:rostoohi', alueenperkele)
				holdingup = false
				laskuri = 0
			end

			Citizen.Wait(100)
		end
		
	end
end)

function robNpc(targetPed)
    Citizen.CreateThread(function()
		robbedRecently = true
		ClearPedTasks(targetPed)
		SetEnableHandcuffs(targetPed, true)
		for xd=1, Config.RobAnimationSeconds*100 do
			Citizen.Wait(0)
			TaskHandsUp(targetPed, 100, GetPlayerPed(-1), 5000, 1)
		end
		TaskSmartFleePed(targetPed, GetPlayerPed(-1), 1000.0, -1, true, true)
		SetPedAsNoLongerNeeded(targetPed)
		oldped = targetPed
        robbedRecently = false
		laskuri = laskuri + 1
    end)
end
