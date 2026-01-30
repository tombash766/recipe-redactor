class_name Card
extends Node2D

@export var rank = 0
@export var suit = 0 
@export var temp = false	

var faceUp;
var targetPos;
var back_tex
var tex

func _ready() -> void:
	tex = find_child("CardTex");
	tex.set_frame(suit * 13 + rank);
	back_tex = find_child("BackTex")
	back_tex.set_visible(!faceUp)
	tex.set_visible(faceUp)
	if targetPos == null:
		targetPos = get_position()

func _process(delta: float) -> void:
	var p = get_position()
	var posDiff = (targetPos - p).limit_length( CardManager.MAX_VELO )
	if temp and posDiff.length_squared() < 0.01:
		get_parent().remove_child(self)
		temp = false
	set_position( lerp(p, p + posDiff, 
		delta * CardManager.FOLLOW_SPEED)
	)
	set_rotation( lerp(get_rotation(), 
		posDiff.x * CardManager.ROT_AMOUNT,
		delta * CardManager.ROT_SPEED
	) )

func set_facing(fu : bool):
	faceUp = fu
	CardManager.flip_tween(self, func(): back_tex.set_visible(!fu); tex.set_visible(fu))
	
func get_info() -> String:
	return "[" + CardManager.SUITS[suit] + CardManager.RANKS[rank] + "]"
