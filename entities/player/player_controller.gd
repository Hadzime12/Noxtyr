class_name PlayerController
extends CharacterBody2D

@export var speed = 150.0
var joystick_vector = Vector2.ZERO

func _physics_process(delta):
	velocity = joystick_vector * speed
	move_and_slide()

func set_joystick(v):
	joystick_vector = v

