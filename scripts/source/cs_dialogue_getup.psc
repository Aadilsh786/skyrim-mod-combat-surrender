;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname CS_Dialogue_GetUp Extends TopicInfo Hidden

CSVictimQuestScript Property VictimQuestScript Auto

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
	VictimQuestScript.SetVictimStatus(VictimQuestScript.LastActivatedIndex, "Caught", 0.05)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
