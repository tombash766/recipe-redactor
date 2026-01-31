class_name Card_Collection extends Node2D

var cards = []
@export var faceUp = false

func add_card(c : Card) -> void:
	cards.push_back(c)
	
func get_amount() -> int:
	return cards.size()
