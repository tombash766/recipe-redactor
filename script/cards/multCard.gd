class_name MultCard extends Card

@export var multiplier : int

func setCardProps():
	typeInd = 3
	numArgs = 1
	reg = RegEx.new()
	reg.compile("[-+]?[0-9]*\\.?[0-9]+([eE][-+]?[0-9]+)?", true)
	regDesc = "numbers"
	if multiplier == null || multiplier == 0:
		multiplier = 2 + randi() % 18
	get_child(0).set_text("×%s" % multiplier)
	desc = "Multiplies a number in the recipe by %s" % multiplier

func distort(arg):
	arg[0]["word"] = str( int( arg[0]["word"].to_float() * multiplier ) )
	return arg
