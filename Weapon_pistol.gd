extends Spatial

const DAMAGE = 13
const IDLE_ANIM_NAME = "Pistol_idle"
const FIRE_ANIM_NAME = "Pistol_fire"
var is_weapon_enabled = false
var bullet_scene= preload("Bullet_Scene.tscn") # preload the bullet prefab
var player_node = null

func _ready():
	pass

func _ready_weapon():
	# adding bullet in the scene
	var clone = bullet_scene.instance()
	var scene_root= get_tree().root.get_children()[0]
	scene_root.add_child(clone)
	clone.global_transform = self.global_transform # spawning bullet at the end of the pistol
	clone.scale = Vector3(4,4,4)
	clone.BULLET_DAMAGE = DAMAGE

func equip_weapon():
	if player_node.animation_manager.current_state == IDLE_ANIM_NAME:
		is_weapon_enabled = true
		return true
	if player_node.animation_manager.current_state == "idle_unarmed":
		player_node.animation_manager.set_animation("Pistol_equip")
	return false

func unequip_weapon():
	if player_node.animation_manager.current_state == IDLE_ANIM_NAME:
		if player_node.animation_manager.current_state != "Pistol_unequip":
			player_node.animation_manager.set_animation("Pistol_equip")

		if player_node.animation_manager.current_state == "Idle_unarmed":
			is_weapon_enabled = false
			return true
		else :
			return false
