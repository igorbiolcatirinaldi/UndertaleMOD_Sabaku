-- SabakuLogo Sprite spawn at right/left border and try hitting with 4 colored cubes like ping pong

timer = 0
colorsType = {"regular","cyan","orange"}
colors = {{255/255, 255/255, 255/255},{0/255, 162/255, 232/255},{255/255, 154/255, 34/255}}
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
bullets = {}
damage = 6

function RandombulletOrientation(bullet)
	bullet.sprite.rotation = math.random(10,80)
	Audio.PlaySound("bounce",0.8)
end
function UpdatebulletDirectionMovement(bullet,left)
	if(bullet["prevVelx"] == bullet["velx"]) then --TODO: CHECK BUG
		DEBUG("velx uguale")
	end
	bullet["prevVelx"] = bullet["velx"]
	bullet["prevVely"] = bullet["velxy"]
	if left == true then
		bullet["velx"] = 5--math.random(5,6)
	else
		bullet["velx"] = -1 * 5--math.random(5,6)
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

function CreateBullet(x, y, rotation, velx, vely, color, ctype)
	local bullet = CreateProjectile("Cube", x, y)
	bullet.sprite.rotation = rotation
	bullet["color"] = ctype
	bullet.sprite.color = color
	bullet["velx"] = velx
	bullet["vely"] = vely
	table.insert(bullets, bullet)
end

function Update()
	
	if timer > 45 and bulletSpawn == false then
		CreateBullet(-Arena.width-80,-30,35,math.random(4,6),2,{255/255, 255/255, 255/255},"regular")
		CreateBullet(Arena.width+80,30,15,-math.random(4,6),2,{255/255, 255/255, 255/255},"regular")
		CreateBullet(Arena.width+80,-30,5,-math.random(4,6),3,{255/255, 154/255, 34/255},"orange")
		CreateBullet(-Arena.width-80,30,25,math.random(4,6),3,{0/255, 162/255, 232/255},"cyan")
		bulletSpawn = true
	end	
	
	for i = #bullets, 1, -1
	do
		currentBullet = bullets[i]
		if (i % 2) == 0 then
			if timer > 90 then
				currentBullet.Move(currentBullet["velx"],currentBullet["vely"])
			end
		else
			if timer > 120 then
				currentBullet.Move(currentBullet["velx"],currentBullet["vely"])
			end
		end
		
		-- vertical check for bounce
		if currentBullet.y > Arena.height/2 or currentBullet.y < -Arena.height/2 then
			bulletBounce(currentBullet)
		end
		
		-- lateral check for bounce
		if currentBullet.x > LogoR.x - 10 then
			UpdatebulletDirectionMovement(currentBullet,false)
		elseif currentBullet.x < LogoL.x + 10 then
			UpdatebulletDirectionMovement(currentBullet,true)
		end
		
	end
	end
	
	timer = timer + 1
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

