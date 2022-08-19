extends CharacterBody2D

const SPEED = 270.0
#const JUMP_VELOCITY = -400.0
const dash_duration = 0.2
const dash_boost = 3 #% extra de velocidad aplicado a la velocidad base



@onready var aSprite:AnimatedSprite2D = $ASprite
@onready var dash = $Dash


#Esta variable se usa para saber cuál animación de reposo usar (derecha o izquierda)
var last_direction:Vector2 = Vector2.ZERO

func _physics_process(_delta):
	
	if Input.is_action_just_pressed("dash") and dash.can_dash and !dash.is_dashing():
		dash.start_dash(aSprite,dash_duration)
	
	
	#Se consiguen los inputs para general el vector de dirección de movimiento
	var direction = Input.get_vector("left","right","forward","backward")
	if direction: #Animaciones en movimiento
		#cuando hay movimiento
		velocity = direction * SPEED + (direction*SPEED*dash_boost if dash.is_dashing() else Vector2.ZERO)
		
		if direction.x >0:
			aSprite.animation = "nuevo_derecha"
			aSprite.flip_h = false
		elif direction.x <0:
			aSprite.animation = "nuevo_derecha"
			aSprite.flip_h = true
		elif direction.y > 0:
			aSprite.animation = "walk_down"
		elif direction.y < 0:
			aSprite.animation = "walk_up"
		
		last_direction = direction
	else:  #Animaciones estáticas
		if last_direction.x < 0:
			aSprite.animation = "nuevo_estatico"
			aSprite.flip_h = true
		else:
			aSprite.animation = "nuevo_estatico"
			aSprite.flip_h = false
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
