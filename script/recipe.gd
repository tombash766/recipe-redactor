class_name Recipe extends TextEdit 

var selectedWord
var selectedLine
var selectedStart
var selectedEnd
var selectedInd

var deformations = []
var PUNCTUATION = [".",",","(",")","{","}","[","]",";",":","'",'"',"-","`"]

func _ready():
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
	CardManager.recipe = self

func _on_request_completed(
		_result: int,
		response_code: int,
		_headers: PackedStringArray,
		body: PackedByteArray
	):
	if response_code != 200:
		push_error("HTTP error: %s" % response_code)
		return
	var t = body.get_string_from_utf8()
	var json = JSON.parse_string(t)
	if json == null:
		push_error("Invalid JSON")
		return
	var ingredients = "\n".join(json["ingredients"])
	var instructions = "\n".join( json["instructions"] )
	set_text(json["title"] + "\n\n" + ingredients  + "\n\n" + instructions  ) 

func remove_punctuation(s):
	for c in PUNCTUATION:
		s = s.replace(c,"")
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
	print(CardManager.selectedCard.reg, w)
	var valid = CardManager.selectedCard.reg.search(w)
	if valid == null: return
	selectedWord = valid.get_string()
	print(selectedWord)
	selectedInd = i - 1
	selectedLine = get_caret_line()
	
	for d in deformations:
		for rep in d:
			if rep["original"]["line"] == selectedLine && rep["original"]["wordInd"] == selectedInd:
				return
		
	
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
		
		
