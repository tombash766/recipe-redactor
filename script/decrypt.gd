extends Control

var deformations
var found_deformations = []
var points = 0
var hl := preload("res://script/word_highlighter.gd").new()

func _ready():
	$ScrollContainer/Recipe.syntax_highlighter = hl
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

func _on_caret_changed() -> void:
	var col = $ScrollContainer/Recipe.get_caret_column()
	var line = $ScrollContainer/Recipe.get_caret_line()
	var words = $ScrollContainer/Recipe.get_text().split("\n")[line].split(" ")
	var word_index = 0
	var count = 0
	var w = ""
	while count < col:
		w = words[word_index]
		count += len(w) + 1
		word_index += 1
	
	if word_index == 0:
		return

	var selectedWord = w.replace(" ","")
	var selectedInd = word_index - 1

	var matching_group = null
	for group in deformations:
		for distortion in group:
			if distortion["original"]["wordInd"] == selectedInd:
				matching_group = group

	if matching_group in found_deformations:
		return

	if matching_group != null:
		points += 10
		found_deformations.push_back(matching_group)
		deformations.erase(matching_group)
		hl.ranges.push_back({
			"line": line, 
			"start_col": count, 
			"end_col": count + len(w)
		})
		$ScrollContainer/Recipe.text = $ScrollContainer/Recipe.text + " "
	else:
		points -= 5
	$Points.text = str(points)
