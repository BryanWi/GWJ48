extends Sprite2D

@onready var tween:Tween = get_tree().create_tween()


func _ready():
	tween.set_trans(Tween.TRANS_CUBIC)
	#tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"modulate.a",0.0,2.0)
	


func _process(_delta):
	pass
