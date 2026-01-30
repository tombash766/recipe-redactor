extends TextEdit

func _ready():
	randomize()
	
	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_request_completed)

	var url = "http://142.4.218.188:6969/api/v1/get_recipe"

	var headers = [
		"Content-Type: application/json"
	]

	var body = JSON.stringify({
		"id": randi() % 800000
	})

	var err = http.request(
		url,
		headers,
		HTTPClient.METHOD_POST,
		body
	)

	if err != OK:
		push_error("Request failed to start: %s" % err)
	print(url)


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
		
	print( len( json["ingredients"] ) )
	var ingredients = "\n".join(json["ingredients"])
	var instructions = "\n".join( json["instructions"] )
	set_text(json["title"] + "\n\n" + ingredients  + "\n\n" + instructions  ) 

func _on_caret_changed() -> void:
	print(get_caret_column())
	print(get_caret_line())
	var line = get_text().split("\n")[get_caret_line()]
	var count = 0
	
	get_child(0).set_text( get_text().split("\n")[get_caret_line()] )
