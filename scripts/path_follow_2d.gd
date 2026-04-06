class_name NPCPathFollow2D
extends PathFollow2D

@export_range(0.0, 1.0, 0.01) var chanceToMove: float = 0.75
@export var speed: float = 60.0
@export var noise_scale: float = 0.01
@export var time_scale: float = 1.0

@export var min_walk_time: float = 4.0
@export var min_stop_time: float = 2.0
@export var max_stop_time: float = 5.0
@export var can_move: bool = true

@onready var noise := FastNoiseLite.new()

var time := 0.0
var stop_timer := 0.0
var walk_timer := 0.0
var is_stopped := false


func _ready():
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 1.0


func _process(delta: float) -> void:
	time += delta * time_scale

	# If currently stopped -> count down timer
	if is_stopped:
		stop_timer -= delta
		if stop_timer <= 0.0:
			is_stopped = false
			walk_timer = min_walk_time
		return
	else:
		walk_timer -= delta
		if walk_timer < 0.0:
			walk_timer = 0.0

	# Noise evaluation
	var x = progress * noise_scale
	var y = time
	
	var noise_val = noise.get_noise_2d(x, y)
	var normalized = (noise_val + 1.0) * 0.5
	
	# Decide to stop
	if not can_move or (normalized > chanceToMove and walk_timer == 0):
		is_stopped = true
		stop_timer = randf_range(min_stop_time, max_stop_time)
		return

	# Otherwise move
	progress += speed * delta
