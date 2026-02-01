@abstract class_name Card
extends Node2D

var typeInd
var numArgs
var reg
var regDesc
var desc

var faceUp = false
var targetPos;
var targetRot;
var back_tex
var tex
var used = false

func apply(args):
	for arg in args:
		if ( reg.search(arg) == null ):
			assert (false)
			return
	assert ( len(args) == numArgs )
	return distort(args)
	
@abstract func distort(args)

@abstract func setCardProps()

func _ready() -> void:
	setCardProps()
	tex = find_child("CardTex");
	if tex is AnimatedSprite2D:
		tex.set_frame(typeInd);
	back_tex = find_child("BackTex")
	back_tex.set_visible(!faceUp)
	tex.set_visible(faceUp)
	if targetPos == null:
		targetPos = get_position()
	if targetRot == null:
		targetRot = 0

func _process(delta: float) -> void:
	if used: return
	var p = get_position()
	var posDiff = (targetPos - p).limit_length( CardManager.MAX_VELO )
	set_position( lerp(p, p + posDiff, 
		delta * CardManager.FOLLOW_SPEED)
	)
	set_rotation( lerp( get_rotation() - targetRot , 
		posDiff.x * CardManager.ROT_AMOUNT,
		delta * CardManager.ROT_SPEED
	) )

func set_facing(fu : bool):
	faceUp = fu
	CardManager.flip_tween(self, func(): back_tex.set_visible(!fu); tex.set_visible(fu))
	
func get_info() -> String:
	return "[" + str(typeInd) + "]"
	
func use_card(p):
	used = true
	CardManager.card_use_tween(self, p)
	
