extends Node


func on_quit_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)

func on_lobby_pressed():
	get_parent().get_node("Lobby").show()
	queue_free()
