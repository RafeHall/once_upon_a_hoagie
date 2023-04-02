class_name Player
extends KinematicBody2D


enum {
	FACING_NONE,
	FACING_RIGHT,
	FACING_LEFT,
}


export var speed: float = 350.0;
export var acceleration: float = 1.0 / 0.35;
export var deceleration: float = 1.0 / 0.3;
export var gravity: Vector2 = Vector2(0.0, 9.81);
export var air_drag: float = 0.65;
export var jump_force: float = 450.0;
export var ledge_stick_time: float = 0.18;

export var project_leeway: float = 0.22;
export var roll_leeway: float = 0.22;
export var platform_leeway: float = 0.22;

export var platforms: int = 1;
export var jumps: int = 1;
export var projections: int = 1;
export var slams: int = 1;
export var rolls: int = 1;

export var force_allow_roll: bool = false;
export var force_allow_project: bool = false;
export var force_allow_slam: bool = false;
export var force_allow_platform: bool = false;

var velocity: Vector2 = Vector2.ZERO;
var time_on_ground: int = 0;
var time_try_jump: int = 0;
var time_of_jump: int = 0;
var direction: int = FACING_RIGHT;
var ledge: int = FACING_NONE;

var _platforms: int = platforms;
var _jumps: int = jumps;
var _projections: int = projections;
var _slams: int = slams;
var _rolls: int = rolls;

var _current_state = null;
var _state_stack: Array = [];
var _immediate: bool = false;

var _time_try_roll: int = 0;
var _time_try_project: int = 0;
var _time_try_platform: int = 0;

var _anti_stick_time: int = 0;
var _interactable: Area2D = null;

onready var states: Dictionary = {
	"idle": $States/Idle,
	"move": $States/Move,
	"jump": $States/Jump,
	"fall": $States/Fall,
	"roll": $States/Roll,
	"ledge": $States/Ledge,
	"project": $States/Project,
	"slam": $States/Slam,
};

onready var _ground_rays: Node2D = $GroundRays;
onready var _head_rays: Node2D = $HeadRays;

onready var _interact_label: Label = $Hud/Interact;

onready var _right_ledge_ray: RayCast2D = $LedgeRays/Right;
onready var _left_ledge_ray: RayCast2D = $LedgeRays/Left;
onready var _right_check_ray: RayCast2D = $LedgeRays/RightCheck;
onready var _left_check_ray: RayCast2D = $LedgeRays/LeftCheck;

onready var _right_ledge_end: float = 0.0;
onready var _left_ledge_end: float = 0.0;


func _ready() -> void:
	Global.player = self;
	
	_current_state = states["idle"];
	_state_stack.push_back(_current_state);
	_current_state.entered(self);
	
	_right_ledge_end = _right_check_ray.position.y;
	_left_ledge_end = _left_check_ray.position.y;


func _physics_process(delta: float) -> void:
	if on_ground():
		time_on_ground = OS.get_ticks_msec();
		_jumps = jumps;
		_rolls = rolls;
		
		for ground_ray in _ground_rays.get_children():
			var collider = ground_ray.get_collider();
			if collider != null:
				if collider.get_class() != "platform":
					_platforms = platforms;
					_projections = projections;
					_slams = slams;
	
	if Input.is_action_just_pressed("platform"):
		_time_try_platform = OS.get_ticks_msec();
	
	if Input.is_action_just_pressed("roll"):
		_time_try_roll = OS.get_ticks_msec();
	
	if Input.is_action_just_pressed("project"):
		_time_try_project = OS.get_ticks_msec();
	
	_current_state.physics_update(delta, self);
	while _immediate:
		_immediate = false;
		_current_state.physics_update(delta, self);
	
	if direction == FACING_LEFT:
		$Visuals.scale.x = -1.0;
	elif direction == FACING_RIGHT:
		$Visuals.scale.x = 1.0;
	
	var d = get_horizontal_input();
	if not is_equal_approx(d, 0.0):
		if d > 0.0:
			direction = FACING_RIGHT;
		else:
			direction = FACING_LEFT;


func _process(delta: float) -> void:
	$Visuals/Moving.speed = abs(self.velocity.x) / self.speed;
	
	if Input.is_action_just_pressed("interact"):
		if _interactable != null:
			if _interactable.has_method("_interact"):
				_interactable.call("_interact");
		
		_interactable = null;
		_interact_label.hide();
	
	_current_state.update(delta, self);
	while _immediate:
		_immediate = false;
		_current_state.update(delta, self);


func get_direction_vector(dir: int) -> Vector2:
	if dir == FACING_RIGHT:
		return Vector2.RIGHT;
	elif dir == FACING_LEFT:
		return Vector2.LEFT;
	return Vector2.ZERO;


func set_state(state_name: String, immediate: bool = false) -> void:
	if state_name in states:
		var new_state = states[state_name];
		if new_state == _current_state:
			return;
		
		_state_stack.pop_back();
		_state_stack.push_back(new_state);
		
		_current_state.exited(self);
		_update_visuals(state_name);
		
		_current_state = new_state;
		_current_state.entered(self);
		
		if immediate:
			_immediate = immediate;


func push_state(state_name: String, immediate: bool = true) -> void:
	if state_name in states:
		var new_state = states[state_name];
		if new_state == _current_state:
			return;
		
		_state_stack.push_back(new_state);
		
		_current_state.exited(self);
		_update_visuals(state_name);
		_current_state = new_state;
		_current_state.entered(self);
		
		
		if immediate:
			_immediate = true;


func pop_state(immediate: bool = false) -> void:
	_state_stack.pop_back();
	_current_state.exited(self);
	_current_state = _state_stack.back();
	var state_name = _current_state.name.to_lower();
	_update_visuals(state_name);
	
	if _current_state == null:
		_current_state = states["move"];
	_current_state.entered(self);
	
	
	if immediate:
		_immediate = true;


func move(target: float) -> void:
	var motion = target;
	var delta = get_physics_process_delta_time();
	
	if is_equal_approx(target, 0.0):
		motion = -sign(velocity.x) * speed * deceleration;
	elif is_equal_approx(sign(target), sign(velocity.x)) or is_zero_approx(velocity.x):
		motion *= acceleration;
	else:
		motion *= deceleration;
	
	var accel = motion * delta;
	var remainder = target - velocity.x;
	
	var over_limit = false;
	if is_equal_approx(sign(target), sign(velocity.x)):
		if abs(velocity.x) >= speed:
			over_limit = true;
	else:
		over_limit = false;
	
	var on_ground = on_ground();
	
	if not over_limit:
		if abs(remainder) < abs(accel):
			velocity.x += remainder;
		else:
			velocity.x = clamp(velocity.x + accel, -speed, speed);
	elif not on_ground:
		velocity.x = lerp(velocity.x, 0.0, 0.98 * delta);
	
	if not on_ground:
		velocity += gravity * delta;
	
	velocity = move_and_slide(velocity, Vector2(0.0, -1.0), false, 4, deg2rad(35.0));


func _update_visuals(state_name: String):
	for visual in $Visuals.get_children():
		visual.hide();
	
	match state_name:
		"idle":
			$Visuals/Idle.show();
		"ledge":
			$Visuals/Hanging.show();
		"move":
			$Visuals/Moving.show();
		"fall":
			$Visuals/Midair.show();
		"project":
			$Visuals/Projection.show();
		"slam":
			$Visuals/Slam.show();


func on_roof() -> bool:
	for head_ray in _head_rays.get_children():
		if head_ray.is_colliding():
			return true;
	return false;


func on_ground() -> bool:
	for ground_ray in _ground_rays.get_children():
		if ground_ray.is_colliding():
			return true;
	return false;


func get_platform_input() -> bool:
	if Dialogic.get_variable("Can Platform") != "1" and not force_allow_platform:
		return false;
	
	if not on_ground():
		if OS.get_ticks_msec() - _time_try_platform < platform_leeway * 1000:
			return true;
		
		if Input.is_action_just_pressed("platform"):
			return true;
	return false;


func get_project_input() -> bool:
	if Dialogic.get_variable("Can Project") != "1" and not force_allow_project:
		return false;
	
	if not on_ground():
		if OS.get_ticks_msec() - _time_try_project < project_leeway * 1000:
			return true;
		
		if Input.is_action_just_pressed("project"):
			return true;
	return false;


func get_roll_input() -> bool:
	if Dialogic.get_variable("Can Roll") != "1" and not force_allow_roll:
		return false;
	
	if on_ground():
		if OS.get_ticks_msec() - _time_try_roll < roll_leeway * 1000:
			return true;
		
		if Input.is_action_just_pressed("roll"):
			return true;
	return false;


func get_slam_input() -> bool:
	if Dialogic.get_variable("Can Slam") != "1" and not force_allow_slam:
		return false;
	
	if _slams <= 0:
		return false;
	
	if Input.is_action_just_pressed("move_down"):
		if not on_ground():
			return true;
	return false;


func get_jump_input(ignore_ground: bool = false, disable_buffer: bool = false) -> bool:
	if ignore_ground:
		if Input.is_action_just_pressed("move_up"):
			time_of_jump = OS.get_ticks_msec();
			return true;
		
		if disable_buffer:
			pass;
		elif OS.get_ticks_msec() - time_try_jump < states.jump.jump_buffer * 1000:
			time_of_jump = OS.get_ticks_msec();
			return true;
	else:
		if on_ground():
			if disable_buffer:
				pass;
			elif OS.get_ticks_msec() - time_try_jump < states.jump.jump_buffer * 1000:
				time_of_jump = OS.get_ticks_msec();
				return true;
			if Input.is_action_just_pressed("move_up"):
				time_of_jump = OS.get_ticks_msec();
				return true;
		else:
			if Input.is_action_just_pressed("move_up"):
				if OS.get_ticks_msec() - time_on_ground < states.jump.coyote_time * 1000:
					time_of_jump = OS.get_ticks_msec();
					return true;
				time_try_jump = OS.get_ticks_msec();
	return false;


func get_horizontal_input() -> float:
	return Input.get_action_strength("move_right") - Input.get_action_strength("move_left");
#	return float(int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")));


func _on_interactable_entered(area: Area2D) -> void:
	_interactable = area;
	_interact_label.show();


func _on_interactable_exited(area: Area2D) -> void:
	_interactable = null;
	_interact_label.hide();
