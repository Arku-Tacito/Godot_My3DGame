extends Node
export (PackedScene) var mob_scene

func _ready():
	randomize()
	$UserInterface/Retry.hide()

# 生成小怪
func _on_MobTimer_timeout():
	var mob = mob_scene.instance()	# 实例化小怪
	# 获取随机位置
	var mob_location = get_node("SpawnPath/SpawnLocation")
	mob_location.unit_offset = randf()	# 随机偏移
	# 获取玩家位置
	if $Player:
		var player_position = $Player.transform.origin
		# 生成小怪
		mob.initialized(mob_location.translation, player_position)	# 初始化朝向和速度
		add_child(mob)
	# 动态生成的小怪的信号连接方式
	mob.connect("squashed", $UserInterface/ScoreLabel, "_on_Mob_squashed")

# 玩家击中, 结束游戏
func _on_Player_hit():
	$MobTimer.stop()	# 停止生产小怪
	$UserInterface/Retry.show()

# 按下回车重试游戏
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:	# 要死亡画面可见
		# This restarts the current scene.
		get_tree().reload_current_scene()
