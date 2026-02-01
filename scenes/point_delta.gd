extends Label

func add_points_anim(n):
	if n > 0:
		text = "+%s" % n
		get_child(0).stop()
		get_child(0).current_animation = "points_add"
	else:
		text = "-%s" % n
		get_child(0).stop()
		get_child(0).current_animation = "points_sub"
