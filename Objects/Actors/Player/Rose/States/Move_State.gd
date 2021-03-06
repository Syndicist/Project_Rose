extends "./State.gd"

onready var ground = get_parent().get_node("Move_On_Ground");
onready var air = get_parent().get_node("Move_In_Air");
onready var ledge = get_parent().get_node("Ledge_Grab");
onready var attack = get_parent().get_node("Attack");
onready var hurt = get_parent().get_node("Hurt");

onready var powerups = get_parent().get_parent().get_node("Powerups");