extends Node2D

signal game_finished()

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
	
	await get_tree().create_timer(2).timeout
	
	var intermission = load("res://scenes/intermission.tscn").instantiate()
	intermission.local_recipe = $ScrollContainer.get_node("Recipe").text
	intermission.local_deformations = $ScrollContainer.get_node("Recipe").deformations
	get_tree().get_root().add_child(intermission)
	queue_free()
