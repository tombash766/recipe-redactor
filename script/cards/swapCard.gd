class_name SwapCard extends Card

func setCardProps():
	typeInd = 2
	numArgs = 2
	reg = RegEx.new()
	reg.compile("^[a-zA-Z0-9]*$", true)

func distort(args):
	var temp = args[0]["word"]
	args[0]["word"] = args[1]["word"]
	args[1]["word"] = temp
	return args
