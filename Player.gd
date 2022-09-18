extends KinematicBody

export var speed = 14	# 移动速度
export var fall_accerleration = 75	# 重力加速度

export var jump_impulse = 20	# 跳跃力
export var bounce_impulse = 15	# 弹跳力

var velocity = Vector3.ZERO

signal hit

# 获取方向
func get_direction():
	var direction = Vector3.ZERO
	# x轴左右
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	# z轴前进后退
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	# 方向归一化
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$AnimationPlayer.playback_speed = 4	# 移动时动画速度变快
	else:
		$AnimationPlayer.playback_speed = 1

	return direction

# 更新速度
func update_velocity(direction, delta):
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	# 处理跳跃
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y += jump_impulse
	# 垂直向由重力加速度影响
	velocity.y -= fall_accerleration * delta

# 判断踩中小怪
func press_mob_update():
	for index in range(get_slide_count()):
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("mob"):	# 碰撞的是怪物组
			var mob = collision.collider
			# 通过与法线点击判断是否在小怪上方, 是则杀怪与弹跳
			if Vector3.UP.dot(collision.normal) > 0.1:
				mob.squash()
				velocity.y = bounce_impulse

# 物体处理
func _physics_process(delta):
	# 获取方向
	var direction = get_direction()
	# 角色更新朝向
	$Pivot.look_at(translation + direction, Vector3.UP)	# translation相对于父节点的位置
	# 更新速度
	update_velocity(direction, delta)
	# 移动并存储角色速度
	velocity = move_and_slide(velocity, Vector3.UP)	# 遇到碰撞会减小或重置对应方位的速率, 存储可防止y轴累计速率
	# 判断踩怪
	press_mob_update()

# 角色死亡
func die():
	emit_signal("hit")
	queue_free()

# 检测到怪物的碰撞
func _on_MobDetector_body_entered(body):
	die()
