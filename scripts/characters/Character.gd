extends CharacterBody2D

var state_machine
var is_attacking: bool = false
var stop_move: bool = false

@export_category("Variables")
@export var move_speed: float = 64.0
@export var acceleration: float = 0.2
@export var friction: float = 0.2

@export_category("Objects")
@export var animation_tree: AnimationTree = null
@export var attack_timer: Timer = null

func _ready() -> void:
	animation_tree.active = true # Sempre q roda o projeto ativa o animation tree
	state_machine = animation_tree["parameters/playback"]

func _physics_process(delta: float) -> void:
	if not stop_move:
		move()
		move_and_slide()
	attack()
	animate()

	
func move() -> void:
	var direction : Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	
	if direction != Vector2.ZERO:
		#Pega a direção do personagem e coloca no blend_position
		animation_tree["parameters/idle/blend_position"] = direction
		animation_tree["parameters/walk/blend_position"] = direction
		animation_tree["parameters/attack/blend_position"] = direction
		
		velocity.x = lerp(velocity.x, direction.normalized().x * move_speed, acceleration)
		velocity.y = lerp(velocity.y, direction.normalized().y * move_speed, acceleration)
		return
		
	velocity.x = lerp(velocity.x, direction.normalized().x * move_speed, friction)
	velocity.y = lerp(velocity.y, direction.normalized().y * move_speed, friction)	


func attack():
	if Input.is_action_just_pressed("attack") and not is_attacking:
		attack_timer.start()
		is_attacking = true
		stop_move = true


func animate():
	
	if is_attacking:
		state_machine.travel("attack")
		# tem q bota o return para a animação roda/funcionar
		return 
	
	if velocity.length() > 5:
		state_machine.travel("walk")
		return
	
	state_machine.travel("idle")


func _on_attack_timer_timeout():
	is_attacking = false
	stop_move = false


# Caso ele entre em contando com 
func _on_attack_area_body_entered(body) -> void:
	# Determina o grupo 
	if body.is_in_group("enemy"):
		body.update_health(5)
