extends Control

@onready var dialogue_label = $HUD/Display
@onready var side_bar = $Buttons

var tween


func write_dialogue(msg, time):
	dialogue_label.text = msg
	
	if tween != null:
		tween.kill()
		modulate = Color.WHITE
	
	tween = get_tree().create_tween()
	tween.tween_property(dialogue_label, "modulate", Color.TRANSPARENT, time).set_trans(Tween.TRANS_BACK)


func _on_toggle_side_bar_pressed():
	if side_bar.visible:
		side_bar.set_visible(false)
	else:
		side_bar.set_visible(true)
