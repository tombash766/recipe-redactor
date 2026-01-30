extends Menu

func _on_pause_button_pressed() -> void:
	GameManager.toggle_pause()

func _on_main_button_pressed():
	if GameManager.isPaused:
		await GameManager.toggle_pause()
	super._on_main_button_pressed()
	
