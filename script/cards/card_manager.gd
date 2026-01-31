extends Node2D

var cardSelected = false;
var selectedCard = null;
var cardContainer = null;

var modifiers = []
var deformations = []

var arguments = []
var recipe
var originalContainer
var cardPresets = [
	preload("res://scenes/cards/shuffle_card.tscn"),
	preload("res://scenes/cards/swap_card.tscn"),
	preload("res://scenes/cards/mult_card.tscn"),
	preload("res://scenes/cards/word_card.tscn"),
	preload("res://scenes/cards/ghost_card.tscn")
	]
var dealer

var ROT_SPEED = 6
var ROT_AMOUNT = 0.007
var FOLLOW_SPEED = 20
var MAX_VELO = 100
var SPR_SIZE = Vector2(60,87)
var CARD_SIZE = Vector2(120, 174);
var DEAL_DELAY = 0.05
var WORDLIST = [
	"oven",
	"celsius",
	"fahrenheit",
	"blend",
	"banana",
	"eggs",
	"cook",
	"heat",
	"simmer",
	"molotov"
]

func findDealer():
	dealer = $"/root/Encrypt/Dealer"
	
	
func _process(_delta: float) -> void:
	pass

func selectCard(c) -> void:
	cardSelected = true;
	selectedCard = c;
	cardContainer = c.get_parent();
	arguments = []
	if selectedCard is ModCard:
		modifiers.push_back( selectedCard.get_mod() )
		recycleCard(selectedCard)
	if selectedCard is Card:
		wiggle_tween(selectedCard)
		selectedCard.targetPos = selectedCard.targetPos + Vector2(0, -100)
	
func recycleCard(c):
	deselect()
	cardContainer.delete_card(c)
	cardContainer.add_card(get_random_card())
	
func deselect() -> void:
	if selectedCard is Card:
		selectedCard.targetPos = selectedCard.targetPos + Vector2(0, 100)
	cardSelected = false;
	
func get_random_card():
	if dealer == null : findDealer()
	var ind = randi() % len(cardPresets)
	var c = cardPresets[ind].instantiate()
	if c is ModCard:
		cardPresets.remove_at(ind)
	c.set_position( dealer.get_position() )
	c.faceUp = false
	return c
	
func get_full_deck():
	var d = []
	for i in range(5):
		d.push_back( get_random_card() )
	return d
	
func deal_delay(t : float = DEAL_DELAY) -> void:
	await get_tree().create_timer(t).timeout
	return
	
func submit_word(w):
	if cardSelected && selectedCard.reg.search(w["word"]) != null:
		arguments.push_back(w)
		if len(arguments) == selectedCard.numArgs:
			$"/root/Encrypt".points += 10
			$"/root/Encrypt/Points".text = str($"/root/Encrypt".points)
			recipe.replace_words(arguments.duplicate(true), selectedCard.distort(arguments))
			recycleCard(selectedCard)
			arguments = []
			$"/root/Encrypt/ScrollContainer/Recipe".syntax_highlighter.ranges.clear()
		else:
			$"/root/Encrypt/ScrollContainer/Recipe".syntax_highlighter.ranges.push_back({
				"line": w["line"],
				"start": w["charInd"] - 1 - len(w["word"]),
				"end": w["charInd"] - 1,
				"color": Color.AQUAMARINE
			})
		
		# what follows is a dumb hack to force refresh (without changing caret and scroll)
		var te = $"/root/Encrypt/ScrollContainer/Recipe"
		var v = te.scroll_vertical
		var h = te.scroll_horizontal
		var c = te.get_caret_column()
		var l = te.get_caret_line()

		$"/root/Encrypt/ScrollContainer/Recipe".syntax_highlighter.clear_highlighting_cache()
		te.text = te.text

		te.set_caret_line(l)
		te.set_caret_column(c)
		te.scroll_vertical = v
		te.scroll_horizontal = h
	
func wiggle_tween(o):
	var t = create_tween()
	t.tween_property(o, "scale", Vector2(0.8,0.8), 0.1)
	t.tween_property(o, "scale", Vector2(1,1), 0.5).set_trans(Tween.TRANS_ELASTIC)

func flip_tween(o, f : Callable):
	var t = create_tween()
	t.tween_property(o, "scale:x", 0, 0.1).set_trans(Tween.TRANS_CIRC)
	t.tween_callback( f )
	t.tween_property(o, "scale:x", 1, 0.1).set_trans(Tween.TRANS_CIRC)
