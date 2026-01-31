extends Node


func on_quit_pressed():
	$"/root/Lobby/LobbyPanel".end_game()
	get_tree().quit()

func on_lobby_pressed():
	$"/root/Lobby/LobbyPanel".end_game()
	$"/root/Lobby/LobbyPanel".show()
	queue_free()
