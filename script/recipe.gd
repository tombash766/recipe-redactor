class_name Recipe extends TextEdit 

var selectedWord
var selectedLine
var selectedStart
var selectedEnd
var selectedInd

var deformations = []
var hl := preload("res://script/word_highlighter.gd").new()

func _ready():
	syntax_highlighter = hl
	set_random_recipe()
	CardManager.recipe = self
	
func set_random_recipe():
	randomize()
	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_request_completed)
	var url = "http://142.4.218.188:6969/api/v1/get_recipe"
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify({"id": randi() % 800000})
	var err = http.request(
		url,
		headers,
		HTTPClient.METHOD_POST,
		body
	)
	if err != OK:
		push_error("Request failed to start: %s" % err)

func _on_request_completed(
		_result: int,
		response_code: int,
		_headers: PackedStringArray,
		body: PackedByteArray
	):
	if response_code != 200:
		push_error("HTTP error: %s\nretrying.." % response_code)
		set_random_recipe()
		return
	var t = body.get_string_from_utf8()
	var json = JSON.parse_string(t)
	if json == null:
		push_error("Invalid JSON")
		return
	var ingredients = ", ".join(json["ingredients"])
	var instructions = "\n".join( json["instructions"] )
	var recipeText = json["title"] + "\n\n" + ingredients  + "\n\n" + instructions
	if len(recipeText) > 1000 :
		print( "recipe too long: %s\nretrying.." % len(recipeText) )
		set_random_recipe()
		return
		
	recipeText = decode_recipe_text(recipeText)
	
	set_text( recipeText ) 

func decode_recipe_text(s: String) -> String:
	var replacements = {
		"½":"0.5", "⅓":"0.33", "⅔":"0.66",
		"¼":"0.25", "¾":"0.75", "⅛":"0.125",
		"⅜":"0.375", "⅝":"0.625", "⅞":"0.875",
		"1/2":"0.5", "1/3":"0.33", "2/3":"0.66",
		"1/4":"0.25", "3/4":"0.75", "1/8":"0.125",
		"&#39;":"'", "&#039;":"", "&nbsp":"\n", "&quot;":"\"", "&amp;":"&",
		"&frac12;":"0.5", "&frac14;":"0.25", "&frac34;":"0.75",
		",,":","
	}
	for key in replacements.keys():
		s = s.replace(key, replacements[key])
	return s

func replace_preserve_punct(s,to_word):
	var re := RegEx.new()
	re.compile("^([\\W]*)(\\w+)([\\W]*)$")
	var m := re.search(s)
	if m == null:
		return s
	return m.get_string(1) + to_word + m.get_string(3)

func _on_caret_changed() -> void:
	if !CardManager.cardSelected: return
	var col = get_caret_column()
	var line = get_text().split("\n")[get_caret_line()].split(" ")
	var i = 0
	var count = 0
	var w = ""
	
	while count < col:
		w = line[i]
		count += len(w) + 1
		i = i + 1

	#selectedWord = remove_punctuation(w)
	var valid = CardManager.selectedCard.reg.search(w)
	if valid == null: return
	
	selectedWord = valid.get_string()
	
	selectedInd = i - 1
	selectedLine = get_caret_line()
	
	for d in deformations:
		for rep in d:
			if rep["original"]["line"] == selectedLine && rep["original"]["wordInd"] == selectedInd:
				return
				
	if CardManager.selectedCard is SwapCard && CardManager.arguments != []:
		if CardManager.arguments[0]["word"] == selectedWord:
			return
	
	print("accepted %s" % selectedWord)
	
	CardManager.submit_word(
		{
			"word" : selectedWord,
			"line" : selectedLine,
			"wordInd" : selectedInd
		}
	)

func replace_words(originals, replacements):
	var deformation = []
	for i in range( len(originals) ):
		deformation.push_back( {
			"original" : originals[i],
			"replacement" : replacements[i]
		} )
	deformations.push_back( deformation )
	var t = get_text().split("\n")
	# makes sure CardManager.selectedCard is not freed or changed
	for i in len(originals):
		var l = t[ originals[i]["line"] ].split(" ")
		l[ originals[i]["wordInd"] ] = CardManager.selectedCard.reg.sub( l[ originals[i]["wordInd"] ], replacements[i]["word"] )
		t[ originals[i]["line"] ] = " ".join(Array(l))
	set_text( "\n".join(Array(t)) )
