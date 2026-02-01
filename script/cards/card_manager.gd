extends Node2D

var cardSelected = false;
var selectedCard = null;
var cardContainer = null;

var modifiers = []
var deformations = []

var arguments = []
var recipe
var dealer
var helper

var cardPresets = [
	preload("res://scenes/cards/shuffle_card.tscn"),
	preload("res://scenes/cards/swap_card.tscn"),
	preload("res://scenes/cards/mult_card.tscn"),
	preload("res://scenes/cards/word_card.tscn"),
	preload("res://scenes/cards/ghost_card.tscn"),
	preload("res://scenes/time_card.tscn")
]

var ROT_SPEED = 6
var ROT_AMOUNT = 0.007
var FOLLOW_SPEED = 9
var MAX_VELO = 200
var SPR_SIZE = Vector2(61,87)
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
	"314",
	"420",
	"destroy",
	"mustard",
	"the",
	"molotov"
]

func findDealer():
	dealer = $"/root/Encrypt/Dealer"
	helper = $"/root/Encrypt/Helper"

func selectCard(c) -> void:
	cardSelected = true;
	selectedCard = c;
	cardContainer = c.get_parent();
	arguments = []
	if selectedCard is ModCard:
		if selectedCard is AddCard:
			add_points(5)
		else:
			modifiers.push_back( selectedCard.get_mod() )
		recycleCard(selectedCard)
	elif selectedCard is Card:
		wiggle_tween(selectedCard)
		selectedCard.targetPos = selectedCard.targetPos + Vector2(0, -100)
	update_helper()
	
func recycleCard(c):
	deselect()
	cardContainer.remove_card(c)
	cardContainer.add_sibling(c)
	c.use_card( get_global_mouse_position() )
	cardContainer.add_card(get_random_card())
	
func deselect() -> void:
	if selectedCard is Card:
		selectedCard.targetPos = selectedCard.targetPos + Vector2(0, 100)
	cardSelected = false;
	remove_arg_highlights()
	
func get_random_card():
	if dealer == null : findDealer()
	var ind = randi() % len(cardPresets)
	var c = cardPresets[ind].instantiate()
	if c is ModCard:
		ind = randi() % len(cardPresets)
		c = cardPresets[ind].instantiate()
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

func remove_arg_highlights():
	for arg in arguments:
			var j = 0
			var ranges = $"/root/Encrypt/ScrollContainer/Recipe".syntax_highlighter.ranges
			while j < len(ranges):
				if arg["line"] == ranges[j].line && arg["charInd"] == ranges[j].end:
					ranges.remove_at(j)
				else:
					j += 1

func add_points(n):
	$"/root/Encrypt".points += n
	$"/root/Encrypt/Points".text = str($"/root/Encrypt".points)
	$"/root/Encrypt/PointDelta".add_points_anim(n)

func submit_word(w):
	if !cardSelected || selectedCard.reg.search(w["word"]) == null:
		return
		
	var te = $"/root/Encrypt/ScrollContainer/Recipe"
	var v = te.scroll_vertical
	var h = te.scroll_horizontal
	var c = te.get_caret_column()
	var l = te.get_caret_line()
	
	arguments.push_back(w)
	if len(arguments) == selectedCard.numArgs:
		add_points(10)
		var distorted = selectedCard.distort(arguments.duplicate(true))
		recipe.replace_words(arguments.duplicate(true), distorted)
		recycleCard(selectedCard)
		remove_arg_highlights()
		
		# EXTREME HACKS AHEAD
		var i = 0
		var ranges = $"/root/Encrypt/ScrollContainer/Recipe".syntax_highlighter.ranges
		var prev_delta = 0 # massive hack, sorry
		var prev_line = 0
		var prev_end = 0
		for arg in arguments:
			var start = arg["charInd"] - len(arg["word"])
			var end = arg["charInd"] - len(arg["word"]) + len(distorted[i]["word"])
			if arg["line"] == prev_line && arg["charInd"] >= prev_end:
				start += prev_delta
				end += prev_delta
			var delta = len(distorted[i]["word"]) - len(arg["word"])
			
			# shift all existing highlights after this one, because length may differ
			for r in ranges:
				if r.line == arg["line"] && r.start >= arg["charInd"]:
					r.start += delta
					r.end += delta
			
			# add new highlight
			ranges.push_back({
				"line": arg["line"],
				"start": start,
				"end": end,
				"color": Color.ORANGE
			})
			i += 1
			prev_delta = delta
			prev_line = arg["line"]
			prev_end = end
		arguments = []
	else:
		$"/root/Encrypt/ScrollContainer/Recipe".syntax_highlighter.ranges.push_back({
			"line": w["line"],
			"start": w["charInd"] - len(w["word"]),
			"end": w["charInd"],
			"color": Color.AQUAMARINE
		})
	update_helper()
	
	# what follows is a dumb hack to force refresh (without changing caret and scroll)
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

func err_tween(o):
	var start = o.get_position()
	var t = create_tween()
	t.tween_property(o, "position", start + Vector2(0, -8), 0.05)
	t.tween_property(o, "position", start + Vector2(0,  8), 0.05)
	t.tween_property(o, "position", start, 0.2).set_trans(Tween.TRANS_ELASTIC)
	
func card_use_tween(o, p):
	var t = create_tween()
	t.tween_property(o, "position", p, 0.2).set_ease(Tween.EASE_OUT)
	t.tween_property(o, "scale", Vector2(0, 0), 0.3).set_trans(Tween.TRANS_CUBIC)
	t.finished.connect(o.queue_free)
	
func update_helper(s = null, err = false):
	var msg = ""
	if s != null:
		msg = s
	elif cardSelected:
		var n = selectedCard.numArgs - len(arguments)
		msg = "select %s more word" % n + ("s" if n != 1 else "")
	else:
		msg = "select a card"
	if err:
		helper.set_text("[color=#FF0000]%s[/color]" % msg)
		err_tween(helper)
	else:
		helper.set_text("[wave amp=50 freq=3]%s[/wave]" % msg)
		
func reset_game():
	cardSelected = false;
	selectedCard = null;
	cardContainer = null;
	modifiers = []
	deformations = []
	arguments = []
	
