extends Control

func _ready() -> void:
	$Timer.start()

func on_timer_expire():
	if multiplayer.is_server():
		var recipe = get_parent().get_node("Encrypt").get_node("ScrollContainer").get_node("TextEdit").text
		set_recipe.rpc(recipe)

@rpc("any_peer", "call_remote", "reliable")
func set_recipe(recipe: String):
	var encrypt = get_parent().get_node("Encrypt")
	
	if !multiplayer.is_server():
		var new_recipe = encrypt.get_node("ScrollContainer").get_node("TextEdit").text
		set_recipe.rpc(new_recipe)
		
	encrypt.queue_free()
	queue_free()
	
	var decrypt = load("res://decrypt.tscn").instantiate()
	decrypt.get_node("Recipe").text = recipe
	get_tree().get_root().add_child(decrypt)
