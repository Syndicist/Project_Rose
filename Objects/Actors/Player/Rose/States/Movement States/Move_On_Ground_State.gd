extends "./Free_Motion_State.gd"

func enter():
	host.move_state = 'move_on_ground';
	handleInput();
	pass

func handleAnimation():
	if(host.hspd > 0 || host.hspd < 0):
		if(!host.style_states[host.style_state].busy):
			host.animate(host.get_node("TopAnim"),"run", false);
	else: 
		if(!host.style_states[host.style_state].busy):
			host.animate(host.get_node("TopAnim"),"idle", false);

func handleInput():
	if(Input.is_action_just_pressed("jump")):
		host.vspd = -host.jspd;
		exit(host.get_node("Movement_States").get_node("Move_In_Air"));
	elif(!host.on_floor()):
		exit(host.get_node("Movement_States").get_node("Move_In_Air"));
	pass

func execute(delta):
	.execute(delta);
	if(host.Direction != sign(host.velocity.x) && get_input_direction() != 0 ):
		host.hspd -= 10 * sign(host.hspd);
	pass;

func exit(state):
	.exit(state);
	pass
