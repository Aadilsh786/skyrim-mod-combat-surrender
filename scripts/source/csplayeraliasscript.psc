Scriptname CSPlayerAliasScript extends ReferenceAlias

;------
;Important Properties
;------
Actor Property PlayerREF Auto

Quest Property CSVictimAliasQuest Auto
Quest Property CSTeammateAliasQuest Auto
Quest Property CSMCMQuest Auto

MiscObject Property CSDummyItem Auto

CSPlayerQuestScript Property PlayerScript Auto
CSVictimQuestScript Property VictimQuestScript Auto

bool Property IsCSProcessing Auto Hidden
bool IsCombatOver

;------
;Special Quests - Ill Met By Moonlight; The Mind of Madness; Waking Nightmare
;------
Quest Property DA05 Auto
Quest Property DA15 Auto
Quest Property DA16 Auto

Event OnInit()
	AddInventoryEventFilter(CSDummyItem)
EndEvent

Event OnPlayerLoadGame()
	PlayerScript.Maintenance()
	
	RemoveAllInventoryEventFilters()
	AddInventoryEventFilter(CSDummyItem)
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	if IsCSProcessing
		return
	endif
	
	IsCSProcessing = True
	
	if CSVictimAliasQuest.IsRunning()
		int i = 0
		int ie = VictimQuestScript.VictimREFArray.Length
		While i < ie
			if VictimQuestScript.VictimREFArray[i]
				VictimQuestScript.VictimAliasScript[i].Retaliate()
			endif
			i += 1
		EndWhile
	endif
	if !SpecialQuests()
		PlayerScript.AlreadyFinished = False
		if CSVictimAliasQuest.IsRunning()
			CSVictimAliasQuest.Stop()
		endif
		CSVictimAliasQuest.Start()
	else
		CSVictimAliasQuest.Stop()
	endif
	if CSVictimAliasQuest.IsRunning()
		VictimQuestScript.ActiveTeammates = 0
		CSTeammateAliasQuest.Stop()
		CSTeammateAliasQuest.Start()
	endif
	
	if IsCombatOver
		if VictimQuestScript.ActiveVictims == 0
			CSVictimAliasQuest.Stop()
			CSTeammateAliasQuest.Stop()
		endif
	endif
	
	IsCSProcessing = False
	IsCombatOver = False
EndEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	if IsCSProcessing
		IsCombatOver = True
		return
	endif
	
	if VictimQuestScript.ActiveVictims == 0
		CSVictimAliasQuest.Stop()
		CSTeammateAliasQuest.Stop()
	endif
EndEvent

bool Function SpecialQuests()
	if (CSMCMQuest as CSMCMQuestScript).Toggle_Quests
		return False
	endif
	int DA05Stage = DA05.GetStage()
	int DA15Stage = DA15.GetStage()
	int DA16Stage = DA16.GetStage()
	
	if DA05Stage >= 55 && DA05Stage < 100
		return True
	elseif DA15Stage >= 50 && DA15Stage < 200
		return True
	elseif DA16Stage >= 30 && DA16Stage < 200
		return True
	EndIf
	
	return False
EndFunction