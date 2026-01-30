extends Node2D
signal loaded 

@export var pauseMenu : Toggle_Menu;
@export var winMenu : Toggle_Menu;
	
func trans_on() -> void:
	set_position( Vector2(1500, 0) )
	var t = get_tree().create_tween()
	t.tween_property(self, "position:x", 0, GameManager.TRANS_TIME).set_trans(Tween.TRANS_CUBIC)
	await t.finished
	loaded.emit()

func trans_off():
	await get_tree().create_tween().tween_property(self, "position:x", 1500, GameManager.TRANS_TIME).set_trans(Tween.TRANS_CUBIC).finished

func unpause():
	await pauseMenu.off_screen()
	
func pause():
	await pauseMenu.on_screen()

func win():
	await winMenu.on_screen()
