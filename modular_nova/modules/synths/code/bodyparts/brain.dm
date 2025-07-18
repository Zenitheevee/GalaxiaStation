/obj/item/organ/brain/synth
	name = "compact positronic brain"
	slot = ORGAN_SLOT_BRAIN
	zone = BODY_ZONE_CHEST
	organ_flags = ORGAN_ROBOTIC | ORGAN_SYNTHETIC_FROM_SPECIES
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves. It has an IPC serial number engraved on the top. It is usually slotted into the chest of synthetic crewmembers."
	icon = 'modular_nova/master_files/icons/obj/surgery.dmi'
	icon_state = "posibrain-ipc"
	/// The last time (in ticks) a message about brain damage was sent. Don't touch.
	var/last_message_time = 0
	organ_traits = list(TRAIT_SILICON_EMOTES_ALLOWED)

/obj/item/organ/brain/synth/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/bubble_icon_override, "robot", BUBBLE_ICON_PRIORITY_ORGAN)

/obj/item/organ/brain/synth/on_mob_insert(mob/living/carbon/brain_owner, special, movement_flags)
	. = ..()

	if(brain_owner.stat != DEAD || !ishuman(brain_owner))
		return

	var/mob/living/carbon/human/human_brain_owner = brain_owner
	if(HAS_TRAIT(human_brain_owner, TRAIT_REVIVES_BY_HEALING) && human_brain_owner.health > SYNTH_BRAIN_WAKE_THRESHOLD)
		human_brain_owner.revive(FALSE)

/obj/item/organ/brain/synth/on_mob_remove(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	// Ensure all neuroware is removed if the brain is removed
	var/datum/status_effect/neuroware/neuro_status = organ_owner.has_status_effect(/datum/status_effect/neuroware)
	if(isnull(neuro_status))
		return
	for(var/datum/reagent/reagent as anything in organ_owner.reagents.reagent_list)
		if(reagent.chemical_flags & REAGENT_NEUROWARE)
			organ_owner.reagents.remove_reagent(reagent)

/obj/item/organ/brain/synth/emp_act(severity) // EMP act against the posi, keep the cap far below the organ health
	. = ..()

	if(!owner || . & EMP_PROTECT_SELF)
		return

	if(!COOLDOWN_FINISHED(src, severe_cooldown)) //So we cant just spam emp to kill people.
		COOLDOWN_START(src, severe_cooldown, 10 SECONDS)

	switch(severity)
		if(EMP_HEAVY)
			to_chat(owner, span_warning("01001001 00100111 01101101 00100000 01100110 01110101 01100011 01101011 01100101 01100100 00101110"))
			apply_organ_damage(SYNTH_ORGAN_HEAVY_EMP_DAMAGE, SYNTH_EMP_BRAIN_DAMAGE_MAXIMUM, required_organ_flag = ORGAN_ROBOTIC)
		if(EMP_LIGHT)
			to_chat(owner, span_warning("Alert: Electromagnetic damage taken in central processing unit. Error Code: 401-YT"))
			apply_organ_damage(SYNTH_ORGAN_LIGHT_EMP_DAMAGE, SYNTH_EMP_BRAIN_DAMAGE_MAXIMUM, required_organ_flag = ORGAN_ROBOTIC)

/obj/item/organ/brain/synth/apply_organ_damage(damage_amount, maximum, required_organ_flag)
	. = ..()

	if(owner && damage > 0 && (world.time - last_message_time) > SYNTH_BRAIN_DAMAGE_MESSAGE_INTERVAL)
		last_message_time = world.time

		if(damage > BRAIN_DAMAGE_SEVERE)
			to_chat(owner, span_warning("Alre: re oumtnin ilir tocorr:pa ni ne:cnrrpiioruloomatt cessingode: P1_1-H"))
			return

		if(damage > BRAIN_DAMAGE_MILD)
			to_chat(owner, span_warning("Alert: Minor corruption in central processing unit. Error Code: 001-HP"))

/obj/item/organ/brain/synth/circuit
	name = "compact AI circuit"
	desc = "A compact and extremely complex circuit, perfectly dimensioned to fit in the same slot as a synthetic-compatible positronic brain. It is usually slotted into the chest of synthetic crewmembers."
	icon = 'modular_nova/master_files/icons/obj/alt_silicon_brains.dmi'
	icon_state = "circuit-occupied"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'

/obj/item/organ/brain/synth/circuit/hyperboard
	name = "compact hyperboard circuit"
	desc = "A compact and extremely complex circuit, made with more advanced technologies at least visually, but its perfectly dimensioned to fit in \
		the same slot as a synthetic-compatible positronic brain. It is usually slotted into the chest of synthetic crew members."
	icon_state = "hyperboard-occupied"

/obj/item/organ/brain/synth/circuit/limaengine
	name = "compact lima-engine circuit"
	desc = "A compact and extremely complex circuit, seeming to have a tube of fluid that holds its electricity and yet it defies the laws of gravity, but the weight of the board keeps it down... \
		it seems perfectly dimensioned to fit in the same slot as a synthetic-compatible positronic brain. It is usually slotted into the chest of synthetic crew members."
	icon_state = "limaengine-occupied"

/obj/item/organ/brain/synth/circuit/disk
	name = "compact ai braindisk circuit"
	desc = "A compact and rather ancient disk, perfectly dimensioned to fit in the same slot as a synthetic-compatible positronic brain. It is usually slotted into the chest of synthetic crew members."
	icon_state = "diskbrain-occupied"

/obj/item/organ/brain/synth/circuit/neuroboard
	name = "compact neuroboard circuit"
	desc = "A compact and extremely complex circuit. It seems to have an overwhelming amount of processing power and yet its perfectly dimensioned to fit \
		in the same slot as a synthetic-compatible positronic brain. It is usually slotted into the chest of synthetic crew members."
	icon_state = "neuroboard-occupied"

/obj/item/organ/brain/synth/circuit/condensed
	name = "compact hypercrystal"
	desc = "A compact and extremely complex crystal it has no visibly solderings or circuits of any kind yet its perfectly dimensioned to fit in \
		the same slot as a synthetic-compatible positronic brain. It is usually slotted into the chest of synthetic crew members."
	icon_state = "condensed-occupied"

/obj/item/organ/brain/synth/circuit/cyberdeck
	name = "compact advanced cyberdeck"
	desc = "A strange black, smooth complex device, it feels like a solid chunk off metal but yet it seems as if its, perfectly dimensioned to fit in the same slot as a \
		synthetic-compatible positronic brain. It is usually slotted into the chest of synthetic crew members."
	icon_state = "cyberdeck-occupied"

/obj/item/organ/brain/synth/mmi
	name = "compact man-machine interface"
	desc = "A compact man-machine interface, perfectly dimensioned to fit in the same slot as a synthetic-compatible positronic brain. Unfortunately, the brain seems to be permanently attached to the circuitry, and it seems relatively sensitive to its environment. It is usually slotted into the chest of synthetic crewmembers."
	icon = 'modular_nova/master_files/icons/obj/surgery.dmi'
	icon_state = "mmi-ipc"
