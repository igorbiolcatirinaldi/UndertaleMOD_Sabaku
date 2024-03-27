-- Spawn sabaku logo in the middle-up and shoot black/white ray to player
-- meanwhile 2 sabaku logo position left and rigth of the arena to shoot ray

spawntimer = 0
bullets = {}
playerResetPos = false
bulletLife = 30
sabakuLogo = CreateProjectile("SabakuLogoWSym", 0, Arena.height / 2 + 10)
sabakuLogo.sprite.xscale = 0.35
sabakuLogo.sprite.yscale = 0.35
FireSound = "gasterfire"
FireIntro = "gasterintro"
frameToSpawn = 30
timerSpawnHelper = 0
updateAngle = true
setupspawn = false
HeightUp = 25
HeightMiddle = 0
HeightDown = -25
HeightPositions = {HeightUp,HeightMiddle,HeightDown}
RandomHeightPositions = {HeightUp,HeightMiddle,HeightDown}
sabakuLogoL = CreateProjectile("SabakuLogoWSym", -Arena.width - 20, -25)
sabakuLogoL.sprite.xscale = 0.35
sabakuLogoL.sprite.yscale = 0.35
sabakuLogoL.sprite.rotation = 90
sabakuLogoR = CreateProjectile("SabakuLogoWSym", Arena.width + 20, -25)
sabakuLogoR.sprite.xscale = 0.35
sabakuLogoR.sprite.yscale = 0.35
sabakuLogoR.sprite.rotation = -90

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

function table.shallow_copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

function Update()
	if updateAngle == true then
		angle =  math.deg(math.asin(Player.x/math.abs(Player.y-sabakuLogo.y)))
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
			RandomHeightPositions = table.shallow_copy(HeightPositions)
			idx = math.random(1,#RandomHeightPositions)
			sabakuLogoL.MoveTo(-Arena.width - 20,RandomHeightPositions[idx])
			table.remove(RandomHeightPositions,idx)
			sabakuLogoR.MoveTo(Arena.width + 20,RandomHeightPositions[math.random(1,#RandomHeightPositions)])
		elseif setupspawn == true and spawntimer > timerSpawnHelper + frameToSpawn	then
			local xPos = 0
			local yPos = Arena.height
			CreateBullet(xPos, yPos, angle)
			CreateBullet(sabakuLogoL.x, sabakuLogoL.y, 90)
			CreateBullet(sabakuLogoR.x, sabakuLogoR.y, -90)
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