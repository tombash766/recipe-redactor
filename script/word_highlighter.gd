extends SyntaxHighlighter

var ranges := []
# line -> Array[{start, end}]

func custom_array_sort(a, b):
	return a.start < b.start

func _get_line_syntax_highlighting(line: int) -> Dictionary:
	var out := {}
	
	ranges.sort_custom(custom_array_sort)

	for r in ranges:
		if r.line != line:
			continue
		out[r.start] = {
			"color": r.color,
		}
		if not r.end in out:
			out[r.end] = {
				"color": Color.WHITE,
			}

	return out
