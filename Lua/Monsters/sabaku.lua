-- A basic monster script skeleton you can copy and modify for your own creations.
comments = {}
commands = {}
randomdialogue = {"Please do not make me doing this"}
Undyingtheme = "Undertale_But_Refused_to_Die"
sprite = "SabakuSprite" --Always PNG. Extension is added automatically.
spritePhase2 = "SabakuSprite2"
name = "Sabaku"
hp = 1--00
atk = 99
def = 99
check = "The strongest monster"
dialogbubble = "right" -- See documentation for what bubbles you have available.
canspare = false
cancheck = true
currentdialogue = {"Welcome back"}
-- Intro
countParryBeforeStartBattle = 0
introPhase = true
defensemisstext = "PARRY"
parry = false
parrySprite = CreateSprite("parry0","Top")
-- Battle
battleFirstPhase = false
battleSecondPhase = false
countAttacksFirstPhase = 0
countAttacksHitSecondPhase = 0
decreasingParryAccuracyValue = 0.1
playerAttackIndexDialogue = 1

-- DIALOG
dialogueAfterBeingHit = {"..So you find an opening to hit AH?","..Well well..","There is no satisfaction to break down a weak"}
dialoguePersuasion = {"Please do not make me doing this","I know it's hard...","...but you are still in time"}
dialogueRandomBattleAttacks = {}
-- dialog pre attacks:
dialogPreLOREattack = {"I must teach you something...", "...listen this LORE"}
dialogPreCOINattack = {"My logo is my strenght"}
dialogPreBLASTattack = {"Maybe I should use an attack that already make you pain"}
dialogPrePINGPONGattack = {"The old knowledge is my strenght"}
dialogPreBOOMattack = {"This is the new version"}
dialogPreFirstCOMBOattack = {"Wanna try a new combo attack?"}
-- dialog between attack phases
-- (phase 1) 1->2 
dialogChangePhase1AttackPhase12 = {"This was only the warming-up","Welcome to next level![noskip]","[func:State,ACTIONSELECT]"}
-- (phase 1) 2->3
dialogChangePhase1AttackPhase23 = {"..Not bad..","Ok, maybe a bit understimation","Time to the true power","[func:State,ACTIONSELECT]"}
-- (phase 2) 1->2 
dialogChangePhase2AttackPhase12 = {"Ok boy, you need my full attention", "I need to FOCUS"}
-- (phase 2) 2->3 
dialogChangePhase2AttackPhase23 = {"How are you still alive?", "I will use my final form attacks!"}
-- (phase 1) 3->combo 
dialogChangePhase2AttackPhase3combo = {"How are you still here?", "I will use my final skill:","ECCLETISM!"}
-- end 
dialogDefeat = {"I..?","How..?","Even with...?","...","I see...", "..so is this..", "your DETERMINATION"}

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
	currentdialogue = dialogue
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
			Parry({"Please...","You have to stop all of this!","All these murders out of curiosity","The frenzy to discover new CHALLENGE and CONTENTS","Just like me..."}, "rightwide")
			countParryBeforeStartBattle = countParryBeforeStartBattle + 1
		elseif countParryBeforeStartBattle == 2 then
			Parry({"How far would you go?", "Will you ever stop?", "You really think that all this is worthed?","Please..","..Even you..","should have a HEART under that SOUL"},"rightwide")
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
			currentdialogue = {"PATHETIC"}
		elseif Player.lasthitmultiplier < 2.2 - decreasingParryAccuracyValue * countAttacksFirstPhase then
			-- parry
			Parry({"NOT ENOUGH"},"right")
			ParryStartAnimation()
		else
			-- attack hit
			if(playerAttackIndexDialogue <= 3) then
				currentdialogue = dialogueAfterBeingHit[playerAttackIndexDialogue]
				dialogbubble = "rightwide"
				playerAttackIndexDialogue = playerAttackIndexDialogue + 1
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
			currentdialogue = {"SEMPER FIGHT"}
			if(countAttacksHitSecondPhase > 0) then
				countAttacksHitSecondPhase = countAttacksHitSecondPhase - 1
			end
		elseif Player.lasthitmultiplier < 2.2 - decreasingParryAccuracyValue * countAttacksHitSecondPhase then
			-- parry
			Parry({"I'M A PARRY MASTER"},"right")
			ParryStartAnimation()
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
end

function ChangeSabakuSprite()
	SetSprite(spritePhase2)
end

function FightRestart()
	Audio.Stop()
	Audio.PlaySound("mus_sfx_spellcast",0.8)
	ChangeSabakuSprite()
	Audio.LoadFile(Encounter["music"])
end

function OnDeath()
	if battleFirstPhase == true then
		Audio.Stop()
		battleFirstPhase = false
		battleSecondPhase = true
		Encounter.SetVar("indexAttack",1)
		Encounter.SetVar("attackPhase",1)
		currentdialogue = {"....","You!!","You are stronger than me?!", "I should aspected that", "But..","..I didn't imagine this end..","[noskip]...[w:45][next]","..no..","NO![func:HopeMusic]","There is one last thing!","One last HOPE!","I will use the power of the 6 human souls", "Asgore forgive me but it's necessary","...","[func:FightRestart]","Here my ULTIMATE form","[func:State,ACTIONSELECT]"}
		dialogbubble = "rightwide"
		State("ENEMYDIALOGUE")
		check = "THE ULTIMATE..\n..MONSTER?"
		hp = 100
	elseif battleSecondPhase == true then
		-- REAL DEATH
		Audio.Stop()
		currentdialogue = dialogDefeat
		dialogbubble = "rightwide"
		State("ENEMYDIALOGUE")
	end
end



