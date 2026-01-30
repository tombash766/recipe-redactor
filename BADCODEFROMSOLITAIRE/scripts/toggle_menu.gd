class_name Toggle_Menu
extends Control

@export var blur : ColorRect
@export var menu : Menu

@export var positionOffset : float 
 
func _ready():
	pass
	
func on_screen():
	var t = get_tree().create_tween()
	t.tween_method( change_blur, 0.0, 2.0, GameManager.TOGGLE_TIME )
	var s = get_tree().create_tween()
	s.tween_property( menu, "position:y", 0, GameManager.TOGGLE_TIME).set_trans(Tween.TRANS_CUBIC)
	if t: 
		await t.finished
	if s: 
		await s.finished
	
func off_screen():
	var t = get_tree().create_tween()
	t.tween_method( change_blur, 2.0, 0.0, GameManager.TOGGLE_TIME )
	var s = get_tree().create_tween()
	s.tween_property( menu, "position:y", positionOffset, GameManager.TOGGLE_TIME).set_trans(Tween.TRANS_CUBIC)
	if t:
		await t.finished
	if s:
		await s.finished

func change_blur( f : float ):
	blur.get_material().set_shader_parameter("lod",f)
