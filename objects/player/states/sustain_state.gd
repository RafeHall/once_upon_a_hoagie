extends "res://objects/player/states/air_state.gd"

export var hold_time: float = 0.20;
export var hold_curve: Curve = Curve.new();

var _jump_force: float = 0.0;


func entered(player: Player) -> void:
	player.time_of_jump = OS.get_ticks_msec();
	
	_jump_force = player.velocity.y;


func physics_update(delta: float, player: Player) -> void:
	var velocity = player.velocity;
	var speed = player.speed;
	var air_drag = player.air_drag;
	var on_floor = player.on_ground();
	var time_of_jump = player.time_of_jump;
	
	var target = player.get_horizontal_input() * speed * air_drag;
	
	if on_floor:
		player.set_state("move", true);
		return;
	
	var progress = (OS.get_ticks_msec() - time_of_jump) / (hold_time * 1000.0);
	velocity.y += _jump_force * hold_curve.interpolate(progress);
	
	if progress >= 1.0:
		player.set_state("fall", false);
	
	player.velocity = velocity;
	player.move(target);
	
	on_floor = player.on_ground();
	if on_floor:
		player.set_state("move", false);
	
	if check_ledges(player) != Player.FACING_NONE:
		player.set_state("ledge", true);
		return;
