#define COLONY_THREAT_XENOS "xenos"
#define COLONY_THREAT_PIRATES "pirates"
#define COLONY_THREAT_CARP "carp"
#define COLONY_THREAT_SNOW "snow"
#define COLONY_THREAT_MINING "mining"
#define COLONY_THREAT_ICE_MINING "ice-mining"

/obj/structure/ore_vent/ghost_mining
	name = "oxide nodule vent"
	desc = "A vent full of rare oxide nodules, producing varous minerals every time one is brought up. Scan with an advanced mining scanner to start extracting ore from it."
	mineral_breakdown = list(
		/datum/material/iron = 50,
		/datum/material/glass = 50) //we dont need a seperate starting list
	unique_vent = TRUE
	boulder_size = BOULDER_SIZE_SMALL
	defending_mobs = list()
	var/clear_tally = 0 //so we can track how many time it clears for data-testing purposes.
	var/boulder_bounty = 10 //how many boulders per clear attempt. First one is small and easy
	var/threat_pool = list(
		COLONY_THREAT_CARP,
		COLONY_THREAT_PIRATES,
		COLONY_THREAT_XENOS
	) //we put this here for customization reasons


/obj/structure/ore_vent/ghost_mining/produce_boulder(apply_cooldown)
	. = ..()
	boulder_bounty -= 1
	if(boulder_bounty == 0)
		reset_vent()

/obj/structure/ore_vent/ghost_mining/proc/reset_vent()
	cut_overlays()
	tapped = FALSE
	SSore_generation.processed_vents -= src
	icon_state = base_icon_state
	update_appearance(UPDATE_ICON_STATE)
	clear_tally += 1
	reset_ores()

/obj/structure/ore_vent/ghost_mining/proc/reset_ores()
	var/magnitude = rand(1,4)
	var/ore_pool = list(
		/datum/material/iron = 14,
		/datum/material/glass = 12,
		/datum/material/plasma = 10,
		/datum/material/titanium = 9,
		/datum/material/silver = 9,
		/datum/material/gold = 7,
		/datum/material/diamond = 3,
		/datum/material/uranium = 5,
		/datum/material/bluespace = 3,
		/datum/material/plastic = 2,
		)
	var/ore_output_size = list(
		BOULDER_SIZE_SMALL,
		BOULDER_SIZE_MEDIUM,
		BOULDER_SIZE_LARGE,
		)

	boulder_size = pick(ore_output_size)

	boulder_bounty = magnitude * 15 //Max is 60

	var/threat_pick = pick(threat_pool)

	switch(threat_pick)
		if(COLONY_THREAT_CARP)
			defending_mobs = list(
				/mob/living/basic/carp,
				/mob/living/basic/carp/mega)
		if(COLONY_THREAT_PIRATES)
			defending_mobs = list(
				/mob/living/basic/trooper/pirate/melee/space,
				/mob/living/basic/trooper/pirate/ranged/space
			)
		if(COLONY_THREAT_XENOS)
			defending_mobs = list(
				/mob/living/basic/alien,
				/mob/living/basic/alien/drone,
				/mob/living/basic/alien/sentinel
			)
		if(COLONY_THREAT_MINING)
			defending_mobs = list(
				/mob/living/basic/mining/goliath,
				/mob/living/basic/mining/legion/spawner_made,
				/mob/living/basic/mining/watcher,
				/mob/living/basic/mining/lobstrosity/lava,
				/mob/living/basic/mining/brimdemon,
				/mob/living/basic/mining/bileworm,
			)
		if(COLONY_THREAT_ICE_MINING)
			defending_mobs = list(
				/mob/living/basic/mining/ice_whelp,
				/mob/living/basic/mining/lobstrosity,
				/mob/living/basic/mining/legion/snow/spawner_made,
				/mob/living/basic/mining/ice_demon,
				/mob/living/basic/mining/wolf,
				/mob/living/simple_animal/hostile/asteroid/polarbear,
			)
		if(COLONY_THREAT_SNOW)
			defending_mobs = list(
				/mob/living/basic/mining/lobstrosity,
				/mob/living/basic/mining/legion/snow/spawner_made,
				/mob/living/basic/mining/wolf,
				/mob/living/simple_animal/hostile/asteroid/polarbear,
			)

	for(var/old_ore in mineral_breakdown)
		mineral_breakdown -= old_ore

	for(var/new_ore in 1 to magnitude)
		var/datum/mineral_picked = pick(ore_pool)
		mineral_breakdown += mineral_picked
		ore_pool -= mineral_picked
		mineral_breakdown[mineral_picked] = rand(5, 20) //we need a weight to the boulders or else produce_boulder shits the bed.

//// Boulder Stabilizing Collector - Allows for ghost roles to have boulder-based ore vents without NT Yoinking them.

/obj/structure/ore_box/boulder_collector //We want this to automatically grab boulders and desync them from the bluespace boulder grabbers
	name = "BSC Refinery Box"
	desc = "An improvement on the normal boxes drudged around by miners, It is capable of automatically picking up ores or boulders in a set direction once established."
	icon = 'modular_nova/modules/tarkon/icons/obj/mining.dmi'
	icon_state = "orebox"
	/// The current direction of `input_turf`, in relation to the orebox.
	var/input_dir = NORTH
	/// The turf the orebox listens to for items to pick up. Calls the `pickup_item()` proc.
	var/turf/input_turf = null
	/// Determines if this orebox needs to pick up items yet
	var/needs_item_input = FALSE

/obj/structure/ore_box/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = NONE
	if(isnull(held_item))
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Rotate"
		return CONTEXTUAL_SCREENTIP_SET
	if(held_item.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_LMB] = "[anchored ? "Loosen" : "Anchor"]"
	if(held_item.tool_behaviour == TOOL_CROWBAR)
		context[SCREENTIP_CONTEXT_LMB] = "Deconstruct"
		return CONTEXTUAL_SCREENTIP_SET
	else if(istype(held_item, /obj/item/stack/ore) || istype(held_item, /obj/item/boulder))
		context[SCREENTIP_CONTEXT_LMB] = "Insert Item"
		return CONTEXTUAL_SCREENTIP_SET
	else if(held_item.atom_storage)
		context[SCREENTIP_CONTEXT_LMB] = "Transfer Contents"
		return CONTEXTUAL_SCREENTIP_SET

/obj/structure/ore_box/boulder_collector/proc/register_input_turf()
	input_turf = get_step(src, input_dir)
	if(input_turf) // make sure there is actually a turf
		RegisterSignals(input_turf, list(COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON, COMSIG_ATOM_ENTERED), PROC_REF(pickup_item))

/obj/structure/ore_box/boulder_collector/proc/unregister_input_turf()
	if(input_turf)
		UnregisterSignal(input_turf, list(COMSIG_ATOM_ENTERED, COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON))

/obj/structure/ore_box/boulder_collector/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	if(!needs_item_input || !anchored)
		return
	unregister_input_turf()
	register_input_turf()

/obj/structure/ore_box/boulder_collector/click_alt(mob/living/user)
	input_dir = turn(input_dir, -90)
	to_chat(user, span_notice("You change [src]'s I/O settings, setting the input to [dir2text(input_dir)]."))
	unregister_input_turf() // someone just rotated the input directions, unregister the old turf
	register_input_turf() // register the new one
	update_appearance(UPDATE_OVERLAYS)
	return CLICK_ACTION_SUCCESS

/obj/structure/ore_box/boulder_collector/update_overlays()
	. = ..()
	if(anchored == FALSE)
		return
	var/image/ore_input = image(icon='icons/obj/doors/airlocks/station/overlays.dmi', icon_state="unres_[input_dir]")

	switch(input_dir)
		if(NORTH)
			ore_input.pixel_y = 32
		if(SOUTH)
			ore_input.pixel_y = -32
		if(EAST)
			ore_input.pixel_x = 32
		if(WEST)
			ore_input.pixel_x = -32

	ore_input.color = COLOR_MODERATE_BLUE
	var/mutable_appearance/light_in = emissive_appearance(ore_input.icon, ore_input.icon_state, offset_spokesman = src, alpha = ore_input.alpha)
	light_in.pixel_y = ore_input.pixel_y
	light_in.pixel_x = ore_input.pixel_x
	. += ore_input
	. += light_in

/obj/structure/ore_box/boulder_collector/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(default_unfasten_wrench(user, tool))
		update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/structure/ore_box/boulder_collector/can_be_unfasten_wrench(mob/user, silent)
	if(!(isfloorturf(loc) || isindestructiblefloor(loc) || ismiscturf(loc)) && !anchored)
		to_chat(user, span_warning("[src] needs to be on the ground to be secured!"))
		return FAILED_UNFASTEN
	return SUCCESSFUL_UNFASTEN

/obj/structure/ore_box/boulder_collector/default_unfasten_wrench(mob/user, obj/item/wrench, time)
	. = ..()
	if(. != SUCCESSFUL_UNFASTEN)
		return
	if(anchored)
		register_input_turf() // someone just wrenched us down, re-register the turf
		needs_item_input = TRUE
	else
		unregister_input_turf() // someone just un-wrenched us, unregister the turf
		needs_item_input = FALSE

/obj/structure/ore_box/boulder_collector/proc/pickup_item(datum/source, atom/movable/target_boulder, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER

	if(QDELETED(target_boulder))
		return

	if(istype(target_boulder, /obj/item/boulder))
		var/obj/item/boulder/mine_now = target_boulder
		mine_now.forceMove(src) //Pull the boulder into storage
		SSore_generation.available_boulders -= mine_now //Decouple the boulder from the network. Cant be stolen
	return

/obj/structure/ore_box/boulder_collector/attackby(obj/item/weapon, mob/user, params)
	if(istype(weapon, /obj/item/boulder))
		var/obj/item/boulder/mine_now = weapon
		SSore_generation.available_boulders -= mine_now
		user.transferItemToLoc(weapon, src)
	else
		return ..()
