-- Simple LORE Sprite moving from up to down with 3 spawn (center,left,right)

spawntimer = 0
bullets = {}
positionsX = {0, -Arena.width / 2, Arena.width / 2}
bulletSpeedY = 2
indeX = 1

function CreateBullet(x, y)
	local bullet = CreateProjectile("LORE", x, y)
	table.insert(bullets, bullet)
end

function Update()
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
		
		currentBullet.Move(0, -bulletSpeedY)
		
		if currentBullet.y < -Arena.height then
			currentBullet.Remove()
			table.remove(bullets, i)
		end
	end
	
	spawntimer = spawntimer + 1
end