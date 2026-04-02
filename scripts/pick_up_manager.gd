class_name PickUpManager
extends Node2D

var pickup_behaviour: Array[Callable] = []
var drop_behaviour: Array[Callable] = []

@onready var picked_up_item: Bobbing = %PickedUpItem

func GetCurrentBehaviour() -> Callable:
	if picked_up_item.remote_path.is_empty():
		return GetCurrentPickupBehaviour()
	return GetCurrentDropBehaviour()

func GetCurrentPickupBehaviour() -> Callable:
	if pickup_behaviour.size() > 0:
		return pickup_behaviour[0]
	else:
		return DefaultPickupBehaviour

func GetCurrentDropBehaviour() -> Callable:
	if drop_behaviour.size() > 0:
		return drop_behaviour[0]
	else:
		return DefaultDropBehaviour

func AddPickupBehaviour(callable: Callable):
	if pickup_behaviour.has(callable):
		return
	
	pickup_behaviour.insert(0, callable)

func RemovePickupBehaviour(callable: Callable):
	var idx = pickup_behaviour.find(callable)
	
	if idx >= 0:
		pickup_behaviour.remove_at(idx)

func AddDropBehaviour(callable: Callable):
	if drop_behaviour.has(callable):
		return
	
	drop_behaviour.insert(0, callable)

func RemoveDropBehaviour(callable: Callable):
	var idx = drop_behaviour.find(callable)
	
	if idx >= 0:
		drop_behaviour.remove_at(idx)

func DefaultPickupBehaviour():
	print("Pickup!")

func DefaultDropBehaviour():
	if not picked_up_item.remote_path.is_empty():
		picked_up_item.remote_path = ""
	else:
		return false
	return true
