/datum/map_generator/jungle_generator/beewars
	possible_biomes = list(
		BIOME_LOW_HEAT=list(
		BIOME_LOW_HUMIDITY = /datum/biome/flatlands,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/flatlands,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/flatlands,
		BIOME_HIGH_HUMIDITY = /datum/biome/flatlands)
		,
	BIOME_LOWMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/flatlands,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/flatlands,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/flatlands,
		BIOME_HIGH_HUMIDITY = /datum/biome/flatlands
		),
	BIOME_HIGHMEDIUM_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/trees,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/trees,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/trees,
		BIOME_HIGH_HUMIDITY = /datum/biome/trees
		),
	BIOME_HIGH_HEAT = list(
		BIOME_LOW_HUMIDITY = /datum/biome/trees,
		BIOME_LOWMEDIUM_HUMIDITY = /datum/biome/trees,
		BIOME_HIGHMEDIUM_HUMIDITY = /datum/biome/trees,
		BIOME_HIGH_HUMIDITY = /datum/biome/trees
		)
	)





/datum/biome/flatlands
	turf_type = /turf/open/floor/plating/asteroid/wargrass
	flora_types = list(/obj/structure/flora/grass/jungle,/obj/structure/flora/grass/jungle/b, /obj/structure/flora/tree/pine, /obj/structure/flora/junglebush, /obj/structure/flora/junglebush/b, /obj/structure/flora/junglebush/c)
	flora_density = 10

/datum/biome/trees
	turf_type = /turf/open/floor/plating/asteroid/wargrass
	flora_types = list(/obj/structure/flora/grass/jungle,/obj/structure/flora/grass/jungle/b, /obj/structure/flora/tree/pine)
	flora_density = 40

