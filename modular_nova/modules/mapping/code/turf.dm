// Modular turf stuff

// Reskinned soil to make it look like its turf, but its not!
/obj/machinery/hydroponics/soil/fake_turf
	desc = "A patch of fertile soil that you can plant stuff in."
	icon = 'icons/turf/floors.dmi' // This makes it look like the dirt floor
	icon_state = "dirt"
	layer = 2.0001
	plane = FLOOR_PLANE
	self_sustaining = 1
	pixel_z = 0

// Ice without atmos tweaking BS for use inside buildings
/turf/open/misc/ice/icehut
	desc = "A thick sheet of ice that only occasionally allow glances into the large body of water below. It has a salty taste."
	baseturfs = /turf/open/misc/ice/icehut
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = FALSE

// Water turfs for hermit's fishing needs
/turf/open/water/ice_lake
	desc = "A rare glacial salt spring, speckled with fish."
	baseturfs = /turf/open/water/ice_lake
	immerse_overlay_color = "#c1d8e4"
	fishing_datum = /datum/fish_source/ocean

/turf/open/water/lava_lake
	desc = "A deep hole drilled to a mineral-dense underground lake. It tastes salty..."
	baseturfs = /turf/open/water/lava_lake
	immerse_overlay_color = "#e4d6c1"
	fishing_datum = /datum/fish_source/ocean
