Scriptname CSVictimAliasScript extends ReferenceAlias

;------
;Important Properties
;------
Actor Property PlayerREF Auto
Quest Property CSMCMQuest Auto
Quest Property CSVictimSearchingQuest Auto
Quest Property CSPlayerAliasQuest Auto
Weapon Property Unarmed Auto
FormList Property CSGarbageFormList Auto
CSVictimQuestScript Property VictimQuestScript Auto

;------
;Globals
;------
GlobalVariable Property CSYieldType Auto
GlobalVariable Property CSImmediateSurrender Auto
GlobalVariable Property CSYieldIntervalMaximum Auto
GlobalVariable Property CSFightIntervalMaximum Auto
GlobalVariable Property CSSpontaneousFleeing Auto
GlobalVariable Property CSSpontaneousRetaliation Auto

;------
;Packages
;------
Package Property CSVictimCaught Auto
Package Property CSVictimFlee Auto
Package Property CSVictimKneel Auto

;------
;Factions
;------
Faction Property CSRetaliateFaction Auto
Faction Property PotentialFollowerFaction Auto
Faction Property PotentialHireling Auto

;------
;Important Variables
;------
int HarassedVariable
bool RetaliateNextTime
bool Processing

;------
;My Characteristics
;------
Actor _MySelf
Actor Property MySelf Hidden
	Function Set(Actor ref)
		if (_MySelf == None) && (ref != None)
			VictimQuestScript.ActiveVictims += 1
		elseif (_MySelf != None) && (ref == None)
			VictimQuestScript.ActiveVictims -= 1
		endif
		_MySelf = ref
		SetMySelf(ref)
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
	Actor akRef = (Self.GetReference() as Actor)
	if akRef
		MySelf = akRef
	endif
EndEvent

Event OnActivate(ObjectReference akActionRef)
	if akActionRef == PlayerREF
		VictimQuestScript.LastActivatedIndex = MyIndex
	endif
EndEvent

Event OnDying(Actor akKiller)
	if !NearestPossibleVictim()
		MySelf = None
	endif
EndEvent

Event OnUnload()
	(CSPlayerAliasQuest as CSPlayerQuestScript).DeleteActor(MySelf)
	if !NearestPossibleVictim()
		MySelf = None
	endif
EndEvent

Event OnDetachedFromCell()
	(CSPlayerAliasQuest as CSPlayerQuestScript).DeleteActor(MySelf)
	if !NearestPossibleVictim()
		MySelf = None
	endif
EndEvent

;------
;WHEN YOU WANT PEOPLE TO YIELD AT HEALTH %
;------
State Hit
Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	if akAggressor == PlayerREF || (akAggressor as Actor).IsPlayerTeammate()
		float VictimHealth = MySelf.GetActorValuePercentage("Health")
		if (VictimHealth <= (CSMCMQuest as CSMCMQuestScript).ActorHealth) && VictimHealth > 0.0
			Deciding()
		endif
	endif
EndEvent
EndState

;------
;WHEN YOU WANT PEOPLE TO YIELD AT BLEEDOUT
;------
State BleedOut
Event OnEnterBleedout()
	Deciding()
EndEvent
EndState

;------
;Caught State - When target decides to yield
;------
State Caught
Event OnPackageEnd(Package akOldPackage)
	if akOldPackage == CSVictimCaught
		if CSSpontaneousRetaliation.GetValue() == 1
			if RetaliateNextTime
				VictimQuestScript.SetVictimStatus(MyIndex, "Fight", 0.0)
				return
			endif
		endif
		
		bool TryToFlee
		if CSSpontaneousFleeing.GetValue() == 1
			TryToFlee = FightOrFlight(False, 0.0)
		endif
		float Distance = MySelf.GetDistance(PlayerREF)
		if Distance >= (CSMCMQuest as CSMCMQuestScript).Distance_Flee || TryToFlee
			VictimQuestScript.SetVictimStatus(MyIndex, "Flee", 0.0)
		endif
	endif
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	if akAggressor == PlayerREF || (akAggressor as Actor).IsPlayerTeammate()
		if !(RetaliateNextTime)
			if akSource as Weapon == Unarmed
				RetaliateNextTimeFunction(0.20)
				if RetaliateNextTime
					VictimQuestScript.SetVictimStatus(MyIndex, "Fight", 0.0)
				endif
			else
				VictimQuestScript.SetVictimStatus(MyIndex, "Fight", 0.0)
			endif
		endif
	endif
EndEvent
EndState

;------
;Kneel State - When target kneels down
;------
State Kneel
Event OnPackageEnd(Package akOldPackage)
	if akOldPackage == CSVictimKneel
		OnUpdate()
	endif
EndEvent

Event OnSit(ObjectReference akFurniture)
	if akFurniture == VictimQuestScript.KneelMarkerREF[MyIndex]
		MySelf.SetRestrained()
	endif
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	if akAggressor == PlayerREF || (akAggressor as Actor).IsPlayerTeammate()
		if !(RetaliateNextTime)
			if akSource as Weapon == Unarmed
				RetaliateNextTimeFunction(0.20)
				if RetaliateNextTime
					VictimQuestScript.SetVictimStatus(MyIndex, "Fight", 0.0)
				endif
			else
				VictimQuestScript.SetVictimStatus(MyIndex, "Fight", 0.0)
			endif
		endif
	endif
EndEvent

Event OnUpdate()
	if CSSpontaneousRetaliation.GetValue() == 1
		if RetaliateNextTime
			VictimQuestScript.SetVictimStatus(MyIndex, "Fight", 0.0)
			return
		endif
	endif

	bool TryToFlee
	if CSSpontaneousFleeing.GetValue() == 1
		TryToFlee = FightOrFlight(False, 0.0)
	endif
	float Distance = MySelf.GetDistance(PlayerREF)
	if Distance >= (CSMCMQuest as CSMCMQuestScript).Distance_Flee || TryToFlee
		VictimQuestScript.SetVictimStatus(MyIndex, "Flee", 0.0)
	endif
		
	RegisterForSingleUpdate(10.0)
EndEvent

Event OnEndState()
	UnregisterForUpdate()
EndEvent
EndState

State Arena
Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	if akAggressor == PlayerREF || (akAggressor as Actor).IsPlayerTeammate()
		VictimQuestScript.SetVictimStatus(MyIndex, "Fight", 0.0)
	endif
EndEvent

Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
	if !(MySelf.IsDead())
		if (aeCombatState == 0)
			if RetaliateNextTime
				VictimQuestScript.SetVictimStatus(MyIndex, "Fight", 0.0)
			else
				VictimQuestScript.SetVictimStatus(MyIndex, "Flee", 0.0)
			endif
		endif
	endif
EndEvent
EndState

State Empty
EndState

;------
;Necessary functions
;------
Function SetMySelf(Actor akRef)
	if akRef == None
		VictimQuestScript.ShouldStopQuest(MyIndex)
	else
		VictimQuestScript.VictimREFArray[MyIndex] = akRef
		if IsExcluded(akRef)
			GoToState("Empty")
		elseif IsPlayerReallyStrong()
			Surrender()
		else
			bool ShouldYield = ShouldYield()
			if !ShouldYield
				GoToState("Empty")
			else
				if CSYieldType.GetValue() == 0
					GoToState("Hit")
				elseif CSYieldType.GetValue() == 1
					GoToState("BleedOut")
				endif
			endif
		endif
	endif
EndFunction

Function Deciding()		
	if !Processing
		Processing = True
		if !(MySelf.IsPlayerTeammate())
			if !(VictimQuestScript.ShouldEveryoneSurrender())
				Surrender()
			endif
		endif
		Processing = False
	endif
EndFunction

Function Surrender()
	MySelf.RemoveFromFaction(PotentialFollowerFaction)
	MySelf.RemoveFromFaction(PotentialHireling)
	MySelf.SetRelationshipRank(PlayerREF, -2)
	MySelf.SetActorValue("Confidence", 0)
	MySelf.SetActorValue("Assistance", 0)
	MySelf.SetActorValue("Aggression", 0)
	MySelf.StopCombatAlarm()
	VictimQuestScript.SetVictimStatus(MyIndex, "Caught", 0.0)
EndFunction

Actor Function NearestPossibleVictim(bool AutomaticallySwitch = True)	
	CSVictimSearchingQuest.Start()
	Actor Attacker = ((CSVictimSearchingQuest.GetAlias(0) as ReferenceAlias).GetReference() as Actor)
	CSVictimSearchingQuest.Stop()
	
	if Attacker != None
		if !IsExcluded(Attacker)
			if AutomaticallySwitch
				Self.Clear()
				Self.ForceRefTo(Attacker)
				ResetThisAlias()
			endif
		else
			return None
		endif
	endif
	
	return Attacker
EndFunction

bool Function IsPlayerReallyStrong()
	if MySelf.IsInFaction(CSRetaliateFaction)
		MySelf.RemoveFromFaction(CSRetaliateFaction)
		return False
	endif
	
	int PlayerLevel = PlayerREF.GetLevel()
	int MyLevel = MySelf.GetLevel()
	float fMin = (CSImmediateSurrender.GetValue() / 100)
	int iMin = Math.Floor(PlayerLevel * fmin)
	
	if iMin >= MyLevel
		return True
	else
		return False
	endif
EndFunction

bool Function ShouldYield(bool Yield = True, int Offset = 0)
	int RaceFactor = 0
	if (CSMCMQuest as CSMCMQuestScript).Toggle_Race
		RaceFactor = RaceFactorInt(MySelf.GetRace())
	endif
	
	int ConfidenceFactor = 0
	if (CSMCMQuest as CSMCMQuestScript).Toggle_Confidence
		ConfidenceFactor = MySelf.GetActorValue("Confidence") as int
	endif
	
	int RNGFactor = 0
	if (CSMCMQuest as CSMCMQuestScript).Toggle_RNG
		RNGFactor = Utility.RandomInt(0, 4)
	endif
	
	int SumOfAll = RaceFactor + ConfidenceFactor + RNGFactor + Offset
	int IntervalMaximum = 0
	if Yield
		IntervalMaximum = CSYieldIntervalMaximum.GetValue() as int
		if IntervalMaximum == 100
			return True
		endif
	else
		IntervalMaximum = CSFightIntervalMaximum.GetValue() as int
		if IntervalMaximum == 200
			return True
		endif
	endif
	
	if IntervalMaximum == 0
		return False
	endif
	
	int FactorRandomizer = Utility.RandomInt(0, IntervalMaximum)
	
	if FactorRandomizer >= SumOfAll
		return True
	else
		return False
	endif
EndFunction

int Function RaceFactorInt(Race VictimsRace)
	int iIndex = VictimQuestScript.VictimRace.Find(VictimsRace)
	if iIndex < 0
		iIndex = Utility.RandomInt(0, 4)
	else
		iIndex = Math.Floor(iIndex / 4)
	endif
		return iIndex
EndFunction

bool Function IsExcluded(Actor akTarget)
	if !VictimQuestScript.ShouldAcceptVampire(akTarget)
		return True
	endif
	
	if (CSMCMQuest as CSMCMQuestScript).Toggle_Actors
		return False
	endif
	
	int iIndex = 0
	int iElement = VictimQuestScript.ExcludeAlias.Length
	While iIndex < iElement
		Actor ExcludedActor = (VictimQuestScript.ExcludeAlias[iIndex].GetReference() as Actor)
		if (ExcludedActor != None)
			if (ExcludedActor == akTarget)
				return True
			endif
		endif
		iIndex += 1
	EndWhile
	
	return False
EndFunction

bool Function FightOrFlight(bool FightBack = True, float PercentageIncrease = 0.0)
	int Offset = 0
	if FightBack
		int iIncrease = Math.Floor((CSFightIntervalMaximum.GetValue() as int) * PercentageIncrease)
		HarassedVariable += iIncrease
	endif
		
	Offset = HarassedVariable

	return !(ShouldYield(False, Offset))
EndFunction

Function RetaliateNextTimeFunction(float fPercentageIncrease)
	RetaliateNextTime = FightOrFlight(PercentageIncrease = fPercentageIncrease)
	if RetaliateNextTime
		MySelf.AddToFaction(CSRetaliateFaction)
	endif
EndFunction

Function Retaliate()
	float Distance = MySelf.GetDistance(PlayerREF)
	
	if !MySelf.IsDead()
		MySelf.SetRestrained(False)
		if !(MySelf.IsHostileToActor(PlayerREF))
			if Distance <= (CSMCMQuest as CSMCMQuestScript).Distance_Retaliate
				if RetaliateNextTime
					VictimQuestScript.SetVictimStatus(MyIndex, "Fight", 0.0)
					return
				endif
			endif
			if (MySelf.Is3DLoaded())
				MySelf.SetActorValue("Confidence", 2)
				MySelf.SetActorValue("Assistance", 1)
				MySelf.SetActorValue("Aggression", 0)
				MySelf.EvaluatePackage()
				CSGarbageFormList.AddForm(MySelf)
			else
				(CSPlayerAliasQuest as CSPlayerQuestScript).DeleteActor(MySelf)
			endif
		endif
		MySelf = None
	endif
EndFunction

Function ResetThisAlias()
	HarassedVariable = 0
	Processing = False
	RetaliateNextTime = False
	
	GoToState("")
	
	VictimQuestScript.RemoveKneelingMarker(MyIndex)
	OnInit()
EndFunction