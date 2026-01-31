extends Node2D

signal game_finished()

var points = 10

func _ready():
	$ScrollContainer.hide()
	$StartCountdown.text = "3"
	await get_tree().create_timer(1).timeout
	$StartCountdown.text = "2"
	await get_tree().create_timer(1).timeout
	$StartCountdown.text = "1"
	await get_tree().create_timer(1).timeout
	$StartCountdown.text = "GO!"
	await get_tree().create_timer(1).timeout
	$StartCountdown.text = ""
	$ScrollContainer.show()
	$Timer.start()

func _process(delta: float) -> void:
	if !$Timer.is_stopped():
		$RemainingCountdown.text = "%1.1f" % $Timer.time_left

func on_timer_expire():
	$ScrollContainer.process_mode = Node.PROCESS_MODE_DISABLED
	$StartCountdown.text = "TIME UP"
	
	await get_tree().create_timer(4).timeout
	
	var intermission = load("res://scenes/intermission.tscn").instantiate()
	intermission.local_recipe = $ScrollContainer/Recipe.text
	intermission.local_deformations = $ScrollContainer/Recipe.deformations
	intermission.points = points
	get_tree().get_root().add_child(intermission)
	queue_free()
