extends Node


func on_quit_pressed():
	$"/root/Lobby/LobbyPanel".end_game()
	get_tree().quit()

func on_lobby_pressed():
	$"/root/Lobby/LobbyPanel".end_game()
	$"/root/Lobby/LobbyPanel".show()
	queue_free()

func on_play_again_pressed():
	$"/root/Lobby/LobbyPanel".end_game()
	$"/root/Lobby/LobbyPanel".show()
	$"/root/Lobby/LobbyPanel".rejoin()
	CardManager.reset_game()
	queue_free()
