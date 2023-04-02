extends "res://objects/player/player_state.gd"


var direction: int = Player.FACING_NONE;


func physics_update(delta: float, player: Player) -> void:
	player.velocity = Vector2.ZERO;
	
	var d = sign(player.get_horizontal_input());
	var _direction = Player.FACING_NONE;
	if not is_equal_approx(d, 0.0):
		if d > 0.0:
			_direction = Player.FACING_RIGHT;
		else:
			_direction = Player.FACING_LEFT;
	
	if player.get_jump_input(true, false):
		player._anti_stick_time = OS.get_ticks_msec();
		player._jumps = player.jumps;
		player.set_state("jump", true);
		return;
	elif _direction != direction:
		if _direction != Player.FACING_NONE:
			player._anti_stick_time = OS.get_ticks_msec();
			player.set_state("fall", true);
			return;


func entered(player: Player) -> void:
	direction = player.ledge;
