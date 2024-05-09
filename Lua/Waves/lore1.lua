-- Simple LORE Sprite moving from up to down with 3 spawn (center,left,right)

spawntimer = 0
bullets = {}
positionsX = {0, -Arena.width / 2, Arena.width / 2}
bulletSpeedY = 2
index = 1
prevposition = 1
position = 3

function CreateBullet(x, y)
	local bullet = CreateProjectile("LORE", x, y)
	table.insert(bullets, bullet)
end

function Update()
	if spawntimer % 60 == 0 then
		local xPos = positionsX[index]
		local yPos = Arena.height + 5
		CreateBullet(xPos, yPos)
		if index < 3 true then
			index = index + 1
			prevposition = index
		else
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
		
		currentBullet.Move(0, -bulletSpeedY)
		
		if currentBullet.y < -Arena.height then
			currentBullet.Remove()
			table.remove(bullets, i)
		end
	end
	
	spawntimer = spawntimer + 1
end