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

var player_stats = []

func _ready():
	player_stats.resize(56)
	for i in range(56):
		player_stats.append(0.0)
	_init_konstantin()

func _init_konstantin():
	player_stats[Stat.CONSTITUTION] = 12.0
	player_stats[Stat.STRENGTH] = 14.0
	player_stats[Stat.DEXTERITY] = 10.0
	player_stats[Stat.INTELLIGENCE] = 8.0
	player_stats[Stat.LUCK] = 10.0
	player_stats[Stat.MAX_HP] = 20.0 + player_stats[Stat.CONSTITUTION] * 5.0
	player_stats[Stat.MAX_MP] = 10.0 + player_stats[Stat.INTELLIGENCE] * 3.0
	player_stats[Stat.CUR_HP] = player_stats[Stat.MAX_HP]
	player_stats[Stat.CUR_MP] = player_stats[Stat.MAX_MP]

func get_stat(s):
	return player_stats[s]

func modify_stat(s, delta):
	player_stats[s] += delta
	if s == Stat.CUR_HP:
		player_stats[s] = clamp(player_stats[s], 0.0, player_stats[Stat.MAX_HP])

