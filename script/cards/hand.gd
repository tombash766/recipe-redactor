class_name Hand extends Card_Container

@export var width = 1000;

var ANGLEOFFSET = 0.01

func _ready():
	for c in CardManager.get_full_deck():
		add_card(c)
		await CardManager.deal_delay(0.2)
	
func add_card(c : Card) -> void:
	cards.push_back(c)
	add_child(c)
	c.set_position( c.get_position() - get_position() )
	c.z_index = get_amount()
	c.targetPos = get_position()
	c.set_facing(true)
	distribute_cards()

func delete_card(c : Card):
	cards.erase(c)
	remove_child(c)
	c.queue_free()
	distribute_cards()
	
func get_card() -> Card:
	return cards.pop_back()
	
func distribute_cards():
	var n = get_amount()
	if n == 0: return
	if n > 1:
		for i in range(n):
			cards[i].targetPos = Vector2( -width / float(2), 0) + Vector2(width, 0) * i / ( n - 1 )
			cards[i].targetRot = ( ANGLEOFFSET * n ) * ( 0.5 - ( i / float(n-1) ) )
	else:
		cards[0].targetPos = Vector2()
		
		
