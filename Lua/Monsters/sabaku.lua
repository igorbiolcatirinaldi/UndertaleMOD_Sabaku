-- A basic monster script skeleton you can copy and modify for your own creations.
comments = {}
commands = {}
randomdialogue = {"SEMPER FI"}
Undyingtheme = "Undertale_But_Refused_to_Die"
sprite = "SabakuSprite" --Always PNG. Extension is added automatically.
spritePhase2 = "SabakuSprite2"
name = "Sabaku"
hp = 100
xp = 1000000
atk = 99
def = 99
check = "The strongest monster [w:30][func:State,ACTIONSELECT]"
dialogbubble = "right" -- See documentation for what bubbles you have available.
canspare = false
cancheck = true
currentdialogue = {"Welcome back","[func:State,ACTIONSELECT]"}
-- Intro
countParryBeforeStartBattle = 0
introPhase = true
defensemisstext = "PARRY"
parry = false
parrySprite = CreateSprite("parry0","Top")
commentparry = false
parrydialogue = {}
-- Battle
battleFirstPhase = false
battleSecondPhase = false
countAttacksFirstPhase = 0
countAttacksHitSecondPhase = 0
decreasingParryAccuracyValue = 0.1
playerAttackIndexDialogue = 1

-- DIALOG
dialogueAfterBeingHit = {{"..So you find an opening to hit AH?"},{"..Well well.."},{"There is no satisfaction to break down a weak"}}
dialoguePersuasion = {"Please do not make me doing this","I know it's hard...","...but you are still in time"}
dialogueRandomBattleAttacks = {}
-- dialog pre attacks:
dialogPreLOREattack1 = {"I must teach you something...", "...listen this LORE"}
dialogPreLOREattack2 = {"You like lore...", "...here a BIGGER VERSION"}
dialogPreLOREattack3 = {"LORE has differents aspects...", "...someone to wait and other to search"}
dialogPreCOINattack1 = {"My logo is a source of power"}
dialogPreCOINattack2 = {"Double logo means double power"}
dialogPreCOINattack3 = {"Different logos for a crazy power"}
dialogPreBLASTattack1 = {"Maybe I should use an attack...","...that already make you pain"}
dialogPreBLASTattack2 = {"Double blast...","...means double you pain"}
dialogPreBLASTattack3 = {"Blast festival!"}
dialogPrePINGPONGattack1 = {"Here my RETRO attack!"}
dialogPrePINGPONGattack2 = {"Double RETRO attack!"}
dialogPrePINGPONGattack3 = {"Caos RETRO attack!"}
dialogPreBOOMattack1 = {"The logo power is explosive!"}
dialogPreBOOMattack2 = {"Double logo for double fun!"}
dialogPreBOOMattack3 = {"Multiple color explosions!"}
dialogPreCOMBOattackBoomPong = {"Mix balls with explosion?", "Excellent idea!"}
dialogPreCOMBOattackBlastPong = {"How about blast and balls?", "Magnificent!"}
dialogPreCOMBOattackBlastBoomPong = {"FINAL COMBO!"}
-- dialog between attack phases
-- (phase 1) 1->2 
dialogChangePhase1AttackPhase12 = {"This was only the warm-up","Welcome to next level![noskip]","[func:State,ACTIONSELECT]"}
-- (phase 1) 2->3
dialogChangePhase1AttackPhase23 = {"..Not bad..","Ok, maybe I understimate you a bit","But now is time for the true power","[func:State,ACTIONSELECT]"}
-- (phase 2) 1->2 
dialogChangePhase2AttackPhase12 = {"Ok kiddo...","...you need my full attention!", "I need to \n [lettereffect:shake][color:fca600]FOCUS","[func:State,ACTIONSELECT]"}
-- (phase 2) 2->3 
dialogChangePhase2AttackPhase23 = {"How are you still alive?", "I will use my final form attacks!","[func:State,ACTIONSELECT]"}
-- (phase 1) 3->combo 
dialogChangePhase2AttackPhase3combo = {"How are you still here?", "I will use my final skill:","[lettereffect:shake] [color:ffA500]E  [color:ffff00]C [color:ff0000]C [color:ff00ff]L [color:A5A500]E [color:00ff00]T [color:0000A5]I [color:00ffff]S [color:0000ff]M [color:000000]!","[func:State,ACTIONSELECT]"}
-- end 
dialogDefeat = {"I..?","How..?","Even with...?","...","I see...", "..so is this your..", " [voice:uifont][lettereffect:shake][linespacing:-4] [w:10]D\n     [w:10]E\n  [w:10]T\n     [w:10]E\n  [w:10]R\n     [w:10]M\n  [w:10]I\n     [w:10]N\n  [w:10]A\n     [w:10]T\n  [w:10]I\n     [w:10]O\n  [w:10]N","[func:Death]"}

-- Happens after the slash animation and BeforeDamageCalculation 
function HandleAttack(attackstatus)
    if attackstatus == -1 then
        -- player pressed fight but didn't press Z afterwards
    else
        -- player did actually attack
    end
end
 
-- This handles the commands; all-caps versions of the commands list you have above.
function HandleCustomCommand(command)
end

function Parry(dialogue,box)
	Audio.PlaySound("DS2parry",0.8)
	SetDamage(0)
	if introPhase == true then
		currentdialogue = dialogue
	else
		parrydialogue = dialogue
	end
	dialogbubble = box
end

function ParryStartAnimation()
	parry = true
	parrySprite = CreateSprite("parry0","Top")
	parrySprite.y = 300
	parrySprite.SetAnimation({"parry0","parry1","parry2","parry3","parry4","parry5"},1/6)
end

function BeforeDamageCalculation()
	if introPhase == true then
		if countParryBeforeStartBattle == 0 then
			Parry({"Surprise?","Do you really think...","...I wasn't able to use my power?","Yes I can","Even HERE I can [instant][lettereffect:shake][color:ff0000]PARRY!"},"right")
			countParryBeforeStartBattle = countParryBeforeStartBattle + 1
		elseif countParryBeforeStartBattle == 1 then
			Parry({"Please...","You have to stop all of this!","All these murders out of curiosity","The frenzy to discover new CHALLENGE and CONTENTS[w:40][next]","...Just like me..."}, "rightwide")
			countParryBeforeStartBattle = countParryBeforeStartBattle + 1
		elseif countParryBeforeStartBattle == 2 then
			Parry({"How far would you go?", "Will you ever stop?", "You really think that all this is worthed?","Please..","..Even you..","should have a [lettereffect:shake][color:ff0000]HEART [lettereffect:none][color:000000]under that [lettereffect:shake]SOUL"},"rightwide")
			countParryBeforeStartBattle = countParryBeforeStartBattle + 1
		elseif countParryBeforeStartBattle == 3 then
			Parry({"Well...","As excepected..","..talk with you is meaningless","You'll change idea with THIS FIGHT"},"rightwide")
			introPhase = false
			Encounter.SetVar("wavetimer",10.0)
			battleFirstPhase = true
		end
		
		ParryStartAnimation()
	elseif battleFirstPhase == true then
		--DEBUG("last hit mult: " .. Player.lasthitmultiplier)
		Encounter.SetVar("indexAttack",Encounter["indexAttack"] + 1)
		if Player.lasthitmultiplier == -1 then
			-- miss
			defensemisstext = "MISS"
			parrydialogue = {"PATHETIC"}
		elseif Player.lasthitmultiplier < 2.2 - decreasingParryAccuracyValue * countAttacksFirstPhase then
			-- parry
			Parry({"NOT ENOUGH"},"right")
			ParryStartAnimation()
			commentparry = true
		else
			-- attack hit
			if(playerAttackIndexDialogue <= 3) then
				parrydialogue = dialogueAfterBeingHit[playerAttackIndexDialogue]
				dialogbubble = "rightwide"
				playerAttackIndexDialogue = playerAttackIndexDialogue + 1
				commentparry = true
			end
		end
		if(countAttacksFirstPhase < 22) then
			countAttacksFirstPhase = countAttacksFirstPhase + 1
		end
	elseif battleSecondPhase == true then
		--DEBUG("last hit mult: " .. Player.lasthitmultiplier)
		Encounter.SetVar("indexAttack",Encounter["indexAttack"] + 1)
		if Player.lasthitmultiplier == -1 then
			-- miss
			defensemisstext = "ROLL"
			parrydialogue = {"SEMPER FI"}
			if(countAttacksHitSecondPhase > 0) then
				countAttacksHitSecondPhase = countAttacksHitSecondPhase - 1
			end
		elseif Player.lasthitmultiplier < 2.2 - decreasingParryAccuracyValue * countAttacksHitSecondPhase then
			-- parry
			Parry({"I'M A PARRY MASTER"},"right")
			ParryStartAnimation()
			commentparry = true
		else
			-- attack hit
			if(countAttacksHitSecondPhase < 22) then
				countAttacksHitSecondPhase = countAttacksHitSecondPhase + 1
			end
		end
	else
		parry = false
	end
end

function HandleAttack(damage)
	if(parry) then
		parrySprite.StopAnimation()
		parrySprite.Remove()
	end
end

function HopeMusic()
	Audio.LoadFile(Undyingtheme)
	Audio.Volume(0.5)
end

function ChangeSabakuSprite()
	SetSprite(spritePhase2)
end

function FightRestart()
	Audio.Stop()
	Audio.PlaySound("mus_sfx_spellcast",0.8)
	ChangeSabakuSprite()
	hp = 100
	Audio.LoadFile(Encounter["music"])
	Audio.Volume(0.8)
end

function OnDeath()
	if battleFirstPhase == true then
		Audio.Stop()
		battleFirstPhase = false
		battleSecondPhase = true
		Encounter.SetVar("indexAttack",0)
		Encounter.SetVar("attacksPhase",1)
		Encounter.SetVar("stepphase1",false)
		Encounter.SetVar("stepphase2",false)
		Encounter.SetVar("changestepdialogue",true)
		currentdialogue = {"....","You!!","You are stronger than me?!", "I should aspected that", "But..","..I didn't imagine this end..","[noskip]...[w:45][next]","..no..","NO![func:HopeMusic]","There is one last thing!","One last [lettereffect:shake]HOPE!","I will use the power of the 6 human souls", "Asgore forgive me but it's necessary","...","[func:FightRestart]","Here my ULTIMATE form","[func:State,ACTIONSELECT]"}
		dialogbubble = "rightlong"
		check = "THE ULTIMATE..\n..MONSTER?[w:30][func:State,ACTIONSELECT]"
		State("ENEMYDIALOGUE")
	elseif battleSecondPhase == true then
		-- REAL DEATH
		Audio.Stop()
		currentdialogue = dialogDefeat
		dialogbubble = "rightlong"
		Encounter.SetVar("changestepdialogue",true)
		State("ENEMYDIALOGUE")
	end
end

function Death()
	Kill()
end


