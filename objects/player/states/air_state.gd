extends "res://objects/player/player_state.gd"



func get_platform_pos(player: Player, ahead: float) -> Vector2:
	return player.velocity * ahead + player.global_transform.origin;


func spawn_platform(player: Player, position: Vector2) -> void:
	if not player.get_platform_input():
		return;
	
	if player._platforms <= 0:
		return;
	player._platforms -= 1;
	
	var platform = preload("res://objects/platform/platform.tscn").instance();
	
	get_tree().root.add_child(platform);
	
	platform.global_transform.origin = position;


func check_ledges(delta: float, player: Player) -> int:
	var left = player._left_ledge_ray;
	var right = player._right_ledge_ray;
	var left_check = player._left_check_ray;
	var right_check = player._right_check_ray;
	
	var length = abs(player.velocity.y * delta);
	
	left_check.position.y = player._left_ledge_end - length;
	right_check.position.y = player._right_ledge_end - length;
	left_check.cast_to = Vector2(0.0, length);
	right_check.cast_to = Vector2(0.0, length);
	
	left.force_raycast_update();
	right.force_raycast_update();
	left_check.force_raycast_update();
	right_check.force_raycast_update();
	
	if (OS.get_ticks_msec() - player._anti_stick_time) < (player.ledge_stick_time * 1000):
		return Player.FACING_NONE;
	
	if left.is_colliding():
		if left_check.is_colliding():
			player.ledge = Player.FACING_LEFT;
			if left_check.get_collider().get_class() == "platform":
				return Player.FACING_NONE;
			var n = left_check.get_collision_normal();
			var d = n.dot(Vector2(0.0, -1.0));
			if d >= 0.01:
				return Player.FACING_LEFT;
	elif right.is_colliding():
		if right_check.is_colliding():
			player.ledge = Player.FACING_RIGHT;
			if right_check.get_collider().get_class() == "platform":
				return Player.FACING_NONE;
			var n = right_check.get_collision_normal();
			var d = n.dot(Vector2(0.0, -1.0));
			if d >= 0.01:
				return Player.FACING_RIGHT;
	return Player.FACING_NONE;
