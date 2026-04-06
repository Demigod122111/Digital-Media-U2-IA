class_name Fade
extends CanvasLayer

@onready var panel_container: PanelContainer = $PanelContainer
@onready var mat: ShaderMaterial = panel_container.material

var _tween: Tween
var _is_fading := false

func _ready():
	# Ensure starting invisible
	set_progress(0.0)

func _process(_delta: float) -> void:
	panel_container.visible = get_progress() != 0.0

func set_progress(value: float):
	if mat:
		mat.set_shader_parameter("progress", clamp(value, 0.0, 1.0))

func get_progress() -> float:
	if mat:
		return mat.get_shader_parameter("progress")
	return 0.0

func FadeIn(duration: float) -> void:
	await _fade_to(1.0, duration)

func FadeOut(duration: float) -> void:
	await _fade_to(0.0, duration)

func _fade_to(target: float, duration: float) -> void:
	if _is_fading:
		if _tween:
			_tween.kill()

	_is_fading = true

	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_SINE)
	_tween.set_ease(Tween.EASE_IN_OUT)

	_tween.tween_method(
		func(value): set_progress(value),
		get_progress(),
		target,
		duration
	)

	await _tween.finished

	_is_fading = false
