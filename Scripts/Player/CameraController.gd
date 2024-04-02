## Handles the player's camera.
class_name CameraController extends Camera2D

var curr_target: Node2D

func _ready() -> void:
	set_physics_process( false )

func set_target(new_target: Node2D) -> void:
	curr_target = new_target
	set_physics_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position = curr_target.position
