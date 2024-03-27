-- LORE Sprite moving from up to down with 3 spawn (center,left,right), with increasing scale and different color type

spawntimer = 0
bullets = {}
timers = {}
positionsX = {0, -Arena.width / 2, Arena.width / 2}
bulletSpeedY = 2
indeX = 1
minScale = 1
maxScale = 2
waveTimer = 0
colorsType = {"cyan","orange"}
colors = {{0/255, 162/255, 232/255},{255/255, 154/255, 34/255}}
damage = 5

function CreateBullet(x, y)
	local bullet = CreateProjectile("LORE", x, y)
	bullet.sprite.xscale = minScale
	bullet.sprite.yscale = minScale
	index = math.random(1,2)
	bullet.sprite.color = colors[index]
	bullet.SetVar('color', colorsType[index])
	local timer = 0.0
	table.insert(bullets, bullet)
	table.insert(timers,timer)
end

function Update()
	waveTimer = Encounter.GetVar("wavetimer")
	if spawntimer % 60 == 0 then
		local xPos = positionsX[indeX]
		local yPos = Arena.height + 5
		CreateBullet(xPos, yPos)
		if indeX < 3 then
			indeX = indeX + 1
		else
			indeX = math.random(1,#positionsX)
		end
	end
	
	for i = #bullets, 1, -1
	do
		currentBullet = bullets[i]
		
		currentTimer = timers[i]
		scaleValue = minScale + (maxScale-minScale) * (currentTimer/(waveTimer/2*60.0))
		currentBullet.sprite.xscale = scaleValue
		currentBullet.sprite.yscale = scaleValue
		
		currentBullet.Move(0, -bulletSpeedY)
		
		timers[i] = timers[i] + 1
		if currentBullet.y < -Arena.height/2 then
			currentBullet.Remove()
			table.remove(bullets, i)
		end
	end
	
	spawntimer = spawntimer + 1
end

function OnHit(bullet)
	local color = bullet.GetVar("color")
    if color == "cyan" and Player.isMoving then
        Player.Hurt(damage)
    elseif color == "orange" and not Player.isMoving then
        Player.Hurt(damage)
    end
end