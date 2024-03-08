extends Label

var tween

func write(msg, time):
	text = msg
	
	if tween != null:
		tween.kill()
		modulate = Color.WHITE
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, time).set_trans(Tween.TRANS_EXPO)
	
	

