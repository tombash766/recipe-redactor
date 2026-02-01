extends Label

func add_points_anim(n):
	if n > 0:
		text = "+%s" % abs(n)
		get_child(0).stop()
		get_child(0).current_animation = "points_add"
	else:
		text = "-%s" % abs(n)
		get_child(0).stop()
		get_child(0).current_animation = "points_sub"
