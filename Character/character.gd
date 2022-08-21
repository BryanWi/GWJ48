extends CharacterBody2D


const SPEED = 270.0
#const JUMP_VELOCITY = -400.0
const dash_duration = 0.15
const dash_boost = 3 #% extra de velocidad aplicado a la velocidad base
const damage = 50

var health = 100

@onready var aSprite:AnimatedSprite2D = $ASprite
@onready var dash = $Dash
@onready var label = $Label
@onready var atack_timer:Timer = $AtackTimer
@onready var inmune_timer:Timer = $InmuneTimer

@onready var hitbox_pivot:Position2D = $hitboxPivot
@onready var hitbox:CollisionShape2D = $hitboxPivot/hitbox/CollisionShape2D

#Esta variable se usa para saber cuál animación de reposo usar (derecha o izquierda)
var last_direction:Vector2 = Vector2.ZERO

func _ready():
	label.text = str(health)


func _physics_process(_delta):
	
	if Input.is_action_just_pressed("dash") and dash.can_dash and !dash.is_dashing():
		dash.start_dash(aSprite,dash_duration)
	if Input.is_action_just_pressed("atack"):
		
		if atack_timer.is_stopped():
			aSprite.animation = "ataque_derecho"
			
			atack_timer.start()
			hitbox.disabled = false
			await get_tree().create_timer(0.4).timeout
			hitbox.disabled = true
	
	#Se consiguen los inputs para general el vector de dirección de movimiento
	var direction = Input.get_vector("left","right","forward","backward")
	if direction: #Animaciones en movimiento
		#cuando hay movimiento
		velocity = direction * SPEED + (direction*SPEED*dash_boost if dash.is_dashing() else Vector2.ZERO)
		if direction.x >0 :
			aSprite.flip_h = false
			hitbox_pivot.rotation = 0
		elif direction.x <0:
			aSprite.flip_h = true
			hitbox_pivot.rotation = PI
		elif direction.y >0 :
			hitbox_pivot.rotation = PI/2
		elif direction.y <0:
			hitbox_pivot.rotation = PI*3/2
		
		if atack_timer.is_stopped():
			if direction.x >0 :
				aSprite.animation = "nuevo_derecha"
			elif direction.x <0:
				aSprite.animation = "nuevo_derecha"
			elif direction.y > 0:
				aSprite.animation = "walk_down"
			elif direction.y < 0:
				aSprite.animation = "walk_up"
		
		last_direction = direction
	else:  #Animaciones estáticas
		if atack_timer.is_stopped():
			if last_direction.x < 0:
				aSprite.animation = "nuevo_estatico"
				aSprite.flip_h = true
			else:
				aSprite.animation = "nuevo_estatico"
				aSprite.flip_h = false
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()


func take_damage(get_damage):
	
	if !dash.is_dashing() and inmune_timer.is_stopped():
		health -= get_damage
		inmune_timer.start()
		label.text = str(health)
	if health <= 0:
		get_tree().quit()
		restart()


func restart():
	pass


func _on_hitbox_body_entered(body):
	print(body)
	if body.has_method("take_damage") and body.is_in_group("enemy"):
		body.take_damage(damage)


func _on_atack_timer_timeout():
	pass
	#hitbox.disabled = true
