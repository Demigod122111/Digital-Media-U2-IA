class_name Game
extends Node2D

@onready var stamina_bar: TextureRect = %StaminaBar
@onready var stamina_label: RichTextLabel = %StaminaLabel
@onready var stamina_mat: ShaderMaterial = stamina_bar.material

@onready var hunger_bar: TextureRect = %HungerBar
@onready var hunger_label: RichTextLabel = %HungerLabel
@onready var hunger_mat: ShaderMaterial = hunger_bar.material

@onready var money_label: RichTextLabel = %MoneyLabel

var max_stamina := 100.0
var stamina := 100.0
var max_hunger := 100.0
var hunger := 100.0

var money := 0.0

func _ready() -> void:
	GlobalState.game = self

func _process(_delta: float) -> void:
	stamina = min(max(0, stamina), max_stamina)
	var sta := stamina / max_stamina
	stamina_label.text = str(int(roundf(sta * 100))) + "%"
	stamina_mat.set_shader_parameter("fill", sta)
	
	hunger = min(max(0, hunger), max_hunger)
	var hun := hunger / max_hunger
	hunger_label.text = str(int(roundf(hun * 100))) + "%"
	hunger_mat.set_shader_parameter("fill", hun)
	
	money_label.text = "$" + ("%.2f" % money)
