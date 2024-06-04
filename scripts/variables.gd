extends Resource
class_name SaveFile

@export var gear_coins : int = 0
@export var belt : int = 0
# White Belt = 0
# Yellow Belt = 1
# Green Belt = 2
# Blue Belt = 3
# Red Belt = 4
# Black Belt = 5
# Black Belt Mastery = 6
@export var tutorial : bool = true
@export var safe_opened : bool = false

# Structures
@export var disk : int = 1
@export var pillar : int = 0
@export var ball : int = 0
@export var cube : int = 0
@export var wall : int = 0

@export var disk_increase : int = 1
@export var pillar_increase : int = 10
@export var ball_increase : int = 200
@export var cube_increase : int = 10000
@export var wall_increase : int = 5000
@export var general_increase : int = 1

# Modifiers
@export var straight : bool = true
@export var kick : bool = false
@export var uppercut : bool = false
@export var stomp : bool = false
@export var hold : bool = false
@export var parry : bool = false

# Masteries
@export var straight_mastery : bool = false
@export var straight_active : bool = false
# Black Belt
@export var black_belt_mastery : bool = false

# Cost
@export var disk_cost : int = 50
@export var pillar_cost : int = 150
@export var ball_cost : int = 1000
@export var wall_cost : int = 20000
@export var cube_cost : int = 150000
