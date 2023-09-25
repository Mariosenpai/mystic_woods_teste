extends CharacterBody2D

@export_category("Variables")
@export var move_speed: float = 64.0

func _physics_process(delta: float) -> void:
    move()
    
func move() -> void:
    var direction : Vector2 = Vector2(
        Input.get_axis("move_left", "move_right"),
        Input.get_axis("move_up", "move_down")
    )
    
    velocity = direction.normalized() * move_speed
    move_and_slide()
