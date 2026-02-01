class_name Hand extends Card_Container

@export var width = 1000;

var ANGLEOFFSET = 0.01

func _ready():
	for c in CardManager.get_full_deck():
		add_card(c)
		await CardManager.deal_delay(0.2)
	CardManager.update_helper()
	
func add_card(c : Card) -> void:
	cards.push_back(c)
	add_child(c)
	c.set_position( c.get_position() - get_position() )
	c.z_index = get_amount() * 2 + 10
	c.targetPos = get_position()
	c.set_facing(true)
	distribute_cards()

func delete_card(c : Card):
	cards.erase(c)
	remove_child(c)
	c.queue_free()
	distribute_cards()

func remove_card(c : Card):
	cards.erase(c)
	remove_child(c)
	c.set_position( c.get_position() + get_position() )
	distribute_cards()
	
func get_card() -> Card:
	return cards.pop_back()
	
func distribute_cards():
	var n = get_amount()
	if n == 0: return
	if n > 1:
		var radius = width * 50  # tune this
		for i in range(n):
			var t := i / float(n - 1)
			var ang = lerp(-ANGLEOFFSET, ANGLEOFFSET, t)

			cards[i].targetRot = -ang
			cards[i].targetPos = Vector2(
				sin(ang) * radius,
				(1.0 - cos(ang)) * radius
			)
	else:
		cards[0].targetPos = Vector2()
		
		
