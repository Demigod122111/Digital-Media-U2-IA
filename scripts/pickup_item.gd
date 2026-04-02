@tool
class_name Pickup
extends Sprite2D

@onready var pick_up_manager: PickUpManager = %PickUpManager

func _process(_delta: float) -> void:
	if self.texture == null:
		return
	
	var size = self.texture.get_size()
	
	var sx = 16 / size.x
	var sy = 16 / size.y
	
	self.scale = Vector2(sx, sy)


func _on_area_2d_body_entered(_body: Node2D) -> void:
	pick_up_manager.AddPickupBehaviour(PickUpBehaviour)

func _on_area_2d_body_exited(_body: Node2D) -> void:
	pick_up_manager.RemovePickupBehaviour(PickUpBehaviour)

func PickUpBehaviour():
	pick_up_manager.picked_up_item.remote_path = self.get_path()
