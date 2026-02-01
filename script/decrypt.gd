extends Control

var deformations
var found_deformations = []
var points
var hl := preload("res://script/word_highlighter.gd").new()
var first = true # hack

func _ready():
	$ScrollContainer/Recipe.syntax_highlighter = hl
	$Timer.start()

func _process(delta: float) -> void:
	if !$Timer.is_stopped():
		$RemainingCountdown.text = "%1.1f" % $Timer.time_left
		if $RemainingCountdown.text.ends_with("0"):
			$RemainingCountdown/AnimationPlayer.current_animation = "time_flash"

func on_timer_expire():
	$ScrollContainer.process_mode = Node.PROCESS_MODE_DISABLED
	$StartCountdown.text = "TIME UP"
	
	await get_tree().create_timer(2).timeout
	
	if multiplayer.is_server():
		set_points.rpc(points)

@rpc("any_peer", "call_remote", "reliable")
func set_points(opponent_points: int):
	if !multiplayer.is_server():
		set_points.rpc(points)
	
	queue_free()
	
	var game_over = load("res://scenes/game_over.tscn").instantiate()
	game_over.get_node("You").get_node("Score").text = str(points)
	game_over.get_node("Opponent").get_node("Score").text = str(opponent_points)
	if points < opponent_points:
		game_over.get_node("Outcome").text = "We have lost the battle, but not the war"
	else:
		game_over.get_node("Outcome").text = "VICTORY OVER OUR ENEMIES"
	get_tree().get_root().add_child(game_over)

func _on_caret_changed() -> void:
	if first:
		first = false
		return
		
	var col = $ScrollContainer/Recipe.get_caret_column()
	var line_num = $ScrollContainer/Recipe.get_caret_line()
	var line = $ScrollContainer/Recipe.get_text().split("\n")[line_num]
	var words = line.split(" ")
	var i = 0
	var count = 0
	var w = ""
	
	while count <= col:
		w = words[i]
		count += len(w) + 1
		i = i + 1
	count -= 2
	count = max(0, count)
	
	if len(line) == 0:
		return
		
	# ignore punctuation because fuck it
	var re := RegEx.new()
	re.compile("[\\+,\\.\\(\\)\\[\\]\\!_\\&\\'\\\"\\/]")
	while re.search(line[count]) != null:
		count -= 1
	
	count += 1
	
	for group in found_deformations:
		for distortion in group:
			if distortion.original.line == line_num && distortion.original.charInd == count:
				return
	
	var matching_group = null
	for group in deformations:
		for distortion in group:
			print("fuck")
			print(distortion.original.charInd)
			print(count)
			if distortion.original.line == line_num && distortion.distorted.charInd == count:
				matching_group = group
	
	var color
	if matching_group != null:
		points += 20
		$PointDelta.text = "+20"
		$PointDelta/AnimationPlayer.stop()
		$PointDelta/AnimationPlayer.current_animation = "points_add"
		found_deformations.push_back(matching_group)
		deformations.erase(matching_group)
		color = Color.GREEN
	else:
		points -= 10
		$PointDelta.text = "-10"
		$PointDelta/AnimationPlayer.stop()
		$PointDelta/AnimationPlayer.current_animation = "points_sub"
		color = Color.RED
	$Points.text = str(points)
	$ScrollContainer/Recipe.syntax_highlighter.ranges.push_back({
		"line": line_num,
		"start": count - 1 - len(w),
		"end": count - 1,
		"color": color
	})
	
	# what follows is a dumb hack to force refresh (without changing caret and scroll)
	var te = $ScrollContainer/Recipe
	var v = te.scroll_vertical
	var h = te.scroll_horizontal
	var c = te.get_caret_column()
	var l = te.get_caret_line()

	$ScrollContainer/Recipe.syntax_highlighter.clear_highlighting_cache()
	te.text = te.text

	te.set_caret_line(l)
	te.set_caret_column(c)
	te.scroll_vertical = v
	te.scroll_horizontal = h
