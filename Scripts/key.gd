extends BaseCollectable

@onready var key: Node3D = $key
@onready var omni_light_3d: OmniLight3D = $OmniLight3D

## there are only 3 keys, maybe we make those keys further inherited scenes
@export var _key_num : int:
	get:
		return _key_num
	set(val):
		_key_num = clampi(val, 0,2)
		_key_num = val
@export_category("🗝 Physical Properties")
@export var rotation_speed: float = 1.4
@export_range(0,1,.05,"suffix:m") var bob_amplitude: float = 0.2
@export_range(1,8,.1,"suffix:rads/sec") var bob_freq: float= 4.0
@export var light:bool = true
var bob_bucket:float = 0

func _ready() -> void:
	super._ready()
	omni_light_3d.visible = light

func _process(delta: float) -> void:
	bob_bucket = fmod(bob_bucket + delta*bob_freq, PI*2)
	key.position.y = sin(bob_bucket) * bob_amplitude
	global_rotate(Vector3.UP, rotation_speed * delta)	

func do_pickup_action() -> void:
	KeyManager.ref.key_count += 1
	GhostManager.ref.set_danger_level(0)
	GhostManager.ref.set_danger_percentage(0)
	queue_free()
