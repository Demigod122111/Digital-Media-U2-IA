extends CollisionShape2D

func _process(_delta: float) -> void:
	self.disabled = Input.is_action_pressed("secondary")
