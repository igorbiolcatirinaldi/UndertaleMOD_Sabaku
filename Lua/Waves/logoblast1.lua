-- Spawn sabaku logo in the middle-up and shoot black/white ray to player

spawntimer = 0
bullets = {}
playerResetPos = false
bulletLife = 30
sabakuLogo = CreateProjectile("SabakuLogoWSym", 0, Arena.height / 2 + 10)
sabakuLogo.sprite.xscale = 0.35
sabakuLogo.sprite.yscale = 0.35
FireSound = "gasterfire"
FireIntro = "gasterintro"
frameToSpawn = 20
timerSpawnHelper = 0
updateAngle = true
setupspawn = false

function SetBulletDirection(bullet)
	differenceX = Player.x - bullet.x
	differenceY = Player.y - bullet.y
	lengthSquared = math.pow(differenceX, 2) + math.pow(differenceY, 2)
	length = math.sqrt(lengthSquared)
	bullet["velx"] = differenceX / length * bulletSpeed
	bullet["vely"] = differenceY / length * bulletSpeed
end

function CreateBullet(x, y, angle)
	local bullet = CreateProjectileAbs("Beam", 0, 0)
	bullet["frame_spawned"] = spawntimer
	bullet["alternate"] = 3
	bullet.sprite.rotation = angle + 90
	bullet.ppcollision = true
	bullet.sprite.SetPivot(1,0.5)
	bullet.MoveTo(x,y)
	table.insert(bullets, bullet)
	Misc.ShakeScreen(30,3)
end

function Update()
	if updateAngle == true then
		angle =  math.deg(math.atan(Player.x/math.abs(Player.y-sabakuLogo.y)))
		sabakuLogo.sprite.rotation = angle
	end
	
	if playerResetPos == false then
		Player.MoveTo(0,-15)
		playerResetPos = true
	end
	if spawntimer > 0 then
		if spawntimer % 90 == 0 then
			updateAngle = false
			Audio.PlaySound(FireIntro)
			timerSpawnHelper = spawntimer
			setupspawn = true
		elseif setupspawn == true and spawntimer > timerSpawnHelper + frameToSpawn	then
			local xPos = 0
			local yPos = sabakuLogo.y
			CreateBullet(xPos, yPos, angle)
			Audio.PlaySound(FireSound)
			setupspawn = false
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
			updateAngle = true
			currentBullet.Remove()
			table.remove(bullets, i)
		end
	end
	
	spawntimer = spawntimer + 1
end