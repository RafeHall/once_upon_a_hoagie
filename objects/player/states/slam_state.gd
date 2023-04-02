extends "res://objects/player/player_state.gd"


export var windup: float = 0.15;
export var speed: float = 900.0;
export var release_force: float = 450.0;

var _time: float = 0.0;
var _in_windup: bool = true;
var _velocity: float = 0.0;


func physics_update(delta: float, player: Player) -> void:
	player.velocity.x = 0.0;
	
	if player.get_jump_input(true):
		randomize();
		$JumpSound.pitch_scale = 1.0 + rand_range(-0.05, 0.05);
		$JumpSound.play();
		
		player.velocity.y = -release_force;
		player.pop_state(true);
		return;
#		if is_equal_approx(_velocity, speed):
	
	player.velocity.y = _velocity;
	
	var result = player.move_and_collide(player.velocity * delta, true, true);
	
	if player.on_ground():
		randomize();
		$HitGroundSound.pitch_scale = 1.0 + rand_range(-0.05, 0.05);
		$HitGroundSound.play();
		
		player.pop_state();
		return;


func entered(player: Player) -> void:
	if player._slams <= 0:
		player.pop_state(true);
		return;
	
	player._slams -= 1;
	
#	_in_windup = true;
#	yield(get_tree().create_timer(windup), "timeout");
#	_in_windup = false;
	
	_velocity = 0.0;
	
	var tween = get_tree().create_tween();
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS);
	tween.set_ease(Tween.EASE_IN_OUT);
	tween.set_trans(Tween.TRANS_BOUNCE);
	tween.tween_property(self, "_velocity", speed, windup);
