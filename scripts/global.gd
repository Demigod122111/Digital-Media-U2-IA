extends Node2D

var game: Game
var behavior_manager: BehaviourManager
var picked_up_item: Pickup

var PaidKyle := false

func GetPickupName() -> String:
	if not picked_up_item:
		return ""
	return picked_up_item.GetName()
