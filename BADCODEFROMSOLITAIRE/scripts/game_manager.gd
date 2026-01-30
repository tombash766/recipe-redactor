extends Node2D

var isPaused = false
var hasWon = false

var TRANS_TIME = 0.7
var TOGGLE_TIME = 0.5

func win():
	hasWon = true
	await get_tree().current_scene.win()

func start_game( path : String ) -> void:
	await get_tree().current_scene.trans_off()
	get_tree().change_scene_to_file(path)
	hasWon = false
	
func toggle_pause():
	if hasWon: return
	if get_tree().current_scene.has_method("pause"):
		if isPaused:
			await get_tree().current_scene.unpause()
		else:
			await get_tree().current_scene.pause()
		isPaused = !isPaused
