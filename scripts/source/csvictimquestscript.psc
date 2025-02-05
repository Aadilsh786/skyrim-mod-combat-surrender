Scriptname CSVictimQuestScript extends Quest Conditional

;------
;Important Properties
;------
Actor Property PlayerREF Auto
FormList Property CSGarbageFormList Auto
GlobalVariable Property CSMaxVictims Auto
GlobalVariable Property CSVampire Auto
Keyword Property Vampire Auto

;------
;Victims
;------
Actor[] Property VictimREFArray Auto
Race[] Property VictimRace Auto
ReferenceAlias[] Property VictimAlias Auto
CSVictimAliasScript[] Property VictimAliasScript Auto

;------
;Teammates
;------
Actor[] Property TeammateREFArray Auto

;------
;Factions
;------
Faction Property CSCaughtFaction Auto
Faction Property CSFleeFaction Auto
Faction Property CSKneelFaction Auto
Faction Property CSFightFaction Auto
Faction Property CSRetaliateFaction Auto

;------
;Kneeling
;------
Furniture[] Property KneelingMarker Auto
ReferenceAlias[] Property KneelingAlias Auto
ObjectReference[] Property KneelMarkerREF Auto

;------
;Exclude
;------
ReferenceAlias[] Property ExcludeAlias Auto

;------
;VERY IMPORTANT INTS
;------
int Property ActiveVictims Auto Hidden Conditional
int Property ActiveTeammates Auto Hidden
int Property LastActivatedIndex Auto Hidden
;------

Function SetVictimStatus(int id, string Reaction = "", float RetaliateOffset = 0.0)	
	if !VictimREFArray[id]
		FailSafe()
		return
	endif
	
	if RetaliateOffset > 0.0
		VictimAliasScript[id].RetaliateNextTimeFunction(RetaliateOffset)
	endif
	
	if Reaction != "Kneel"
		VictimREFArray[id].SetRestrained(False)
	endif
	
	SetConditionalVariables(VictimREFArray[id], Reaction)
	
	if Reaction == "Flee"
		VictimAliasScript[id].GoToState("Caught")
		CSGarbageFormList.AddForm(VictimREFArray[id])
	elseif Reaction == "Caught"
		VictimAliasScript[id].GoToState("Caught")
	elseif Reaction == "Kneel"
		SetKneelingMarker(id)
		VictimAliasScript[id].GoToState("Kneel")
	elseif Reaction == "Arena"
		VictimAliasScript[id].GoToState("Arena")
		VictimREFArray[id].SetActorValue("Confidence", 4)
		VictimREFArray[id].SetActorValue("Aggression", 1)
	elseif Reaction == "Fight"
		VictimAliasScript[id].GoToState("Empty")
		VictimREFArray[id].EvaluatePackage()
		VictimREFArray[id].SetActorValue("Confidence", 4)
		VictimREFArray[id].SetActorValue("Assistance", 2)
		VictimREFArray[id].SetActorValue("Aggression", 2)
		VictimAliasScript[id].MySelf = None
	endif
	if Reaction != "Fight"
		VictimREFArray[id].EvaluatePackage()
	endif
EndFunction

Function SetConditionalVariables(Actor akVictim, string Reaction = "")
	if Reaction == "Flee"
		akVictim.RemoveFromFaction(CSFightFaction)
		akVictim.RemoveFromFaction(CSCaughtFaction)
		akVictim.RemoveFromFaction(CSKneelFaction)
		akVictim.AddToFaction(CSFleeFaction)
	elseif Reaction == "Caught"
		akVictim.RemoveFromFaction(CSFightFaction)
		akVictim.RemoveFromFaction(CSFleeFaction)
		akVictim.RemoveFromFaction(CSKneelFaction)
		akVictim.AddToFaction(CSCaughtFaction)
	elseif Reaction == "Kneel"
		akVictim.RemoveFromFaction(CSFightFaction)
		akVictim.RemoveFromFaction(CSCaughtFaction)
		akVictim.RemoveFromFaction(CSFleeFaction)
		akVictim.AddToFaction(CSKneelFaction)
	elseif Reaction == "Arena"
		akVictim.RemoveFromAllFactions()
		akVictim.AddToFaction(CSFightFaction)
	elseif Reaction == "Fight"
		akVictim.RemoveFromFaction(CSFightFaction)
		akVictim.RemoveFromFaction(CSCaughtFaction)
		akVictim.RemoveFromFaction(CSFleeFaction)
		akVictim.RemoveFromFaction(CSKneelFaction)
		akVictim.AddToFaction(CSRetaliateFaction)
	endif
EndFunction

Function SetKneelingMarker(int id)
	RemoveKneelingMarker(id)
	int iIndex = Utility.RandomInt(0, (KneelingMarker.Length - 1))
	KneelMarkerREF[id] = VictimREFArray[id].PlaceAtMe(KneelingMarker[iIndex])
	KneelMarkerREF[id].MoveTo(PlayerREF, afYOffset = ((id * 100) + 100))
	KneelingAlias[id].ForceRefTo(KneelMarkerREF[id])
EndFunction

Function RemoveKneelingMarker(int id)
	if KneelMarkerREF[id] != None
		KneelingAlias[id].Clear()
		KneelMarkerREF[id].Delete()
		KneelMarkerREF[id] = None
	endif
EndFunction

Function ShouldStopQuest(int id)
	RemoveKneelingMarker(id)
	VictimREFArray[id] = None
	VictimAlias[id].Clear()
	VictimAliasScript[id].GoToState("")
	if ActiveVictims <= 0
		Stop()
	endif
EndFunction

Function TargetEscaped(Actor akTarget)
	int id = VictimREFArray.Find(akTarget)
	if id >= 0
		VictimAliasScript[id].OnUnload()
	endif
EndFunction

Function FailSafe()
	int iNumOfVictims = 0
	
	int i = 0
	int ie = VictimAliasScript.Length
	While i < ie
		if VictimAlias[i].GetReference()
			iNumOfVictims += 1
		endif
		i += 1
	EndWhile
	
	if ActiveVictims != iNumOfVictims
		if iNumOfVictims == 0
			Stop()
		else
			ActiveVictims = iNumOfVictims
		endif
	endif
EndFunction

Function AliasMaintenance()
	ActiveVictims = 0
	
	int i = 0
	int ie = VictimREFArray.Length
	While i < ie
		Actor Victim = VictimREFArray[i]
		if Victim != None
			Victim.SetRelationshipRank(PlayerREF, -2)
			ActiveVictims += 1
		endif
		i += 1
	EndWhile
EndFunction

bool Function ShouldAcceptVampire(Actor akVictim)
	int Variant = CSVampire.GetValue() as int
	if akVictim
		if akVictim.HasKeyword(Vampire)
			if Variant > 0
				return True
			else
				return False
			endif
		endif
	else
		return False
	endif
	
	return True
EndFunction

bool Function ShouldEveryoneSurrender()
	if ActiveVictims == 1
		return False
	endif
	
	if VictimAliasScript[0].NearestPossibleVictim(False)
		return False
	endif
	
	float MyTeamHealth = MyTeamHealth()
	float OpponentHealth = 0.0
	
	int i = 0
	int ie = VictimREFArray.Length
	int ilimit = 0
	While i < ie
		Actor Victim = VictimREFArray[i]
		if Victim != None
			OpponentHealth += Victim.GetActorValue("Health")
		endif
		i += 1
	EndWhile
	
	if OpponentHealth >= MyTeamHealth
		return False
	else
		i = 0
		While i < ie
			Actor Victim = VictimREFArray[i]
			if Victim != None
				string sState = VictimAliasScript[i].GetState()
				if sState == "Hit" || sState == "BleedOut"
					VictimAliasScript[i].Surrender()
				endif
				ilimit += 1
			endif
			if ilimit == ActiveVictims
				return True
			endif
			i += 1
		EndWhile
		
		return True
	endif
EndFunction

float Function MyTeamHealth()
	if ActiveTeammates == 0
		return PlayerREF.GetActorValue("Health")
	endif
	
	float fbase = 0.0
	
	int i = 0
	int ie = TeammateREFArray.Length
	int ilimit = 0
	While i < ie
		Actor Teammate = TeammateREFArray[i]
		if i == 0
			fbase += PlayerREF.GetActorValue("Health")
		endif
		if Teammate != None
			fbase += Teammate.GetActorValue("Health")
			ilimit += 1
		endif
		if ilimit == ActiveTeammates
			return fbase
		endif
		i += 1
	EndWhile
	return fbase
EndFunction