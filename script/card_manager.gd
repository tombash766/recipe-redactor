extends Node2D

var selected = false;
var selectedObj = null;

var originalContainer
var cardPreset = preload("res://card.tscn")

var ROT_SPEED = 6
var ROT_AMOUNT = 0.007
var FOLLOW_SPEED = 20
var MAX_VELO = 100
var SPR_SIZE = Vector2(60,87)
var CARD_SIZE = Vector2(120, 174);
var DEAL_DELAY = 0.05
	
var TYPES = [
	func (s): s.shuffle(),
	func (n): str( int(n) * 10 ),
]

var REGS = [
	
]

func _process(_delta: float) -> void:
	pass

func selectCard(c) -> void:
	selected = true;
	selectedObj = c;
	if selectedObj is Card:
		selectedObj.targetPos = selectedObj.targetPos + Vector2(0, -100)
	
func deselect() -> void:
	if selectedObj is Card:
		selectedObj.targetPos = selectedObj.targetPos + Vector2(0, 100)
	selected = false;
	
func get_full_deck(shuffle : bool, faceUp : bool = false) -> Array[Card]:
	var d : Array[Card] = []
	for suit in range(4):
		for rank in range(13):
			d.append(cardPreset.instantiate())
			d[-1].rank = rank
			d[-1].suit = suit
			d[-1].faceUp = faceUp;
			d[-1].z_index = 1;
	if shuffle: d.shuffle()
	return d
	
func deal_delay(t : float = DEAL_DELAY) -> void:
	await get_tree().create_timer(t).timeout
	return

func wiggle_tween(o):
	var t = create_tween()
	t.tween_property(o, "scale", Vector2(0.8,0.8), 0.1)
	t.tween_property(o, "scale", Vector2(1,1), 0.5).set_trans(Tween.TRANS_ELASTIC)

func flip_tween(o, f : Callable):
	var t = create_tween()
	t.tween_property(o, "scale:x", 0, 0.1).set_trans(Tween.TRANS_CIRC)
	t.tween_callback( f )
	t.tween_property(o, "scale:x", 1, 0.1).set_trans(Tween.TRANS_CIRC)
