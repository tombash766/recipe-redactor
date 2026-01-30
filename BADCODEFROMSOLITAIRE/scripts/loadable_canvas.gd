extends CanvasLayer

func trans_off():
	var t = get_tree().create_tween()
	t.tween_property( self, "offset:x", 1000, GameManager.TRANS_TIME).set_trans(Tween.TRANS_CUBIC)
	await t.finished

func trans_on():
	set_offset(Vector2(0,500))
	var t = get_tree().create_tween()
	t.tween_property(self, "offset:y", 0, GameManager.TRANS_TIME).set_trans(Tween.TRANS_CUBIC)
	await t.finished

func _ready():
	trans_on()
