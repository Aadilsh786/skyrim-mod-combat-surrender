Scriptname CSPlayerQuestScript extends Quest

WIFunctionsScript Property WI Auto
CSVictimQuestScript Property VictimQuestScript Auto

Quest Property CSMCMQuest Auto
Quest Property CSVictimAliasQuest Auto

Actor Property PlayerREF Auto

ReferenceAlias[] Property SpecialAlias Auto
FormList Property CSGarbageFormList Auto

bool Property AlreadyFinished Auto Hidden

float fModVersion = 2.00

Function Maintenance(bool IsItInit = False)
	Update()
	RemoveGarbage()
	if CSVictimAliasQuest.IsRunning()
		VictimQuestScript.AliasMaintenance()
	endif
EndFunction

Function Update()
	if fModVersion < 1.21
		(CSMCMQuest as CSMCMQuestScript).Toggle_Actors = False
		fModVersion = 1.21
	endif
EndFunction

int Function FindActor(Actor VictimREF)
	int iIndex = 0
	if !(CSMCMQuest as CSMCMQuestScript).Toggle_Bounty
		return -1
	endif
	int iElement = SpecialAlias.Length
	
	While iIndex < iElement
		Actor ExcludedActor = (SpecialAlias[iIndex].GetReference() as Actor)
		if (ExcludedActor != None)
			if (ExcludedActor == VictimREF)
				return iIndex
			endif
		endif
		iIndex += 1
	EndWhile
	
	return -1
EndFunction

Function RemoveGarbage()
	int iIndex = CSGarbageFormList.GetSize()
	int DeletedNumber = 0
	int GarbageNumber = iIndex
	
	if iIndex >= 0
		While iIndex > 0
			iIndex -= 1
			Actor VictimREF = CSGarbageFormList.GetAt(iIndex) as Actor
			if VictimREF != None
				if !(VictimREF.Is3DLoaded())
					DeleteActor(VictimREF)
					DeletedNumber += 1
				endif
			endif
		EndWhile
		if DeletedNumber == GarbageNumber
			CSGarbageFormList.Revert()
		endif
	endif
EndFunction

Function DeleteActor(Actor VictimREF)
	FailQuest(VictimREF)
	ActorBase VictimREFBase = VictimREF.GetLeveledActorBase()
	bool ShouldExclude = VictimREFBase.IsUnique()
	if !ShouldExclude
		ShouldExclude = VictimREFBase.IsProtected()
	endif
	
	if !VictimREF.IsDead()
		if !ShouldExclude
			VictimREF.UnequipAll()
			VictimREF.Kill()
			VictimREF.SetCriticalStage(VictimREF.CritStage_DisintegrateEnd)
		else
			Actor DoppelgangerREF = WI.WIDeadBodyCleanupCellMarker.PlaceAtMe(VictimREF.GetBaseObject()) as Actor
			VictimREF.SetActorValue("Confidence", DoppelgangerREF.GetBaseActorValue("Confidence"))
			VictimREF.SetActorValue("Assistance", DoppelgangerREF.GetBaseActorValue("Assistance"))
			VictimREF.SetActorValue("Aggression", DoppelgangerREF.GetBaseActorValue("Aggression"))
			DoppelgangerREF.UnequipAll()
			DoppelgangerREF.Kill()
			DoppelgangerREF.SetCriticalStage(DoppelgangerREF.CritStage_DisintegrateEnd)
		endif
	endif
	
	if CSGarbageFormList.HasForm(VictimREF)
		CSGarbageFormList.RemoveAddedForm(VictimREF)
	endif
EndFunction

Function FailQuest(Actor VictimREF)
	int iIndex = FindActor(VictimREF)
	if iIndex >= 0
		if !AlreadyFinished
			SpecialAlias[iIndex].GetOwningQuest().FailAllObjectives()
		endif
	endif
EndFunction

Function EndQuest(Actor VictimREF)
	int iIndex = FindActor(VictimREF)
	if iIndex >= 0
		ReferenceAlias SpecialVictim = SpecialAlias[iIndex]
		if iIndex == 0
			(SpecialVictim as BQBountyScript).OnDeath(None)
		elseif iIndex == 1
			(SpecialVictim as BQBountyScript).OnDeath(None)
		elseif iIndex == 2
			(SpecialVictim as CR05BossScript).OnDeath(None)
		elseif iIndex == 3
			(SpecialVictim as CR08BossScript).OnDeath(None)
		elseif iIndex == 4
			(SpecialVictim as CR09BossScript).OnDeath(None)
		elseif iIndex == 5
			(SpecialVictim as WIKill06ThugScript).OnDeath(None)
		elseif iIndex == 6
			(SpecialVictim as WIKill06ThugScript).OnDeath(None)
		elseif iIndex == 7
			(SpecialVictim as WIKill06ThugScript).OnDeath(None)
		endif
		AlreadyFinished = True
	endif
EndFunction