class_name ShuffleCard extends Card

func setCardProps():
	typeInd = 1
	numArgs = 1
	reg = RegEx.new()
	reg.compile("[a-zA-Z]{3,}", true)
	regDesc = "word longer than 3 characters"
	desc = "shuffles the letters of a word"

func distort(arg):
	var a = Array( arg[0]["word"].split("") )
	var b = a.duplicate()
	while b == a:
		a.shuffle()
	arg[0]["word"] = cap_if_capped(arg[0]["word"],"".join(a))
	return arg

func cap_if_capped(teststr, s):
	if is_capped(teststr):
		return cap(s)
	else:
		return s.to_lower()
	
func is_capped(s):
	return RegEx.create_from_string("[A-Z][A-Za-z]*").search(s) != null

func cap(s):
	return s[0].to_upper() + s.substr(1).to_lower()
