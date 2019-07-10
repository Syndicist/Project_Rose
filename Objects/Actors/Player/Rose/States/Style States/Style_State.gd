extends "../State.gd"

onready var Wind_Dance = get_parent().get_node("Wind_Dance");
onready var bash = get_parent().get_node("Closed_Fan");

signal attack;

### temp inits ###
var on_cooldown = false;
var hit = false;
#starting the attack
var attack_start = false;
#middle of the attack
var attack_mid = false;
#end of the attack
var attack_end = false;
var animate = false;
var attack_spawned = false;
var attack_is_saved = false;
var attack_triggered = false;
var busy = false;
var dashing = false;
### attack codes ###
var style = "style";
var dir = "_horizontal";
var vdir = "";
var current_event = "current_event";
var combo = "";
var attack_str = "attack_str";
var attack_idx = "attack_idx";
var previous_event = "previous_event";

### modifiable inits ###
var end_time = .5;
var interrupt_time = .5;
var distance_traversable = 80;
var air_counter = 1;
var cool = 1;
var base_cost = 15;
var spec_cost = 25;
var basic_cost = 15;
var cur_cost = 0;

### debug_vars ###
var input_testing = false;
var style_idx = 0;
var style_n = 0;
var stm1;
var stp1;

func _ready():
	style_n = get_parent().get_child_count();
	style_idx = get_index();
	stm1 = style_idx - 1;
	if(stm1 < 0):
		stm1 = style_n - 1;
	stp1 = style_idx + 1;
	if(stp1 >= style_n):
		stp1 = 0;

func enter():
	print("   " + get_parent().get_child(style_idx).name);
	print(get_parent().get_child(stm1).name + "   " + get_parent().get_child(stp1).name);

### Handles animation, incomplete ###
func handleAnimation():
	if(!input_testing):
		"""
		if(attack_end):
			#landing frames
			if(host.on_floor()):
				pass;
				#if(combo_attack.length()%2 == 1):
				#	host.new_anim = combo_attack.substr(combo_attack.length()-1,1) + "land";
				#else:
				#	host.new_anim = "-" + combo_attack.substr(combo_attack.length()-1,1) + "land";
		elif(attack_start):
		"""
		"""
		if(attack_triggered):
			host.animate(host.get_node("TopAnim"),attack_str, false);
			if(host.hspd == 0 || dashing):
				host.animate(host.get_node("BotAnim"),attack_str, false);
		"""
	pass;

### Prepares next move if user input is detected ###
func handleInput():
	if(busy):
		return;
	if(attack_triggered):
		combo += current_event;
		busy = true;
		set_position_vars();

func switch():
	if(Input.is_action_just_pressed("switchL")):
		exit(get_parent().get_child(stm1));
	if(Input.is_action_just_pressed("switchR")):
		exit(get_parent().get_child(stp1));

func exit(state):
	.exit(state);
	reset_strings();
	attack_triggered = false;
	busy = false;
	dashing = false;

### Determines direction of attack ###
func atk_left():
	return Input.is_action_pressed("rleft") || Input.is_action_pressed("left") || (host.mouse_l() && host.ActiveInput == host.InputType.KEYMOUSE);

func atk_right():
	return Input.is_action_pressed("rright") || Input.is_action_pressed("right") || (host.mouse_r() && host.ActiveInput == host.InputType.KEYMOUSE);

func atk_up():
	return Input.is_action_pressed("rup") || Input.is_action_pressed("up") || (host.mouse_u() && host.ActiveInput == host.InputType.KEYMOUSE);

func atk_down():
	return Input.is_action_pressed("rdown") || Input.is_action_pressed("down") || (host.mouse_d() && host.ActiveInput == host.InputType.KEYMOUSE);

### Handles all player input to decide what attack to trigger ###
func set_position_vars():
	if(atk_left()):
		dir = "horizontal"
	elif(atk_right()):
		dir = "horizontal";
	if(atk_down() || atk_up()):
		if(!atk_left() && !atk_right()):
			dir = "";
		if(atk_up()):
			vdir = "_up";
		elif(atk_down()):
			vdir = "_down";
	else:
		vdir = "";
		dir = "horizontal"
	if(init_attack()):
		attack();
	pass;

### Initializes attack once the player has committed ###
func init_attack():
	host.reset_hitbox();
	if(input_testing):
		#construct_attack_string();
		#attack_is_saved = false;
		return true;
	else:
		#stopTimers();
		attack_start = true;
		attack_end = false;
		attack_is_saved = false;
		return true;
	pass;

### Constructs the string used to look up attack hitboxes and animations ###
func construct_attack_string():
	attack_str = style + "_" + combo+dir+vdir;
	print(attack_str);
	pass;

### Resets attack strings ###
func reset_strings():
	dir = "_horizontal";
	vdir = "";
	current_event = 'current_event';
	attack_str = "attack_str";
	attack_idx = "attack_idx";
	pass;

### Triggers appropriate attack based on the strings constructed by player input ###
func attack():
	#TODO: put this signal in the attacks instead
	#host.emit_signal("consume_resource", cur_cost);
	#animate = true;
	attack_spawned = true;
	
	construct_attack_string();
	attack_done();
	#TODO: Get appropriate path to attack scene
	"""
	var path = "res://Objects/Actors/Player/Rose/AttackObjects/" + type + "/" + current_attack + "/";
	path += dir+vdir+place+"_attack.tscn";
	var effect = load(path).instance();
	effect.host = host;
	effect.attack_state = self;
	host.add_child(effect);
	"""
	pass;


func attack_done():
	busy = false;
	attack_triggered = false;
	dashing = false;
	previous_event = current_event;
	reset_strings();
	pass;