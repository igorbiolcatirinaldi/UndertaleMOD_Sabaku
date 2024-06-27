-- Spawn 2 sabaku logo at the corner of arena and shoot a yellow coin sprite to player that explode

spawntimer = 0
bullets = {}
explosionBullets = {}
directions = {}
bulletSpeed = 2
bulletStartAttackAge1 = 60
bulletStartAttackAge2 = 100
explosionBulletLife = 30
playerResetPos = false
yellow = {1,1,0}
sabakuLogo1 = CreateProjectile("SabakuLogoWSym", -Arena.width, Arena.height / 2 + 20)
sabakuLogo1.sprite.color = yellow
sabakuLogo1.sprite.xscale = 0.35
sabakuLogo1.sprite.yscale = 0.35
sabakuLogo2 = CreateProjectile("SabakuLogoWSym", Arena.width, Arena.height / 2 + 20)
sabakuLogo2.sprite.color = yellow
sabakuLogo2.sprite.xscale = 0.35
sabakuLogo2.sprite.yscale = 0.35

function SetBulletDirection(bullet)
	differenceX = Player.x - bullet.x
	differenceY = Player.y - bullet.y
	lengthSquared = math.pow(differenceX, 2) + math.pow(differenceY, 2)
	length = math.sqrt(lengthSquared)
	bullet["velx"] = differenceX / length * bulletSpeed
	bullet["vely"] = differenceY / length * bulletSpeed
	bullet["movingtime"] = spawntimer
end

function CreateBullet(x, y, age, pos)
	local bullet = CreateProjectile("CoinBW", x, y)
	bullet["frame_spawned"] = spawntimer
	bullet["computeDirection"] = false
	bullet["age"] = age
	bullet["position"] = pos
	bullet["movingtime"] = 0
	bullet["explodingtime"] = math.random(30,80)
	bullet.sprite.color = yellow
	table.insert(bullets, bullet)
end

function CreateExplosionBullet(x, y)
	local bullet = CreateProjectile("Explosion_Original", x, y)
	bullet.ppcollision = true
	bullet.sprite.color = yellow
	bullet["frame_spawned"] = spawntimer
	bullet.sprite.xscale = 0.05
	bullet.sprite.yscale = 0.05
	table.insert(explosionBullets, bullet)
end

function Update()
	sabakuLogo1.sprite.rotation = math.deg(math.atan(math.abs(Player.x-sabakuLogo1.x)/math.abs(Player.y-sabakuLogo1.y)))
	sabakuLogo2.sprite.rotation = 360 - math.deg(math.atan(math.abs(Player.x-sabakuLogo2.x)/math.abs(Player.y-sabakuLogo2.y)))

	if playerResetPos == false then
		Player.MoveTo(0,-15)
		playerResetPos = true
	end
	if spawntimer % 120 == 0 then
		local xPosLeft = sabakuLogo1.x - 10 + Player.x / 8
		local xPosRight = sabakuLogo2.x + 10 + Player.x / 8
		local yPos = sabakuLogo1.y - 10
		CreateBullet(xPosLeft, yPos, bulletStartAttackAge1, "left")
		CreateBullet(xPosRight, yPos, bulletStartAttackAge2, "right")
	end
	
	for i = #bullets, 1, -1
	do
		currentBullet = bullets[i]
		bulletAge = spawntimer - currentBullet["frame_spawned"]
		if bulletAge < currentBullet["age"] then
			if currentBullet["position"] == "left" then
				currentBullet.x = -Arena.width + 20 + Player.x / 8
			else
				currentBullet.x = Arena.width - 20 + Player.x / 8
			end
			currentBullet["movingtime"] = spawntimer
		elseif bulletAge >= currentBullet["age"] and spawntimer < currentBullet["movingtime"] + currentBullet["explodingtime"] then
			if currentBullet["computeDirection"] == false then
				SetBulletDirection(currentBullet)
				currentBullet["computeDirection"] = true
			end
			currentBullet.Move(currentBullet["velx"], currentBullet["vely"])
		elseif spawntimer >= (currentBullet["movingtime"] + currentBullet["explodingtime"]) then
			-- explode
			CreateExplosionBullet(currentBullet.x,currentBullet.y)
			Audio.PlaySound("boom10",0.8)
			currentBullet.Remove()
			table.remove(bullets, i)
		end		
		
		if currentBullet.y < -Arena.height then
			currentBullet.Remove()
			table.remove(bullets, i)
		end
	end
	
	for i = #explosionBullets, 1, -1
	do
		currentBullet = explosionBullets[i]
		bulletAge = spawntimer - currentBullet["frame_spawned"]
		if bulletAge < explosionBulletLife then
			currentBullet.sprite.xscale = currentBullet.sprite.xscale + 0.007
			currentBullet.sprite.yscale = currentBullet.sprite.yscale + 0.007
		else
			currentBullet.Remove()
			table.remove(explosionBullets, i)
		end
	end
	
	spawntimer = spawntimer + 1
end