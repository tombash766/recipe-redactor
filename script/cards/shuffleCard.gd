class_name ShuffleCard extends Card

func setCardProps():
	typeInd = 1
	numArgs = 1
	reg = RegEx.new()
	reg.compile("[a-zA-Z]{3,}", true)

func distort(arg):
	var a = Array( arg[0]["word"].split("") )
	var b = a.duplicate()
	while b == a:
		a.shuffle()
	arg[0]["word"] = "".join(a)
	return arg
