extends Node2D

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var o = get_obj_under_mouse()
		if event.is_pressed():
			if !CardManager.cardSelected:
				if o is Card:
					CardManager.selectCard(o)
			else:
				if o is Card && CardManager.selectedCard != o:
					CardManager.deselect()
					CardManager.selectCard(o)
				elif o is Recipe && CardManager.selectedObj is Card:
					o.useCard(CardManager.selectedObj.rank)

func get_obj_under_mouse() -> Node2D:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true
	query.collision_mask = 1
	var result = space_state.intersect_point(query)
	if result.size() > 0:
		return result[0].collider.get_parent()
	else:
		return null
