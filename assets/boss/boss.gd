extends Node2D

var health = 20
var mode = 0
var direction
const speed = 50

@export var target:CharacterBody2D

@onready var label:Label = $Label
@onready var aSprite:AnimatedSprite2D = $AnimatedSprite2D


@onready var ataque_1 = $bullet_pattern_1
@onready var ataque_2 = $bullet_pattern_2
@onready var ataque_3 = $bullet_pattern_3
@onready var ataque_4 = $bullet_pattern_4
#mode 0:descativado, 1:activandose, 2:activado, 3: Mejorado, 4: muerto

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#inputs
	
	
	#State machine
	if mode == 0: #Desactivado, ocurre mientras que el jugador no entra a la sala
		#detectar jugador e iniciar modo 1
		aSprite.animation = "boss_activation"
		aSprite.frame = 0
		aSprite.playing = false
	elif mode == 1: #trancisión a etapa 
		
		aSprite.animation = "boss_activation"
		
		label.text = str(health)
		aSprite.playing = true
	elif mode == 2: #jefe etapa 1: inmovil, ataques simples, recibe daño
		aSprite.animation = "boss_reposo_etapa1"
		ataque_1.disable = false
		pass
	elif mode == 3: #trancisión a etapa 2
		aSprite.animation = "boss_upgrade"
		set_health(150)
		ataque_1.disable = true
		ataque_2.disable = false
		ataque_3.disable = false
		ataque_4.disable = false
	elif mode == 4: #etapa 2:Jefe activado, empieza con ataques simples y sin moverse, recibe daño
		var direction = (target.position-self.position).normalized()
		
		position += speed*direction*delta
		
		if (abs(direction.x) >=abs(direction.y)):
			if direction.x >=0:
				aSprite.animation = "boss_right"
			elif direction.x < 0:
				aSprite.animation = "boss_left"
		else:
			if direction.y >=0:
				aSprite.animation = "boss_front"
			elif direction.y < 0:
				aSprite.animation = "boss_back"
		#else:aSprite.animation = "default"
		
		
		pass
	elif mode == 5: #Jefe derrotado, se cae al suelo
		aSprite.animation = "death"
		ataque_1.disable = true
		ataque_2.disable = true
		ataque_3.disable = true
		ataque_4.disable = true
		


func set_health(new_health):
	health = new_health
	label.text = str(health)

func take_damage(damage):
	
	
	if mode== 2 or mode == 4:
		set_health(health - damage)
	if health <= 0 and mode==2:
		
		mode = 3
	elif health <=0 and mode==4:
		mode = 5
		label.text=""



func _on_hitbox_area_entered(area):
	if area.is_in_group("atack"):
		take_damage(area.get_parent().get_parent().damage)



func _on_animated_sprite_2d_animation_finished():
	#cambiar de modo en los modos de transición
	if mode ==1:
		mode = 2
	if mode == 3:
		mode = 4


func activar(_body):
	if mode == 0:
		mode = 1


