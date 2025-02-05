Scriptname CSTeammateAliasScript extends ReferenceAlias

;------
;Important Properties
;------
CSVictimQuestScript Property VictimQuestScript Auto

;------
;My Characteristics
;------
Actor _MySelf
Actor Property MySelf Hidden
	Function Set(Actor ref)
		if (_MySelf == None) && (ref != None)
			VictimQuestScript.ActiveTeammates += 1
		elseif (_MySelf != None) && (ref == None)
			VictimQuestScript.ActiveTeammates -= 1
			if VictimQuestScript.ActiveTeammates == 0
				GetOwningQuest().Stop()
			endif
		endif
		VictimQuestScript.TeammateREFArray[MyIndex] = ref
		_MySelf = ref
	EndFunction
	Actor Function Get()
		return _MySelf
	EndFunction
EndProperty

;------
;VERY IMPORTANT INT
;------
int Property MyIndex Auto
;------

;------
;HIGHWAY TO THE EVENTZONE
;------
Event OnInit()
	MySelf = (Self.GetReference() as Actor)
EndEvent

Event OnDying(Actor akKiller)
	MySelf = None
EndEvent