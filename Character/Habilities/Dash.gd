extends Node

const ghost_scene = preload("res://Character/Habilities/dash/dash_ghost.tscn")

@onready var duration_timer:Timer = $durationTimer
@onready var ghost_timer:Timer = $GhostTimer

const dash_delay = 0.1
var can_dash = true
var sprite:AnimatedSprite2D


func start_dash(sprite:AnimatedSprite2D,duration):
	self.sprite = sprite
	sprite.material.set_shader_param("mix_weight",0.7)
	sprite.material.set_shader_param("whiten",true)
	
	
	duration_timer.wait_time = duration
	duration_timer.start()
	
	ghost_timer.start()
	instance_ghost()


func instance_ghost():
	var ghost:AnimatedSprite2D = ghost_scene.instantiate()
	ghost.global_transform = get_parent().global_transform
	ghost.frames = sprite.frames
	ghost.animation = sprite.animation
	ghost.frame = sprite.frame
	ghost.scale = Vector2(4,4)
	ghost.flip_h=sprite.flip_h
	
	
	#ghost.texture = aSprite.frame
	get_parent().get_parent().add_child(ghost)

func is_dashing():
	return !duration_timer.is_stopped()


func end_dash():
	ghost_timer.stop()
	sprite.material.set_shader_param("whiten",false)
	
	can_dash = false
	await get_tree().create_timer(dash_delay).timeout
	can_dash = true


func _on_duration_timer_timeout() -> void:
	end_dash()


func _on_ghost_timer_timeout():
	instance_ghost()
