class_name BehaviourManager
extends Node2D

var behaviours: Array[Behaviour] = []

@onready var picked_up_item: Bobbing = %PickedUpItem
@onready var player: Player = %Player

func _ready() -> void:
	GlobalState.behavior_manager = self

func _process(_delta: float) -> void:
	if not picked_up_item.remote_path.is_empty():
		var item = get_node(picked_up_item.remote_path) as Pickup
		GlobalState.picked_up_item = item
	else:
		GlobalState.picked_up_item = null

func CallCurrentBehaviour():
	if behaviours.size() != 0:
		var behaviour = behaviours[0];
		behaviour.Func.call()
		RemoveBehaviour(behaviour.Func)

func NoneBehaviour():
	pass

func AddBehaviour(type: BehaviourType, callable: Callable):
	for b in behaviours:
		if b.Func == callable:
			return
	
	var behaviour = Behaviour.new()
	behaviour.Type = type
	behaviour.Func = callable
	behaviours.insert(0, behaviour)

func RemoveBehaviour(callable: Callable):
	var i := 0
	for b in behaviours:
		if b.Func == callable:
			behaviours.remove_at(i)
		i += 1

func DefaultDropBehaviour():
	if not picked_up_item.remote_path.is_empty():
		var node = get_node(picked_up_item.remote_path) as Node2D
		picked_up_item.remote_path = ""
		node.set_deferred("position", player.position)
	else:
		return false
	return true

func DestroyPickedUpItem():
	if not picked_up_item.remote_path.is_empty():
		var node = get_node(picked_up_item.remote_path) as Node2D
		picked_up_item.remote_path = ""
		node.free.call_deferred()

enum BehaviourType {
	PICKUP,
	DROP,
	NPC,
	UNKNOWN
}
class Behaviour:
	var Type: BehaviourType
	var Func: Callable
