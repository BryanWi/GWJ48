extends AnimatedSprite2D

@onready var tween:Tween = get_tree().create_tween()


func _ready():
	#var tween:Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"modulate:a",0.0,0.5)
	tween.tween_callback(finished)

func finished():
	self.queue_free()
func _process(_delta):
	pass
