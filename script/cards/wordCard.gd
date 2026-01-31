class_name WordCard extends Card

@export var word = "oven"

func setCardProps():
	typeInd = 4
	numArgs = 1
	reg = RegEx.new()
	reg.compile("[a-zA-Z0-9]+", true)
	get_child(0).set_text(word)

func distort(args):
	args[0]["word"] = word
	return args
