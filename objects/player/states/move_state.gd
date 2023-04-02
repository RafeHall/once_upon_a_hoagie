extends "res://objects/player/player_state.gd"



func physics_update(delta: float, player: Player) -> void:
	var velocity = player.velocity;
	var speed = player.speed;
	var on_floor = player.on_ground();
	
	var target = player.get_horizontal_input() * speed;
	
	if is_equal_approx(target, 0.0) and velocity.is_equal_approx(Vector2.ZERO):
		player.set_state("idle", false);
	else:
		player.set_state("move", false);
	
	if player.get_roll_input():
		player.set_state("roll", false);
	
	if not on_floor:
		player.set_state("fall", false);
	
	if player.get_jump_input():
		player.set_state("jump", false);
	
	player.move(target);
