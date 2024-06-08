-- Spawn sabaku logo at the high corner of arena and shoot black/white coin sprite to player

spawntimer = 0
bullets = {}
directions = {}
bulletSpeed = 3
playerResetPos = false
ageBullet1 = 60
ageBullet2 = 100
sabakuLogo1 = CreateProjectile("SabakuLogoWSym", -Arena.width +40, Arena.height / 2 + 10)
sabakuLogo1.sprite.xscale = 0.35
sabakuLogo1.sprite.yscale = 0.35
sabakuLogo2 = CreateProjectile("SabakuLogoWSym", Arena.width -40, Arena.height / 2 + 10)
sabakuLogo2.sprite.xscale = 0.35
sabakuLogo2.sprite.yscale = 0.35

function SetBulletDirection(bullet)
	differenceX = Player.x - bullet.x
	differenceY = Player.y - bullet.y
	lengthSquared = math.pow(differenceX, 2) + math.pow(differenceY, 2)
	length = math.sqrt(lengthSquared)
	bullet["velx"] = differenceX / length * bulletSpeed
	bullet["vely"] = differenceY / length * bulletSpeed
end

function CreateBullet(x, y, age, pos)
	local bullet = CreateProjectile("CoinBW", x, y)
	bullet["frame_spawned"] = spawntimer
	bullet["computeDirection"] = false
	bullet["age"] = age
	bullet["position"] = pos
	table.insert(bullets, bullet)
end

function Update()
	sabakuLogo1.sprite.rotation = math.deg(math.atan(math.abs(Player.x-sabakuLogo1.x)/math.abs(Player.y-sabakuLogo1.y)))
	sabakuLogo2.sprite.rotation = 360 - math.deg(math.atan(math.abs(Player.x-sabakuLogo2.x)/math.abs(Player.y-sabakuLogo2.y)))
	
	if playerResetPos == false then
		Player.MoveTo(0,-15)
		playerResetPos = true
	end
	if spawntimer % 60 == 0 then
		local xPosLeft = -Arena.width / 2
		local xPosRight = Arena.width / 2
		local yPos = sabakuLogo1.y - 17
		CreateBullet(xPosLeft, yPos, ageBullet1, "left")
		CreateBullet(xPosRight, yPos, ageBullet2, "right")
	end
	
	for i = #bullets, 1, -1
	do
		currentBullet = bullets[i]
		bulletAge = spawntimer - currentBullet["frame_spawned"]
		if bulletAge > currentBullet["age"] then
			if currentBullet["computeDirection"] == false then
				SetBulletDirection(currentBullet)
				currentBullet["computeDirection"] = true
			end
			currentBullet.Move(currentBullet["velx"], currentBullet["vely"])
		else
			if currentBullet["position"] == "left" then
				currentBullet.x = -Arena.width / 2 + Player.x / 7
			else
				currentBullet.x = Arena.width / 2 + Player.x / 7
			end
		end
		
		if currentBullet.y < -Arena.height then
			currentBullet.Remove()
			table.remove(bullets, i)
		end
	end
	
	spawntimer = spawntimer + 1
end