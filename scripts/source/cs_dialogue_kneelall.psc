;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname CS_Dialogue_KneelAll Extends TopicInfo Hidden

CSVictimQuestScript Property VictimQuestScript Auto
Package Property CSVictimFlee Auto
Faction Property CSRetaliateFaction Auto

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
	int i = 0
	int ie = VictimQuestScript.VictimREFArray.Length
	While i < ie
		Actor Victim = VictimQuestScript.VictimREFArray[i]
		if Victim != None
			if Victim.GetCurrentPackage() != CSVictimFlee
				if Victim.IsInFaction(CSRetaliateFaction)
					VictimQuestScript.SetVictimStatus(i, "Fight", 0.0)
				else
					VictimQuestScript.SetVictimStatus(i, "Kneel", 0.10)
				endif
			endif
		endif
		i += 1
	EndWhile
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
