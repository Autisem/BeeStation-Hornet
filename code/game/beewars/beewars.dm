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
	ctf_gear = /datum/outfit/soldier/redsoldier
	control_points = 1
	control_points_to_win = 500

/obj/machinery/capture_the_flag/blue/beewar
	name = "Blue team spawner"
	ctf_gear = /datum/outfit/soldier/bluesoldier
	control_points = 1
	control_points_to_win = 500

/obj/machinery/capture_the_flag/blue/beewar/ctf_dust_old(mob/living/body)
	if(isliving(body) && (team in body.faction))
		recently_dead_ckeys += body.ckey
		addtimer(CALLBACK(src, .proc/clear_cooldown, body.ckey), respawn_cooldown, TIMER_UNIQUE)
		body.death(0)

/obj/machinery/capture_the_flag/red/beewar/ctf_dust_old(mob/living/body)
	if(isliving(body) && (team in body.faction))
		recently_dead_ckeys += body.ckey
		addtimer(CALLBACK(src, .proc/clear_cooldown, body.ckey), respawn_cooldown, TIMER_UNIQUE)
		body.death(0)

/turf/closed/indestructible/woodwall
	name = "Fine wooden wall"
	desc = "The change those pesky enemy's comming trough here is NONE"
	icon = 'icons/turf/walls/wood_wall.dmi'
	icon_state = "wood"

/obj/item/gun/ballistic/rifle/boltaction/musket
	name = "\improper kentucky  rifle"
	desc = "I own a musket for home defense, since that's what the founding fathers intended. Four ruffians break into my house. What the devil? As I grab my powdered wig and Kentucky rifle. Blow a golf ball sized hole through the first man, he's dead on the spot."
	mag_type = /obj/item/ammo_box/magazine/internal/boltaction/musket

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

/datum/outfit/soldier
	name = "Foot soldier"
	ears = /obj/item/radio/headset
	back = /obj/item/storage/backpack/soldier
	suit = /obj/item/clothing/suit/jacket/letterman_red/soldier
	head = /obj/item/clothing/head/redcoat
	belt = /obj/item/storage/belt/bandolier/soldier
	r_pocket = /obj/item/kitchen/knife/combat/bayonet
	l_pocket = /obj/item/pinpointer/beewar
	suit_store = /obj/item/gun/ballistic/rifle/boltaction/musket
	backpack_contents = list(/obj/item/shovel/spade = 1,/obj/item/hatchet=1,/obj/item/storage/firstaid/regular=1)
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/color/white

/datum/outfit/soldier/post_equip(mob/living/carbon/human/H, visualsOnly)
	if(visualsOnly)
		return
	var/list/no_drops = list()

	no_drops += H.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	no_drops += H.get_item_by_slot(ITEM_SLOT_GLOVES)
	no_drops += H.get_item_by_slot(ITEM_SLOT_FEET)
	no_drops += H.get_item_by_slot(ITEM_SLOT_ICLOTHING)
	no_drops += H.get_item_by_slot(ITEM_SLOT_EARS)
	for(var/i in no_drops)
		var/obj/item/I = i
		ADD_TRAIT(I, TRAIT_NODROP, CAPTURE_THE_FLAG_TRAIT)

/datum/outfit/soldier/redsoldier
	name = "Red foot soldier"
	uniform = /obj/item/clothing/under/color/red
	back = /obj/item/storage/backpack/soldier/red
	suit =  /obj/item/clothing/suit/jacket/letterman_red/soldier

/datum/outfit/soldier/redsoldier/post_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	var/obj/item/radio/R = H.ears
	R.set_frequency(FREQ_CTF_RED)
	R.freqlock = TRUE
	R.independent = TRUE
	H.dna.species.stunmod = 0


/datum/outfit/soldier/bluesoldier
	name = "Blue foot soldier"
	uniform = /obj/item/clothing/under/color/blue
	back = /obj/item/storage/backpack/soldier/blue
	suit = /obj/item/clothing/suit/jacket/letterman_nanotrasen/soldier


/datum/outfit/soldier/bluesoldier/post_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	var/obj/item/radio/R = H.ears
	R.set_frequency(FREQ_CTF_BLUE)
	R.freqlock = TRUE
	R.independent = TRUE
	H.dna.species.stunmod = 0


/obj/item/clothing/suit/jacket/letterman_nanotrasen/soldier
	allowed = list(/obj/item/gun/ballistic/rifle/boltaction/musket)


/obj/item/clothing/suit/jacket/letterman_red/soldier
	allowed = list(/obj/item/gun/ballistic/rifle/boltaction/musket)

/obj/item/storage/backpack/soldier
	name = "emergency response team security backpack"
	desc = "A spacious backpack with lots of pockets, worn by Security Officers of an Emergency Response Team."
	icon_state = "ert_security"

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
