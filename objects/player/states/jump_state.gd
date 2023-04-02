extends "res://objects/player/states/air_state.gd"


export var jump_time: float = 0.40;
export var jump_buffer: float = 0.18;
export var coyote_time: float = 0.18;
#export var jump_curve: Curve = Curve.new();


var _jumps = false;


func entered(player: Player) -> void:
	_jumps = player._jumps > 0;
	
	if _jumps:
		player.velocity.y = -player.jump_force;
		player._jumps -= 1;
		
		randomize();
		$JumpSound.pitch_scale = 1.0 + rand_range(-0.1, 0.1);
		$JumpSound.play();
	
	player.set_state("fall", false);


#func physics_update(delta: float, player: Player) -> void:
#	var velocity = player.velocity;
#	var speed = player.speed;
#	var air_drag = player.air_drag;
#	var time_of_jump = player.time_of_jump;
#	var jump_force = player.jump_force;
#	var on_floor = player.on_ground();
#
#	var target = player.get_horizontal_input() * speed * air_drag;
#
#	if player.get_slam_input():
#		player.push_state("slam", true);
#		return;
#
#	if Input.is_action_just_pressed("platform"):
#		var position = get_platform_pos(player, 0.333);
#
#		spawn_platform(player, position);
#
#	if _jumps:
#		if Input.is_action_just_released("move_up"):
#			_jumps = false;
#
#		var progress = (OS.get_ticks_msec() - time_of_jump) / (jump_time * 1000.0);
#		velocity.y += -jump_force * jump_curve.interpolate(progress);
#
#		if progress >= 1.0:
#			_jumps = false;
#
#		player.velocity = velocity;
#	else:
#		player.set_state("fall", true);
#		return;
#
#	player.move(target);
#
#	if check_ledges(player) != Player.FACING_NONE:
#		player.set_state("ledge", false);
#		return;
#
#	if Input.is_action_just_pressed("project"):
#		player.push_state("project", false);
#		return;
#
#	if player.on_roof():
#		_jumps = false;
