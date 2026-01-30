class_name Card_Container extends Card_Collection

@export var harshFacing = true;
@export var blockAdd = false;
@export var blockGet = false;

func add_card(c : Card) -> void:
	cards.push_back(c);
	add_child(c)
	c.set_position( c.get_position() - get_position() )
	c.targetPos = Vector2()
	c.z_index = 0
	if harshFacing: c.set_facing(faceUp)

func get_card() -> Card:
	return cards.pop_back()

func replace_card(c : Card) -> void:
	add_card(c)
	
func get_facing() -> bool:
	return faceUp

func is_addable(_c : Card) -> bool:
	return !blockAdd

func is_getable() -> bool:
	return !blockGet and get_amount() >= 1
