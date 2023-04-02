extends Button


export var audio_effect: AudioStreamSample = null;
export var start: float = 0.0;
export var end: float = 1.0;
export var hover_pitch: float = 1.0;
export var unhover_pitch: float = 1.0;
export var press_pitch: float = 1.0;


var last_hover = false;


func _ready() -> void:
	connect("pressed", self, "_pressed");


func _process(delta: float) -> void:
	if audio_effect != null:
		var hover = is_hovered();
		
		if hover && !last_hover:
			UiAudioServer.play_sound(audio_effect, start, end, hover_pitch);
		elif !hover && last_hover:
			UiAudioServer.play_sound(audio_effect, start, end, unhover_pitch);
		
		last_hover = hover;


func _pressed() -> void:
	if audio_effect != null:
		UiAudioServer.play_sound(audio_effect, start, end, press_pitch);
