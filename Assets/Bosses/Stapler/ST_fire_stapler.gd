extends State

#var minion_path = preload("res://Assets/Enemies/Amalgoms/BoltAmalgom.tscn")
@export var boss : Stapler_Boss
@onready var rand = RandomNumberGenerator.new()

func Enter():
	%BodySprite.play("Fire")
	%ProtectileSprite.visible = true
	%ProtectileSprite.play("FireProjectile")
	$FireTime.start()
	$SpawnDelay.start()


func spawn_enemies():
	var minions_to_spawn = boss.minion_spawn_count
	var minionID : int
	if minions_to_spawn + Global.minion_count > Global.minion_max:
		minions_to_spawn = Global.minion_max - Global.minion_count
	while minions_to_spawn > 0:
		minionID = rand.randi_range(0,2)
		var minion_path = load(Global.AlmalgomEnemyDict[minionID])
		var minion = minion_path.instantiate()
		minion.global_position = Vector2(%Enemy_Spawner.global_position.x + (-30)*minions_to_spawn, %Enemy_Spawner.global_position.y)
		boss.get_parent().add_child(minion)
		minion.speed = 80
		minions_to_spawn -= 1
		Global.minion_count += 1



func Exit():
	%ProtectileSprite.pause()
	%ProtectileSprite.visible = false


func _on_fire_time_timeout() -> void:
	Transitioned.emit(self,"Transition-Idle_Stapler")


func _on_spawn_delay_timeout() -> void:
	spawn_enemies()
