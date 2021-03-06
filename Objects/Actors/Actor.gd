extends KinematicBody2D

###actor_data###
export(int) var max_hp = 100;
#warning-ignore-
export(float) var base_mspd = 100;
var true_mspd;
export(float) var base_jspd = 50;
var true_jspd = 50;
export(String) var tag = "NPC";
export(bool) var enabled = true;

var hp;

###physics vars###
var air_time = 0;
var hspd = 0;
var vspd = 0;
var Direction = 1;
export(float) var base_gravity = 10;
export(float) var base_friction = 50;
var true_friction;
var true_gravity;
export(float) var g_max = 250;
var velocity = Vector2(0,0);
var floor_normal = Vector2(0,-1);
var grav_activated = true;
var fric_activated = true;

func _ready():
	true_gravity = base_gravity;
	true_friction = base_friction;
	true_mspd = base_mspd;
	true_jspd = base_jspd;
	hp = max_hp;
	### default movement controller vars ###
	#1 = right, -1 = left
	Direction = 1;
	velocity = Vector2(0,0);
	floor_normal = Vector2(0,-1);
	pass;

func _process(delta):
	if(enabled):
		execute(delta);
	pass;

func _physics_process(delta):
	if(enabled):
		phys_execute(delta);
	pass;

func execute(delta):
	pass;

func phys_execute(delta):
	pass;

var first = false;
func animate(animator, anim, cont = true):
	animator.stop(cont);
	animator.play(anim);

func Kill():
	#TODO: death anims and effects
	queue_free();

func on_floor():
	return test_move(transform, Vector2(0,1));

func deactivate_grav():
	grav_activated = false;
	vspd = 0;
	velocity.y = 0;

func mitigate_grav():
	vspd = 0;
	velocity.y = 0;
	true_gravity = base_gravity * .5;

func normalize_grav():
	true_gravity = base_gravity;

func deactivate_grav_dont_stop():
	grav_activated = false;

func deactivate_fric():
	fric_activated = false;
	hspd = 0;
	velocity.x = 0;

func activate_grav():
	grav_activated = true;

func activate_fric():
	fric_activated = true;

func cleanup():
	pass;
