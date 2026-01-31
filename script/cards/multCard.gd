class_name MultCard extends Card

@export var multiplier = 10

func setCardProps():
	typeInd = 3
	numArgs = 1
	reg = RegEx.new()
	reg.compile("[-+]?[0-9]*\\.?[0-9]+([eE][-+]?[0-9]+)?", true)

func distort(arg):
	arg[0]["word"] = str( int( arg[0]["word"].to_float() * multiplier ) )
	return arg
