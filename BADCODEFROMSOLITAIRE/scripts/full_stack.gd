class_name Full_Stack extends Card_Stack

func _ready() -> void:
	faceUp = false
	cards = CardManager.get_full_deck(true)
	if faceUp:
		var t = find_child("cardsTex")
		t.set_texture( load("res://cards.png") )
		t.region_enabled = true
		updateFace()
 
func updateFace() -> void:
	var fCard = cards[-1]
	find_child("cardsTex").region_rect = Rect2(
		fCard * CardManager.SPR_SIZE.x,
		fCard.suit * CardManager.SPR_SIZE.y,
		CardManager.SPR_SIZE.x,
		CardManager.SPR_SIZE.y
	)

func get_card() -> Card:
	cards[-1].set_position( get_position() )
	cards[-1].faceUp = faceUp
	if cards.size() <= 1:
		set_visible( false )
	if faceUp: 
		updateFace()
	return cards.pop_back()
	
func replace_card(c):
	cards.push_back(c);
	
func is_addable(_c : Card) -> bool:
	return false
