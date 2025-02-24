; ===========================================================================
; -------------------------------------------------------------------------------
; Main game level order

; One value per act. That value is the level/act number of the level to load when
; that act finishes.
; -------------------------------------------------------------------------------
;word_142F8:
LevelOrder: zoneOrderedTable 2,2	; WrdArr_LevelOrder
	zoneTableEntry.w  emerald_hill_zone_act_2   ; 0
	zoneTableEntry.w  chemical_plant_zone_act_1	; 1
	zoneTableEntry.w  emerald_hill_zone_act_1	; 2
	zoneTableEntry.w  emerald_hill_zone_act_1	; 3
	zoneTableEntry.w  wood_zone_act_2		    ; 4
	zoneTableEntry.w  metropolis_zone_act_1		; 5
	zoneTableEntry.w  emerald_hill_zone_act_1	; 6
	zoneTableEntry.w  emerald_hill_zone_act_1	; 7
	zoneTableEntry.w  metropolis_zone_act_2		; 8
	zoneTableEntry.w  metropolis_zone_act_3		; 9
	zoneTableEntry.w  sky_chase_zone_act_1		; 10
	zoneTableEntry.w  emerald_hill_zone_act_1	; 11
	zoneTableEntry.w  death_egg_zone_act_1		; 12
	zoneTableEntry.w  emerald_hill_zone_act_1	; 13
	zoneTableEntry.w  hill_top_zone_act_2		; 14
	zoneTableEntry.w  mystic_cave_zone_act_1	; 15
	zoneTableEntry.w  hidden_palace_zone_act_2 	; 16
	zoneTableEntry.w  oil_ocean_zone_act_1		; 17
	zoneTableEntry.w  emerald_hill_zone_act_1	; 18
	zoneTableEntry.w  emerald_hill_zone_act_1	; 19
	zoneTableEntry.w  oil_ocean_zone_act_2		; 20
	zoneTableEntry.w  metropolis_zone_act_1		; 21
	zoneTableEntry.w  mystic_cave_zone_act_2	; 22
	zoneTableEntry.w  oil_ocean_zone_act_1		; 23
	zoneTableEntry.w  casino_night_zone_act_2	; 24
	zoneTableEntry.w  hill_top_zone_act_1		; 25
	zoneTableEntry.w  chemical_plant_zone_act_2	; 26
	zoneTableEntry.w  aquatic_ruin_zone_act_1	; 27
	zoneTableEntry.w  $FFFF				        ; 28
	zoneTableEntry.w  emerald_hill_zone_act_1	; 29
	zoneTableEntry.w  aquatic_ruin_zone_act_2	; 30
	zoneTableEntry.w  casino_night_zone_act_1	; 31
	zoneTableEntry.w  wing_fortress_zone_act_1 	; 32
	zoneTableEntry.w  emerald_hill_zone_act_1	; 33
    zoneTableEnd

;word_1433C:
LevelOrder_2P: zoneOrderedTable 2,2	; WrdArr_LevelOrder_2P
	zoneTableEntry.w  emerald_hill_zone_act_2
	zoneTableEntry.w  casino_night_zone_act_1	; 1
	zoneTableEntry.w  emerald_hill_zone_act_1	; 2
	zoneTableEntry.w  emerald_hill_zone_act_1	; 3
	zoneTableEntry.w  wood_zone_act_2		; 4
	zoneTableEntry.w  metropolis_zone_act_1		; 5
	zoneTableEntry.w  emerald_hill_zone_act_1	; 6
	zoneTableEntry.w  emerald_hill_zone_act_1	; 7
	zoneTableEntry.w  metropolis_zone_act_2		; 8
	zoneTableEntry.w  metropolis_zone_act_3		; 9
	zoneTableEntry.w  sky_chase_zone_act_1		; 10
	zoneTableEntry.w  emerald_hill_zone_act_1	; 11
	zoneTableEntry.w  death_egg_zone_act_1		; 12
	zoneTableEntry.w  emerald_hill_zone_act_1	; 13
	zoneTableEntry.w  hill_top_zone_act_2		; 14
	zoneTableEntry.w  mystic_cave_zone_act_1	; 15
	zoneTableEntry.w  hidden_palace_zone_act_2 	; 16
	zoneTableEntry.w  oil_ocean_zone_act_1		; 17
	zoneTableEntry.w  emerald_hill_zone_act_1	; 18
	zoneTableEntry.w  emerald_hill_zone_act_1	; 19
	zoneTableEntry.w  oil_ocean_zone_act_2		; 20
	zoneTableEntry.w  metropolis_zone_act_1		; 21
	zoneTableEntry.w  mystic_cave_zone_act_2	; 22
	zoneTableEntry.w  $FFFF				; 23
	zoneTableEntry.w  casino_night_zone_act_2	; 24
	zoneTableEntry.w  mystic_cave_zone_act_1	; 25
	zoneTableEntry.w  chemical_plant_zone_act_2 	; 26
	zoneTableEntry.w  aquatic_ruin_zone_act_1	; 27
	zoneTableEntry.w  $FFFF				; 28
	zoneTableEntry.w  emerald_hill_zone_act_1	; 29
	zoneTableEntry.w  aquatic_ruin_zone_act_2	; 30
	zoneTableEntry.w  casino_night_zone_act_1	; 31
	zoneTableEntry.w  wing_fortress_zone_act_1 	; 32
	zoneTableEntry.w  emerald_hill_zone_act_1	; 33
    zoneTableEnd
