extends "res://Objects/Actors/Actor.gd"

signal consume_resource;

###states###
#TODO: hurt_state
###states###
#TODO: hurt_state
onready var move_states = {
	'move_on_ground' : $Movement_States/Move_On_Ground,
	'move_in_air' : $Movement_States/Move_In_Air,
	'ledge_grab' : $Movement_States/Ledge_Grab
}
var move_state = 'move_on_ground';

onready var style_states = {
	'wind_dance' : $Style_States/Wind_Dance,
	'closed_fan' : $Style_States/Closed_Fan
}
var style_state = 'wind_dance';

###hitbox detection###
var targettableHitboxes = [];
var itemTrace = [];

###camera control###
onready var cam = get_node("Camera2D");

###Player Vars###
var magic_bool = false;
var stamina_bool = true;
var mana = 100;
var max_mana = 100;
var stamina = 100;
var max_stamina = 100;
var resource = 0;
var rad = 0.0;
var deg = 0.0;
var grav_activated = true;
var fric_activated = true;

enum InputType {GAMEPAD, KEYMOUSE};
var ActiveInput = InputType.GAMEPAD;


func _ready():
	$Camera2D.current = true;
	max_hp = 1;
	damage = 1;
	mspd = 200;
	jspd = 400;
	hp = max_hp;
	tag = "player";
	gravity = 20;
	move_states[move_state].enter();
	style_states[style_state].enter();

func _input(event):
	if(event.get_class() == "InputEventMouseButton" || event.get_class() == "InputEventKey" || Input.get_connected_joypads().size() == 0):
		ActiveInput = InputType.KEYMOUSE;
	elif(event.get_class() == "InputEventJoypadMotion" || event.get_class() == "InputEventJoypadButton"):
		ActiveInput = InputType.GAMEPAD;


func execute(delta):
	if(ActiveInput == InputType.KEYMOUSE):
		rad = atan2(get_global_mouse_position().y - global_position.y , get_global_mouse_position().x - global_position.x);
	elif(ActiveInput == InputType.GAMEPAD):
		rad = atan2(Input.get_joy_axis(0, JOY_ANALOG_LY), Input.get_joy_axis(0, JOY_ANALOG_LX));
	deg = rad2deg(rad);
	
	hitboxLoop();

func phys_execute(delta):
	_stretch_based_on_velocity()
	#print(move_state);
	#state machine
	move_states[move_state].handleAnimation();
	move_states[move_state].handleInput();
	move_states[move_state].execute(delta);
	style_states[style_state].handleInput();
	style_states[style_state].handleAnimation();
	#count time in air
	air_time += delta;
	
	#move across surfaces
	velocity.y = vspd;
	velocity.x = hspd;
	velocity = move_and_slide(velocity, floor_normal);
	#no gravity acceleration when on floor
	if(on_floor()):
		air_time = 0;
		velocity.y = 0
		vspd = 0;
	
	if(is_on_ceiling()):
		vspd = 0;
	
	if(grav_activated):
		vspd += gravity;
	
	#cap gravity
	if(vspd > g_max && grav_activated) :
		vspd = g_max;

func _on_DetectHitboxArea_area_entered(area):
	if(!targettableHitboxes.has(area)):
		targettableHitboxes.push_back(area);

func _on_DetectHitboxArea_area_exited(area):
	if(targettableHitboxes.has(area)):
		targettableHitboxes.erase(area);

func hitboxLoop():
	var space_state = get_world_2d().direct_space_state;
	for item in targettableHitboxes:
		var slash = nextRay(self,item,10,space_state);
		var bash = nextRay(self,item,11,space_state);
		var pierce = nextRay(self,item,12,space_state);
		if(slash || bash || pierce):
			item.hittable = true;
		else:
			item.hittable = false;

func nextRay(origin,dest,col_layer,spc):
	if(!itemTrace.has(origin)):
		itemTrace.push_back(origin);
	var result = spc.intersect_ray(origin.global_position, dest.global_position, itemTrace, $RayCastCollision.collision_mask);
	if(result.empty()):
		itemTrace.clear();
		return true;
	
	elif(result.collider.get_collision_layer_bit(col_layer)):
		if(result.collider != dest):
			return nextRay(result.collider,dest,col_layer,spc);
		else:
			itemTrace.clear();
			return true;
	
	else:
		itemTrace.clear();
		return false;

func _stretch_based_on_velocity():
	if(!on_floor()):
		$Sprites/Sprite.scale.y = range_lerp(abs(velocity.y), 0, 500, 1, 1.5)
		$Sprites/Sprite.scale.x = 1 / $Sprites/Sprite.scale.y

func mouse_r():
	return (deg > -60 && deg < 60);

func mouse_u():
	return (deg > -150 && deg < -30);

func mouse_l():
	return (deg > 120 || deg < -120);

func mouse_d():
	return (deg < 150 && deg > 30);

func add_velocity(vec: Vector2 = Vector2(0,0)):
	hspd = vec.x * Direction;
	vspd = vec.y;

func subtract_velocity(vec: Vector2 = Vector2(0,0)):
	hspd -= vec.x * Direction;
	vspd -= vec.y;

func deactivate_grav():
	grav_activated = false;
	vspd = 0;
	velocity.y = 0;

func deactivate_fric():
	fric_activated = false;
	hspd = 0;
	velocity.x = 0;

func activate_grav():
	grav_activated = true;

func activate_fric():
	fric_activated = true;

func change_move_state(var state: NodePath):
	move_states[move_state].exit(get_node(state));

func tween_rotation(node: NodePath, new: float, time: float = .1):
	$Tween.interpolate_property(get_node(node),"rotation_degrees",get_node(node).rotation_degrees,new,time,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Tween.start();

func tween_rotation_from_specified(node: NodePath, cur: float, new: float, time: float = .1):
	$Tween.interpolate_property(get_node(node),"rotation_degrees",cur,new,time,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Tween.start();

func tween_rotation_to_origin(var node: NodePath, time: float = .1):
	$Tween.interpolate_property(get_node(node),"rotation_degrees",get_node(node).rotation_degrees,0,time,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Tween.start();

func jump():
	vspd = -jspd;

func tween_scale(node: NodePath, new: Vector2, time: float = .1):
	$Tween.interpolate_property(get_node(node),"scale",get_node(node).scale,new,time,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Tween.start();
