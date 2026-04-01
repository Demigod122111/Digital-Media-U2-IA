class_name Bobbing
extends RemoteTransform2D

@export var amplitude := 1
@export var speed := 10

var timer := 0.0
var y := 0.0

func _ready() -> void:
	y = self.position.y

func _process(delta: float) -> void:
	timer += delta
	if timer >= PI * 2:
		timer -= PI * 2
	
	self.position.y = y + amplitude * sin(speed * timer)
