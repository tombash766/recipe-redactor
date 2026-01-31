extends Control

var deformations
var points

func _on_caret_changed() -> void:
	var col = $Recipe.get_caret_column()
	var line = $Recipe.get_text().split("\n")[$Recipe.get_caret_line()].split(" ")
	var i = 0
	var count = 0
	var w = ""
	while count < col:
		w = line[i]
		count += len(w) + 1
		i = i + 1
	
	var selectedWord = w.replace(" ","")
	var selectedInd = i - 1
	
	var matching_group = null
	print(deformations)
	for group in deformations:
		for distortion in group:
			print(distortion)
			if distortion["original"]["wordInd"] == selectedInd:
				matching_group = group

	if matching_group != null:
		print("matching")
	else:
		print("not matching")
	
	print(selectedWord)
