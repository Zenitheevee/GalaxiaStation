/obj/item/charge_transformer
	name = "magazine charger"
	desc = "A bulky item for charging electrical magazines."
	icon = 'icons/obj/tools.dmi'
	icon_state = "inducer-engi"
	inhand_icon_state = "inducer-engi"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	force = 7

	/// Divider that determines the charge used to refill magazines. 1 = 1000 watts
	var/power_transfer_divider = 1
	/// Multiplier to determine how many bullets are refilled per cycle
	var/charge_multi = 1
	/// Can this accept plasma to charge its cell?
	var/can_plasma_charge = TRUE
	/// Is the battery hatch opened?
	var/opened = FALSE
	/// The cell for used in recharging cycles
	var/obj/item/stock_parts/power_store/powerdevice = /obj/item/stock_parts/power_store/battery/high
	/// Are we in the process of recharging something?
	var/recharging = FALSE
	/// Are we done charging?
	var/finished_recharging = TRUE
	/// What ammo device are we recharging?
	var/obj/item/ammo_box/magazine/recharge/target_mag = null

/obj/item/charge_transformer/Initialize(mapload)
	. = ..()

	if(ispath(powerdevice))
		powerdevice = new powerdevice(src)

	register_context()

	update_appearance(UPDATE_OVERLAYS)

/obj/item/charge_transformer/Destroy(force)
	QDEL_NULL(powerdevice)
	. = ..()

/obj/item/charge_transformer/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	if(istype(arrived, /obj/item/ammo_box/magazine/recharge))
		target_mag = arrived
		START_PROCESSING(SSobj, src)
		finished_recharging = FALSE
		recharging = TRUE
		update_appearance()
	return ..()

/obj/item/charge_transformer/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == powerdevice)
		powerdevice = null
	if(gone == target_mag)
		target_mag = null
		recharging = FALSE
		finished_recharging = TRUE
		STOP_PROCESSING(SSobj, src)

/obj/item/charge_transformer/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(isnull(held_item))
		if(opened && !QDELETED(powerdevice))
			context[SCREENTIP_CONTEXT_LMB] = "Remove Cell"
			return CONTEXTUAL_SCREENTIP_SET

		if(!opened && !QDELETED(target_mag))
			context[SCREENTIP_CONTEXT_LMB] = "Remove Magazine"
			return CONTEXTUAL_SCREENTIP_SET

	if(opened)
		if(istype(held_item, /obj/item/stock_parts/power_store) && QDELETED(powerdevice))
			context[SCREENTIP_CONTEXT_LMB] = "Insert cell"
			return CONTEXTUAL_SCREENTIP_SET

		if(can_plasma_charge)
			if(istype(held_item, /obj/item/stack/sheet/mineral/plasma) && !QDELETED(powerdevice) && !target_mag)
				context[SCREENTIP_CONTEXT_LMB] = "Charge cell"
				return CONTEXTUAL_SCREENTIP_SET

	if(held_item?.tool_behaviour == TOOL_SCREWDRIVER) // we do the ?. to cancel out a runtime when items dont have tool_behavior.
		context[SCREENTIP_CONTEXT_LMB] = "[opened ? "Close" : "Open"] Panel"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/ammo_box/magazine/recharge))
		context[SCREENTIP_CONTEXT_LMB] = "Insert magazine"
		return CONTEXTUAL_SCREENTIP_SET

/obj/item/charge_transformer/examine(mob/living/user)
	. = ..()

	. += examine_hints(user)

/obj/item/charge_transformer/proc/examine_hints(mob/living/user)
	PROTECTED_PROC(TRUE)
	SHOULD_BE_PURE(TRUE)

	. = list()

	var/obj/item/stock_parts/power_store/our_cell = get_cell(src, user)
	if(!QDELETED(our_cell))
		. += span_notice("Its display shows: [display_energy(our_cell.charge)].")
		if(opened)
			. += span_notice("The cell can be removed with an empty hand.")
			. += span_notice("Plasma sheets can be used to recharge the cell.")
	else
		. += span_warning("It's missing a power cell.")

	. += span_notice("Its battery compartment can be [EXAMINE_HINT("screwed")] [opened ? "shut" : "open"].")

/obj/item/charge_transformer/update_overlays()
	. = ..()
	if(!opened)
		return
	. += "inducer-[!QDELETED(powerdevice) ? "bat" : "nobat"]"

/obj/item/charge_transformer/get_cell()
	return powerdevice

/obj/item/charge_transformer/emp_act(severity)
	. = ..()
	if(!QDELETED(powerdevice) && !(. & EMP_PROTECT_CONTENTS))
		powerdevice.emp_act(severity)

/obj/item/charge_transformer/screwdriver_act(mob/living/user, obj/item/tool)
	. = NONE

	if(!tool.use_tool(src, user, delay = 0))
		return

	opened = !opened
	to_chat(user, span_notice("You [opened ? "open" : "close"] the battery compartment."))
	update_appearance(UPDATE_OVERLAYS)

	return ITEM_INTERACT_SUCCESS

/obj/item/charge_transformer/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = NONE

	if(user.combat_mode || tool.flags_1 & HOLOGRAM_1 || tool.item_flags & ABSTRACT)
		return ITEM_INTERACT_SKIP_TO_ATTACK

	if(!istype(tool)) //if hand is empty
		if(!QDELETED(target_mag))
			user.visible_message(span_notice("[user] removes [target_mag] from [src]!"), span_notice("You remove [target_mag]."))
			target_mag.update_appearance()
			user.put_in_hands(target_mag)
			update_appearance(UPDATE_OVERLAYS)
			return ITEM_INTERACT_SUCCESS

		if(opened && !QDELETED(powerdevice))
			user.visible_message(span_notice("[user] removes [powerdevice] from [src]!"), span_notice("You remove [powerdevice]."))
			powerdevice.update_appearance()
			user.put_in_hands(powerdevice)
			update_appearance(UPDATE_OVERLAYS)
			return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/stock_parts/power_store))
		if(!opened)
			balloon_alert(user, "open first!")
			return ITEM_INTERACT_FAILURE

		if(!QDELETED(powerdevice))
			balloon_alert(user, "cell already installed!")
			return ITEM_INTERACT_FAILURE

		if(!user.transferItemToLoc(tool, src))
			balloon_alert(user, "stuck in hand!")
			return ITEM_INTERACT_FAILURE

		powerdevice = tool
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/ammo_box/magazine/recharge))
		if(!QDELETED(target_mag))
			balloon_alert(user, "magazine already installed!")
			return ITEM_INTERACT_FAILURE

		if(!user.transferItemToLoc(tool, src))
			balloon_alert(user, "stuck in hand!")
			return ITEM_INTERACT_FAILURE

		target_mag = tool
		return ITEM_INTERACT_SUCCESS

	else if(istype(tool, /obj/item/stack/sheet/mineral/plasma) && !target_mag && !QDELETED(powerdevice)) // needs cell but cant have a magazine
		if(!can_plasma_charge)
			return ITEM_INTERACT_FAILURE
		if(!powerdevice.used_charge())
			balloon_alert(user, "fully charged!")
			return ITEM_INTERACT_FAILURE

		tool.use(1)
		powerdevice.give(1.5 * STANDARD_CELL_CHARGE)
		balloon_alert(user, "cell recharged")

		return ITEM_INTERACT_SUCCESS

/obj/item/charge_transformer/process(seconds_per_tick)
	var/obj/item/stock_parts/power_store/our_cell = get_cell(powerdevice)

	if(QDELETED(our_cell))
		return PROCESS_KILL

	if(!our_cell.charge)
		return PROCESS_KILL

	var/obj/item/ammo_box/magazine/recharge/power_pack = target_mag

	if(QDELETED(power_pack))
		return PROCESS_KILL

	if(istype(target_mag, /obj/item/ammo_box/magazine/recharge)) //if you add any more snowflake ones, make sure to update the examine messages too.
		for(var/charge_iterations in 1 to charge_multi)
			if(power_pack.stored_ammo.len >= power_pack.max_ammo)
				break
			power_pack.stored_ammo += new power_pack.ammo_type(power_pack)
			our_cell.use(min(our_cell.charge , (BASE_MACHINE_ACTIVE_CONSUMPTION / power_transfer_divider)))

	if(power_pack.stored_ammo.len >= power_pack.max_ammo)
		recharging = FALSE

	//update all appearances
	our_cell.update_appearance()
	power_pack.update_appearance()

	if(!recharging && !finished_recharging) //Inserted thing is at max charge/ammo, notify those around us
		finished_recharging = TRUE
		playsound(src, 'sound/machines/ping.ogg', 30, TRUE)
		say("[target_mag] has finished recharging!")

/obj/item/charge_transformer/attack_self(mob/user)
	if(!QDELETED(target_mag))
		user.visible_message(span_notice("[user] removes [target_mag] from [src]!"), span_notice("You remove [target_mag]."))
		target_mag.update_appearance()
		user.put_in_hands(target_mag)
		update_appearance(UPDATE_OVERLAYS)
		return

	if(opened && !QDELETED(powerdevice))
		user.visible_message(span_notice("[user] removes [powerdevice] from [src]!"), span_notice("You remove [powerdevice]."))
		powerdevice.update_appearance()
		user.put_in_hands(powerdevice)
		update_appearance(UPDATE_OVERLAYS)

