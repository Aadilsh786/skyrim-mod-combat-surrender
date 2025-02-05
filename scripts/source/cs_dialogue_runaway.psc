;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname CS_Dialogue_RunAway Extends TopicInfo Hidden

Quest Property CSPlayerAliasQuest Auto
CSVictimQuestScript Property VictimQuestScript Auto

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
	;GetOwningQuest().Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
	VictimQuestScript.SetVictimStatus(VictimQuestScript.LastActivatedIndex, "Flee", 0.0)
	(CSPlayerAliasQuest as CSPlayerQuestScript).EndQuest(akSpeaker)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment