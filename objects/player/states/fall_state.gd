extends "res://objects/player/states/air_state.gd"


func physics_update(delta: float, player: Player) -> void:
	var velocity = player.velocity;
	var speed = player.speed;
	var air_drag = player.air_drag;
	var on_floor = player.on_ground();
	
	var target = player.get_horizontal_input() * speed * air_drag;
	
	if check_ledges(delta, player) != Player.FACING_NONE:
		player.set_state("ledge", false);
		return;
	
	if player.get_slam_input():
		player.push_state("slam", false);
		return;
	
	if player.get_platform_input():
		var position = get_platform_pos(player, 0.333);
		
		spawn_platform(player, position);
	
	if player.get_jump_input():
		player.set_state("jump", false);
	
	if on_floor:
		player.set_state("move", false);
		
		$LandingSound.play();
	
	player.move(target);
	
	if player.get_project_input():
		player.push_state("project", false);
		return;
