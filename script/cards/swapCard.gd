class_name SwapCard extends Card

func setCardProps():
	typeInd = 2
	numArgs = 2
	reg = RegEx.new()
	reg.compile("[a-zA-Z0-9]+", true)
	regDesc = "word or number of any length"

func distort(args):
	var temp = args[0]["word"]
	args[0]["word"] = cap_if_capped(args[0]["word"], args[1]["word"])
	args[1]["word"] = cap_if_capped(args[1]["word"], temp)
	return args

func cap_if_capped(teststr, s):
	if is_capped(teststr):
		return cap(s)
	else:
		return s.to_lower()
	
func is_capped(s):
	return RegEx.create_from_string("[A-Z][A-Za-z]*").search(s) != null

func cap(s):
	return s[0].to_upper() + s.substr(1).to_lower()
