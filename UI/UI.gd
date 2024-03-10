extends CanvasLayer


@onready var dialogue_label = $HUD/Display
@onready var side_bar = $Buttons

var tween

var building

func write_dialogue(msg, time):
	dialogue_label.text = msg
	
	if tween != null:
		tween.kill()
		dialogue_label.modulate = Color.WHITE
	
	tween = get_tree().create_tween()
	tween.tween_property(dialogue_label, "modulate", Color.TRANSPARENT, time).set_trans(Tween.TRANS_BACK)


func view_stats(tile):
	
	building = tile
	var sprite_frame = 1
	var building_type = "Empty"
	
	$BuildingStats.visible = true
	
	match tile.type:
		BuildTile.Types.TOWN:
			sprite_frame = 0
			building_type = "Town"
		
		BuildTile.Types.FACTORY:
			sprite_frame = 3
			building_type = "Factory"
		
		BuildTile.Types.SILO:
			sprite_frame = 6
			building_type = "Silo"
			
	

	$BuildingStats/BuildingSprite.frame = sprite_frame
	$BuildingStats/TypeLabel.text = building_type
	$BuildingStats/HealthLabel.text = str(tile.health) + " / " + str(tile.max_health)


func _on_toggle_side_bar_pressed():
	if side_bar.visible:
		side_bar.set_visible(false)
	else:
		side_bar.set_visible(true)


func _on_close_stats_button_pressed():
	$BuildingStats.set_visible(false)
