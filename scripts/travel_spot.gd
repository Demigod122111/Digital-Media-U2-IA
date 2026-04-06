extends Area2D

@onready var travel: Travel = %Travel

func _on_body_entered(_body: Node2D) -> void:
	travel.ShowMenu()

func _on_body_exited(_body: Node2D) -> void:
	travel.HideMenu()
