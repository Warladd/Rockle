extends Resource
class_name SaveFile

var gear_coins : int = 0
var gear_amount : int = 1

# Structures
var disk : int = 1
var pillar : int = 0
var boulder : int = 0
var wall : int = 0

# Modifiers
var straight : bool = true
var kick : bool = false
var uppercut : bool = false
var explode : bool = false
var hold : bool = false

# Cost
var disk_cost : int = 50
var pillar_cost : int = 150
var boulder_cost : int = 1000
var wall_cost : int = 20000
