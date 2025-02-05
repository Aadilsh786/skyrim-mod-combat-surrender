Scriptname CSCombatStateChange extends ActiveMagicEffect

Actor Property PlayerREF Auto

MiscObject Property CSDummyItem Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)	
	PlayerREF.AddItem(CSDummyItem, 1, True)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	PlayerREF.RemoveItem(CSDummyItem, PlayerREF.GetItemCount(CSDummyItem), True)
EndEvent