extends Node2D

const speed = 100
var damage = 25
var lifespan = 10

@onready var timer:Timer = $KillTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = lifespan
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position +=transform.x * speed * delta


func _on_kill_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	if body.has_method("take_damage") and body.is_in_group("Player"):
		body.take_damage(damage)
		if body.dash.is_dashing():
			return
	queue_free()


func _on_area_2d_area_entered(area):
	if area.is_in_group("atack") or area.is_in_group("limit"):
		queue_free()

