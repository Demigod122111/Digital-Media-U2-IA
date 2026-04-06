class_name PauseManager
extends CanvasLayer

@onready var panel_container: PanelContainer = $PanelContainer

var isPaused := false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Toggle()

func _process(_delta: float) -> void:
	panel_container.visible = isPaused
	get_tree().paused = isPaused

func Unpause():
	isPaused = false

func Pause():
	isPaused = true

func Toggle():
	isPaused = !isPaused


func _on_resume_pressed() -> void:
	Unpause()

func _on_main_menu_pressed() -> void:
	pass

func _on_quit_pressed() -> void:
	get_tree().quit.call_deferred()
