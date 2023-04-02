extends "res://objects/player/player_state.gd"


export var projection_time: float = 1.1;
export var projection_distance: float = 300.0;

var _velocity: Vector2 = Vector2.ZERO;
var _target_position: Vector2 = Vector2.ZERO;
var _preview = null;

var _early_exit: bool = false;


func physics_update(delta: float, player: Player) -> void:
	_velocity.y = 0.0;
	_velocity.x *= 0.98;
	
	_velocity = player.move_and_slide(_velocity, Vector2(0.0, -1.0), false, 4, deg2rad(180.0));


func entered(player: Player) -> void:
	_early_exit = false;
	if player._projections <= 0:
		_early_exit = true;
		player.pop_state(false);
		return;
	
	var direction = player.get_direction_vector(player.direction).x;
	
	if not is_equal_approx(sign(player.velocity.x), direction):
		player.velocity *= -1.0;
	_velocity = player.velocity;
	
	var velocity = Vector2(projection_distance * direction, 0.0);
	
	var result = player.move_and_collide(velocity, true, true, true);
	if result:
		_target_position = result.travel;
	else:
		_target_position = velocity;
	_target_position += player.global_transform.origin;
	
	_preview = preload("res://objects/player/projection_preview.tscn").instance();
	get_tree().root.add_child(_preview);
	_preview.global_position = _target_position;
	if player.direction == Player.FACING_LEFT:
		_preview.scale.x = -1.0;
	
	randomize();
	$ProjectionSound.pitch_scale = 2.0 + rand_range(-0.1, 0.1);
	$ProjectionSound.play();
	
	get_tree().create_timer(projection_time).connect("timeout", player, "pop_state");


func exited(player: Player) -> void:
	if _early_exit:
		return;
	
	if _preview != null:
		_preview.queue_free();
	
	if player._projections <= 0:
		return;
	player._projections -= 1;
	
	player.global_transform.origin = _target_position;
