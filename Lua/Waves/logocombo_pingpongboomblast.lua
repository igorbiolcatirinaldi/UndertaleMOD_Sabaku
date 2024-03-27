-- SabakuLogo Sprite spawn at right/left border and try hitting with 2 cubes like ping pong 
-- +
-- Spawn sabaku logo in the middle-up and shoot a yellow coin sprite to player that explode
-- +
-- Spawn sabaku logo in the middle-up and shoot black/white ray to player

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
--- BOOM & BLAST
spawntimer = 0
playerResetPos = false
-- BOOM
bulletsBoom = {}
explosionBullets = {}
directions = {}
bulletSpeed = 2
bulletStartAttackAge = 30
bulletExplodingAge = 90
explosionBulletLife = 30
yellow = {1,1,0}
sabakuLogoBoom = CreateProjectile("SabakuLogoWSym",  -Arena.width, Arena.height / 2 + 20)
sabakuLogoBoom.sprite.color = yellow
sabakuLogoBoom.sprite.xscale = 0.35
sabakuLogoBoom.sprite.yscale = 0.35
-- BLAST
bulletsBlast = {}
bulletLife = 30
sabakuLogoBlast = CreateProjectile("SabakuLogoWSym", Arena.width, Arena.height / 2 + 10)
sabakuLogoBlast.sprite.xscale = 0.35
sabakuLogoBlast.sprite.yscale = 0.35
FireSound = "gasterfire"
FireIntro = "gasterintro"
frameToSpawn = 20
timerSpawnHelper = 0
updateAngle = true
setupspawn = false

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

--- BOOM & BLAST

function SetBulletDirection(bullet)
	differenceX = Player.x - bullet.x
	differenceY = Player.y - bullet.y
	lengthSquared = math.pow(differenceX, 2) + math.pow(differenceY, 2)
	length = math.sqrt(lengthSquared)
	bullet["velx"] = differenceX / length * bulletSpeed
	bullet["vely"] = differenceY / length * bulletSpeed
end

--- BOOM

function CreateBulletBoom(x, y)
	local bullet = CreateProjectile("CoinBW", x, y)
	bullet["frame_spawned"] = spawntimer
	bullet["computeDirection"] = false
	bullet.sprite.color = yellow
	table.insert(bulletsBoom, bullet)
end

function CreateExplosionBullet(x, y)
	local bullet = CreateProjectile("Circle-Exp", x, y)
	bullet["frame_spawned"] = spawntimer
	bullet.sprite.xscale = 0.05
	bullet.sprite.yscale = 0.05
	table.insert(explosionBullets, bullet)
end

--- BLAST

function CreateBulletBlast(x, y, angle)
	local bullet = CreateProjectileAbs("Beam", 0, 0)
	bullet["frame_spawned"] = spawntimer
	bullet["alternate"] = 3
	bullet.sprite.rotation = angle + 90
	bullet.ppcollision = true
	bullet.sprite.SetPivot(1,0.5)
	bullet.MoveTo(x,y)
	table.insert(bulletsBlast, bullet)
	Misc.ShakeScreen(30,3)
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
	sabakuLogoBoom.sprite.rotation = math.deg(math.atan(math.abs(Player.x-sabakuLogoBoom.x)/math.abs(Player.y-sabakuLogoBoom.y)))

	if playerResetPos == false then
		Player.MoveTo(0,-15)
		playerResetPos = true
	end
	if spawntimer % 120 == 0 then
		local xPos = -Arena.width + 20 + Player.x / 8
		local yPos = Arena.height - 20
		CreateBulletBoom(xPos, yPos)
	end
	
	for i = #bulletsBoom, 1, -1
	do
		currentBullet = bulletsBoom[i]
		bulletAge = spawntimer - currentBullet["frame_spawned"]
		if bulletAge < bulletStartAttackAge then
			currentBullet.x = -Arena.width + 20 + Player.x / 8
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
			table.remove(bulletsBoom, i)
		end		
		
		if currentBullet.y < -Arena.height then
			currentBullet.Remove()
			table.remove(bulletsBoom, i)
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
	
	--- BLAST
	if updateAngle == true then
		angle =  360 - math.deg(math.atan(math.abs(Player.x-sabakuLogoBlast.x)/math.abs(Player.y-sabakuLogoBlast.y)))
		sabakuLogoBlast.sprite.rotation = angle
	end

	if spawntimer > 0 then
		if spawntimer % 90 == 0 then
			updateAngle = false
			Audio.PlaySound(FireIntro)
			timerSpawnHelper = spawntimer
			setupspawn = true
		elseif setupspawn == true and spawntimer > timerSpawnHelper + frameToSpawn	then
			local xPos = Arena.width
			local yPos = Arena.height - 5
			CreateBulletBlast(xPos, yPos, angle)
			Audio.PlaySound(FireSound)
			setupspawn = false
		end
	end
	
	for i = #bulletsBlast, 1, -1
	do
		currentBullet = bulletsBlast[i]
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
			table.remove(bulletsBlast, i)
		end
	end

	
	spawntimer = spawntimer + 1
	
end



