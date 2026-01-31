class_name WordCard extends Card

@export var word : String

func setCardProps():
	typeInd = 4
	numArgs = 1
	reg = RegEx.new()
	reg.compile("[a-zA-Z0-9]+", true)
	if word == null || word == "":
		word = CardManager.WORDLIST.pick_random()
	get_child(0).set_text(word)

func distort(args):
	args[0]["word"] = cap_if_capped(args[0]["word"], word)
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
