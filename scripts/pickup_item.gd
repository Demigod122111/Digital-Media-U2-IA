@tool
class_name Pickup
extends Sprite2D

@onready var behaviour_manager: BehaviourManager = %BehaviourManager

func _process(_delta: float) -> void:
	if self.texture == null:
		return
	
	var size = self.texture.get_size()
	
	var sx = 16 / size.x
	var sy = 16 / size.y
	
	self.scale = Vector2(sx, sy)


func _on_area_2d_body_entered(_body: Node2D) -> void:
	behaviour_manager.AddBehaviour(BehaviourManager.BehaviourType.PICKUP, PickUpBehaviour)

func _on_area_2d_body_exited(_body: Node2D) -> void:
	behaviour_manager.RemoveBehaviour(PickUpBehaviour)

func PickUpBehaviour():
	behaviour_manager.picked_up_item.remote_path = self.get_path()
	behaviour_manager.AddBehaviour(BehaviourManager.BehaviourType.DROP, behaviour_manager.DefaultDropBehaviour)

func GetName():
	return self.name
