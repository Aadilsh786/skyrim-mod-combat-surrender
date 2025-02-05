Scriptname CSMCMQuestScript extends ski_configbase

Quest Property CSVictimAliasQuest Auto
Quest Property CSPlayerAliasQuest Auto

GlobalVariable Property CSVampire Auto
GlobalVariable Property CSMaxVictims Auto
GlobalVariable Property CSImmediateSurrender Auto
GlobalVariable Property CSYieldType Auto
GlobalVariable Property CSYieldIntervalMaximum Auto
GlobalVariable Property CSFightIntervalMaximum Auto
GlobalVariable Property CSSpontaneousFleeing Auto
GlobalVariable Property CSSpontaneousRetaliation Auto
GlobalVariable Property CSEscapeDistance Auto

bool Property Toggle_Race = True Auto Hidden
bool Property Toggle_Confidence = True Auto Hidden
bool Property Toggle_RNG = True Auto Hidden

float Property ActorHealth = 0.1 Auto Hidden
float Property Distance_Retaliate = 5000.0 Auto Hidden
float Property Distance_Flee = 2000.0 Auto Hidden

bool CSActivated = True
bool Property Toggle_Bounty = True Auto Hidden
bool Property Toggle_Quests = True Auto Hidden
bool Property Toggle_Actors Auto Hidden

int _text_active
int _slider_maxvictimnumber
int _slider_immediatesurrender
int _menu_yieldmechanism
int _slider_actorhealth
int _slider_yield_intervalmaximum
int _slider_fight_intervalmaximum
int _toggle_vampire
int _toggle_race
int _toggle_confidence
int _toggle_RNG
int _toggle_spontaneous_flee
int _toggle_spontaneous_retaliation
int _slider_distance_escape
int _slider_distance_retaliate
int _slider_distance_flee
int _toggle_activate_bounty
int _toggle_activate_specialquests
int _toggle_activate_specialactors

string[] YieldMechanismArray

Event OnConfigInit()
	Pages = new String[1]
	Pages[0] = "$Page_General"
	
	YieldMechanismArray = new string[2]
	YieldMechanismArray[0] = "$On Hit Event"
	YieldMechanismArray[1] = "$On Bleedout State"
EndEvent

Event OnPageReset(string s_page)
	if !CSActivated
		if (s_page == "$Page_General")
			SetCursorFillMode( TOP_TO_BOTTOM )
			AddHeaderOption("$Deactivate/Activate Mod")
			_text_active = AddTextOption("$Activate Combat Surrender", "$Click", Game.GetPlayer().IsInCombat() as int)
		endif
	else
		if (s_page == "$Page_General")
			SetCursorFillMode( TOP_TO_BOTTOM )
			AddHeaderOption("$Deactivate/Activate Mod")
			_text_active = AddTextOption("$Deactivate Combat Surrender", "$Click", CSVictimAliasQuest.IsRunning() as int)
			AddEmptyOption()
			
			AddHeaderOption("$Yield")
			_slider_maxvictimnumber = AddSliderOption("$Maximum Victim Number", CSMaxVictims.GetValue() as int)
			_slider_immediatesurrender = AddSliderOption("$Minimum Level Percentage", CSImmediateSurrender.GetValue() as int, "{0} %")
			_menu_yieldmechanism = AddMenuOption("$Yield Mechanism", YieldMechanismArray[CSYieldType.GetValue() as int])
			_slider_actorhealth = AddSliderOption("$Actor Health", (ActorHealth * 100), "{0} %", CSYieldType.GetValue() as int)
			_slider_yield_intervalmaximum = AddSliderOption("$Yield Interval Maximum", CSYieldIntervalMaximum.GetValue() as int)
			_slider_fight_intervalmaximum = AddSliderOption("$Fight/Flee Interval Maximum", CSFightIntervalMaximum.GetValue() as int)
			
			AddEmptyOption()
			AddHeaderOption("$Distance")
			_slider_distance_escape = AddSliderOption("$Escape Distance", CSEscapeDistance.GetValue() as int, "{0} units")
			_slider_distance_retaliate = AddSliderOption("$Retaliate Distance", Distance_Retaliate, "{0} units")
			_slider_distance_flee = AddSliderOption("$Flee Distance", Distance_Flee, "{0} units")

			SetCursorPosition(1)
			AddHeaderOption("$Toggles")
			_toggle_vampire = AddToggleOption("$Toggle Vampire", CSVampire.GetValue() as bool)
			_toggle_race  = AddToggleOption("$Toggle Race Factor", Toggle_Race)
			_toggle_confidence  = AddToggleOption("$Toggle Confidence Factor", Toggle_Confidence)
			_toggle_RNG  = AddToggleOption("$Toggle RNG Factor", Toggle_RNG)
			_toggle_spontaneous_flee = AddToggleOption("$Toggle Spontaneous Fleeing", CSSpontaneousFleeing.GetValue() as bool)
			_toggle_spontaneous_retaliation = AddToggleOption("$Toggle Spontaneous Retaliation", CSSpontaneousRetaliation.GetValue() as bool)
			
			AddEmptyOption()
			AddHeaderOption("$Options")
			_toggle_activate_bounty = AddToggleOption("$Toggle Alternate Bounty Handling", Toggle_Bounty)
			_toggle_activate_specialquests = AddToggleOption("$Toggle Special Quests", Toggle_Quests)
			_toggle_activate_specialactors = AddToggleOption("$Toggle Special Actors", Toggle_Actors)
		endif
	endif
EndEvent

Event OnOptionDefault(int option)
	if option == _toggle_vampire
		CSVampire.SetValue(1)
		SetToggleOptionValue(option, CSVampire.GetValue() as bool)
	elseif option == _slider_maxvictimnumber
		CSMaxVictims.SetValue(3)
		SetSliderOptionValue(option, CSMaxVictims.GetValue() as int)
	elseif option == _slider_immediatesurrender
		CSImmediateSurrender.SetValue(50)
		SetSliderOptionValue(option, CSImmediateSurrender.GetValue() as int, "{0} %")
	elseif option == _menu_yieldmechanism
		CSYieldType.SetValue(0)
		SetMenuOptionValue(option, YieldMechanismArray[0])
		ForcePageReset()
	elseif option == _slider_actorhealth
		ActorHealth = 0.1
		SetSliderOptionValue(option, (ActorHealth * 100), "{0} %")
	elseif option == _slider_yield_intervalmaximum
		CSYieldIntervalMaximum.SetValue(16)
		SetSliderOptionValue(option, CSYieldIntervalMaximum.GetValue() as int)
	elseif option == _slider_fight_intervalmaximum
		CSFightIntervalMaximum.SetValue(40)
		SetSliderOptionValue(option, CSFightIntervalMaximum.GetValue() as int)
	elseif option == _toggle_race
		Toggle_Race = True
		SetToggleOptionValue(option, Toggle_Race)
	elseif option == _toggle_confidence
		Toggle_Confidence = True
		SetToggleOptionValue(option, Toggle_Confidence)
	elseif option == _toggle_RNG
		Toggle_RNG = True
		SetToggleOptionValue(option, Toggle_RNG)
	elseif option == _toggle_spontaneous_flee
		CSSpontaneousFleeing.SetValue(1)
		SetToggleOptionValue(option, CSSpontaneousFleeing.GetValue() as bool)
	elseif option == _toggle_spontaneous_retaliation
		CSSpontaneousRetaliation.SetValue(0)
		SetToggleOptionValue(option, CSSpontaneousRetaliation.GetValue() as bool)
	elseif option == _slider_distance_escape
		CSEscapeDistance.SetValue(10000)
		SetSliderOptionValue(option, CSEscapeDistance.GetValue() as int, "{0} units")
	elseif option == _slider_distance_retaliate
		Distance_Retaliate = 5000.0
		SetSliderOptionValue(option, Distance_Retaliate, "{0} units")
	elseif option == _slider_distance_flee
		Distance_Flee = 2000.0
		SetSliderOptionValue(option, Distance_Flee, "{0} units")
	elseif option == _toggle_activate_bounty
		Toggle_Bounty = True
		SetToggleOptionValue(option, Toggle_Bounty)
	elseif option == _toggle_activate_specialquests
		Toggle_Quests = True
		SetToggleOptionValue(option, Toggle_Quests)
	elseif option == _toggle_activate_specialactors
		Toggle_Actors = False
		SetToggleOptionValue(option, Toggle_Actors)
	endif
EndEvent

Event OnOptionHighlight(int option)
	if option == _slider_maxvictimnumber
		SetInfoText("$HL_MaximumNumber")
	elseif option == _slider_immediatesurrender
		SetInfoText("$HL_ImmediateSurrender")
	elseif option == _menu_yieldmechanism
		SetInfoText("$HL_Yield")
	elseif option == _slider_actorhealth
		SetInfoText("$HL_ActorHealth")
	elseif option == _slider_yield_intervalmaximum
		SetInfoText("$HL_Yield_Interval_Maximum")
	elseif option == _slider_fight_intervalmaximum
		SetInfoText("$HL_Fight/Flee_Interval_Maximum")
	elseif option == _toggle_vampire
		SetInfoText("$HL_Toggle_Vampire")
	elseif option == _toggle_race
		SetInfoText("$HL_Toggle_Race")
	elseif option == _toggle_confidence
		SetInfoText("$HL_Toggle_Confidence")
	elseif option == _toggle_RNG
		SetInfoText("$HL_Toggle_RNG")
	elseif option == _toggle_spontaneous_flee
		SetInfoText("$HL_Toggle_Spontaneous_Flee")
	elseif option == _toggle_spontaneous_retaliation
		SetInfoText("$HL_Toggle_Spontaneous_Retaliation")
	elseif option == _slider_distance_escape
		SetInfoText("$HL_Distance_Escape")
	elseif option == _slider_distance_retaliate
		SetInfoText("$HL_Distance_Retaliate")
	elseif option == _slider_distance_flee
		SetInfoText("$HL_Distance_Flee")
	elseif option == _toggle_activate_bounty
		SetInfoText("$HL_Toggle_Bounty")
	elseif option == _toggle_activate_specialquests
		SetInfoText("$HL_Toggle_SpecialQuests")
	elseif option == _toggle_activate_specialactors
		SetInfoText("$HL_Toggle_SpecialActors")
	endif
EndEvent

Event OnOptionSliderOpen(int option)
	if option == _slider_maxvictimnumber
		SetSliderDialogStartValue(CSMaxVictims.GetValue() as int)
		SetSliderDialogDefaultValue(3)
		SetSliderDialogRange(0, 3)
		SetSliderDialogInterval(1.0)
	elseif option == _slider_immediatesurrender
		SetSliderDialogStartValue(CSImmediateSurrender.GetValue() as int)
		SetSliderDialogDefaultValue(50)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1.0)
	elseif option == _slider_actorhealth
		SetSliderDialogStartValue((ActorHealth * 100))
		SetSliderDialogDefaultValue(10)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1.0)
	elseif option == _slider_yield_intervalmaximum
		SetSliderDialogStartValue(CSYieldIntervalMaximum.GetValue() as int)
		SetSliderDialogDefaultValue(16)
		SetSliderDialogRange(0, 100)
		SetSliderDialogInterval(1.0)
	elseif option == _slider_fight_intervalmaximum
		SetSliderDialogStartValue(CSFightIntervalMaximum.GetValue() as int)
		SetSliderDialogDefaultValue(40)
		SetSliderDialogRange(0, 200)
		SetSliderDialogInterval(1.0)
	elseif option == _slider_distance_flee
		SetSliderDialogStartValue(Distance_Flee)
		SetSliderDialogDefaultValue(2000.0)
		SetSliderDialogRange(0.0, 10000.0)
		SetSliderDialogInterval(100.0)
	elseif option == _slider_distance_retaliate
		SetSliderDialogStartValue(Distance_Retaliate)
		SetSliderDialogDefaultValue(5000.0)
		SetSliderDialogRange(0.0, 10000.0)
		SetSliderDialogInterval(100.0)
	elseif option == _slider_distance_escape
		SetSliderDialogStartValue(CSEscapeDistance.GetValue() as int)
		SetSliderDialogDefaultValue(10000)
		SetSliderDialogRange(0, 20000)
		SetSliderDialogInterval(100.0)
	endif
EndEvent

Event OnOptionSliderAccept(int option, float value)
	if option == _slider_maxvictimnumber
		CSMaxVictims.SetValue(value as int)
		SetSliderOptionValue(option, CSMaxVictims.GetValue() as int)
	elseif option == _slider_immediatesurrender
		CSImmediateSurrender.SetValue(value as int)
		SetSliderOptionValue(option, CSImmediateSurrender.GetValue() as int, "{0} %")
	elseif option == _slider_actorhealth
		ActorHealth = (value / 100)
		SetSliderOptionValue(option, value, "{0} %")
	elseif option == _slider_yield_intervalmaximum
		CSYieldIntervalMaximum.SetValue(value as int)
		SetSliderOptionValue(option, CSYieldIntervalMaximum.GetValue() as int)
	elseif option == _slider_fight_intervalmaximum
		CSFightIntervalMaximum.SetValue(value as int)
		SetSliderOptionValue(option, CSFightIntervalMaximum.GetValue() as int)
	elseif option == _slider_distance_escape
		CSEscapeDistance.SetValue(value as int)
		SetSliderOptionValue(option, CSEscapeDistance.GetValue() as int, "{0} units")
	elseif option == _slider_distance_retaliate
		Distance_Retaliate = value
		SetSliderOptionValue(option, Distance_Retaliate, "{0} units")
	elseif option == _slider_distance_flee
		Distance_Flee = value
		SetSliderOptionValue(option, Distance_Flee, "{0} units")
	endif
EndEvent

Event OnOptionSelect(int option)
	if option == _text_active
		if !ShowMessage("$Deactivate_" + CSActivated as string, true, "$Yes", "$No")
			return
		endif
		CSActivated = !CSActivated
		DeactivateCS(CSActivated)
	elseif option == _toggle_vampire
		int Opposite = (!(CSVampire.GetValue() as bool)) as int
		CSVampire.SetValue(Opposite)
		SetToggleOptionValue(option, CSVampire.GetValue())
	elseif option == _toggle_race
		Toggle_Race = !Toggle_Race
		SetToggleOptionValue(option, Toggle_Race)
	elseif option == _toggle_confidence
		Toggle_Confidence = !Toggle_Confidence
		SetToggleOptionValue(option, Toggle_Confidence)
	elseif option == _toggle_RNG
		Toggle_RNG = !Toggle_RNG
		SetToggleOptionValue(option, Toggle_RNG)
	elseif option == _toggle_spontaneous_flee
		int Opposite = (!(CSSpontaneousFleeing.GetValue() as bool)) as int
		CSSpontaneousFleeing.SetValue(Opposite)
		SetToggleOptionValue(option, CSSpontaneousFleeing.GetValue())
	elseif option == _toggle_spontaneous_retaliation
		int Opposite = (!(CSSpontaneousRetaliation.GetValue() as bool)) as int
		CSSpontaneousRetaliation.SetValue(Opposite)
		SetToggleOptionValue(option, CSSpontaneousRetaliation.GetValue())
	elseif option == _toggle_activate_bounty
		Toggle_Bounty = !Toggle_Bounty
		SetToggleOptionValue(option, Toggle_Bounty)
	elseif option == _toggle_activate_specialquests
		Toggle_Quests = !Toggle_Quests
		SetToggleOptionValue(option, Toggle_Quests)
	elseif option == _toggle_activate_specialactors
		Toggle_Actors = !Toggle_Actors
		SetToggleOptionValue(option, Toggle_Actors)
	endif
EndEvent

Event OnOptionMenuOpen(int option)
	if option == _menu_yieldmechanism
		SetMenuDialogStartIndex(CSYieldType.GetValue() as int)
		SetMenuDialogDefaultIndex(0)
		SetMenuDialogOptions(YieldMechanismArray)
		ForcePageReset()
	endif
EndEvent

Event OnOptionMenuAccept(int option, int index)
	if option == _menu_yieldmechanism
		CSYieldType.SetValue(index)
		SetMenuOptionValue(option, YieldMechanismArray[index])
		ForcePageReset()
	endif
EndEvent

Function DeactivateCS(bool bToggle)
	if bToggle
		UI.InvokeBool("Journal Menu", "_root.QuestJournalFader.Menu_mc.CloseMenu", false)
		SetDefaultValues()
		CSPlayerAliasQuest.Start()
	else
		CSPlayerAliasQuest.Stop()
		CSVictimAliasQuest.Stop()
	endif
	ForcePageReset()
EndFunction

Function SetDefaultValues()
	CSVampire.SetValue(1)
	CSMaxVictims.SetValue(3)
	CSImmediateSurrender.SetValue(50)
	CSYieldType.SetValue(0)
	CSYieldIntervalMaximum.SetValue(16)
	CSFightIntervalMaximum.SetValue(40)
	CSSpontaneousFleeing.SetValue(1)
	CSSpontaneousRetaliation.SetValue(0)
	CSEscapeDistance.SetValue(10000)
	
	
	Toggle_Race = True
	Toggle_Confidence = True
	Toggle_RNG = True
	
	ActorHealth = 0.1
	Distance_Retaliate = 5000.0
	Distance_Flee = 2000.0

	Toggle_Bounty = True
	Toggle_Quests = True
	Toggle_Actors = False
EndFunction