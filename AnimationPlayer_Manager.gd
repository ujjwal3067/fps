extends AnimationPlayer

# Structure -> Animation Name : [Connecting Animation States ]
# Similar to State  Machines in Bio Informatics ( Viterbi Algorithm )
var states = {
	"Idle_unarmed"  :["Knife_equip", "Pistol_equip", "Rifle_equip", "Idle_unarmed"],
	"Pistol_equip"  :["Pistol_idle"],
	"Pistol_fire"   :["Pistol_idle"],
	"Pistol_idle"   :["Pistol_fire", "Pistol_reload", "Pistol_unequip", "Pistol_idle"],
	"Pistol_reload" :["Pistol_idle"],
	"Pistol_unequip":["Idle_unarmed"],

	"Rifle_equip"	:["Rifle_idle"],
	"Rifle_fire"	:["Rifle_idle"],
	"Rifle_idle"	:["Rifle_fire", "Rifle_reload", "Rifle_unequip", "Rifle_idle"],
	"Rifle_reload"	:["Rifle_idle"],
	"Rifle_unequip"	:["Idle_unarmed"],

	"Knife_equip"	:["Knife_idle"],
	"Knife_fire"	:["Knife_idle"],
	"Knife_idle"	:["Knife_fire", "Knife_unequip", "Knife_idle"],
	"Knife_unequip"	:["Idle_unarmed"],

}

# Structure -> Animation Speed
var animation_speeds = {
	"Idle_unarmed":1,

	"Pistol_equip":1.4,
	"Pistol_fire":1.8,
	"Pistol_idle":1,
	"Pistol_reload":1,
	"Pistol_unequip":1.4,

	"Rifle_equip":2,
	"Rifle_fire":6,
	"Rifle_idle":1,
	"Rifle_reload":1.45,
	"Rifle_unequip":2,

	"Knife_equip":1,
	"Knife_fire":1.35,
	"Knife_idle":1,
	"Knife_unequip":1,
}


var current_state = null # keeps tracks of current animation playing
var callback_function = null # funcref ( for passing function as arguments  )

func _ready():
	set_animation("idle_unarmed") # setting ready animation
	# when animation is ended this animation_ended() function is going to be called :" automatic"
	connect("animation_finished", self, "animation_ended") # connecting signal animation_ended with function animation_ended(anin_name)

func set_animation(animation_name):
	if animation_name == current_state:
		print("AnimationPlayer_Manager.gd -- WARNING : animation is already ", animation_name)
		return true

	if has_animation(animation_name):
		if current_state != null :
			var possible_animations = states[current_state] # get the possible states of animation possible after current state
			if animation_name in possible_animations:
				# blend time = -1 and 3rd parameter is for animation speed
				play(animation_name, -1, animation_speeds[animation_name])
				return true
			else:
				# Inputed animation_name cannot be player after current state
				print("AnimationPlayer_Manager.gd -- WARNING: Cannot change to ", animation_name, " from ", current_state)
				return false
		else:
			current_state = animation_name
			play(animation_name, -1, animation_speeds[animation_name])
			return true
	return false


# transtion from active to idle state for various active state
func animation_ended(anim_name):

	# UNARMED transitions
	if current_state == "Idle_unarmed":
		pass
	# KNIFE transitions
	elif current_state == "Knife_equip":
		set_animation("Knife_idle")
	elif current_state == "Knife_idle":
		pass
	elif current_state == "Knife_fire":
		set_animation("Knife_idle")
	elif current_state == "Knife_unequip":
		set_animation("Idle_unarmed")
	# PISTOL transitions
	elif current_state == "Pistol_equip":
		set_animation("Pistol_idle")
	elif current_state == "Pistol_idle":
		pass
	elif current_state == "Pistol_fire":
		set_animation("Pistol_idle")
	elif current_state == "Pistol_unequip":
		set_animation("Idle_unarmed")
	elif current_state == "Pistol_reload":
		set_animation("Pistol_idle")
	# RIFLE transitions
	elif current_state == "Rifle_equip":
		set_animation("Rifle_idle")
	elif current_state == "Rifle_idle":
		pass
	elif current_state == "Rifle_fire":
		set_animation("Rifle_idle")
	elif current_state == "Rifle_unequip":
		set_animation("Idle_unarmed")
	elif current_state == "Rifle_reload":
		set_animation("Rifle_idle")

func animation_callback():
	if callback_function == null:
		print ("AnimationPlayer_Manager.gd -- WARNING: No callback function for the animation to call!")
	else:
		callback_function.call_func()
