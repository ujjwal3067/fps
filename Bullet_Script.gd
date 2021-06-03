extends Spatial

var BULLET_SPEED = 70
var BULLET_DAMAGE = 15

const KILL_TIMER = 4 # How long a bullet can last without hitting anything
var timer = 0
var hit_something = false

func _ready():
	$Area.connect("body_entered", self, "collided")

func _physics_process(delta):

	var forward_dir = global_transform.basis.z.normalized() # get the bullet forward direction
	global_translate(forward_dir *BULLET_SPEED *delta)
	timer += delta
	if timer >= KILL_TIMER :
		queue_free() #  used to destroy the node safely at the end of the frame and also remove it from tree.

func collided(body):
	if hit_something == false :
		if body.has_method("bullet_hit"):
			body.bullet_hit(BULLET_DAMAGE, global_transform)
	hit_something = true
	queue_free()
