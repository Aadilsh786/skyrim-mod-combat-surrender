;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname CS_Dialogue_Disarm Extends TopicInfo Hidden

Idle Property IdleGive Auto
MiscObject Property Gold001 Auto
CSVictimQuestScript Property VictimQuestScript Auto

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
	int SpeakerGold = akSpeaker.GetItemCount(Gold001)
	if (SpeakerGold > 0)
		if (akSpeaker.GetSitState() == 0)
			akSpeaker.PlayIdle(IdleGive)
		endif
		akSpeaker.RemoveItem(Gold001, SpeakerGold)
		Game.GetPlayer().AddItem(Gold001, SpeakerGold)
	endif
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
	VictimQuestScript.VictimAliasScript[VictimQuestScript.LastActivatedIndex].RetaliateNextTimeFunction(0.05)
	akSpeaker.OpenInventory(true)
	Utility.Wait(0.1)
	akSpeaker.EvaluatePackage()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
