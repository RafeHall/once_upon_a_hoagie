extends Node

signal finished();

export var duration: float = 2.0;

var reversed: bool = false setget _set_reversed;

var _progress: float = 0.0;

onready var overlay: TextureRect = $Overlay;


func _enter_tree() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS;


func _process(delta: float) -> void:
	overlay.material.set_shader_param("progress", _progress);


func play() -> void:
	var tween = get_tree().create_tween();
	_progress = int(reversed);
	tween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS);
	tween.tween_property(self, "_progress", 1.0 - int(reversed), duration);
	tween.set_trans(Tween.TRANS_CUBIC);
	tween.set_ease(Tween.EASE_IN_OUT);
	tween.connect("finished", self, "_finished");


func _set_reversed(_reversed: bool) -> void:
	reversed = _reversed;


func _finished() -> void:
	emit_signal("finished");
