/obj/structure/ore_vent/tarkon_mining
	mineral_breakdown = list(
		/datum/material/iron = 50,
		/datum/material/glass = 50) //we dont need a seperate starting list
	unique_vent = TRUE
	boulder_size = BOULDER_SIZE_SMALL
	defending_mobs = list()
	var/clear_tally = 0 //so we can track how many time it clears.
	var/boulder_bounty = 1 //how many boulders per clear attempt

/obj/structure/ore_vent/tarkon_mining/produce_boulder(apply_cooldown)
	. = ..()
	boulder_bounty -= 1
	if(boulder_bounty == 0)
		reset_vent()

/obj/structure/ore_vent/tarkon_mining/proc/reset_vent()
	cut_overlays()
	tapped = FALSE
	SSore_generation.processed_vents -= src
	icon_state = base_icon_state
	update_appearance(UPDATE_ICON_STATE)
	clear_tally += 1
	reset_ores()

/obj/structure/ore_vent/tarkon_mining/proc/reset_ores()
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

	boulder_bounty = round(((magnitude + clear_tally) * rand(1,10))/5)

	boulder_size = pick(ore_output_size)

	for(var/old_ore in mineral_breakdown)
		mineral_breakdown -= old_ore

	for(var/new_ore in 1 to magnitude)
		var/datum/mineral_picked = pick(ore_pool)
		mineral_breakdown += mineral_picked
		ore_pool -= mineral_picked
		mineral_breakdown[mineral_picked] = rand(5, 15) //we need a weight to the boulders or else produce_boulder shits the bed.
