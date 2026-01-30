class_name Deck extends Card_Dealer

func _ready():
	faceUp = false;
	cards = CardManager.get_full_deck(true)
