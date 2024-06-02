-- LORE Sprite moving from up to down with 3 spawn (center,left,right), with increasing scale

spawntimer = 0
bullets = {}
timers = {}
positionsX = {0, -Arena.width / 2, Arena.width / 2}
bulletSpeedY = 2
index = 1
prevposition = 1
position = 3
minScale = 0.8
maxScale = 1.5
waveTimer = 0
first = true

function CreateBullet(x, y)
	local bullet = CreateProjectile("LORE", x, y)
	bullet.sprite.xscale = minScale
	bullet.sprite.yscale = minScale
	local timer = 0.0
	table.insert(bullets, bullet)
	table.insert(timers,timer)
end

function Update()
	waveTimer = Encounter.GetVar("wavetimer")
	if spawntimer % 60 == 0 then
		local xPos = positionsX[index]
		local yPos = Arena.height + 5
		CreateBullet(xPos, yPos)
		if index < 3 and first == true then
			index = index + 1
			prevposition = index
		else
			first = false
			while prevposition == position do
				position = math.random(1,#positionsX)
			end
			prevposition = position
			index = position
		end
	end
	
	for i = #bullets, 1, -1
	do
		currentBullet = bullets[i]
		
		currentTimer = timers[i]
		scaleValue = minScale + (maxScale-minScale) * (currentTimer/(waveTimer*60.0))
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