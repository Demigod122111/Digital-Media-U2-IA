class_name Player
extends CharacterBody2D

@export var anim_sheets: Dictionary[StringName, AnimationSheet]
@export var current_anim_state := &"Idle"

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var sprite_2d: Sprite2D = $Sprite2D

var previous_state := &""

var input_direction := Vector2.ZERO

var speed := 100
var sprint_multiplier := 1.35
var sprinting := false

func update_texture() -> void:
	sprite_2d.hframes = anim_sheets[current_anim_state].hframes
	sprite_2d.vframes = anim_sheets[current_anim_state].vframes
	sprite_2d.texture = anim_sheets[current_anim_state].texture
	if sprite_2d.hframes * sprite_2d.vframes >= sprite_2d.frame:
		sprite_2d.frame = 0

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("primary"):
		Input.action_release("primary")
		DialogueManager.call_deferred("show_example_dialogue_balloon", load("res://dialogues/test.dialogue"), "START")

func _physics_process(_delta: float):
	input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	sprinting = Input.get_action_strength("secondary") != 0
	
	update_anim_blend(input_direction)
	
	var multiplier =  sprint_multiplier if sprinting else 1.0
		
	velocity = input_direction * speed * multiplier
	
	if velocity.x < 0:
		sprite_2d.flip_h = false
	elif velocity.x > 0:
		sprite_2d.flip_h = true
	
	move_and_slide()
	pick_new_state()

func update_anim_blend(moveDirection: Vector2):
	if moveDirection != Vector2.ZERO:
		if moveDirection.x != 0:
			moveDirection.y = 0
			
		animation_tree.set("parameters/Idle/blend_position", moveDirection)
		animation_tree.set("parameters/Walk/blend_position", moveDirection)
		#animation_tree.set("parameters/Run/blend_position", moveDirection)

func pick_new_state():
	if (velocity != Vector2.ZERO):
		current_anim_state = &"Walk"
		if sprinting:
			pass
			#state_machine.travel("Run")
		else:
			pass
			#state_machine.travel("Walk")
	else:
		current_anim_state = &"Idle"
	
	if current_anim_state != previous_state:
		previous_state = current_anim_state
		change_state.call_deferred()

func change_state():
	animation_tree.active = false
	
	update_texture()
	sprite_2d.frame = 0
	state_machine.stop()
	state_machine.travel(current_anim_state)
	
	animation_tree.active = true
