extends Node2D

const bullet_scene = preload("res://assets/proyectil_1/bullet.tscn")

var health:float = 100

@export var rotate_speed = 100
@export var shooter_timer_wait_time = 0.25
@export var spawn_point_count = 4
@export var radius = 15

@onready var label:Label = $Label

@onready var shoot_timer = $ShootTimer
@onready var rotator:Node2D = $Rotator

func _ready():
	var step = 2 * PI / spawn_point_count
	label.text = str(health)
	#label.text = str(health)
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step*i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotator.add_child(spawn_point) 
	
	shoot_timer.wait_time = shooter_timer_wait_time
	shoot_timer.start()


func _process(delta):
	var new_rotation = rotator.rotation + deg2rad(rotate_speed)*delta
	rotator.rotation = fmod(new_rotation,2*PI)

func _on_shoot_timer_timeout():
	for s in rotator.get_children():
		var bullet = bullet_scene.instantiate()
		get_tree().get_root().add_child(bullet)
		
		bullet.position = s.global_position
		bullet.rotation = s.global_rotation


func take_damage(damage):
	health -= damage
	label.text = str(health)
	if health <= 0:
		get_tree().quit()
		#restart()
	
