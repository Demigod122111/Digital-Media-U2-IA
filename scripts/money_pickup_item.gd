@tool
class_name MoneyPickup
extends Pickup

@export var Amount := 250.0

@onready var dialogue = DialogueManager.create_resource_from_text("You found $" + ("%.2f" % Amount) + "!")

func PickUpBehaviour():
	GlobalState.game.money += Amount
	queue_free()
	DialogueManager.show_example_dialogue_balloon(dialogue)
