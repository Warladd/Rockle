extends Resource
class_name SaveFile

@export var gear_coins : int = 0

# Structures
@export var disk : int = 1
@export var pillar : int = 0
@export var boulder : int = 0
@export var wall : int = 0

# Modifiers
@export var straight : bool = true
@export var kick : bool = false
@export var uppercut : bool = false
@export var explode : bool = false
@export var hold : bool = false

# Cost
@export var disk_cost : int = 50
@export var pillar_cost : int = 150
@export var boulder_cost : int = 1000
@export var wall_cost : int = 20000
