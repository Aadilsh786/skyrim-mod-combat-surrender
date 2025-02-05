;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname CS_Dialogue_FightBack_Loot Extends TopicInfo Hidden

CSVictimQuestScript Property VictimQuestScript Auto

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
	VictimQuestScript.SetVictimStatus(VictimQuestScript.LastActivatedIndex, "Fight", 0.0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
	VictimQuestScript.SetConditionalVariables(akSpeaker, "Fight")
	akSpeaker.EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
