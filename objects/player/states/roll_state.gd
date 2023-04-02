extends "res://objects/player/player_state.gd"


export var roll_force: float = 600;
export var roll_offset: Vector2 = Vector2.ZERO;


func entered(player: Player) -> void:
	if player._rolls <= 0:
		player.set_state("move");
		return;
	player._rolls -= 1;
	
	randomize();
	$RollSound.pitch_scale = 1.5 + rand_range(-0.15, 0.15);
	$RollSound.play();
	
	var direction = player.get_direction_vector(player.direction);
	
	direction = (direction + roll_offset).normalized();
	
	player.velocity = direction * roll_force;
	
	player.set_state("fall");
