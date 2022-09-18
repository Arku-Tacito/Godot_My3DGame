extends KinematicBody

export var max_speed = 18
export var min_speed = 10

signal squashed

var velocity = Vector3.ZERO

# 初始化小怪
func initialized(start_position, player_position):
	# 从初始位置看向玩家
	look_at_from_position(start_position, player_position, Vector3.UP)
	rotate_y(rand_range(-PI/4, PI/4))	# 随机偏移
	# 初始化随机速度
	var random_speed = rand_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)

# 离开屏幕销毁小怪
func _on_VisibilityNotifier_screen_exited():
	queue_free()

# 被踩
func squash():
	emit_signal("squashed")
	queue_free()

# 物理处理
func _physics_process(delta):
	move_and_slide(velocity)	# 匀速移动
