#define RED_TEAM "red"
#define BLUE_TEAM "blue"

var/global/obj/machinery/capture_the_flag/red/beewar/RT
var/global/obj/machinery/capture_the_flag/blue/beewar/BT
/turf/open/floor/plating/asteroid/wargrass
	name = "Grass"
	desc = "The distinct lack of blood on youre enemy's is offsetting."
	baseturfs = /turf/open/floor/plating/asteroid/wargrass
	icon = 'icons/turf/floors.dmi'
	icon_state = "grass"
	icon_plating = "grass"
	postdig_icon_change = TRUE
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_GRASS
	clawfootstep = FOOTSTEP_GRASS
	planetary_atmos = TRUE
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	floor_variance = 0

/turf/open/floor/wood/wargrass
	baseturfs = /turf/open/floor/plating/asteroid/wargrass
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS

/area/ctf/battlefield
	name = "The battlefield"
	atmosalm = FALSE
	poweralm = FALSE
	teleport_restriction = TELEPORT_ALLOW_NONE
	dynamic_lighting = DYNAMIC_LIGHTING_DISABLED

/area/ctf/battlefield/generated
	map_generator = /datum/map_generator/jungle_generator/beewars

/obj/machinery/capture_the_flag/red/beewar
	name = "Red team spawner"
	ctf_gear = /datum/outfit/war/red
	control_points = 1
	control_points_to_win = 500
	var/commander
	var/datum/outfit/commander_gear = /datum/outfit/war/red/commander

/obj/machinery/capture_the_flag/blue/beewar
	name = "Blue team spawner"
	ctf_gear = /datum/outfit/war/blue
	control_points = 1
	control_points_to_win = 500
	var/commander
	var/datum/outfit/commander_gear = /datum/outfit/war/blue/commander

/obj/machinery/capture_the_flag/blue/beewar/Initialize(mapload)
	. = ..()
	BT = src

/obj/machinery/capture_the_flag/red/beewar/Initialize(mapload)
	. = ..()
	RT = src


/obj/machinery/capture_the_flag/blue/beewar/spawn_team_member(client/new_team_member)
	var/mob/living/carbon/human/M = new/mob/living/carbon/human(get_turf(src))
	new_team_member.prefs.copy_to(M)
	if (isplasmaman(M))
		M.set_species(/datum/species/human)
	M.key = new_team_member.key
	M.faction += team
	if (new_team_member.key == commander)
		M.equipOutfit(commander_gear)
	else
		M.equipOutfit(ctf_gear)
	spawned_mobs += M


/obj/machinery/capture_the_flag/red/beewar/spawn_team_member(client/new_team_member)
	var/mob/living/carbon/human/M = new/mob/living/carbon/human(get_turf(src))
	new_team_member.prefs.copy_to(M)
	if (isplasmaman(M))
		M.set_species(/datum/species/human)
	M.key = new_team_member.key
	M.faction += team
	if (new_team_member.key == commander)
		M.equipOutfit(commander_gear)
	else
		M.equipOutfit(ctf_gear)
	spawned_mobs += M

/obj/structure/trap/ctf/beewar/trap_effect(mob/living/L)
	if(!(src.team in L.faction))
		to_chat(L, "<span class='danger'><B>Stay out of the enemy spawn!</B></span>")
		L.death()

/obj/structure/trap/ctf/beewar/red
	team = RED_TEAM
	icon_state = "trap-fire"

/obj/structure/trap/ctf/beewar/blue
	team = BLUE_TEAM
	icon_state = "trap-frost"

/obj/machinery/capture_the_flag/blue/beewar/process(delta_time)
	for(var/mob/living/M as() in spawned_mobs)
		if(QDELETED(M))
			spawned_mobs -= M
			continue
		// Anyone in crit, automatically reap
		if(M.stat == DEAD  && M.ckey)
			ctf_dust_old(M)
		else
			// The changes that you've been hit with no shield but not
			// instantly critted are low, but have some healing.
			M.adjustBruteLoss(-1 * delta_time)
			M.adjustFireLoss(-1 * delta_time)


/obj/machinery/capture_the_flag/red/beewar/process(delta_time)
	for(var/mob/living/M as() in spawned_mobs)
		if(QDELETED(M))
			spawned_mobs -= M
			continue
		// Anyone in crit, automatically reap
		if(M.stat == DEAD  && M.ckey)
			ctf_dust_old(M)
		else
			// The changes that you've been hit with no shield but not
			// instantly critted are low, but have some healing.
			M.adjustBruteLoss(-1 * delta_time)
			M.adjustFireLoss(-1 * delta_time)

/obj/machinery/capture_the_flag/blue/beewar/ctf_dust_old(mob/living/body)
	if(isliving(body) && (team in body.faction))
		if (body.ckey)
			recently_dead_ckeys += body.ckey
			addtimer(CALLBACK(src, .proc/clear_cooldown, body.ckey), respawn_cooldown, TIMER_UNIQUE)
			body.ghostize(FALSE,FALSE)
			spawned_mobs -= body
		var/obj/item/clothing/suit/S = body.get_item_by_slot(ITEM_SLOT_OCLOTHING)
		var/datum/component/tracking_beacon/TB = S.GetComponent(/datum/component/tracking_beacon)
		var/datum/component/team_monitor/TM = S.GetComponent(/datum/component/team_monitor)
		if(TB)
			qdel(TB)
		if(TM)
			qdel(TM)


/obj/machinery/capture_the_flag/red/beewar/ctf_dust_old(mob/living/body)
	if(isliving(body) && (team in body.faction))
		if (body.ckey)
			recently_dead_ckeys += body.ckey
			addtimer(CALLBACK(src, .proc/clear_cooldown, body.ckey), respawn_cooldown, TIMER_UNIQUE)
			body.ghostize(FALSE,FALSE)
			spawned_mobs -= body
		var/obj/item/clothing/suit/S = body.get_item_by_slot(ITEM_SLOT_OCLOTHING)
		var/datum/component/tracking_beacon/TB = S.GetComponent(/datum/component/tracking_beacon)
		var/datum/component/team_monitor/TM = S.GetComponent(/datum/component/team_monitor)
		if(TB)
			qdel(TB)
		if(TM)
			qdel(TM)


/turf/closed/indestructible/woodwall
	name = "Fine wooden wall"
	desc = "The change those pesky enemy's comming trough here is NONE"
	icon = 'icons/turf/walls/wood_wall.dmi'
	icon_state = "wood"

/obj/item/gun/ballistic/rifle/boltaction/musket
	name = "\improper kentucky  rifle"
	desc = "I own a musket for home defense, since that's what the founding fathers intended. Four ruffians break into my house. What the devil? As I grab my powdered wig and Kentucky rifle. Blow a golf ball sized hole through the first man, he's dead on the spot."
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction/musket
	fire_sound = 'code/game/beewars/musketshot.ogg'


/obj/item/ammo_box/magazine/internal/boltaction/musket
	max_ammo = 1

/obj/item/storage/belt/bandolier/soldier
	name = "Ammo bandolier"
	desc = "Hold all that grape shot you have been saving up"

/obj/item/storage/belt/bandolier/soldier/ComponentInitialize()
	. = ..()
	var/datum/component/storage/concrete/stack/STR = GetComponent(/datum/component/storage/concrete/stack)
	STR.allow_quick_gather = TRUE
	STR.click_gather = TRUE
	STR.max_combined_stack_amount = 50
	STR.max_items = 50
	STR.can_hold = typecacheof(list(/obj/item/ammo_casing/a762))

/obj/item/storage/belt/bandolier/soldier/PopulateContents()
	for(var/i in 1 to 50)
		new /obj/item/ammo_casing/a762(src)

/obj/item/pinpointer/beewar
	name = "Control point locator"
	desc = "Secure the point of interest, build defenses using the wood in the forrest, good luck."

/obj/item/pinpointer/beewar/scan_for_target()
	target = null
	var/obj/machinery/control_point/CP = locate() in GLOB.poi_list
	target = CP

/obj/machinery/control_point/New(loc, ...)
	. = ..()
	GLOB.poi_list += src

/obj/item/clock
	name = "Pocket watch"
	desc = "Special kind of pocket watch, instead of the time it shows how close you or youre enemy are to winning."
	icon = 'icons/obj/clockwork_objects.dmi'
	icon_state = "dread_ipad"
	worn_icon_state = "dread_ipad"


/obj/item/clock/Initialize(mapload)
	. = ..()


/obj/item/clock/examine(mob/user)
	. = ..()
	. += "Red team score: [RT.control_points]/[RT.control_points_to_win]"
	. += "Blue team score: [BT.control_points]/[BT.control_points_to_win]"

/obj/item/promotionkit
	name = "Commander kit"
	desc = "Become the commander of youre team with this handy kit, use it in youre hand and boom!"
	icon = 'code/game/beewars/beewars.dmi'
	icon_state = "cannonball"

/obj/item/promotionkit/attack_self(mob/user)
	. = ..()
	if(!istype(user,/mob/living/carbon/human))
		return FALSE

	var/mob/living/carbon/human/new_commander = user

	if (BLUE_TEAM in new_commander.faction)
		if (!BT.commander)
			BT.commander = new_commander.client.key
			for (var/obj/item/I in new_commander.get_equipped_items(TRUE))
				qdel(I)
			new_commander.equipOutfit(BT.commander_gear)
			to_chat(new_commander,"<span class='warning'>You have been promoted!</span>")
			log_game("[key_name(new_commander.mind)] has made themselves commander of the blue team")
			qdel(src)
			return TRUE

	if (RED_TEAM in new_commander.faction)
		if (!RT.commander)
			RT.commander = new_commander.client.key
			for (var/obj/item/I in new_commander.get_equipped_items(TRUE))
				qdel(I)
			new_commander.equipOutfit(RT.commander_gear)
			to_chat(new_commander,"<span class='warning'>You have been promoted!</span>")
			log_game("[key_name(new_commander.mind)] has made themselves commander of the red team")
			qdel(src)
			return TRUE
	return FALSE


/obj/item/projectile/magic/aoe/fireball/cannon
	exp_flash = 0
	icon = 'code/game/beewars/beewars.dmi'
	icon_state = "cannonball"

/obj/machinery/manned_turret/cannon
	name = "Field cannon"
	desc = "I have to resort to the cannon mounted at the top of the stairs loaded with grape shot, Tally ho lads! The grape shot shreds two men in the blast, the sound and extra shrapnel set off car alarms."
	projectile_type = /obj/item/projectile/magic/aoe/fireball/cannon
	icon = 'code/game/beewars/beewars.dmi'
	icon_state = "cannon"
	rate_of_fire = 1
	number_of_shots = 1
	cooldown_duration = 60
	view_range = 9

/obj/machinery/manned_turret/cannon/Initialize(mapload)
	. = ..()
	var/matrix/M = matrix()
	M.Scale(1.5,1.5)
	transform = M

/obj/item/kitchen/knife/combat/bayonet
	name = "Bayonet"
	desc = "Fix bayonet and charge the last terrified rapscallion. He Bleeds out waiting on the police to arrive since triangular bayonet wounds are impossible to stitch up. Just as the founding fathers intended."
	force =	25

/obj/item/clothing/shoes/jackboots/soldier
	name = "Militia boots"
	desc = "More resiliant, aint that nice?"
	body_parts_covered =  FEET|LEGS
	resistance_flags = FIRE_PROOF
	armor = list("melee" = 60, "bullet" = 50, "laser" = 30, "energy" = 40, "bomb" = 25, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50, "stamina" = 30)


/datum/outfit/war
	name = "Foot soldier"
	ears = /obj/item/radio/headset
	back = /obj/item/storage/backpack/soldier
	suit = /obj/item/clothing/suit/jacket/letterman_red/soldier
	head = /obj/item/clothing/head/redcoat/beewars
	belt = /obj/item/storage/belt/bandolier/soldier
	r_pocket = /obj/item/kitchen/knife/combat/bayonet
	l_pocket = /obj/item/pinpointer/beewar
	suit_store = /obj/item/gun/ballistic/rifle/boltaction/musket
	backpack_contents = list(/obj/item/shovel/spade = 1,/obj/item/hatchet=1,/obj/item/storage/firstaid/regular=1,/obj/item/clock=1)
	shoes = /obj/item/clothing/shoes/jackboots/soldier
	gloves = /obj/item/clothing/gloves/color/white



/datum/outfit/war/post_equip(mob/living/carbon/human/H, visualsOnly)
	if(visualsOnly)
		return
	var/list/no_drops = list()

	H.mind.assigned_role = "soldier"

	no_drops += H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	no_drops += H.get_item_by_slot(ITEM_SLOT_GLOVES)
	no_drops += H.get_item_by_slot(ITEM_SLOT_FEET)
	no_drops += H.get_item_by_slot(ITEM_SLOT_ICLOTHING)
	no_drops += H.get_item_by_slot(ITEM_SLOT_EARS)
	for(var/i in no_drops)
		var/obj/item/I = i
		ADD_TRAIT(I, TRAIT_NODROP, CAPTURE_THE_FLAG_TRAIT)


/obj/item/storage/belt/sabre/beewars
	name = "Commanders sheath"
	desc = "Bit rude to put that kniofe in me chest innit bruf?"
	resistance_flags = FIRE_PROOF

/obj/item/melee/sabre/beewars
	name = "Commanders saber"
	desc = "Bit rude to put that kniofe in me chest innit bruf?"

/obj/item/storage/belt/sabre/beewars/PopulateContents()
	new /obj/item/melee/sabre/beewars(src)
	update_icon()


/obj/item/storage/belt/beewars/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text, damage, attack_type)
	. = ..()
	if(isprojectile(hitby) && !istype(hitby,/obj/item/projectile/magic/aoe/fireball/cannon))
		var/obj/item/projectile/P = hitby
		P.firer = src
		P.setAngle(get_dir(owner, hitby))
		owner.emote("Gracefully returns the bullets back to sender")
		return 1

/datum/outfit/war/red/commander
	name = "Red Commander"
	back = /obj/item/storage/backpack/bannerpack/red
	suit = /obj/item/clothing/suit/aristo_red/commander
	head = /obj/item/clothing/head/beret/black/commander
	belt = /obj/item/storage/belt/sabre/beewars
	backpack_contents = list(/obj/item/shovel/spade = 1,/obj/item/hatchet=1,/obj/item/storage/firstaid/regular=1,/obj/item/clock=1,/obj/item/storage/belt/bandolier/soldier=1)

/datum/outfit/war/red/commander/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/obj/item/radio/R = H.ears
	R.command = TRUE
	R.use_command = TRUE
	H.mind.assigned_role = "commander"
	H.real_name = "Commander [H.real_name]"

/datum/outfit/war/blue/commander
	name = "Blue Commander"
	back = /obj/item/storage/backpack/bannerpack/blue
	suit = /obj/item/clothing/suit/aristo_blue/commander
	head = /obj/item/clothing/head/beret/black/commander
	belt = /obj/item/storage/belt/sabre/beewars
	backpack_contents = list(/obj/item/shovel/spade = 1,/obj/item/hatchet=1,/obj/item/storage/firstaid/regular=1,/obj/item/clock=1,/obj/item/storage/belt/bandolier/soldier=1)

/datum/outfit/war/blue/commander/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/obj/item/radio/R = H.ears
	R.command = TRUE
	R.use_command = TRUE
	H.mind.assigned_role = "commander"




/datum/outfit/war/red
	name = "Red foot soldier"
	uniform = /obj/item/clothing/under/color/red/beewar
	back = /obj/item/storage/backpack/soldier/red
	suit =  /obj/item/clothing/suit/jacket/letterman_red/soldier
	backpack_contents = list(/obj/item/shovel/spade = 1,/obj/item/hatchet=1,/obj/item/storage/firstaid/regular=1,/obj/item/clock=1)

/datum/outfit/war/red/post_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	var/obj/item/radio/R = H.ears
	R.set_frequency(FREQ_CTF_RED)
	R.freqlock = TRUE
	R.independent = TRUE



/datum/outfit/war/blue
	name = "Blue foot soldier"
	uniform = /obj/item/clothing/under/color/blue/beewars
	back = /obj/item/storage/backpack/soldier/blue
	suit = /obj/item/clothing/suit/jacket/letterman_nanotrasen/soldier


/datum/outfit/war/blue/post_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	var/obj/item/radio/R = H.ears
	R.set_frequency(FREQ_CTF_BLUE)
	R.freqlock = TRUE
	R.independent = TRUE



/obj/item/clothing/suit/aristo_red/commander
	allowed = list(/obj/item/gun/ballistic/rifle/boltaction/musket)
	armor = list("melee" = 20, "bullet" = 40, "laser" = 30, "energy" = 40, "bomb" = 75, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50, "stamina" = 30)

/obj/item/clothing/suit/aristo_red/commander/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/team_monitor, "red", 1)
	AddComponent(/datum/component/tracking_beacon, "red", 1, GetComponent(/datum/component/team_monitor), TRUE, "#eb270d", TRUE)
	//TM.toggle_hud(TRUE, H)

/obj/item/clothing/suit/aristo_blue/commander
	allowed = list(/obj/item/gun/ballistic/rifle/boltaction/musket)
	armor = list("melee" = 20, "bullet" = 40, "laser" = 30, "energy" = 40, "bomb" = 75, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50, "stamina" = 30)

/obj/item/clothing/suit/aristo_blue/commander/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/team_monitor, "blue", 1)
	AddComponent(/datum/component/tracking_beacon, "blue", 1, GetComponent(/datum/component/team_monitor), TRUE, "#1519e9", TRUE)

/obj/item/clothing/suit/jacket/letterman_nanotrasen/soldier
	allowed = list(/obj/item/gun/ballistic/rifle/boltaction/musket)
	resistance_flags = FIRE_PROOF
	armor = list("melee" = 10, "bullet" = 20, "laser" = 30, "energy" = 40, "bomb" = 75, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50, "stamina" = 30)

/obj/item/clothing/suit/jacket/letterman_nanotrasen/soldier/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/team_monitor, "blue", 1)
	//TM.toggle_hud(TRUE, H)


/obj/item/clothing/suit/jacket/letterman_red/soldier
	allowed = list(/obj/item/gun/ballistic/rifle/boltaction/musket)
	resistance_flags = FIRE_PROOF
	armor = list("melee" = 10, "bullet" = 20, "laser" = 30, "energy" = 40, "bomb" = 75, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50, "stamina" = 30)

/obj/item/clothing/suit/jacket/letterman_red/soldier/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/team_monitor, "red", 1)
	//TM.toggle_hud(TRUE, H)


/obj/item/clothing/under/color/red/beewar
	name = "Red war tunic"
	resistance_flags = FIRE_PROOF
	//armor = list("melee" = 10, "bullet" = 20, "laser" = 30, "energy" = 40, "bomb" = 75, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50, "stamina" = 30)
/obj/item/clothing/under/color/blue/beewars
	name = "Blue battle tunic"
	resistance_flags = FIRE_PROOF
	//armor = list("melee" = 10, "bullet" = 20, "laser" = 30, "energy" = 40, "bomb" = 75, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50, "stamina" = 30)
/obj/item/clothing/head/redcoat/beewars
	resistance_flags = FIRE_PROOF
	armor = list("melee" = 10, "bullet" = 20, "laser" = 30, "energy" = 40, "bomb" = 75, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50, "stamina" = 30)
/obj/item/clothing/head/beret/black/commander
	name = "Commanders berret"
	desc = "For the most dinstinquished gentleman on the battle field, show them hell!"
	resistance_flags = FIRE_PROOF
	armor = list("melee" = 20, "bullet" = 40, "laser" = 30, "energy" = 40, "bomb" = 75, "bio" = 0, "rad" = 0, "fire" = 50, "acid" = 50, "stamina" = 30)
/obj/item/storage/backpack/soldier
	name = "emergency response team security backpack"
	desc = "A spacious backpack with lots of pockets, worn by Security Officers of an Emergency Response Team."
	icon_state = "ert_security"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/soldier/blue
	name = "Blue soldier backpack"
	desc = "A spacious backpack with lots of pockets, for all those supply's."
	icon_state = "ert_commander"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/soldier/red
	name = "Red soldier backpack"
	desc = "A spacious backpack with lots of pockets, for all those supply's."
	icon_state = "ert_security"
	resistance_flags = FIRE_PROOF
	item_flags = DROPDEL
