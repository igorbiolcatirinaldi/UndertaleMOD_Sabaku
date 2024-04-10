-- SabakuLogo Sprite spawn at right/left border and try hitting with a cube like ping pong

timer = 0
bullet = CreateProjectile("Cube", -Arena.width-75,0)
bullet.sprite.alpha = 0
bullet.sprite.rotation = 35
bulletSpeedX = 4
bulletSpeedY = 4
bulletL = CreateProjectile("pxSabakuLogoWSym2", -Arena.width-100,0)
bulletR = CreateProjectile("pxSabakuLogoWSym2", Arena.width+100,0)
bulletL.ppcollision = true
bulletL.sprite.xscale = 1.5
bulletL.sprite.yscale = 1.5
bulletR.ppcollision = true
bulletR.sprite.xscale = 1.5
bulletR.sprite.yscale = 1.5
bulletR.sprite.rotation = 180
bulletSpawn = false
differenceX = Player.x - bullet.x
differenceY = Player.y - bullet.y
lengthSquared = math.pow(differenceX, 2) + math.pow(differenceY, 2)
length = math.sqrt(lengthSquared)
velocityX = differenceX / length * bulletSpeedX
velocityY = differenceY / length * bulletSpeedY
startingDirection = false

function RandomBulletOrientation()
	bullet.sprite.rotation = math.random(10,80)
end

function UpdateBulletDirectionMovement()
	differenceX = Player.x - bullet.x
	differenceY = Player.y - bullet.y
	lengthSquared = math.pow(differenceX, 2) + math.pow(differenceY, 2)
	length = math.sqrt(lengthSquared)
	velocityX = differenceX / length * bulletSpeedX
	velocityY = differenceY / length * bulletSpeedY
	RandomBulletOrientation()
end

function BulletBounce()
	velocityY = -velocityY
	RandomBulletOrientation()
end

function Update()
	
	if timer > 60 and bulletSpawn == false then
		bullet.sprite.alpha = 1
		bulletSpawn = true
	end
	
	if timer > 90 then
		if startingDirection == false then
			UpdateBulletDirectionMovement()
			startingDirection = true
		end
		bullet.Move(velocityX,velocityY)
	end
	
	if bullet.x > bulletR.x - 10 or bullet.x < bulletL.x + 10 then
		UpdateBulletDirectionMovement()
	end
	
	if bullet.y > Arena.height/2 or bullet.y < -Arena.height/2 then
		BulletBounce()
	end
	
	timer = timer + 1
end



