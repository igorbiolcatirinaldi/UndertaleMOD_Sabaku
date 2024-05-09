-- Spawn 3 sabaku logo at middle and the corner of arena and shoot a yellow coin sprite to player that explode

spawntimer = 0
bullets = {}
explosionBullets = {}
directions = {}
bulletSpeed = 2
explosionBulletLife = 20
playerResetPos = false
offsetX = 20
positionsX = {0, -Arena.width + offsetX, Arena.width - offsetX}
ageBullets = {60,80,100}
colorsType = {"regular","cyan","orange"}
colors = {{255/255,255/255,0/255},{0/255, 162/255, 232/255},{255/255, 154/255, 34/255}}
damage = 5
sabakuLogo1 = CreateProjectile("SabakuLogoWSym", -Arena.width, Arena.height / 2 + 20)
sabakuLogo1.sprite.color = colors[2]
sabakuLogo1.sprite.xscale = 0.35
sabakuLogo1.sprite.yscale = 0.35
sabakuLogo2 = CreateProjectile("SabakuLogoWSym", Arena.width, Arena.height / 2 + 20)
sabakuLogo2.sprite.color = colors[3]
sabakuLogo2.sprite.xscale = 0.35
sabakuLogo2.sprite.yscale = 0.35
sabakuLogoC = CreateProjectile("SabakuLogoWSym", 0, Arena.height / 2 + 20)
sabakuLogoC.sprite.xscale = 0.35
sabakuLogoC.sprite.yscale = 0.35
sabakuLogoC.sprite.color = colors[1]

function SetBulletDirection(bullet)
	differenceX = Player.x - bullet.x
	differenceY = Player.y - bullet.y
	lengthSquared = math.pow(differenceX, 2) + math.pow(differenceY, 2)
	length = math.sqrt(lengthSquared)
	bullet["velx"] = differenceX / length * bulletSpeed
	bullet["vely"] = differenceY / length * bulletSpeed
	bullet["movingtime"] = spawntimer
end

function CreateBullet(x, y, age, color, ctype)
	local bullet = CreateProjectile("CoinBW", x, y)
	bullet["positionX"] = x
	bullet["frame_spawned"] = spawntimer
	bullet["computeDirection"] = false
	bullet["age"] = age
	bullet["movingtime"] = 0
	bullet["explodingtime"] = math.random(30,80)
	bullet["color"] = ctype
	bullet.sprite.color = color
	table.insert(bullets, bullet)
end

function CreateExplosionBullet(x, y, ctype) -- todo change color
	local bullet = CreateProjectile("Circle-Exp", x, y)
	bullet["frame_spawned"] = spawntimer
	bullet["color"] = ctype
	bullet.sprite.xscale = 0.05
	bullet.sprite.yscale = 0.05
	table.insert(explosionBullets, bullet)
end

function Update()
	sabakuLogoC.sprite.rotation = math.deg(math.asin(Player.x/math.abs(Player.y-sabakuLogoC.y)))
	sabakuLogo1.sprite.rotation = math.deg(math.atan(math.abs(Player.x-sabakuLogo1.x)/math.abs(Player.y-sabakuLogo1.y)))
	sabakuLogo2.sprite.rotation = 360 - math.deg(math.atan(math.abs(Player.x-sabakuLogo2.x)/math.abs(Player.y-sabakuLogo2.y)))

	if playerResetPos == false then
		Player.MoveTo(0,-15)
		playerResetPos = true
	end
	if spawntimer % 120 == 0 then
		local yPos = Arena.height - 20
		-- center
		CreateBullet(positionsX[1],yPos,ageBullets[1],colors[1],colorsType[1])
		-- left
		CreateBullet(positionsX[2],yPos,ageBullets[2],colors[2],colorsType[2])
		-- right
		CreateBullet(positionsX[3],yPos,ageBullets[3],colors[3],colorsType[3])
	end
	
	for i = #bullets, 1, -1
	do
		currentBullet = bullets[i]
		bulletAge = spawntimer - currentBullet["frame_spawned"]
		if bulletAge < currentBullet["age"] then
			currentBullet.x = currentBullet["positionX"] + Player.x / 5
			currentBullet["movingtime"] = spawntimer
		elseif bulletAge >= currentBullet["age"] and spawntimer < currentBullet["movingtime"] + currentBullet["explodingtime"] then
			if currentBullet["computeDirection"] == false then
				SetBulletDirection(currentBullet)
				currentBullet["computeDirection"] = true
			end
			currentBullet.Move(currentBullet["velx"], currentBullet["vely"])
		elseif spawntimer >= (currentBullet["movingtime"] + currentBullet["explodingtime"]) then
			-- explode
			CreateExplosionBullet(currentBullet.x,currentBullet.y,currentBullet["color"])
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

function OnHit(bullet)
	local color = bullet.GetVar("color")
	if color == "regular" then
        Player.Hurt(damage)
	elseif color == "cyan" and Player.isMoving then
        Player.Hurt(damage)
    elseif color == "orange" and not Player.isMoving then
        Player.Hurt(damage)
    end
end