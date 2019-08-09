extends Node2D

var partNode;
var particle;
var hitNode;
var hitbox;

onready var attack_manager = get_parent();
onready var attack_state = get_parent().get_parent();
onready var host = get_parent().get_parent().get_parent().get_parent();

### GENERAL FUNCTIONS ### 

func instance_particle():
	attack_manager.attack_start = false;
	particle = partNode.get_child(0);
	partNode.scale = scale;
	get_parent().add_child(partNode);
	partNode.global_position = get_parent().global_position;

func connect_entered():
	var attack_manager = attack_state.attack_manager;
	hitbox.connect("area_entered",attack_manager,"on_hit");

func instance_hitbox():
	hitbox = hitNode.get_child(0);
	hitbox.host = get_parent().get_parent().host;
	connect_entered();
	hitNode.scale = scale;
	get_parent().add_child(hitNode);
	hitNode.global_position = get_parent().global_position;

func set_rot():
	hitbox.global_rotation_degrees += attack_manager.attack_degrees;
	particle.global_rotation_degrees += attack_manager.attack_degrees;
	hitbox.direction = hitbox.global_rotation_degrees * host.Direction

func emit_off():
	particle.emitting = false;

func _on_particleTimer_timeout():
	if(is_instance_valid(partNode)):
		particle.process_material.gravity = Vector3(0,0,0);
		particle.process_material.angular_velocity_random = 0;
		if(particle.process_material.angular_velocity_curve):
			particle.process_material.angular_velocity_curve = null;
		particle.process_material.scale_random = 0;
		if(particle.process_material.scale_curve):
			particle.process_material.scale_curve = null;
		particle.process_material.scale = 1;
		particle.rotation_degrees = 0
		particle.z_index = 0;
		particle.scale = Vector2(1,1);
		particle.queue_free();
		partNode.queue_free()
	if(is_instance_valid(hitNode)):
		hitbox.rotation_degrees = 0
		hitbox.inchdir = 1;
		hitNode.queue_free();
		hitbox.queue_free();
	$particleTimer.stop();

### SLASH ATTACKS ###

func instance_slash_particle():
	partNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Wind_Dance/SlashParticles.tscn").instance();
	instance_particle();

func instance_slash_X_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Wind_Dance/X.tscn").instance();
	instance_hitbox();

func instance_slash_XplusB_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Wind_Dance/X+B.tscn").instance();
	instance_hitbox();

func instance_slash_HoldX_Hor_Ground_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Wind_Dance/HoldX_Hor_Ground.tscn").instance();
	instance_hitbox();

func instance_slash_HoldX_Down_Ground_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Wind_Dance/HoldX_Down_Ground.tscn").instance();
	instance_hitbox();

func instance_slash_Y_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Wind_Dance/Y.tscn").instance();
	instance_hitbox();

func Wind_Dance_XplusB():
	instance_slash_particle();
	instance_slash_XplusB_hitbox();
	particle.z_index = 1;
	particle.amount = 1;
	particle.lifetime = .4;
	particle.process_material.gravity = Vector3(0,-250,0);
	particle.process_material.angular_velocity = 1000;
	particle.process_material.angular_velocity_random = 0;
	particle.process_material.angular_velocity_curve = CurveTexture.new();
	particle.process_material.angular_velocity_curve.curve.add_point(Vector2(0,0));
	particle.process_material.angular_velocity_curve.curve.add_point(Vector2(-360,1));
	particle.process_material.scale = 2;
	particle.rotation_degrees = 0;
	particle.scale = Vector2(.8, 0.25);
	particle.emitting = true;
	$particleTimer.start(.4);

func Wind_Dance_X():
	instance_slash_particle();
	instance_slash_X_hitbox();
	particle.lifetime = .2;
	particle.process_material.angular_velocity = 750;
	particle.rotation_degrees = 10;
	particle.scale = Vector2(2.5, 1);
	particle.emitting = true;
	$particleTimer.start(.2);
	set_rot();

func Wind_Dance_XX():
	instance_slash_particle();
	instance_slash_X_hitbox();
	particle.lifetime = .2;
	particle.process_material.angular_velocity = 750;
	particle.rotation_degrees = -10;
	particle.scale = Vector2(2.5, -1);
	particle.emitting = true;
	$particleTimer.start(.2);
	set_rot();

func Wind_Dance_Y():
	instance_slash_particle();
	instance_slash_Y_hitbox();
	particle.one_shot = false;
	particle.z_index = 5;
	particle.amount = 10
	particle.lifetime = .3;
	particle.process_material.gravity = Vector3(-500,0,0);
	particle.process_material.angular_velocity = 1000;
	particle.process_material.angular_velocity_random = 1;
	particle.process_material.scale = 1;
	particle.process_material.scale_random = 0.4;
	particle.process_material.scale_curve = CurveTexture.new();
	particle.process_material.scale_curve.curve.add_point(Vector2(0,0.5));
	particle.process_material.scale_curve.curve.add_point(Vector2(1,1));
	particle.rotation_degrees = 0;
	particle.scale = Vector2(3, 1);
	particle.emitting = true;
	$particleTimer.start(.45);
	set_rot();

### BASH ATTACKS ###

func instance_bash_particle():
	partNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Closed_Fan/BashParticles.tscn").instance();
	instance_particle();
	
func instance_bash_Y_Hor_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Closed_Fan/Y_Hor.tscn").instance();
	instance_hitbox();

func instance_bash_Y_Up_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Closed_Fan/Y_Up.tscn").instance();
	instance_hitbox();

func instance_bash_X_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Closed_Fan/X.tscn").instance();
	instance_hitbox();

func instance_bash_HoldX_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Closed_Fan/HoldX.tscn").instance();
	instance_hitbox();

func instance_bash_QuickX_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Closed_Fan/QuickX.tscn").instance();
	instance_hitbox();

func Closed_Fan_X_Hor():
	instance_bash_particle();
	instance_bash_X_hitbox();
	particle.lifetime = .3;
	particle.process_material.angular_velocity = 500;
	particle.rotation_degrees = 0;
	particle.scale = Vector2(1.5, 1);
	particle.emitting = true;
	$particleTimer.start(.3);

func Closed_Fan_XX_Hor():
	Closed_Fan_X_Hor();
	particle.scale *= Vector2(1, -1);
	particle.emitting = true;
	$particleTimer.start(.3);
	hitbox.inchdir = -1;

func Closed_Fan_QuickX_Hor():
	instance_bash_particle();
	instance_bash_QuickX_hitbox();
	particle.lifetime = .2;
	particle.process_material.angular_velocity = 500;
	particle.rotation_degrees = 0;
	particle.scale = Vector2(2, .5);
	particle.emitting = true;
	$particleTimer.start(.2);

func Closed_Fan_Y_Hor():
	instance_bash_particle();
	instance_bash_Y_Hor_hitbox();
	particle.lifetime = .4;
	particle.process_material.angular_velocity = 500;
	particle.rotation_degrees = 90;
	particle.scale = Vector2(1.5, 4);
	particle.emitting = true;
	hitbox.rotation_degrees = 0;
	$particleTimer.start(.4);
	set_rot();
	if(hitbox.global_rotation_degrees == -135):
		hitNode.scale *= Vector2(1,-1);
		hitNode.rotation_degrees += 90;
		particle.scale *= Vector2(-1,1);
	if(hitbox.global_rotation_degrees == 45):
		hitNode.scale *= Vector2(1,-1);
		hitNode.rotation_degrees += 90;
		particle.scale *= Vector2(-1,1);
	if(round(hitbox.global_rotation_degrees) == 90 && host.Direction == 1):
		hitNode.scale *= Vector2(-1,1);
		particle.scale *= Vector2(-1,1);
	if(round(hitbox.global_rotation_degrees) == -90 && host.Direction == -1):
		hitNode.scale *= Vector2(-1,1);
		particle.scale *= Vector2(-1,1);