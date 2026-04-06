class_name NPC
extends CharacterBody2D

@export var anim_sheets: Dictionary[StringName, AnimationSheet]
@export var current_anim_state := &"Idle"

@export var PathFollow: NPCPathFollow2D
@onready var player: Player = %Player

@export var dialogue: DialogueResource
@onready var behaviour_manager: BehaviourManager = %BehaviourManager

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var sprite_2d: Sprite2D = $Sprite2D

var previous_state := &""

var input_direction := Vector2.ZERO
var last_position := Vector2.ZERO

var speed := 100
var sprint_multiplier := 1.35
var sprinting := false
var can_move := true

func _ready() -> void:
	last_position = PathFollow.global_position

func update_texture() -> void:
	sprite_2d.hframes = anim_sheets[current_anim_state].hframes
	sprite_2d.vframes = anim_sheets[current_anim_state].vframes
	sprite_2d.texture = anim_sheets[current_anim_state].texture
	if sprite_2d.hframes * sprite_2d.vframes >= sprite_2d.frame:
		sprite_2d.frame = 0

func _process(_delta: float) -> void:
	PathFollow.can_move = can_move

func _physics_process(_delta: float):
	var current_position = PathFollow.global_position
	input_direction = (current_position - last_position).normalized()
	last_position = current_position
	
	sprinting = randi_range(0, 1) != 0
	
	update_anim_blend(input_direction)
	
	var multiplier =  sprint_multiplier if sprinting else 1.0
		
	velocity = input_direction * speed * multiplier
	
	move_and_slide()
	pick_new_state()

func update_anim_blend(moveDirection: Vector2):
	if moveDirection != Vector2.ZERO:
		if abs(moveDirection.x) == abs(moveDirection.y):
			moveDirection.y = 0
		elif abs(moveDirection.x) < abs(moveDirection.y):
			moveDirection.x = 0
		else:
			moveDirection.y = 0
		
		if moveDirection.x < 0:
			sprite_2d.flip_h = false
		elif moveDirection.x > 0:
			sprite_2d.flip_h = true
		
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


func _on_area_2d_body_entered(_body: Node2D) -> void:
	behaviour_manager.AddBehaviour(BehaviourManager.BehaviourType.NPC, InteractBehaviour)


func _on_area_2d_body_exited(_body: Node2D) -> void:
	behaviour_manager.RemoveBehaviour(InteractBehaviour)

func InteractBehaviour():
	if dialogue:
		can_move = false
		player.can_move = false
		update_anim_blend((player.position - self.position).normalized())
		player.update_anim_blend((self.position - player.position).normalized())
		DialogueManager.show_example_dialogue_balloon(dialogue)
		await DialogueManager.dialogue_ended
		can_move = true
		player.can_move = true
