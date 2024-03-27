-- SabakuLogo Sprite spawn at right/left border and try hitting with 2 cubes like ping pong 
-- +
-- Spawn sabaku logo in the middle-up and shoot a yellow coin sprite to player that explode

--- PING PONG
timer = 0
bulletL = CreateProjectile("Cube", -Arena.width-80,-30)
bulletL.sprite.alpha = 0
bulletL.sprite.rotation = 35
bulletR = CreateProjectile("Cube", Arena.width+80,30)
bulletR.sprite.alpha = 0
bulletR.sprite.rotation = 15
LogoL = CreateProjectile("pxSabakuLogoWSym2", -Arena.width-100,0)
LogoR = CreateProjectile("pxSabakuLogoWSym2", Arena.width+100,0)
LogoL.ppcollision = true
LogoL.sprite.xscale = 1.5
LogoL.sprite.yscale = 1.5
LogoR.ppcollision = true
LogoR.sprite.xscale = 1.5
LogoR.sprite.yscale = 1.5
LogoR.sprite.rotation = 180
bulletSpawn = false
bulletL["velx"] = 4--math.random(4,6)
bulletL["vely"] = 2--math.random(1,3)
bulletR["velx"] = -1 * 4--math.random(4,6)
bulletR["vely"] = 2--math.random(1,3)
--- BOOM
spawntimer = 0
bullets = {}
explosionBullets = {}
directions = {}
bulletSpeed = 2
bulletStartAttackAge = 30
bulletExplodingAge = 90
explosionBulletLife = 30
playerResetPos = false
yellow = {1,1,0}
sabakuLogo = CreateProjectile("SabakuLogoWSym", 0, Arena.height / 2 + 20)
sabakuLogo.sprite.color = yellow
sabakuLogo.sprite.xscale = 0.35
sabakuLogo.sprite.yscale = 0.35


----- FUNCTIONS

--- PING PONG
function RandombulletOrientation(bullet)
	bullet.sprite.rotation = math.random(10,80)
end

function UpdatebulletDirectionMovement(bullet,left)
	if left == true then
		bullet["velx"] = 4 --math.random(4,6)
	else
		bullet["velx"] = -1 * 4-- math.random(1,3)
	end
	bullet["vely"] = 2--math.random(1,3)
	RandombulletOrientation(bullet)
end

function bulletBounce(bullet)
	bullet["vely"] = -bullet["vely"]
	RandombulletOrientation(bullet)
end

--- BOOM

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
	local bullet = CreateProjectile("Circle-Exp", x, y)
	bullet["frame_spawned"] = spawntimer
	bullet.sprite.xscale = 0.05
	bullet.sprite.yscale = 0.05
	table.insert(explosionBullets, bullet)
end

---


-- UPDATE

function Update()
	
	--- PING PONG
	if timer > 60 and bulletSpawn == false then
		bulletL.sprite.alpha = 1
		bulletR.sprite.alpha = 1
		bulletSpawn = true
	end
	
	if timer > 90 then
		bulletL.Move(bulletL["velx"], bulletL["vely"])
		bulletR.Move(bulletR["velx"], bulletR["vely"])
	end
	
	if bulletL.x > LogoR.x - 10 then
		UpdatebulletDirectionMovement(bulletL,false)
	elseif bulletL.x < LogoL.x + 10 then
		UpdatebulletDirectionMovement(bulletL,true)
	end
	
	if bulletR.x > LogoR.x - 10 then
		UpdatebulletDirectionMovement(bulletR,false)
	elseif bulletR.x < LogoL.x + 10 then
		UpdatebulletDirectionMovement(bulletR,true)
	end
	
	if bulletL.y > Arena.height/2 or bulletL.y < -Arena.height/2 then
		bulletBounce(bulletL)
	end
	if bulletR.y > Arena.height/2 or bulletR.y < -Arena.height/2 then
		bulletBounce(bulletR)
	end
	
	timer = timer + 1
	
	--- BOOM
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



