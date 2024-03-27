-- SabakuLogo Sprite spawn at right/left border and try hitting with 2 cubes like ping pong

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
bulletL["velx"] = 6--math.random(4,6)
bulletL["vely"] = 3--math.random(1,3)
bulletR["velx"] = -1 * 6--math.random(4,6)
bulletR["vely"] = 3--math.random(1,3)

function RandombulletOrientation(bullet)
	bullet.sprite.rotation = math.random(10,80)
end
function UpdatebulletDirectionMovement(bullet,left)
	if left == true then
		bullet["velx"] = 6 --math.random(4,6)
	else
		bullet["velx"] = -1 * 6-- math.random(1,3)
	end
	bullet["vely"] = 3--math.random(1,3)
	RandombulletOrientation(bullet)
end

function bulletBounce(bullet)
	bullet["vely"] = -bullet["vely"]
	RandombulletOrientation(bullet)
end

function Update()
	
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
end



