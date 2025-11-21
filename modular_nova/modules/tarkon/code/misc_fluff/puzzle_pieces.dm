/obj/machinery/puzzle/button/tarkon
	name = "Lockdown Release"
	desc = "A large red button with hazard stripes surrounding it... What could it mean..."
	late_initialize_pop = 1 //All of these operate pod doors and SHOULD be paired with a helper
	single_use = FALSE
	queue_size = 3

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/puzzle/button/tarkon, 32)

/obj/machinery/puzzle/keycardpad/tarkon
	single_use = FALSE //can only be locked from outside, And honestly if someone bricks it just replace their flavour text with "stinky no fun rat"
	queue_size = 3
	late_initialize_pop = 1

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/puzzle/keycardpad/tarkon, 32)

/obj/item/keycard/tarkon
	name = "Tarkon Industries Secure Access Card"
	icon = 'modular_nova/modules/tarkon/icons/misc/card.dmi'
	icon_state = "robotics" //Temp
	puzzle_id = "tarkon_command_bunker"

/obj/machinery/door/poddoor/tarkon
	name = "Pressurized Blast Door"
	desc = "A set of heavy blast doors with a \"HydrauLock\" patented lock system. No greytide could ever erode this barrier."

/obj/machinery/door/poddoor/tarkon/crowbar_act(mob/living/user, obj/item/tool)
	if(machine_stat & NOPOWER)
		balloon_alert(user, "the doors still have pressure!")
		return ITEM_INTERACT_SUCCESS
	if (density)
		balloon_alert(user, "open the door first!")
		return ITEM_INTERACT_SUCCESS
	if (!panel_open)
		balloon_alert(user, "open the panel first!")
		return ITEM_INTERACT_SUCCESS
	if (deconstruction != BLASTDOOR_FINISHED)
		return
	balloon_alert(user, "removing airlock electronics...")
	if(tool.use_tool(src, user, 10 SECONDS, volume = 50))
		new /obj/item/electronics/airlock(loc)
		id = null
		owner = null
		deconstruction = BLASTDOOR_NEEDS_ELECTRONICS
		balloon_alert(user, "removed airlock electronics")
	return ITEM_INTERACT_SUCCESS
