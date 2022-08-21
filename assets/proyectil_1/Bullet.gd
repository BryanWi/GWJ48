extends Node2D

const speed = 100

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
