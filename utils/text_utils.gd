class_name TextUtils

static func parse_valid_answers(answer_text: String) -> Array[String]:
	var answers: Array[String] = []
	
	var cleaned := answer_text.replace("to ", "").replace("(", "").replace(")", "")
	
	var normalize_pattern := RegEx.new()
	normalize_pattern.compile("[/;]")
	var normalized := normalize_pattern.sub(cleaned, ",", true)
	for token in normalized.split(","):
		var trimmed := token.strip_edges().to_lower()
		if not trimmed.is_empty():
			answers.append(trimmed)
	
	return answers

static func is_similar(a: String, b: String, max_distance: int = 2) -> bool:
	return _levenshtein_distance(a.to_lower(), b.to_lower()) <= max_distance

static func _levenshtein_distance(s: String, t: String) -> int:
	var n := s.length()
	var m := t.length()
	
	if n == 0:
		return m
	if m == 0:
		return n
	
	var d := []
	d.resize(n + 1)
	for i in d.size():
		d[i] = []
		d[i].resize(m + 1)
		d[i][0] = i
	for j in range(m + 1):
		d[0][j] = j
	
	for i in range(1, n + 1):
		for j in range(1, m + 1):
			var cost := 0 if s[i - 1] == t[j - 1] else 1
			d[i][j] = min(
				d[i - 1][j] + 1,      # Deletion
				d[i][j - 1] + 1,       # Insertion
				d[i - 1][j - 1] + cost # Substitution
			)
	
	return d[n][m]
