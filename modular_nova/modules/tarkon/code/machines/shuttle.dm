//---- Tarkon Driver: Shuttle for Port Tarkon (duh) ----//

/obj/machinery/computer/shuttle/tarkon_driver
	name = "Tarkon Driver Control"
	desc = "Used to control the Tarkon Driver."
	circuit = /obj/item/circuitboard/computer/tarkon_driver
	shuttleId = "tarkon_driver"
	possible_destinations = "tarkon_driver_custom;port_tarkon;whiteship_home"

/obj/machinery/computer/camera_advanced/shuttle_docker/tarkon_driver
	name = "Tarkon Driver Navigation Computer"
	desc = "The Navigation console for the Tarkon Driver. A broken \"Engage Drill\" button seems to dimly blink in a yellow colour"
	shuttleId = "tarkon_driver"
	lock_override = NONE
	shuttlePortId = "tarkon_driver_custom"
	jump_to_ports = list("port_tarkon" = 1, "whiteship_home" = 1)
	view_range = 0

/obj/item/circuitboard/computer/tarkon_driver
	name = "Tarkon Driver Control Console (Computer Board)"
	build_path = /obj/machinery/computer/shuttle/tarkon_driver

//---- Salvage Skiff: Shuttle for Colony Echo ----//

/obj/machinery/computer/shuttle/tarkon_salvageskiff
	name = "T.I. Salvage Skiff Control"
	desc = "Used to control the Salvage Skiff, Tarkon Industries stamped into the frame."
	circuit = /obj/item/circuitboard/computer/tarkon_salvageskiff
	shuttleId = "tarkon_salvageskiff"
	possible_destinations = "tarkon_salvageskiff_custom;colony_echo;whiteship_home"

/obj/machinery/computer/camera_advanced/shuttle_docker/tarkon_salvageskiff
	name = "T.I. Salvage Skiff Navigation Computer"
	shuttleId = "tarkon_salvageskiff"
	lock_override = NONE
	shuttlePortId = "tarkon_salvageskiff_custom"
	jump_to_ports = list("colony_echo" = 1, "whiteship_home" = 1)
	view_range = 0

/obj/item/circuitboard/computer/tarkon_salvageskiff
	name = "T.I. Salvage Skiff Control Console (Computer Board)"
	build_path = /obj/machinery/computer/shuttle/tarkon_salvageskiff

//---- The main reason i made this file: DOCK ROOTS GOD FUCKING FINALLY ----//

/obj/docking_port/stationary/port_tarkon
	dir = EAST
	dwidth = 6
	height = 16
	name = "Port Tarkon"
	roundstart_template = /datum/map_template/shuttle/ruin/tarkon_driver
	shuttle_id = "port_tarkon"
	width = 14

/obj/docking_port/mobile/tarkon_driver
	name = "Tarkon Driver"
	port_direction = SOUTH
	preferred_direction = WEST
	shuttle_id = "tarkon_driver"

/obj/docking_port/stationary/colony_echo
	dir = SOUTH
	name = "Colony Echo"
	dwidth = 6
	width = 17
	height = 7
	roundstart_template = /datum/map_template/shuttle/ruin/tarkon_salvageskiff
	shuttle_id = "colony_echo"

/obj/docking_port/mobile/tarkon_salvageskiff
	name = "T.I. Salvage Skiff"
	dir = SOUTH
	port_direction = WEST
	preferred_direction = EAST
	shuttle_id = "tarkon_salvageskiff"
