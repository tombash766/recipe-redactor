extends SyntaxHighlighter

var ranges := {}  
# line -> Array[{start, end}]

func _get_line_syntax_highlighting(line: int) -> Dictionary:
	print("rerender")
	print(line)
	var out := {}

	if not ranges.has(line):
		return out

	for r in ranges[line]:
		out[r.start] = {
			"color": Color.GREEN_YELLOW,
			"end": r.end
		}

	return out
