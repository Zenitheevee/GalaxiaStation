// Casing and projectile for the plasma thrower

/obj/item/ammo_casing/energy/laser/plasma_glob
	projectile_type = /obj/projectile/beam/laser/plasma_glob
	fire_sound = 'modular_nova/modules/modular_weapons/sounds/laser_firing/incinerate.ogg'

/obj/item/ammo_casing/energy/laser/plasma_glob/Initialize(mapload)
	. = ..()

	AddElement(/datum/element/caseless)

/obj/projectile/beam/laser/plasma_glob
	name = "plasma globule"
	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/szot_dynamica/ammo.dmi'
	icon_state = "plasma_glob"
	damage = 10
	speed = 1
	exposed_wound_bonus = 40
	wound_bonus = -20 // Not too great at wounding through armor.
	pass_flags = PASSTABLE | PASSGRILLE // His ass does NOT pass through glass!

// Silver, "Bane", For hunting fauna.

/obj/item/ammo_casing/energy/laser/plasma_glob/bane
	projectile_type = /obj/projectile/beam/laser/plasma_glob/bane

/obj/projectile/beam/laser/plasma_glob/bane
	name = "silver plasma globule"
	icon_state = "silver_plasma_glob"
	damage = 5 //SHOULD translate to ~30 damage to baned targets, However, /mining/ mobs have a .3 damage coficiency for non-brute damage below 30, but doesn't account for bane damage

/obj/projectile/beam/laser/plasma_glob/bane/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/bane, target_type = /mob/living/basic/mining, damage_multiplier = 12, requires_combat_mode = FALSE) //Numbers say 60, This is gonna be closer to ~20
	AddElement(/datum/element/bane, target_type = /mob/living/simple_animal/hostile/asteroid, damage_multiplier = 12, requires_combat_mode = FALSE)  //same as above
	AddElement(/datum/element/bane, target_type = /mob/living/simple_animal/hostile/megafauna, damage_multiplier = 4 , requires_combat_mode = FALSE) //This is just 20 damage. Look, The only megafauna you're killing with this is if you sweat the miner.

