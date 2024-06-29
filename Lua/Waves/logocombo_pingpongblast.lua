-- SabakuLogo Sprite spawn at right/left border and try hitting with 2 cubes like ping pong 
-- +
-- Spawn sabaku logo in the middle-up and shoot black/white ray to player

--- PING PONG
timer = 0
bulletL = CreateProjectile("Cube", -Arena.width-70,-20)
bulletL.sprite.alpha = 0
bulletL.sprite.rotation = 35
bulletR = CreateProjectile("Cube", Arena.width+70,20)
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
--- BLAST
spawntimer = 0
bullets = {}
playerResetPos = false
bulletLife = 30
sabakuLogo = CreateProjectile("SabakuLogoWSym", 0, Arena.height / 2 + 20)
sabakuLogo.sprite.xscale = 0.35
sabakuLogo.sprite.yscale = 0.35
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
		bullet["velx"] = math.random(4,6)
	else
		bullet["velx"] = -1 * math.random(4,6)
	end
	if bullet.y > 0 then 
		bullet["vely"] = math.random(-3,-2)
	else
		bullet["vely"] = math.random(2,3)
	end
	RandombulletOrientation(bullet)
end

function bulletBounce(bullet)
	bullet["vely"] = -bullet["vely"]
	RandombulletOrientation(bullet)
end

--- BLAST

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
	
	if bulletL.y > Arena.height/2 or bulletL.y < -Arena.height/2 then
		bulletBounce(bulletL)
	end
	if bulletR.y > Arena.height/2 or bulletR.y < -Arena.height/2 then
		bulletBounce(bulletR)
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
	
	
	timer = timer + 1
	
	--- BLAST
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



