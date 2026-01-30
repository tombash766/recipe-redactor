class_name Card_Dealer extends Card_Collection

@export var outputContainer : Card_Container

func deal(container : Card_Container = outputContainer) -> void:
	var c = cards.pop_back()
	c.set_position( get_position() )
	container.add_card( c );
	
func is_dealable() -> bool:
	return ( cards.size() > 0 ) and outputContainer.is_addable(cards[-1])

func add_card(c):
	cards.push_front(c)
	add_child(c)
	c.set_position( c.get_position() - get_position() )
	c.targetPos = Vector2()
	c.set_facing(false)
	c.temp = true
