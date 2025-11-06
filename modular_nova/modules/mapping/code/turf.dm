// Modular turf stuff

// Reskinned soil to make it look like it's turf, but it's not!
/obj/machinery/hydroponics/soil/fake_turf
	desc = "A patch of fertile soil that you can plant stuff in."
	icon = 'icons/turf/floors.dmi' // This makes it look like the dirt floor
	icon_state = "dirt"
	layer = LOW_FLOOR_LAYER
	plane = FLOOR_PLANE
	self_sustaining = 1
	pixel_z = 0

/turf/open/floor/circuit/green/xenobio
	desc = "The air about this floor seems.. different?"
	initial_gas_mix = XENOBIO_BZ

/turf/open/floor/grass/fairy/icemoon
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS
	baseturfs = /turf/open/misc/asteroid/snow/icemoon

/turf/open/floor/mineral/gold/icemoon
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS
	baseturfs = /turf/open/misc/asteroid/snow/icemoon

/turf/closed/indestructible/normal_wall
	name = "wall"
	icon = 'modular_nova/modules/aesthetics/walls/icons/wall.dmi'
	icon_state = "wall-0"
	base_icon_state = "wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS

/turf/closed/indestructible/fakedoor/blast_door
	name = /obj/machinery/door/poddoor::name
	desc = /obj/machinery/door/poddoor::desc
	icon = /obj/machinery/door/poddoor::icon
	icon_state = /obj/machinery/door/poddoor::icon_state

/turf/open/skyline
	name = "long way down"
	icon = 'modular_nova/master_files/icons/obj/skyscraper/background.dmi'
	base_icon_state = "0,34"

// Don't let things enter if they can't fly
/turf/open/skyline/Enter(atom/movable/movable, atom/oldloc)
	. = ..()
	if(.)
		if(HAS_TRAIT(src, TRAIT_CHASM_STOPPED)) // lets people walk on catwalks and such
			return
		return HAS_TRAIT(movable, TRAIT_MOVE_FLYING) || HAS_TRAIT(movable, TRAIT_MOVE_FLOATING)

/// Water turfs for Hermit Fishing submap

/turf/open/water/hermit
	name = "fresh-water pond"
	desc = "some fresh, calm shallows."
	icon = 'icons/turf/beach.dmi'
	icon_state = "water"
	base_icon_state = "water"
	baseturfs = /turf/open/water/hermit
	fishing_datum = /datum/fish_source/lake

/turf/open/water/hermit/deep
	name = "deep fresh-water pond"
	desc = "Deep enough you wouldn't want to trip."
	immerse_overlay = "immerse_deep"
	icon_state = "deepwater"
	base_icon_state = "deepwater"
	baseturfs = /turf/open/water/hermit/deep
	fishing_datum = /datum/fish_source/deep_lake
	is_swimming_tile = TRUE

/// Fishing datums for the water turfs

/datum/fish_source/lake
	catalog_description = "Lake water"
	radial_state = "lake"
	overlay_state = "portal_river" // its "fresh water" so... should be fine? Uses most the same fish
	fish_table = list(
		FISHING_DUD = 4,
		/obj/item/fish/goldfish = 5,
		/obj/item/fish/guppy = 5,
		/obj/item/fish/plasmatetra = 4,
		/obj/item/fish/perch = 4,
		/obj/item/fish/angelfish = 4,
		/obj/item/fish/pike = 1,
		/obj/item/fish/goldfish/three_eyes = 1,
	)
	fish_counts = list(
		/obj/item/fish/pike = 3,
	)
	fish_count_regen = list(
		/obj/item/fish/pike = 4 MINUTES,
	)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 5
	fish_source_flags = FISH_SOURCE_FLAG_EXPLOSIVE_MALUS
	associated_safe_turfs = list(/turf/open/water)
	safe_turfs_blacklist = list(/turf/open/water/hot_spring, /turf/open/water/beach)

/datum/fish_source/deep_lake // A more "custom" table
	background = "background_ice"
	catalog_description = "deep-lake water"
	radial_state = "deep-lake"
	overlay_state = "portal_ocean"
	fish_table = list(
		FISHING_DUD = 4,
		/obj/item/fish/sockeye_salmon = 5,
		/obj/item/fish/catfish = 4,
		/obj/item/fish/zipzap = 3,
		/obj/item/fish/chasm_crab/ice = 2,
		/obj/item/fish/slimefish = 2,
		/obj/item/fish/boned = 1,
	)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 15
	associated_safe_turfs = list(/turf/open/water)
	safe_turfs_blacklist = list(/turf/open/water/hot_spring, /turf/open/water/beach)
