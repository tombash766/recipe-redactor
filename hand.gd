class_name Hand extends Card_Container

@export var width = 1000;

func _ready():
	for c in CardManager.get_full_deck(true).slice(0,5):
		add_card(c)
	
func add_card(c : Card) -> void:
	cards.push_back(c)
	add_child(c)
	c.set_position( c.get_position() - get_position() )
	c.z_index = get_amount()
	c.set_facing(true)
	distribute_cards()

func get_card() -> Card:
	print("getting card")
	return cards.pop_back()
	
func distribute_cards():
	for i in range(get_amount()):
		cards[i].targetPos = Vector2(-width / 2, 0) + Vector2(width, 0) * i / get_amount()
	
