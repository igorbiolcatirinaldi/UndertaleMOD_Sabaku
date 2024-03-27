-- Simple SabakuLogo Sprite blocking the player in the arena and move/rotate

timer = 0
bulletSpeedX = 0.9
bulletSpeedY = 2
bullet = CreateProjectile("SabakuLogoWSym", 0, Arena.height / 2)
bullet.ppcollision = true
bullet.sprite.xscale = 1.5
bullet.sprite.yscale = 1.5
rotation = 0

function Update()
	
	if bullet.y > 0 then
		bullet.Move(0, -bulletSpeedY)	
	end
	

	-- move left-right
	if timer >= 60 and timer < 180 then
		bullet.Move(bulletSpeedX, 0)
	elseif timer >= 180 and timer < 300 then
		bullet.Move(-bulletSpeedX, 0)
	-- rotate 180
	elseif timer >= 300 and timer < 480 then
		rotation = rotation + 1
		bullet.sprite.rotation = rotation
	-- move left-right
	elseif timer >= 480 and timer < 600 then
		bullet.Move(-bulletSpeedX, 0)
	elseif timer >= 600 and timer < 720 then
		bullet.Move(bulletSpeedX, 0)
	end
	
	timer = timer + 1
end