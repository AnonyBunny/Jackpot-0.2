extends KinematicBody

# base variables used for determining the speed and gravity of the character
# along with the direction of movement
# speed itself is exported to be changed depending on armor
# haven't figured out how to do it but it's probably easy
export var speed = 7
var gravity = 10
var move_direction = Vector3.ZERO

# controls dash speed with "additional_speed" added, a cooldown timer and a bool
var ad_speed = 0
var dashed = false
var dash_cooldown_timer = 0.0

# this is for the pause menu, heaven knows why you'd need it considering-
# it doesn't stop the game but it's here
onready var pause_menu = $"User Interface/Pause Menu"
var paused = false

func _physics_process(delta):
	#gravity is constant actually, since we don't have a need for jumping
	move_direction.y = -gravity
	if not paused:
		movement_input()
	pause_input()
	# dash variables to check if you have dashed and if additional(dashing) speed is 0
	# ad_speed multiplies base speed so dashing is actually omni-directional if you're fast enough
	if dashed:
		dash_cooldown_timer += delta
		if dash_cooldown_timer >= 7:
			dash_cooldown_timer = 0
			dashed = false
	
	if ad_speed > 0:
		ad_speed -= .5
		move_direction.x = move_direction.x * ad_speed
		move_direction.z = move_direction.z * ad_speed
	#warning-ignore: return_value_discarded
	move_and_slide(move_direction, Vector3.UP)

# as the function itself says, movement_input controls the inputs of your movement and additional movement capabilities
func movement_input():
	move_direction.x = Input.get_axis("a", "d") * speed
	move_direction.z = Input.get_axis("w","s") * speed
	if Input.is_action_just_pressed("shift") and !dashed:
		ad_speed += 5
		dashed = true

# for the life of me this does not make a lick of sense but whatever, it pauses
func pause_input():
	if Input.is_action_pressed("pause_button") and not paused:
		pause_menu.show()
		paused = true


func _on_Resume_pressed():
	pause_menu.hide()
	paused = false


func _on_Quit_pressed():
	get_tree().quit()
