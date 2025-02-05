Scriptname CSEscapeCondition extends activemagiceffect

CSVictimQuestScript Property VictimQuestScript Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	VictimQuestScript.TargetEscaped(akTarget)	
EndEvent
