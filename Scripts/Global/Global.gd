extends Node


enum Colour_States {K,C,Y,M}
var colourDict = {0:Vector4(1,1,1,1) , 1:Vector4(0,1,1,1),2:Vector4(1,1,0,1), 3:Vector4(1,0,1,1)}
var ink_counts = {Global.Colour_States.K: 0, Global.Colour_States.C: 0 , Global.Colour_States.Y: 0, Global.Colour_States.M:0}

#dictionary of scnese for spawning in the Stapler boss
var AlmalgomEnemyDict = {0:"res://Assets/Enemies/Amalgoms/BoltAmalgom.tscn", 1:"res://Assets/Enemies/Amalgoms/BoltAmalgom.tscn",2:"res://Assets/Enemies/Amalgoms/BoltAmalgom.tscn"}

var Levels : Dictionary = {0: "res://Levels/Level_KC.tscn", 1:"res://Levels/StaplerBossLevel.tscn", 2: "res://Levels/Level_KCY.tscn", 3:"res://Levels/PaperJamBossLevel.tscn", 4:"res://Levels/YOUWINLVL.tscn"}
var current_Level = 0

var checkpoint_pos = Vector2(-999999999,-999999999)
var previous_checkpoint : Sprite2D = null

var unlocked_k : bool = true
var unlocked_c : bool = false
var unlocked_y : bool = false
var unlocked_m : bool = false

#InkGathering from enemies:
func gain_ink(ink : Global.Colour_States):
	ink_counts[ink] += 1

func lose_ink(ink :Global.Colour_States):
	ink_counts[ink] -= 1
	
func reload_level():
	minion_count = 0
	ChangeScene(Levels[current_Level])

func next_level():
	checkpoint_pos = Vector2(-999999999,-999999999)
	minion_count = 0
	if current_Level == 1:
		unlocked_y = true
	current_Level += 1
	
		
	ChangeScene(Levels[current_Level])

func ChangeScene(_path : String):
	get_tree().change_scene_to_file(_path)
	
	
	
	##LEVEL SPECIFIC STUFF
	
#Stapler Boss
var minion_count = 0
var  minion_max = 5
	
