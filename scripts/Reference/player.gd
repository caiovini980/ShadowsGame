extends CharacterBody2D
# REFERENCES
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var jump_sound = $JumpSound

# CONSTANTS
const SPEED = 150.0
const JUMP_VELOCITY = -300.0

# VARIABLES
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_crouched : bool = false
var is_idle : bool = false
var is_running : bool = false

# METHODS
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animated_sprite_2d.play("jump")
		jump_sound.play()

	# Handle crouch
	if Input.is_action_just_pressed("crouch") and is_on_floor():
		is_crouched = true
		animated_sprite_2d.play("crouch")
		
	if Input.is_action_just_released("crouch") and is_on_floor():
		is_crouched = false
		animated_sprite_2d.play("crouch")
		
	# Get the input 
	var direction : float = Input.get_axis("move_left", "move_right")
	handle_direction(direction)
	apply_movement(direction)
	play_movement_animations(direction)

	move_and_slide()

func handle_direction(direction):
	if direction > 0:
		animated_sprite_2d.flip_h = false
		
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
func apply_movement(direction):
	if is_crouched: 
		return
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func play_movement_animations(direction):
	if direction == 0 and is_on_floor() and not is_crouched:
		animated_sprite_2d.play("idle")
		is_idle = true;
		is_running = false;
		
	if direction != 0 and is_on_floor() and not is_crouched:
		animated_sprite_2d.play("run")
		is_idle = false;
		is_running = true;
		
	if !is_on_floor():
		animated_sprite_2d.play("fall")
