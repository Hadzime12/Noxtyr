#!/bin/bash
# Noxtyr Godot 4 Project Setup Script
# Run: bash setup-project.sh

mkdir -p noxtyr/{autoload,core/components,core/systems,entities/{player,enemies},ui/hud,scenes,assets/sprites}

cd noxtyr

cat > project.godot << 'EOF'
; Noxtyr Project Configuration
[application]
config/name="Noxtyr"
config/description="2.5D Dark Fantasy Action RPG for Android"
run/main_scene="res://scenes/game.tscn"
config/features=PackedStringArray("4.2", "Mobile")
boot_splash/bg_color=Color(0.0196078, 0.0196078, 0.0313726, 1)

[display]
window/size/viewport_width=1080
window/size/viewport_height=2640
window/stretch/mode="canvas_items"
window/stretch/aspect="expand"
window/handheld/orientation=5
window/vsync/vsync_mode=0

[rendering]
renderer/rendering_method="mobile"
textures/vram_compression/import_etc2_astc=true
frame_limits/frame_limit=120

[autoload]
GameState="*res://autoload/game_state.gd"

[input_devices]
pointing/emulate_touch_from_mouse=true
EOF

cat > autoload/game_state.gd << 'EOF'
extends Node

enum Stat {
	CUR_HP = 0, CUR_MP = 1, CUR_WALK_DIST = 2, POISONED = 3, STUNNED = 4,
	STONE = 5, DEAD = 6, EXP = 7, LVL = 8, CONSTITUTION = 9, INTELLIGENCE = 10,
	STRENGTH = 11, DEXTERITY = 12, LUCK = 13, MAX_HP = 14, MAX_MP = 15,
	WALK_DIST = 16, SIGHT = 17, ATK_RANGE = 18, REGENERATING = 19,
	MANA_REGEN = 20, PHYS_RES = 21, BLACK_RES = 22, WHITE_RES = 23,
	PHYS_ABS_RES = 24, BLACK_ABS_RES = 25, WHITE_ABS_RES = 26,
	PHYS_BONUS = 27, BLACK_BONUS = 28, WHITE_BONUS = 29,
	PHYS_ABS_DMG = 30, BLACK_ABS_BONUS = 31, WHITE_ABS_BONUS = 32,
	SPEED_ATK = 33, SIGHT_ATK = 34, RANGE_ATK = 35, POISON_ATK = 36,
	STUN_ATK = 37, VAMPIRIC_ATK = 38, PIERCE_ATK = 39, ATTACK = 40,
	DEFEND = 41, TACTICS = 42, SHOOTING = 43, KILL = 44, ATHLETICS = 45,
	FIRE_RES = 46, EARTH_RES = 47, WATER_RES = 48, AIR_RES = 49,
	ASTRAL_RES = 50, FIRE_BONUS = 51, EARTH_BONUS = 52, WATER_BONUS = 53,
	AIR_BONUS = 54, ASTRAL_BONUS = 55
}

var player_stats: Array[float] = []

func _ready():
	player_stats.resize(56)
	player_stats.fill(0.0)
	_init_konstantin()

func _init_konstantin():
	player_stats[Stat.CONSTITUTION] = 12
	player_stats[Stat.STRENGTH] = 14
	player_stats[Stat.DEXTERITY] = 10
	player_stats[Stat.INTELLIGENCE] = 8
	player_stats[Stat.LUCK] = 10
	player_stats[Stat.MAX_HP] = 20 + player_stats[Stat.CONSTITUTION] * 5
	player_stats[Stat.MAX_MP] = 10 + player_stats[Stat.INTELLIGENCE] * 3
	player_stats[Stat.CUR_HP] = player_stats[Stat.MAX_HP]
	player_stats[Stat.CUR_MP] = player_stats[Stat.MAX_MP]

func get_stat(s: int) -> float:
	return player_stats[s]

func modify_stat(s: int, delta: float):
	player_stats[s] += delta
	if s == Stat.CUR_HP:
		player_stats[s] = clamp(player_stats[s], 0, player_stats[Stat.MAX_HP])
EOF

cat > core/components/stats_component.gd << 'EOF'
class_name StatsComponent
extends Node

@export var base_hp: float = 100.0
@export var base_strength: float = 10.0
var current_hp: float = 100.0
var modifiers: Array = []

func _ready():
	current_hp = base_hp

func get_stat(key: String) -> float:
	match key:
		"hp": return current_hp
		"max_hp": return base_hp
		"strength": return base_strength
	return 0.0

func take_damage(amount: float):
	current_hp -= amount
	current_hp = max(0, current_hp)
	if current_hp == 0:
		get_parent().queue_free()
EOF

cat > entities/player/player_controller.gd << 'EOF'
class_name PlayerController
extends CharacterBody2D

@export var speed: float = 150.0
var joystick_vector: Vector2 = Vector2.ZERO
var is_attacking: bool = false

func _physics_process(delta):
	if not is_attacking:
		velocity = joystick_vector * speed
	move_and_slide()

func set_joystick(v: Vector2):
	joystick_vector = v

func attack():
	if is_attacking: return
	is_attacking = true
	$AnimationPlayer.play("attack")
	await $AnimationPlayer.animation_finished
	is_attacking = false
EOF

cat > scenes/game.tscn << 'EOF'
[gd_scene load_steps=3 format=3 uid="uid://game"]

[ext_resource type="Script" path="res://entities/player/player_controller.gd" id="1_player"]
[ext_resource type="Script" path="res://core/components/stats_component.gd" id="2_stats"]

[node name="Game" type="Node2D"]

[node name="Player" type="CharacterBody2D" parent="."]
script = ExtResource("1_player")

[node name="StatsComponent" type="Node" parent="Player"]
script = ExtResource("2_stats")

[node name="Camera2D" type="Camera2D" parent="Player"]
zoom = Vector2(2, 2)
EOF

echo "Project created in ./noxtyr/"
echo "Open in Godot Editor for Android or upload to GitHub"

