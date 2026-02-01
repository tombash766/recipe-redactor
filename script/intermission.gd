extends Control

var local_recipe: String
var local_deformations
var local_modifiers
var points

func _ready() -> void:
	$Timer.start()
	
func on_timer_expire():
	if multiplayer.is_server():
		set_recipe.rpc(local_recipe, local_deformations, local_modifiers)

@rpc("any_peer", "call_remote", "reliable")
func set_recipe(recipe: String, deformations, modifiers):
	if !multiplayer.is_server():
		set_recipe.rpc(local_recipe, local_deformations, local_modifiers)
	
	var encrypt = get_parent().get_node_or_null("Encrypt")
	if (encrypt != null):
		encrypt.queue_free()
		
	queue_free()
	
	var decrypt = load("res://scenes/decrypt.tscn").instantiate()
	decrypt.deformations = deformations
	decrypt.modifiers = modifiers
	decrypt.points = points
	decrypt.get_node("Points").text = str(points)
	decrypt.get_node("ScrollContainer").get_node("Recipe").text = recipe
	get_tree().get_root().add_child(decrypt)
