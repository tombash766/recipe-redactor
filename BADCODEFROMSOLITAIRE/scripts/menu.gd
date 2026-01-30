class_name Menu
extends Control

func _on_start_button_pressed() -> void:
	GameManager.start_game("res://solitare/scenes/solitare.tscn")

func _on_main_button_pressed() -> void:
	GameManager.start_game("res://base/scenes/start.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
