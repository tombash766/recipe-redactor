class_name Card_Stack extends Card_Container

@export var offset = Vector2(0,35)
@export var maxCards = 52

var stackTop
signal is_full
signal card_added
signal card_removed

func _ready():
	stackTop = find_child("StackTop")
	cards = CardManager.get_full_deck()

func add_card(c):
	super.add_card(c)
	c.targetPos = offset * ( get_amount() - 1 )
	CardManager.wiggle_tween(c)
	if get_amount() == maxCards:
		is_full.emit()
	card_added.emit()
	update_stack_top()

func get_card() -> Card:
	var c = cards.pop_back()
	remove_child(c)
	c.set_position( c.get_position() + get_position() )
	update_stack_top()
	card_removed.emit()
	return c

func update_stack_top() -> void:
	stackTop.set_position( offset * max(0, cards.size() - 1) )

func is_addable(_c : Card) -> bool:
	return !blockAdd and cards.size() < maxCards

func notify_remove():
	pass	

func set_facing(fu : bool):
	faceUp = fu
	if harshFacing:
		for card in cards:
			card.set_facing(fu)
			CardManager.deal_delay()

func get_is_full() -> bool:
	return get_amount() == maxCards
