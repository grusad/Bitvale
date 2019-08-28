extends "res://src/mobs/enemies/Enemy.gd"

onready var attack_animation_player = $AttackAnimation

func simple_attack(target):
	attack_animation_player.play("attack")
	target.hit(simple_attack_dmg)
	