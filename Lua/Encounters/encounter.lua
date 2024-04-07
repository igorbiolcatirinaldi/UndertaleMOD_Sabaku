-- A basic encounter script skeleton you can copy and modify for your own creations.
-- Damage formula: round((Weapon ATK + ATK - Monster DEF + r) * b)
music = "Im_your_last_hope" --Either OGG or WAV. Extension is added automatically. Uncomment for custom music.
encountertext = "Sabaku STOPS YOU!" --Modify as necessary. It will only be read out in the action select screen.
nextwaves = {"logoarena"} -- first attack
wavetimer = 0.0 --12 for ping pong
arenasize = {155, 130}
indexAttack = 0
attacksPhase = 1
attackCombo = false

autolinebreak = true

enemies = {
"sabaku"
}

enemypositions = {
{0, 0}
}

-- A custom list with attacks to choose from. Actual selection happens in EnemyDialogueEnding(). Put here in case you want to use it.
attacks_phase1 = {"lore","logocoin","logopingpong"}
attacks_phase2 = {"logocoinboom","logoblast"}
attacks_combo = {"logocombo_pingpongboom","logocombo_pingpongblast","logocombo_pingpongboomblast"}

function EncounterStarting()
    -- If you want to change the game state immediately, this is the place.
	Player.lv = 20
	Player.hp = 99
	Player.atk = 101
	Player.def = 99
	Player.name = "Rogy"
	--DEBUG("weapon" .. Player.weapon)
	--DEBUG("weapon atk" .. Player.weaponatk)
	enemies[1].GetVar("parrySprite").Remove()
	enemies[1].Call("BindToArena",false)
	-- Add items
	Inventory.AddCustomItems({"Cinnamon Pie","Hush Puppy","Snowman Piece","Hot Dog"},{0,0,0,0})
	Inventory.SetInventory({"Cinnamon Pie","Hush Puppy","Snowman Piece","Hot Dog"})
end

function EnemyDialogueStarting()
    -- Good location for setting monster dialogue depending on how the battle is going

	if enemies[1].GetVar("battleFirstPhase") == true then
		if indexAttack == 1 then
			enemies[1].SetVar("currentdialogue", enemies[1].GetVar("dialogPreLOREattack"))
		elseif indexAttack == 2 then
			enemies[1].SetVar("currentdialogue", enemies[1].GetVar("dialogPreCOINattack"))
		elseif indexAttack == 3 then
			enemies[1].SetVar("currentdialogue", enemies[1].GetVar("dialogPrePINGPONGattack"))
		else
			enemies[1].SetVar("currentdialogue", enemies[1].GetVar("")) -- random?
		end
	elseif enemies[1].GetVar("battleSecondPhase") == true then
		if attackCombo == false then
			if indexAttack == 1 then
				enemies[1].SetVar("currentdialogue", enemies[1].GetVar("dialogPreBOOMattack"))
			elseif indexAttack == 2 then
				enemies[1].SetVar("currentdialogue", enemies[1].GetVar("dialogPreBLASTattack"))
			else
				enemies[1].SetVar("currentdialogue", enemies[1].GetVar(""))  -- random?
			end
		else
			if indexAttack >= 1 and indexAttack <= #attackCombo then
				enemies[1].SetVar("currentdialogue", enemies[1].GetVar("dialogPreFirstCOMBOattack"))
			else
				enemies[1].SetVar("currentdialogue", enemies[1].GetVar(""))  -- random?
			end
		end
	end
end

function EnemyDialogueEnding()
    -- Good location to fill the 'nextwaves' table with the attacks you want to have simultaneously.

	if enemies[1].GetVar("battleFirstPhase") == true then
		if indexAttack > 0 and indexAttack <= #attacks_phase1 then
			nextwaves = {attacks_phase1[indexAttack] .. attacksPhase}
		elseif indexAttack > #attacks_phase1 then
			nextwaves = {attacks_phase1[math.random(attacks_phase1)] .. attacksPhase}
		end
	elseif enemies[1].GetVar("battleSecondPhase") == true then
		if attackCombo == false then
			if indexAttack > 0 and indexAttack <= #attacks_phase2 then
				nextwaves = {attacks_phase2[indexAttack] .. attacksPhase}
			elseif indexAttack > #attacks_phase2 then
				nextwaves = {attacks_phase2[math.random(attacks_phase2)] .. attacksPhase}
			end
		else
			if indexAttack > 0 and indexAttack <= #attacks_combo then
				nextwaves = {attacks_combo[indexAttack]}
			elseif indexAttack > #attacks_combo then
				nextwaves = {attacks_combo[math.random(attacks_combo)]}
			end
		end
	end

	
	if nextwaves[1] == "logocombo_pingpongboomblast" || nextwaves[1] == "logocoin" .. attacksPhase
		|| nextwaves[1] == "logocoinboom" .. attacksPhase || nextwaves[1] == "logoblast" .. attacksPhase then
		arenasize = {120,80}
		wavetimer = 8.0
		--Misc.ResizeWindow(Misc.WindowWidth * 1.5,Misc.WindowHeight * 1.5)
	elseif nextwaves[1] == "logopingpong" .. attacksPhase then
		arenasize = {120,80}
		wavetimer = 12.0
	end
end


function DefenseEnding() --This built-in function fires after the defense round ends.
	if enemies[1].GetVar("battleFirstPhase") == true then
		if enemies[1].GetVar("hp") <= 70 then
			enemies[1].SetVar("currentdialogue", enemies[1].GetVar("dialogChangePhase1AttackPhase12"))
			attacksPhase = 2
			State("ENEMYDIALOGUE")
		elseif enemies[1].GetVar("hp") <= 40 then
			enemies[1].SetVar("currentdialogue", enemies[1].GetVar("dialogChangePhase1AttackPhase23"))
			attacksPhase = 3
			State("ENEMYDIALOGUE")
		end
	elseif enemies[1].GetVar("battleSecondPhase") == true then
		if enemies[1].GetVar("hp") <= 75 then
			enemies[1].SetVar("currentdialogue", enemies[1].GetVar("dialogChangePhase2AttackPhase12"))
			attacksPhase = 2
			State("ENEMYDIALOGUE")
		elseif enemies[1].GetVar("hp") <= 50 then
			enemies[1].SetVar("currentdialogue", enemies[1].GetVar("dialogChangePhase2AttackPhase23"))
			attacksPhase = 3
			State("ENEMYDIALOGUE")
		elseif enemies[1].GetVar("hp") <= 25 then
			enemies[1].SetVar("currentdialogue", enemies[1].GetVar("dialogChangePhase2AttackPhase3combo"))
			attackCombo = true
			State("ENEMYDIALOGUE")
		end
	end
end

function HandleSpare()
    State("ENEMYDIALOGUE")
end

function HandleItem(ItemID)
    BattleDialog({"Selected item " .. ItemID .. "."})
	if ItemID == "CINNAMON PIE" then
		Player.Heal(100)
	elseif ItemID == "HUSH PUPPY" then
		Player.Heal(65)
	elseif ItemID == "SNOWMAN PIECE" then
		Player.Heal(45)
	elseif ItemID == "HOT DOG" then
		Player.Heal(20)
	end
end