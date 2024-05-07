-- Spawn 3 sabaku logo at the high of arena and shoot 1 black/white, 1 cyan, 1 orange coin sprite to player

spawntimer = 0
bullets = {}
directions = {}
bulletSpeed = 2.5
playerResetPos = false
offsetX = 20
positionsX = {0, -Arena.width + offsetX, Arena.width - offsetX}
ageBullets = {60,80,100}
colorsType = {"regular","cyan","orange"}
colors = {{255/255, 255/255, 255/255},{0/255, 162/255, 232/255},{255/255, 154/255, 34/255}}
damage = 5
sabakuLogoL = CreateProjectile("SabakuLogoWSym", -Arena.width, Arena.height / 2 + 20)
sabakuLogoL.sprite.xscale = 0.35
sabakuLogoL.sprite.yscale = 0.35
sabakuLogoR = CreateProjectile("SabakuLogoWSym", Arena.width, Arena.height / 2 + 20)
sabakuLogoR.sprite.xscale = 0.35
sabakuLogoR.sprite.yscale = 0.35
sabakuLogoC = CreateProjectile("SabakuLogoWSym", 0, Arena.height / 2 + 20)
sabakuLogoC.sprite.xscale = 0.35
sabakuLogoC.sprite.yscale = 0.35

function SetBulletDirection(bullet)
	differenceX = Player.x - bullet.x
	differenceY = Player.y - bullet.y
	lengthSquared = math.pow(differenceX, 2) + math.pow(differenceY, 2)
	length = math.sqrt(lengthSquared)
	bullet["velx"] = differenceX / length * bulletSpeed
	bullet["vely"] = differenceY / length * bulletSpeed
end

function CreateBullet(x, y, age, color, ctype)
	local bullet = CreateProjectile("CoinBW", x, y)
	bullet["positionX"] = x
	bullet["frame_spawned"] = spawntimer
	bullet["computeDirection"] = false
	bullet["age"] = age
	bullet["color"] = ctype
	bullet.sprite.color = color
	table.insert(bullets, bullet)
end

function Update()
	sabakuLogoC.sprite.rotation = math.deg(math.asin(Player.x/math.abs(Player.y-sabakuLogoC.y)))
	sabakuLogoL.sprite.rotation = math.deg(math.atan(math.abs(Player.x-sabakuLogoL.x)/math.abs(Player.y-sabakuLogoL.y)))
	sabakuLogoR.sprite.rotation = 360 - math.deg(math.atan(math.abs(Player.x-sabakuLogoR.x)/math.abs(Player.y-sabakuLogoR.y)))
	
	if playerResetPos == false then
		Player.MoveTo(0,-15)
		playerResetPos = true
	end
	if spawntimer % 60 == 0 then
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
		if bulletAge > currentBullet["age"] then
			if currentBullet["computeDirection"] == false then
				SetBulletDirection(currentBullet)
				currentBullet["computeDirection"] = true
			end
			currentBullet.Move(currentBullet["velx"], currentBullet["vely"])
		else
			currentBullet.x = currentBullet["positionX"] + Player.x / 5
		end
		
		if currentBullet.y < -Arena.height then
			currentBullet.Remove()
			table.remove(bullets, i)
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
