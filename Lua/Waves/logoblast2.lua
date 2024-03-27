-- Spawn 2 sabaku logo at the high corner of arena and shoot black/white ray to player

spawntimer = 0
bullets = {}
playerResetPos = false
bulletLife = 20
sabakuLogoL = CreateProjectile("SabakuLogoWSym", -Arena.width, Arena.height / 2 + 20)
sabakuLogoL.sprite.xscale = 0.35
sabakuLogoL.sprite.yscale = 0.35
sabakuLogoR = CreateProjectile("SabakuLogoWSym", Arena.width, Arena.height / 2 + 20)
sabakuLogoR.sprite.xscale = 0.35
sabakuLogoR.sprite.yscale = 0.35
FireSound = "gasterfire"
FireIntro = "gasterintro"
frameToSpawn = 20
timerSpawnHelperL = 0
timerSpawnHelperR = 0
updateAngleL = true
updateAngleR = true
setupspawnL = false
setupspawnR = false
spawnFrameL = 80
spawnFrameR = 120 -- after letf spawned

function CreateBullet(x, y, angle, btype)
	local bullet = CreateProjectileAbs("Beam", 0, 0)
	bullet["frame_spawned"] = spawntimer
	bullet["alternate"] = 3
	bullet["type"] = btype
	bullet.sprite.rotation = angle + 90
	bullet.ppcollision = true
	bullet.sprite.SetPivot(1,0.5)
	bullet.MoveTo(x,y)
	table.insert(bullets, bullet)
	Misc.ShakeScreen(30,3)
end

function Update()
	if updateAngleL == true then
		angleL = math.deg(math.atan(math.abs(Player.x-sabakuLogoL.x)/math.abs(Player.y-sabakuLogoL.y)))
		sabakuLogoL.sprite.rotation = angleL
	end
	if updateAngleR == true then
		angleR = 360 - math.deg(math.atan(math.abs(Player.x-sabakuLogoR.x)/math.abs(Player.y-sabakuLogoR.y)))
		sabakuLogoR.sprite.rotation = angleR
	end
	
	if playerResetPos == false then
		Player.MoveTo(0,-15)
		playerResetPos = true
	end
	if spawntimer > 0 then
		if spawntimer % spawnFrameL == 0 then
			updateAngleL = false
			Audio.PlaySound(FireIntro)
			timerSpawnHelperL = spawntimer
			setupspawnL = true
		elseif setupspawnL == true and spawntimer > timerSpawnHelperL + frameToSpawn	then
			local xPos = -Arena.width + 5
			local yPos = Arena.height
			CreateBullet(xPos, yPos, angleL, "left")
			Audio.PlaySound(FireSound)
			setupspawnL = false
		end
		if spawntimer % spawnFrameR == 0 then
			updateAngleR = false
			Audio.PlaySound(FireIntro)
			timerSpawnHelperR = spawntimer
			setupspawnR = true
		elseif setupspawnR == true and spawntimer > timerSpawnHelperR + frameToSpawn	then
			local xPos = Arena.width - 5
			local yPos = Arena.height
			CreateBullet(xPos, yPos, angleR, "rigth")
			Audio.PlaySound(FireSound)
			setupspawnR = false
		end
	end
	
	for i = #bullets, 1, -1
	do
		currentBullet = bullets[i]
		bulletAge = spawntimer - currentBullet["frame_spawned"]
		
		if currentBullet["alternate"] > 0 then
			currentBullet.sprite.alpha = currentBullet.sprite.alpha - 0.1
			currentBullet.sprite.xscale = currentBullet.sprite.xscale - 0.1
			currentBullet.sprite.yscale = currentBullet.sprite.yscale - 0.1
			currentBullet["alternate"] = currentBullet["alternate"] - 1
			if currentBullet["alternate"] == 0 then
				currentBullet["alternate"] = -3
			end
		else
			currentBullet.sprite.alpha = currentBullet.sprite.alpha + 0.1
			currentBullet.sprite.xscale = currentBullet.sprite.xscale + 0.1
			currentBullet.sprite.yscale = currentBullet.sprite.yscale + 0.1
			currentBullet["alternate"] = currentBullet["alternate"] + 1
			if currentBullet["alternate"] == 0 then
				currentBullet["alternate"] = 3
			end
		end
		
		
		if bulletAge > bulletLife then
			if(currentBullet["type"] == "left") then
				updateAngleL = true
			else
				updateAngleR = true
			end			
			currentBullet.Remove()
			table.remove(bullets, i)
		end
	end
	
	spawntimer = spawntimer + 1
end