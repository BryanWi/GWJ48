extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var aSprite:AnimatedSprite2D = $ASprite

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = 0 #ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Se removió la gravedad ya que es un top_botom
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	var direction = Input.get_vector("left","right","forward","backward")
	if direction:
		#cuando hay movimiento
		velocity = direction * SPEED
	else:
		aSprite.animation = "default"
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
