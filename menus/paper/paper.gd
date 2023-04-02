extends CanvasLayer


onready var effect = $Effect;
onready var effect_buffer = $EffectBuffer;
onready var warping = $Warping;

var rand_offset: Vector2 = Vector2.ZERO;


func _process(delta: float) -> void:
	effect_buffer.rect.size = OS.window_size;
	
	if Global.camera != null:
		var c = Global.camera;
		
		var offset = c.get_camera_screen_center() / c.zoom / OS.window_size.x;
		
		effect.material.set_shader_param("offset", offset + rand_offset);
		warping.material.set_shader_param("time_step", rand_offset.x * 10.0);
	else:
		effect.material.set_shader_param("offset", rand_offset);
		warping.material.set_shader_param("time_step", rand_offset.x * 10.0);


func _on_randomize() -> void:
	randomize();
	rand_offset.x = randf();
	rand_offset.y = randf();
