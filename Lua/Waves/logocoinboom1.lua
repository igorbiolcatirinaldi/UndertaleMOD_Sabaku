-- Spawn sabaku logo in the middle-up and shoot a yellow coin sprite to player that explode

spawntimer = 0
bullets = {}
explosionBullets = {}
directions = {}
bulletSpeed = 2.5
bulletStartAttackAge = 30
bulletExplodingAge = 75
explosionBulletLife = 35
playerResetPos = false
yellow = {1,1,0}
sabakuLogo = CreateProjectile("SabakuLogoWSym", 0, Arena.height / 2 + 20)
sabakuLogo.sprite.color = yellow
sabakuLogo.sprite.xscale = 0.35
sabakuLogo.sprite.yscale = 0.35

function SetBulletDirection(bullet)
	differenceX = Player.x - bullet.x
	differenceY = Player.y - bullet.y
	lengthSquared = math.pow(differenceX, 2) + math.pow(differenceY, 2)
	length = math.sqrt(lengthSquared)
	bullet["velx"] = differenceX / length * bulletSpeed
	bullet["vely"] = differenceY / length * bulletSpeed
end

function CreateBullet(x, y)
	local bullet = CreateProjectile("CoinBW", x, y)
	bullet["frame_spawned"] = spawntimer
	bullet["computeDirection"] = false
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
	sabakuLogo.sprite.rotation = math.deg(math.asin(Player.x/math.abs(Player.y-sabakuLogo.y)))

	if playerResetPos == false then
		Player.MoveTo(0,-15)
		playerResetPos = true
	end
	if spawntimer % 120 == 0 then
		local xPos = Player.x / 8
		local yPos = Arena.height - 10
		CreateBullet(xPos, yPos)
	end
	
	for i = #bullets, 1, -1
	do
		currentBullet = bullets[i]
		bulletAge = spawntimer - currentBullet["frame_spawned"]
		if bulletAge < bulletStartAttackAge then
			currentBullet.x = Player.x / 8
		elseif bulletAge >= bulletStartAttackAge and bulletAge < bulletExplodingAge then
			if currentBullet["computeDirection"] == false then
				SetBulletDirection(currentBullet)
				currentBullet["computeDirection"] = true
			end
			currentBullet.Move(currentBullet["velx"], currentBullet["vely"])
		elseif bulletAge >= bulletExplodingAge then
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