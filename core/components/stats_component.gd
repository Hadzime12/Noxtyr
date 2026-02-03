class_name StatsComponent
extends Node

@export var base_hp = 100.0
var current_hp = 100.0

func _ready():
	current_hp = base_hp

func take_damage(amount):
	current_hp -= amount
	if current_hp <= 0:
		get_parent().queue_free()

