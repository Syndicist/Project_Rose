	extends Control

signal set_disabled;

var is_disabled = false;
var can_exit = false;
var started = false;
var is_paused = false;

func _process(delta):
	if(!is_disabled):
		if(!started && (get_focus_owner() == null || $PauseMenu/VBoxContainer.get_children().has(get_focus_owner()))):
			started = true;
			$Timer.start();
		if(started && !(get_focus_owner() == null || $PauseMenu/VBoxContainer.get_children().has(get_focus_owner()))):
			$Timer.stop()
			started = false;
			can_exit = false;
		if(Input.is_action_just_pressed("Pause") && !get_tree().paused):
			$PauseMenu/VBoxContainer/CloseMenuButton.grab_focus()
			get_tree().paused = true;
			$PauseMenu.show();
			is_paused = true;
		elif(is_paused && can_exit && ((Input.is_action_just_pressed("ui_cancel") || Input.is_action_just_pressed("Pause")) && get_tree().paused)):
			get_tree().paused = false;
			is_paused = false;
			$PauseMenu.hide();
			$PauseMenu/VBoxContainer/ControlsMenuButton/ControlsMenu.hide();
			$PauseMenu/VBoxContainer/UpgradeMenuButton/UpgradeMenu.hide();
		#elif((Input.is_action_just_pressed("ui_cancel") || Input.is_action_just_pressed("Pause")) && get_tree().paused):
		#	print(get_focus_owner());
		#	get_focus_owner().hide();
#TODO: Volume control


func _on_Pause_System_set_disabled(status):
	for child in $PauseMenu/VBoxContainer.get_children():
			child.disabled = status;
	is_disabled = status;


func _on_Timer_timeout():
	can_exit = true;
