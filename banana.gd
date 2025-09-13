extends CharacterBody3D

# ความเร็วต่ำสุดของ mob (เมตร/วินาที)
@export var min_speed = 10
# ความเร็วสูงสุดของ mob (เมตร/วินาที)
@export var max_speed = 18

signal squashed


func _physics_process(_delta):
	move_and_slide()

# ฟังก์ชันนี้จะถูกเรียกจาก Main scene
func initialize(start_position, player_position):
	# วาง mob ที่ตำแหน่งเริ่มต้น และหันไปทางผู้เล่น
	look_at_from_position(start_position, player_position, Vector3.UP)
	# หมุนสุ่มเล็กน้อย เพื่อไม่ให้พุ่งตรงไปที่ผู้เล่นเสมอ
	rotate_y(randf_range(-PI / 4, PI / 4))

	# สุ่มความเร็ว
	var random_speed = randi_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)

	
func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()

func squash():
	squashed.emit()
	queue_free()
