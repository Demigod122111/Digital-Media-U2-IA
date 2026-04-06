class_name Travel
extends Control

@export var PlayerBody: Player
@export var Locations: Array[TravelLocation]
@onready var fade: Fade = %Fade

@onready var center_container: CenterContainer = $CenterContainer
@onready var location_button: Button = $LocationButton
@onready var v_box_container: VBoxContainer = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer

var btns: Dictionary[StringName, Button]
var current_location = &"Home"

func _ready() -> void:
	HideMenu()

func _process(_delta: float) -> void:
	var keys: Array[StringName] = []
	for location in Locations:
		keys.push_back(location.Name)
		if not btns.has(location.Name):
			var btn = location_button.duplicate()
			v_box_container.add_child(btn)
			btn.text = location.Name
			btn.visible = true
			btns[location.Name] = btn
			btn.connect("pressed", func(): travelTo(location))
	
	for btn in btns:
		if not keys.has(btn):
			btns[btn].queue_free()
			btns.erase(btn)
		
		btns[btn].disabled = btn == current_location

func travelTo(place: TravelLocation):
	await fade.FadeIn(3)
	current_location = place.Name
	PlayerBody.position = place.Point
	PlayerBody.update_anim_blend(place.Facing)
	await fade.FadeOut(3)

func ShowMenu():
	center_container.show()

func HideMenu():
	center_container.hide()
