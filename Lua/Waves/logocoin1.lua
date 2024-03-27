-- Spawn sabaku logo in the middle-up and shoot black/white coin sprite to player

spawntimer = 0
bullets = {}
directions = {}
bulletSpeed = 3
playerResetPos = false
sabakuLogo = CreateProjectile("SabakuLogoWSym", 0, Arena.height / 2 + 20)
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
	table.insert(bullets, bullet)
end

function Update()
	sabakuLogo.sprite.rotation = math.deg(math.asin(Player.x/math.abs(Player.y-sabakuLogo.y)))
	--DEBUG("rotation " .. sabakuLogo.sprite.rotation)
	
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
		if bulletAge > 60 then
			if currentBullet["computeDirection"] == false then
				SetBulletDirection(currentBullet)
				currentBullet["computeDirection"] = true
			end
			currentBullet.Move(currentBullet["velx"], currentBullet["vely"])
		else
			currentBullet.x = Player.x / 8
		end
		
		if currentBullet.y < -Arena.height then
			currentBullet.Remove()
			table.remove(bullets, i)
		end
	end
	
	
	spawntimer = spawntimer + 1
end