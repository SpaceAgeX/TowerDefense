extends CanvasLayer


@onready var dialogue_label = $HUD/Display
@onready var side_bar = $Buttons
@onready var Main = $".."

var tween
var selected_building


func _ready():
	# Fix the dimensions of Stats Panel
	$BuildingStats.size.y = 600
	$BuildingStats.position.y -= 200


func write_dialogue(msg, time):
	dialogue_label.text = msg
	
	if tween != null:
		tween.kill()
		dialogue_label.modulate = Color.WHITE
	
	tween = get_tree().create_tween()
	tween.tween_property(dialogue_label, "modulate", Color.TRANSPARENT, time).set_trans(Tween.TRANS_BACK)


func updateCurrency(Production, EnemyParts):
	$Currency/Production.text = str(Production)
	$Currency/EnemyPartsLabel.text = str(EnemyParts)


func toggleSideBar(value):
		$Buttons.visible = value
		$ToggleSideBar.visible = value
		
		if value == false:
			for node in $BuildingStats.get_children():
				node.visible = false
			
			$BuildingStats/ColorRect.visible = true
			$BuildingStats/CloseStatsButton.visible = true
			$BuildingStats/BuildingSprite.visible = true
			$BuildingStats/TypeLabel.visible = true


func view_stats(tile):
	selected_building = tile
	var stat_rows = 0
	
	for node in $BuildingStats.get_children():
		node.visible = false
	
	$BuildingStats/ColorRect.visible = true
	$BuildingStats/CloseStatsButton.visible = true
	$BuildingStats/BuildingSprite.visible = true
	$BuildingStats/TypeLabel.visible = true
	
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
	
	if tile.stats.has("health") and tile.stats.has("maxHealth"):
		stat_rows += 1
		$BuildingStats/health.text = str(tile.stats["health"])
		$BuildingStats/maxHealth.text = str(tile.stats["maxHealth"])
		
		$BuildingStats/health.position.y = stat_rows*100
		$BuildingStats/maxHealth.position.y = stat_rows*100
		
		$BuildingStats/health.visible = true
		$BuildingStats/maxHealth.visible = true
	
	if tile.stats.has("damage"):
		stat_rows += 1
		$BuildingStats/damage.text = str(tile.stats["damage"]) + " dmg"
		$BuildingStats/damage.position.y = stat_rows*100
		$BuildingStats/damage.visible = true
	
	if tile.stats.has("cooldown") and tile.stats.has("missileTime"):
		stat_rows += 1
		$BuildingStats/cooldown.text = str(tile.stats["cooldown"] + tile.stats["missileTime"]) + " sec"
		$BuildingStats/cooldown.position.y = stat_rows*100
		$BuildingStats/cooldown.visible = true
	
	if tile.stats.has("productionRate"):
		stat_rows += 1
		$BuildingStats/productionRate.text = str(tile.stats["productionRate"])
		$BuildingStats/productionRate.position.y = stat_rows*100
		$BuildingStats/productionRate.visible = true


func _on_toggle_side_bar_pressed():
	if side_bar.visible:
		side_bar.set_visible(false)
	else:
		side_bar.set_visible(true)


func _on_close_stats_button_pressed():
	$BuildingStats.set_visible(false)
