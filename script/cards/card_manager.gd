extends Node2D

var cardSelected = false;
var selectedCard = null;

var arguments = []
var recipe
var originalContainer
var cardPresets = [
	preload("res://scenes/cards/shuffle_card.tscn"),
	preload("res://scenes/cards/swap_card.tscn")
	
	]

var ROT_SPEED = 6
var ROT_AMOUNT = 0.007
var FOLLOW_SPEED = 20
var MAX_VELO = 100
var SPR_SIZE = Vector2(60,87)
var CARD_SIZE = Vector2(120, 174);
var DEAL_DELAY = 0.05

func _process(_delta: float) -> void:
	pass

func selectCard(c) -> void:
	cardSelected = true;
	selectedCard = c;
	arguments = []
	if selectedCard is Card:
		wiggle_tween(selectedCard)
		selectedCard.targetPos = selectedCard.targetPos + Vector2(0, -100)
	
func deselect() -> void:
	if selectedCard is Card:
		selectedCard.targetPos = selectedCard.targetPos + Vector2(0, 100)
	cardSelected = false;
	
func get_full_deck():
	var d = []
	for i in range( len(cardPresets) ):
		var c = cardPresets[i].instantiate()
		c.faceUp = false
		d.push_back(c)
	return d
	
func deal_delay(t : float = DEAL_DELAY) -> void:
	await get_tree().create_timer(t).timeout
	return
	
func submit_word(w):
	if cardSelected:
		print(selectedCard.reg.search(w["word"]))
	if cardSelected && selectedCard.reg.search(w["word"]) != null:
		# don't allow two distortions on one word
		arguments.push_back(w)
		if len(arguments) == selectedCard.numArgs:
			recipe.replace_words(arguments, selectedCard.distort(arguments))
			deselect()
			selectedCard.queue_free()
			arguments = []
	
func wiggle_tween(o):
	var t = create_tween()
	t.tween_property(o, "scale", Vector2(0.8,0.8), 0.1)
	t.tween_property(o, "scale", Vector2(1,1), 0.5).set_trans(Tween.TRANS_ELASTIC)

func flip_tween(o, f : Callable):
	var t = create_tween()
	t.tween_property(o, "scale:x", 0, 0.1).set_trans(Tween.TRANS_CIRC)
	t.tween_callback( f )
	t.tween_property(o, "scale:x", 1, 0.1).set_trans(Tween.TRANS_CIRC)
