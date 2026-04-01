extends PathFollow2D


func _process(delta: float) -> void:
	self.progress += delta * 60
