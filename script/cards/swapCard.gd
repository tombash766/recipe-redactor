class_name SwapCard extends Card

func setCardProps():
	typeInd = 2
	numArgs = 2
	reg = RegEx.new()
	reg.compile("^[a-zA-Z0-9]*$", true)

func distort(args):
	return [ args[1], args[0] ]
