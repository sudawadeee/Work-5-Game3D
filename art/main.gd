extends Node

# เปลี่ยนชื่อเป็น banana_scene เพื่อสื่อว่าเป็น Banana
@export var banana_scene: PackedScene

func _ready():
	$UserInterface/Retry.hide()

func _on_mob_timer_timeout():
	# สร้าง instance ของ Banana scene
	var banana = banana_scene.instantiate()

	# เลือกตำแหน่งสุ่มบน Path
	var spawn_location = get_node("SpawnPath/SpawnLocation")
	spawn_location.progress_ratio = randf()

	# หาตำแหน่งผู้เล่น
	var player_position = $Player.position
	# เรียก initialize ของ Banana.gd
	banana.initialize(spawn_location.position, player_position)

	# เพิ่ม Banana เข้าฉาก
	add_child(banana)
	# เมื่อ mob ถูกเหยียบ → ให้ ScoreLabel เพิ่มคะแนน
	banana.squashed.connect(Callable($UserInterface/ScoreLabel, "_on_mob_squashed"))


func _on_player_hit() -> void:
	$MobTimer.stop()
	$UserInterface/Retry.show()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()
