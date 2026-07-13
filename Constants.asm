; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equates section - Names for variables.
Max_Rings = 511 ; default. maximum number possible is 759
    if Max_Rings > 759
    fatal "Maximum number of rings possible is 759"
    endif

Rings_Space = (Max_Rings+1)*2
; ---------------------------------------------------------------------------
; size variables - you'll get an informational error if you need to change these...
; they are all in units of bytes
Size_of_DAC_samples =		$1F44D
Size_of_Snd_driver_guess =	$1500 ; approximate post-compressed size of the Z80 sound driver

; ---------------------------------------------------------------------------
; Object Status Table offsets (for everything between Object_RAM and Primary_Collision)
; ---------------------------------------------------------------------------
; universally followed object conventions:
inertia =                     $1C
anim_frame_duration =         $24
next_anim =                   $21
speedshoes_time =             $36
invincibility_time  =         $35
invulnerable_time =           $34
spindash_flag =               $3D
pinball_mode =                $3D
flip_turned =                 $2D
spindash_counter =            $3E
restart_countdown =           spindash_counter
respawn_index =               $48
peelout_flag =      $5D
peelout_counter =   $20 ;word
;.....///////////////////////////..........
; ---------------------------------------------------------------------------
; Object Status Table offsets (for everything between Object_RAM and Primary_Collision)
; ---------------------------------------------------------------------------
; universally followed object conventions:
id =			  0 ; object ID (if you change this, change insn1op and insn2op in s2.macrosetup.asm, if you still use them)
render_flags =		  4 ; bitfield
; Render flags. The bitfield looks like this:
;     Bit 0 is the horizontal mirror flag. If set, the object will be flipped on its horizontal axis.
;     Bit 1 is the vertical mirror flag.
;     Bits 2 and 3 are the coordinate system flags. If both bits are clear, the object will be positioned by absolute screen coordinates. This is used for things like the HUD and menu options. If either bit is set, the object will be positioned by the playfield coordinates, i.e. where it is in a level.
;     Bit 4 is the assume pixel height flag. If clear, the pixel height of each object is assumed to be 32 pixels, otherwise the y-radius of the object (byte $16 of its status table) is also taken to be its pixel height.
;     Bit 5 is the static mappings flag. If set, this indicates that the mappings pointer for this object points directly to the pieces data for this frame, and implies that the object consists of only one sprite piece.
;     Bit 6 is the compound sprites flag. If set, this indicates that the current object's status table also contains information about other child sprites which need to be drawn using the current object's mappings, and also signifies that certain bytes of its status table have different meanings:
;         Byte $B is the mapping frame to display.
;         Byte $E is the pixel width of the object.
;         Byte $14 is the pixel height of the object.
;         Byte $F is the number of child sprites to draw.
;         From byte $10 onwards is the actual data for each child sprite. The format is six bytes per sprite: the first word is the base X position, the next word is the base Y position, the next byte is ignored and the last byte is the mapping frame to display.
;     Bit 7 is the on-screen flag. It will be set if the object is on-screen, and clear otherwise
height_pixels =		  6 ; byte
width_pixels =		  7 ; byte
priority =		  8 ; word ; in units of $80
art_tile =		 $A ; word ; PCCVH AAAAAAAAAAA ; P = priority, CC = palette line, V = y-flip; H = x-flip, A = starting cell index of art
mappings =		 $C ; long
x_pos =			$10 ; word, or long when extra precision is required
y_pos =			$14 ; word, or long when extra precision is required
x_sub =			  $12 ; and
y_sub =			  $16 ; and $F
mapping_frame =		$22 ; byte
; ---------------------------------------------------------------------------
; conventions followed by most objects:
routine =		  5 ; byte
x_vel =			$18 ; word
y_vel =			$1A ; word
y_radius =		$1E ; byte ; collision height / 2
x_radius =		$1F ; byte ; collision width / 2
anim =			$20 ; byte
prev_anim =		$21 ; byte ; when this isn't equal to anim the animation restarts
anim_frame =		$23 ; byte
anim_frame_timer =	$24 ; byte
angle =			$26 ; byte ; angle about axis into plane of the screen (00 = vertical, 360 degrees = 256)
status =		$2A ; bitfield ; refer to SCHG for details
; ---------------------------------------------------------------------------
; conventions followed by many objects but not Sonic/Tails/Knuckles:
x_pixel =		x_pos ; word ; x-coordinate for objects using screen positioning
y_pixel =		y_pos ; word ; y-coordinate for objects using screen positioning
collision_flags =	$28 ; byte ; TT SSSSSS ; TT = collision type, SSSSSS = size
collision_property =	$29 ; byte ; usage varies, bosses use it as a hit counter
shield_reaction =	$2B ; byte ; bit 3 = bounces off shield, bit 4 = negated by fire shield, bit 5 = negated by lightning shield, bit 6 = negated by bubble shield
subtype =		$2C ; byte
ros_bit =		$3B ; byte ; the bit to be cleared when an object is destroyed if the ROS flag is set
ros_addr =		$3C ; word ; the RAM address whose bit to clear when an object is destroyed if the ROS flag is set
routine_secondary =	$3C ; byte ; used by monitors for this purpose at least
vram_art =		$40 ; word ; address of art in VRAM (same as art_tile * $20)
parent =		$42 ; word ; address of the object that owns or spawned this one, if applicable
child_dx = 		$42 ; byte ; X offset of child relative to parent
child_dy = 		$43 ; byte ; Y offset of child relative to parent
parent3 = 		$46 ; word ; parent of child objects
parent2 =		$48 ; word ; several objects use this instead
respawn_addr =		$48 ; word ; the address of this object's entry in the respawn table
; ---------------------------------------------------------------------------
; conventions specific to Sonic/Tails/Knuckles:
ground_vel =		$1C ; word ; overall velocity along ground, not updated when in the air
double_jump_property =	$25 ; byte ; remaining frames of flight / 2 for Tails, gliding-related for Knuckles
flip_angle =		$27 ; byte ; angle about horizontal axis (360 degrees = 256)
status_secondary =	$2B ; byte ; see SCHG for details
air_left =		$2C ; byte
flip_type =		$2D ; byte ; bit 7 set means flipping is inverted, lower bits control flipping type
object_control =	$2E ; byte ; bit 0 set means character can jump out, bit 7 set means he can't
double_jump_flag =	$2F ; byte ; meaning depends on current character, see SCHG for details
flips_remaining =	$30 ; byte
flip_speed =		$31 ; byte
move_lock =		$32 ; word ; horizontal control lock, counts down to 0
invulnerability_timer =	$34 ; byte ; decremented every frame
invincibility_timer =	$35 ; byte ; decremented every 8 frames
speed_shoes_timer =	$36 ; byte ; decremented every 8 frames
status_tertiary =	$37 ; byte ; see SCHG for details
character_id =		$38 ; byte ; 0 for Sonic, 1 for Tails, 2 for Knuckles
scroll_delay_counter =	$39 ; byte ; incremented each frame the character is looking up/down, camera starts scrolling when this reaches 120
next_tilt =		$3A ; byte ; angle on ground in front of character
tilt =			$3B ; byte ; angle on ground
stick_to_convex =	$3C ; byte ; used to make character stick to convex surfaces such as the rotating discs in CNZ
spin_dash_flag =	$3D ; byte ; bit 1 indicates spin dash, bit 7 indicates forced roll
spin_dash_counter =	$3E ; word
jumping =		$40 ; byte
interact =		$42 ; word ; RAM address of the last object the character stood on
default_y_radius =	$44 ; byte ; default value of y_radius
default_x_radius =	$45 ; byte ; default value of x_radius
top_solid_bit =		$46 ; byte ; the bit to check for top solidity (either $C or $E)
lrb_solid_bit =		$47 ; byte ; the bit to check for left/right/bottom solidity (either $D or $F)
;=============================================================================
;some sonic 3 equs that match sonic 2
;=============================================================================
;ground_vel =		inertia
obj_control  =          $2E
Sprite_table_buffer = Sprite_Table
Sprite_table_input =  Sprite_Table_Input
Current_zone =  Current_Zone
;Sprites_drawn =  Sprite_count
;============================================================================
;some sonic 1 equs that match sonic 2
;============================================================================
ob2ndRout =             routine_secondary
obVelX =                x_vel
obVelY =                y_vel
;============================================================================
LastLoadedDPLC      = $34
Art_Address         = $38
DPLC_Address        = $3C
; ---------------------------------------------------------------------------
; conventions followed by some/most bosses:
boss_subtype		= $12  ;$12
boss_invulnerable_time	= $13  ;$13
boss_sine_count		= mapping_frame  ;$1A	;mapping_frame
boss_routine		= $26	;angle
boss_defeated		= $45
boss_hitcount2		= $42
boss_hurt_sonic		= $44	; flag set by collision response routine when sonic has just been hurt (by boss?)
; ---------------------------------------------------------------------------
; Player Status Variables
Status_Facing       = 0
Status_InAir        = 1
Status_Roll         = 2
Status_OnObj        = 3
Status_RollJump     = 4
Status_Push         = 5
Status_Underwater   = 6

; Elemental Shield DPLC variables
;LastLoadedDPLC      = $34
;Art_Address         = $38
;DPLC_Address        = $3C

; ---------------------------------------------------------------------------
; when childsprites are activated (i.e. bit #6 of render_flags set)
; BUGS
;mainspr_mapframe	= x_sub+1
;mainspr_width		= width_pixels
;mainspr_height		= height_pixels
;mainspr_childsprites 	= y_sub+1	; amount of child sprites
;-----------------------------------------------------------------------------
mainspr_mapframe	= $16 ;$12 ; also these varables also work but i decided to use that insted
mainspr_width		= width_pixels ;$13
mainspr_height		= height_pixels ;$16
mainspr_childsprites 	= $17	; amount of child sprites
mainspr_childsprites_S3K = $16
;------------------------------------------------------------------------------
sub2_x_pos		= $18	;x_vel
sub2_y_pos		= $1A	;y_vel
sub2_mapframe		= $1D
sub3_x_pos		= $1E	;y_radius
sub3_y_pos		= $20	;anim
sub3_mapframe		= $23	;anim_frame
sub4_x_pos		= $24	;anim_frame_timer
sub4_y_pos		= $26	;angle
sub4_mapframe		= $29	;collision_property
sub5_x_pos		= $2A	;status
sub5_y_pos		= $2C	;subtype
sub5_mapframe		= $2F
sub6_x_pos		= $30
sub6_y_pos		= $32
sub6_mapframe		= $35
sub7_x_pos		= $36
sub7_y_pos		= $38
sub7_mapframe		= $3B
sub8_x_pos		= $3C
sub8_y_pos		= $3E
sub8_mapframe		= $41
sub9_x_pos		= $42
sub9_y_pos		= $44
sub9_mapframe		= $47
next_subspr		= $6
; ---------------------------------------------------------------------------

objoff_12 =		2+x_pos;$12 ; note: x_pos can be 4 bytes, but sometimes the last 2 bytes of x_pos are used for other unrelated things
objoff_13 =		$13 ;3+x_pos ; unused
objoff_14 =		$14     ;2+y_pos	; unused
objoff_15 =		$15    ;3+y_pos ; unused
objoff_23 =             $23
objoff_2B  =		$2B
objoff_2C =		$2C ; overlaps subtype, but a few objects use it for other things anyway
 ;enum                objoff_29_s2=$2D,objoff_2A_s2=$2E,objoff_2B_s2=$2F,objoff_2C_s2=$30,objoff_2D_s2=$31,objoff_2E_s2=$32,objoff_2F_s2=$33
 ;enum objoff_30_s2=$34,objoff_31_s2=$35,objoff_32_s2=$36,objoff_33_s2=$37,objoff_34_s2=$38,objoff_35_s2=$39,objoff_36_s2=$3A,objoff_37_s2=$3B
 ;enum objoff_38_s2=$3C,objoff_39_s2=$3D,objoff_3A_s2=$3E,objoff_3B_s2=$3F,objoff_3C_s2=$40,objoff_3D_s2=$41,objoff_3E_s2=$42,objoff_3F_s2=$43
 ;enum objoff_44=$44,objoff_45=$45,objoff_46=$46,objoff_47=$47,objoff_48=$48,objoff_49=$49
 enum                objoff_2D=$2D,objoff_2E=$2E,objoff_2F=$2F,objoff_30=$30,objoff_31=$31,objoff_32=$32,objoff_33=$33  ; done

 enum objoff_34=$34,objoff_35=$35,objoff_36=$36,objoff_37=$37,objoff_38=$38,objoff_39=$39,objoff_3A=$3A,objoff_3B=$3B

 enum objoff_3C=$3C,objoff_3D=$3D,objoff_3E=$3E,objoff_3F=$3F,objoff_40=$40,objoff_41,objoff_42=$42,objoff_43=$43,objoff_44=$44,objoff_46=$46,objoff_48=$48

; ---------------------------------------------------------------------------
; Special Stage object properties:
ss_dplc_timer = $25 ;s2 => 23
SSTestRoutineSec = angle+1 ;flag for your hurt state
ss_x_pos = objoff_2C
ss_x_sub = objoff_2E
ss_y_pos = objoff_30
ss_y_sub = objoff_32
ss_init_flip_timer = objoff_34
ss_flip_timer = objoff_35
ss_z_pos = objoff_36
ss_hurt_timer = objoff_3A
ss_slide_timer = objoff_3B
ss_parent = objoff_3C
ss_rings_base = objoff_3E	; word
ss_rings_hundreds = objoff_3E
ss_rings_tens = objoff_3F
ss_rings_units = objoff_40
ss_last_angle_index = objoff_41
; ---------------------------------------------------------------------------
; property of all objects:
object_size =		$4A ; the size of an object
next_object =		object_size

; ---------------------------------------------------------------------------
; Bits 3-6 of an object's status after a SolidObject call is a
; bitfield with the following meaning:
p1_standing_bit   = 3
p2_standing_bit   = p1_standing_bit + 1

p1_standing       = 1<<p1_standing_bit
p2_standing       = 1<<p2_standing_bit

pushing_bit_delta = 2
p1_pushing_bit    = p1_standing_bit + pushing_bit_delta
p2_pushing_bit    = p1_pushing_bit + 1

p1_pushing        = 1<<p1_pushing_bit
p2_pushing        = 1<<p2_pushing_bit


standing_mask     = p1_standing|p2_standing
pushing_mask      = p1_pushing|p2_pushing

; ---------------------------------------------------------------------------
; The high word of d6 after a SolidObject call is a bitfield
; with the following meaning:
p1_touch_side_bit   = 0
p2_touch_side_bit   = p1_touch_side_bit + 1

p1_touch_side       = 1<<p1_touch_side_bit
p2_touch_side       = 1<<p2_touch_side_bit

touch_side_mask     = p1_touch_side|p2_touch_side

p1_touch_bottom_bit = p1_touch_side_bit + pushing_bit_delta
p2_touch_bottom_bit = p1_touch_bottom_bit + 1

p1_touch_bottom     = 1<<p1_touch_bottom_bit
p2_touch_bottom     = 1<<p2_touch_bottom_bit

touch_bottom_mask   = p1_touch_bottom|p2_touch_bottom

p1_touch_top_bit   = p1_touch_bottom_bit + pushing_bit_delta
p2_touch_top_bit   = p1_touch_top_bit + 1

p1_touch_top       = 1<<p1_touch_top_bit
p2_touch_top       = 1<<p2_touch_top_bit

touch_top_mask     = p1_touch_top|p2_touch_top

; ---------------------------------------------------------------------------
; Controller Buttons
;
; Buttons bit numbers
button_up:			EQU	0
button_down:			EQU	1
button_left:			EQU	2
button_right:			EQU	3
button_B:			EQU	4
button_C:			EQU	5
button_A:			EQU	6
button_start:			EQU	7
; Buttons masks (1 << x == pow(2, x))
button_up_mask:			EQU	1<<button_up	; $01
button_down_mask:		EQU	1<<button_down	; $02
button_left_mask:		EQU	1<<button_left	; $04
button_right_mask:		EQU	1<<button_right	; $08
button_B_mask:			EQU	1<<button_B	; $10
button_C_mask:			EQU	1<<button_C	; $20
button_A_mask:			EQU	1<<button_A	; $40
button_start_mask:		EQU	1<<button_start	; $80

; ---------------------------------------------------------------------------
; Casino night bumpers
bumper_id           = 0
bumper_x            = 2
bumper_y            = 4
next_bumper         = 6
prev_bumper_x       = bumper_x-next_bumper

; ---------------------------------------------------------------------------
; status_secondary bitfield variables
;
; status_secondary variable bit numbers
status_sec_hasShield:		EQU	0
status_sec_isInvincible:	EQU	1
status_sec_hasSpeedShoes:	EQU	2
status_sec_isSliding:		EQU	7
; status_secondary variable masks (1 << x == pow(2, x))
status_sec_hasShield_mask:	EQU	1<<status_sec_hasShield		; $01
status_sec_isInvincible_mask:	EQU	1<<status_sec_isInvincible	; $02
status_sec_hasSpeedShoes_mask:	EQU	1<<status_sec_hasSpeedShoes	; $04
status_sec_isSliding_mask:	EQU	1<<status_sec_isSliding		; $80

; ---------------------------------------------------------------------------
; Constants that can be used instead of hard-coded IDs for various things.
; The "id" function allows to remove elements from an array/table without having
; to change the IDs everywhere in the code.

cur_zone_id := 0 ; the zone ID currently being declared
cur_zone_str := "0" ; string representation of the above

; macro to declare a zone ID
; this macro also declares constants of the form zone_id_X, where X is the ID of the zone in stock Sonic 2
; in order to allow level offset tables to be made dynamic
zoneID macro zoneID,{INTLABEL}
__LABEL__ = zoneID
zone_id_{cur_zone_str} = zoneID
cur_zone_id := cur_zone_id+1
cur_zone_str := "\{cur_zone_id}"
    endm

; Zone IDs. These MUST be declared in the order in which their IDs are in stock Sonic 2, otherwise zone offset tables will screw up
emerald_hill_zone zoneID	$00
zone_1 zoneID			$01
wood_zone zoneID		$02
zone_3 zoneID			$03
metropolis_zone zoneID		$04
metropolis_zone_2 zoneID	$05
wing_fortress_zone zoneID	$06
hill_top_zone zoneID		$07
hidden_palace_zone zoneID	$08
zone_9 zoneID			$09
oil_ocean_zone zoneID		$0A
mystic_cave_zone zoneID		$0B
casino_night_zone zoneID	$0C
chemical_plant_zone zoneID	$0D
death_egg_zone zoneID		$0E
aquatic_ruin_zone zoneID	$0F
sky_chase_zone zoneID		$10

; NOTE: If you want to shift IDs around, set useFullWaterTables to 1 in the assembly options

; set the number of zones
no_of_zones = cur_zone_id

; Zone and act IDs
emerald_hill_zone_act_1 =	(emerald_hill_zone<<8)|$00
emerald_hill_zone_act_2 =	(emerald_hill_zone<<8)|$01
chemical_plant_zone_act_1 =	(chemical_plant_zone<<8)|$00
chemical_plant_zone_act_2 =	(chemical_plant_zone<<8)|$01
aquatic_ruin_zone_act_1 =	(aquatic_ruin_zone<<8)|$00
aquatic_ruin_zone_act_2 =	(aquatic_ruin_zone<<8)|$01
casino_night_zone_act_1 =	(casino_night_zone<<8)|$00
casino_night_zone_act_2 =	(casino_night_zone<<8)|$01
hill_top_zone_act_1 =		(hill_top_zone<<8)|$00
hill_top_zone_act_2 =		(hill_top_zone<<8)|$01
mystic_cave_zone_act_1 =	(mystic_cave_zone<<8)|$00
mystic_cave_zone_act_2 =	(mystic_cave_zone<<8)|$01
oil_ocean_zone_act_1 =		(oil_ocean_zone<<8)|$00
oil_ocean_zone_act_2 =		(oil_ocean_zone<<8)|$01
metropolis_zone_act_1 =		(metropolis_zone<<8)|$00
metropolis_zone_act_2 =		(metropolis_zone<<8)|$01
metropolis_zone_act_3 =		(metropolis_zone_2<<8)|$00
sky_chase_zone_act_1 =		(sky_chase_zone<<8)|$00
wing_fortress_zone_act_1 =	(wing_fortress_zone<<8)|$00
death_egg_zone_act_1 =		(death_egg_zone<<8)|$00
; Prototype zone and act IDs
wood_zone_act_1 =		(wood_zone<<8)|$00
wood_zone_act_2 =		(wood_zone<<8)|$01
hidden_palace_zone_act_1 =	(hidden_palace_zone<<8)|$00
hidden_palace_zone_act_2 =	(hidden_palace_zone<<8)|$01
level_select_special_stage = $4000
level_select_exit = $FFFF
; ---------------------------------------------------------------------------
; some variables and functions to help define those constants (redefined before a new set of IDs)
offset :=	0		; this is the start of the pointer table
ptrsize :=	1		; this is the size of a pointer (should be 1 if the ID is a multiple of the actual size)
idstart :=	0		; value to add to all IDs

; function using these variables
id function ptr,((ptr-offset)/ptrsize+idstart)

; V-Int routines
offset :=	Vint_SwitchTbl
ptrsize :=	1
idstart :=	0

VintID_Lag =		id(Vint_Lag_ptr) ; 0
VintID_SEGA =		id(Vint_SEGA_ptr) ; 2
VintID_Title =		id(Vint_Title_ptr) ; 4
VintID_Unused6 =	id(Vint_Unused6_ptr) ; 6
VintID_Level =		id(Vint_Level_ptr) ; 8
VintID_S2SS =		id(Vint_S2SS_ptr) ; A
VintID_TitleCard =	id(Vint_TitleCard_ptr) ; C
VintID_UnusedE =	id(Vint_UnusedE_ptr) ; E
VintID_Pause =		id(Vint_Pause_ptr) ; 10
VintID_Fade =		id(Vint_Fade_ptr) ; 12
VintID_PCM =		id(Vint_PCM_ptr) ; 14
VintID_Menu =		id(Vint_Menu_ptr) ; 16
VintID_Ending =		id(Vint_Ending_ptr) ; 18
VintID_CtrlDMA =	id(Vint_CtrlDMA_ptr) ; 1A
VintID_Savescreen =	id(Vint_Save_Screen)

; Game modes
offset :=	GameModesArray
ptrsize :=	1
idstart :=	0

GameModeID_SegaScreen =		id(GameMode_SegaScreen) ; 0
GameModeID_TitleScreen =	id(GameMode_TitleScreen) ; 4
GameModeID_Demo =		id(GameMode_Demo) ; 8
GameModeID_Level =		id(GameMode_Level) ; C
GameModeID_SpecialStage =	id(GameMode_SpecialStage) ; 10
GameModeID_ContinueScreen =	id(GameMode_ContinueScreen) ; 14
GameModeID_2PResults =		id(GameMode_2PResults) ; 18
GameModeID_2PLevelSelect =	id(GameMode_2PLevelSelect) ; 1C
GameModeID_EndingSequence =	id(GameMode_EndingSequence) ; 20
GameModeID_OptionsMenu =	id(GameMode_OptionsMenu) ; 24
GameModeID_LevelSelect =	id(GameMode_LevelSelect) ; 28
GameModeID_save_screen =	id(GameMode_save_screen)
GameModeFlag_TitleCard =	7 ; flag bit
GameModeID_TitleCard =		1<<GameModeFlag_TitleCard ; flag mask

; palette IDs
offset :=	PalPointers
ptrsize :=	8
idstart :=	0

PalID_SEGA =	id(PalPtr_SEGA) ; 0
PalID_Title =	id(PalPtr_Title) ; 1
PalID_MenuB =	id(PalPtr_MenuB) ; 2
PalID_BGND =	id(PalPtr_BGND) ; 3
PalID_EHZ =	id(PalPtr_EHZ) ; 4
PalID_EHZ2 =	id(PalPtr_EHZ2) ; 5
PalID_WZ =	id(PalPtr_WZ) ; 6
PalID_EHZ3 =	id(PalPtr_EHZ3) ; 7
PalID_MTZ =	id(PalPtr_MTZ) ; 8
PalID_MTZ2 =	id(PalPtr_MTZ2) ; 9
PalID_WFZ =	id(PalPtr_WFZ) ; A
PalID_HTZ =	id(PalPtr_HTZ) ; B
PalID_HPZ =	id(PalPtr_HPZ) ; C
PalID_EHZ4 =	id(PalPtr_EHZ4) ; D
PalID_OOZ =	id(PalPtr_OOZ) ; E
PalID_MCZ =	id(PalPtr_MCZ) ; F
PalID_CNZ =	id(PalPtr_CNZ) ; 10
PalID_CPZ =	id(PalPtr_CPZ) ; 11
PalID_DEZ =	id(PalPtr_DEZ) ; 12
PalID_ARZ =	id(PalPtr_ARZ) ; 13
PalID_SCZ =	id(PalPtr_SCZ) ; 14
PalID_HPZ_U =	id(PalPtr_HPZ_U) ; 15
PalID_CPZ_U =	id(PalPtr_CPZ_U) ; 16
PalID_ARZ_U =	id(PalPtr_ARZ_U) ; 17
PalID_SS =	id(PalPtr_SS) ; 18
PalID_MCZ_B =	id(PalPtr_MCZ_B) ; 19
PalID_CNZ_B =	id(PalPtr_CNZ_B) ; 1A
PalID_SS1 =	id(PalPtr_SS1) ; 1B
PalID_SS2 =	id(PalPtr_SS2) ; 1C
PalID_SS3 =	id(PalPtr_SS3) ; 1D
PalID_SS4 =	id(PalPtr_SS4) ; 1E
PalID_SS5 =	id(PalPtr_SS5) ; 1F
PalID_SS6 =	id(PalPtr_SS6) ; 20
PalID_SS7 =	id(PalPtr_SS7) ; 21
PalID_SS1_2p =	id(PalPtr_SS1_2p) ; 22
PalID_SS2_2p =	id(PalPtr_SS2_2p) ; 23
PalID_SS3_2p =	id(PalPtr_SS3_2p) ; 24
PalID_OOZ_B =	id(PalPtr_OOZ_B) ; 25
PalID_Menu =	id(PalPtr_Menu) ; 26
PalID_Result =	id(PalPtr_Result) ; 27

; PLC IDs
offset :=	ArtLoadCues
ptrsize :=	2
idstart :=	0

PLCID_Std1 =		id(PLCptr_Std1) ; 0
PLCID_Std2 =		id(PLCptr_Std2) ; 1
PLCID_StdWtr =		id(PLCptr_StdWtr) ; 2
PLCID_GameOver =	id(PLCptr_GameOver) ; 3
PLCID_Ehz1 =		id(PLCptr_Ehz1) ; 4
PLCID_Ehz2 =		id(PLCptr_Ehz2) ; 5
PLCID_Miles1up =	id(PLCptr_Miles1up) ; 6
PLCID_MilesLife =	id(PLCptr_MilesLife) ; 7
PLCID_Tails1up =	id(PLCptr_Tails1up) ; 8
PLCID_TailsLife =	id(PLCptr_TailsLife) ; 9
PLCID_Unused1 =		id(PLCptr_Unused1) ; A
PLCID_Unused2 =		id(PLCptr_Unused2) ; B
PLCID_Mtz1 =		id(PLCptr_Mtz1) ; C
PLCID_Mtz2 =		id(PLCptr_Mtz2) ; D
PLCID_Wfz1 =		id(PLCptr_Wfz1) ; 10
PLCID_Wfz2 =		id(PLCptr_Wfz2) ; 11
PLCID_Htz1 =		id(PLCptr_Htz1) ; 12
PLCID_Htz2 =		id(PLCptr_Htz2) ; 13
PLCID_Hpz1 =		id(PLCptr_Hpz1) ; 14
PLCID_Hpz2 =		id(PLCptr_Hpz2) ; 15
PLCID_Unused3 =		id(PLCptr_Unused3) ; 16
PLCID_Unused4 =		id(PLCptr_Unused4) ; 17
PLCID_Ooz1 =		id(PLCptr_Ooz1) ; 18
PLCID_Ooz2 =		id(PLCptr_Ooz2) ; 19
PLCID_Mcz1 =		id(PLCptr_Mcz1) ; 1A
PLCID_Mcz2 =		id(PLCptr_Mcz2) ; 1B
PLCID_Cnz1 =		id(PLCptr_Cnz1) ; 1C
PLCID_Cnz2 =		id(PLCptr_Cnz2) ; 1D
PLCID_Cpz1 =		id(PLCptr_Cpz1) ; 1E
PLCID_Cpz2 =		id(PLCptr_Cpz2) ; 1F
PLCID_Dez1 =		id(PLCptr_Dez1) ; 20
PLCID_Dez2 =		id(PLCptr_Dez2) ; 21
PLCID_Arz1 =		id(PLCptr_Arz1) ; 22
PLCID_Arz2 =		id(PLCptr_Arz2) ; 23
PLCID_Scz1 =		id(PLCptr_Scz1) ; 24
PLCID_Scz2 =		id(PLCptr_Scz2) ; 25
PLCID_Results =		id(PLCptr_Results) ; 26
PLCID_Signpost =	id(PLCptr_Signpost) ; 27
PLCID_CpzBoss =		id(PLCptr_CpzBoss) ; 28
PLCID_EhzBoss =		id(PLCptr_EhzBoss) ; 29
PLCID_HtzBoss =		id(PLCptr_HtzBoss) ; 2A
PLCID_ArzBoss =		id(PLCptr_ArzBoss) ; 2B
PLCID_MczBoss =		id(PLCptr_MczBoss) ; 2C
PLCID_CnzBoss =		id(PLCptr_CnzBoss) ; 2D
PLCID_MtzBoss =		id(PLCptr_MtzBoss) ; 2E
PLCID_OozBoss =		id(PLCptr_OozBoss) ; 2F
PLCID_FieryExplosion =	id(PLCptr_FieryExplosion) ; 30
PLCID_DezBoss =		id(PLCptr_DezBoss) ; 31
PLCID_EhzAnimals =	id(PLCptr_EhzAnimals) ; 32
PLCID_MczAnimals =	id(PLCptr_MczAnimals) ; 33
PLCID_HtzAnimals =	id(PLCptr_HtzAnimals) ; 34
PLCID_MtzAnimals =	id(PLCptr_MtzAnimals) ; 34
PLCID_WfzAnimals =	id(PLCptr_WfzAnimals) ; 34
PLCID_DezAnimals =	id(PLCptr_DezAnimals) ; 35
PLCID_HpzAnimals =	id(PLCptr_HpzAnimals) ; 36
PLCID_OozAnimals =	id(PLCptr_OozAnimals) ; 37
PLCID_SczAnimals =	id(PLCptr_SczAnimals) ; 38
PLCID_CnzAnimals =	id(PLCptr_CnzAnimals) ; 39
PLCID_CpzAnimals =	id(PLCptr_CpzAnimals) ; 3A
PLCID_ArzAnimals =	id(PLCptr_ArzAnimals) ; 3B
PLCID_SpecialStage =	id(PLCptr_SpecialStage) ; 3C
PLCID_SpecStageBombs =	id(PLCptr_SpecStageBombs) ; 3D
PLCID_WfzBoss =		id(PLCptr_WfzBoss) ; 3E
PLCID_Tornado =		id(PLCptr_Tornado) ; 3F
PLCID_Capsule =		id(PLCptr_Capsule) ; 40
PLCID_ResultsTails =	id(PLCptr_ResultsTails) ; 42

; Object IDs
offset :=	Obj_Index
ptrsize :=	4
idstart :=	1

ObjID_Sonic =			id(ObjPtr_Sonic)		; 01
ObjID_Tails =			id(ObjPtr_Tails)		; 02
ObjID_PlaneSwitcher =		id(ObjPtr_PlaneSwitcher)	; 03
ObjID_WaterSurface =		id(ObjPtr_WaterSurface)		; 04
ObjID_TailsTails =		id(ObjPtr_TailsTails)		; 05
ObjID_Spiral =			id(ObjPtr_Spiral)		; 06
ObjID_Oil =			id(ObjPtr_Oil)			; 07
ObjID_SpindashDust =		id(ObjPtr_SpindashDust)		; 08
ObjID_Splash =			id(ObjPtr_Splash)		; 08
ObjID_SonicSS =			id(ObjPtr_SonicSS)		; 09
ObjID_SmallBubbles =		id(ObjPtr_SmallBubbles)		; 0A
ObjID_TippingFloor =		id(ObjPtr_TippingFloor)		; 0B
ObjID_Signpost =		id(ObjPtr_Signpost)		; 0D
ObjID_IntroStars =		id(ObjPtr_IntroStars)		; 0E
ObjID_TitleMenu =		id(ObjPtr_TitleMenu)		; 0F
ObjID_TailsSS =			id(ObjPtr_TailsSS)		; 10
ObjID_Bridge =			id(ObjPtr_Bridge)		; 11
ObjID_HPZEmerald =		id(ObjPtr_HPZEmerald)		; 12
ObjID_HPZWaterfall =		id(ObjPtr_HPZWaterfall)		; 13
ObjID_Seesaw =			id(ObjPtr_Seesaw)		; 14
ObjID_SwingingPlatform =	id(ObjPtr_SwingingPlatform)	; 15
ObjID_HTZLift =			id(ObjPtr_HTZLift)		; 16
ObjID_ARZPlatform =		id(ObjPtr_ARZPlatform)		; 18
ObjID_EHZPlatform =		id(ObjPtr_EHZPlatform)		; 18
ObjID_CPZPlatform =		id(ObjPtr_CPZPlatform)		; 19
ObjID_OOZMovingPform =		id(ObjPtr_OOZMovingPform)	; 19
ObjID_WFZPlatform =		id(ObjPtr_WFZPlatform)		; 19
ObjID_HPZCollapsPform =		id(ObjPtr_HPZCollapsPform)	; 1A
ObjID_SpeedBooster =		id(ObjPtr_SpeedBooster)		; 1B
ObjID_Scenery =			id(ObjPtr_Scenery)		; 1C
ObjID_BridgeStake =		id(ObjPtr_BridgeStake)		; 1C
ObjID_FallingOil =		id(ObjPtr_FallingOil)		; 1C
ObjID_BlueBalls =		id(ObjPtr_BlueBalls)		; 1D
ObjID_CPZSpinTube =		id(ObjPtr_CPZSpinTube)		; 1E
ObjID_CollapsPform =		id(ObjPtr_CollapsPform)		; 1F
ObjID_LavaBubble =		id(ObjPtr_LavaBubble)		; 20
ObjID_HUD =			id(ObjPtr_HUD)			; 21
ObjID_ArrowShooter =		id(ObjPtr_ArrowShooter)		; 22
ObjID_FallingPillar =		id(ObjPtr_FallingPillar)	; 23
ObjID_ARZBubbles =		id(ObjPtr_ARZBubbles)		; 24
ObjID_Ring =			id(ObjPtr_Ring)			; 25
ObjID_Monitor =			id(ObjPtr_Monitor)		; 26
ObjID_Explosion =		id(ObjPtr_Explosion)		; 27
ObjID_Animal =			id(ObjPtr_Animal)		; 28
ObjID_Points =			id(ObjPtr_Points)		; 29
ObjID_Stomper =			id(ObjPtr_Stomper)		; 2A
ObjID_RisingPillar =		id(ObjPtr_RisingPillar)		; 2B
ObjID_LeavesGenerator =		id(ObjPtr_LeavesGenerator)	; 2C
ObjID_Barrier =			id(ObjPtr_Barrier)		; 2D
ObjID_MonitorContents =		id(ObjPtr_MonitorContents)	; 2E
ObjID_SmashableGround =		id(ObjPtr_SmashableGround)	; 2F
ObjID_RisingLava =		id(ObjPtr_RisingLava)		; 30
ObjID_LavaMarker =		id(ObjPtr_LavaMarker)		; 31
ObjID_BreakableBlock =		id(ObjPtr_BreakableBlock)	; 32
ObjID_BreakableRock =		id(ObjPtr_BreakableRock)	; 32
ObjID_OOZPoppingPform =		id(ObjPtr_OOZPoppingPform)	; 33
ObjID_TitleCard =		id(ObjPtr_TitleCard)		; 34
ObjID_InvStars =		id(ObjPtr_InvStars)		; 35
ObjID_Spikes =			id(ObjPtr_Spikes)		; 36
ObjID_LostRings =		id(ObjPtr_LostRings)		; 37
ObjID_Shield =			id(ObjPtr_Shield)		; 38
ObjID_GameOver =		id(ObjPtr_GameOver)		; 39
ObjID_TimeOver =		id(ObjPtr_TimeOver)		; 39
ObjID_Results =			id(ObjPtr_Results)		; 3A
ObjID_OOZLauncher =		id(ObjPtr_OOZLauncher)		; 3D
ObjID_EggPrison =		id(ObjPtr_EggPrison)		; 3E
ObjID_Fan =			id(ObjPtr_Fan)			; 3F
ObjID_Springboard =		id(ObjPtr_Springboard)		; 40
ObjID_Spring =			id(ObjPtr_Spring)		; 41
ObjID_SteamSpring =		id(ObjPtr_SteamSpring)		; 42
ObjID_SlidingSpike =		id(ObjPtr_SlidingSpike)		; 43
ObjID_RoundBumper =		id(ObjPtr_RoundBumper)		; 44
ObjID_OOZSpring =		id(ObjPtr_OOZSpring)		; 45
ObjID_OOZBall =			id(ObjPtr_OOZBall)		; 46
ObjID_Button =			id(ObjPtr_Button)		; 47
ObjID_LauncherBall =		id(ObjPtr_LauncherBall)		; 48
ObjID_EHZWaterfall =		id(ObjPtr_EHZWaterfall)		; 49
ObjID_Octus =			id(ObjPtr_Octus)		; 4A
ObjID_Buzzer =			id(ObjPtr_Buzzer)		; 4B
ObjID_Aquis =			id(ObjPtr_Aquis)		; 50
ObjID_CNZBoss =			id(ObjPtr_CNZBoss)		; 51
ObjID_HTZBoss =			id(ObjPtr_HTZBoss)		; 52
ObjID_MTZBossOrb =		id(ObjPtr_MTZBossOrb)		; 53
ObjID_MTZBoss =			id(ObjPtr_MTZBoss)		; 54
ObjID_OOZBoss =			id(ObjPtr_OOZBoss)		; 55
ObjID_EHZBoss =			id(ObjPtr_EHZBoss)		; 56
ObjID_MCZBoss =			id(ObjPtr_MCZBoss)		; 57
ObjID_BossExplosion =		id(ObjPtr_BossExplosion)	; 58
ObjID_SSEmerald =		id(ObjPtr_SSEmerald)		; 59
ObjID_SSMessage =		id(ObjPtr_SSMessage)		; 5A
ObjID_SSRingSpill =		id(ObjPtr_SSRingSpill)		; 5B
ObjID_Masher =			id(ObjPtr_Masher)		; 5C
ObjID_CPZBoss =			id(ObjPtr_CPZBoss)		; 5D
ObjID_SSHUD =			id(ObjPtr_SSHUD)		; 5E
ObjID_StartBanner =		id(ObjPtr_StartBanner)		; 5F
ObjID_EndingController =	id(ObjPtr_EndingController)	; 5F
ObjID_SSRing =			id(ObjPtr_SSRing)		; 60
ObjID_SSBomb =			id(ObjPtr_SSBomb)		; 61
ObjID_SSShadow =		id(ObjPtr_SSShadow)		; 63
ObjID_MTZTwinStompers =		id(ObjPtr_MTZTwinStompers)	; 64
ObjID_MTZLongPlatform =		id(ObjPtr_MTZLongPlatform)	; 65
ObjID_MTZSpringWall =		id(ObjPtr_MTZSpringWall)	; 66
ObjID_MTZSpinTube =		id(ObjPtr_MTZSpinTube)		; 67
ObjID_SpikyBlock =		id(ObjPtr_SpikyBlock)		; 68
ObjID_Nut =			id(ObjPtr_Nut)			; 69
ObjID_MCZRotPforms =		id(ObjPtr_MCZRotPforms)		; 6A
ObjID_MTZMovingPforms =		id(ObjPtr_MTZMovingPforms)	; 6A
ObjID_MTZPlatform =		id(ObjPtr_MTZPlatform)		; 6B
ObjID_CPZSquarePform =		id(ObjPtr_CPZSquarePform)	; 6B
ObjID_Conveyor =		id(ObjPtr_Conveyor)		; 6C
ObjID_FloorSpike =		id(ObjPtr_FloorSpike)		; 6D
ObjID_LargeRotPform =		id(ObjPtr_LargeRotPform)	; 6E
ObjID_SSResults =		id(ObjPtr_SSResults)		; 6F
ObjID_Cog =			id(ObjPtr_Cog)			; 70
ObjID_MTZLavaBubble =		id(ObjPtr_MTZLavaBubble)	; 71
ObjID_HPZBridgeStake =		id(ObjPtr_HPZBridgeStake)	; 71
ObjID_PulsingOrb =		id(ObjPtr_PulsingOrb)		; 71
ObjID_CNZConveyorBelt =		id(ObjPtr_CNZConveyorBelt)	; 72
ObjID_RotatingRings =		id(ObjPtr_RotatingRings)	; 73
ObjID_InvisibleBlock =		id(ObjPtr_InvisibleBlock)	; 74
ObjID_MCZBrick =		id(ObjPtr_MCZBrick)		; 75
ObjID_SlidingSpikes =		id(ObjPtr_SlidingSpikes)	; 76
ObjID_MCZBridge =		id(ObjPtr_MCZBridge)		; 77
ObjID_CPZStaircase =		id(ObjPtr_CPZStaircase)		; 78
ObjID_Starpost =		id(ObjPtr_Starpost)		; 79
ObjID_SidewaysPform =		id(ObjPtr_SidewaysPform)	; 7A
ObjID_PipeExitSpring =		id(ObjPtr_PipeExitSpring)	; 7B
ObjID_CPZPylon =		id(ObjPtr_CPZPylon)		; 7C
ObjID_SuperSonicStars =		id(ObjPtr_SuperSonicStars)	; 7E
ObjID_VineSwitch =		id(ObjPtr_VineSwitch)		; 7F
ObjID_MovingVine =		id(ObjPtr_MovingVine)		; 80
ObjID_MCZDrawbridge =		id(ObjPtr_MCZDrawbridge)	; 81
ObjID_SwingingPform =		id(ObjPtr_SwingingPform)	; 82
ObjID_ARZRotPforms =		id(ObjPtr_ARZRotPforms)		; 83
ObjID_ForcedSpin =		id(ObjPtr_ForcedSpin)		; 84
ObjID_PinballMode =		id(ObjPtr_PinballMode)		; 84
ObjID_LauncherSpring =		id(ObjPtr_LauncherSpring)	; 85
ObjID_Flipper =			id(ObjPtr_Flipper)		; 86
ObjID_SSNumberOfRings =		id(ObjPtr_SSNumberOfRings)	; 87
ObjID_SSTailsTails =		id(ObjPtr_SSTailsTails)		; 88
ObjID_ARZBoss =			id(ObjPtr_ARZBoss)		; 89
ObjID_WFZPalSwitcher =		id(ObjPtr_WFZPalSwitcher)	; 8B
ObjID_Whisp =			id(ObjPtr_Whisp)		; 8C
ObjID_GrounderInWall =		id(ObjPtr_GrounderInWall)	; 8D
ObjID_GrounderInWall2 =		id(ObjPtr_GrounderInWall2)	; 8E
ObjID_GrounderWall =		id(ObjPtr_GrounderWall)		; 8F
ObjID_GrounderRocks =		id(ObjPtr_GrounderRocks)	; 90
ObjID_ChopChop =		id(ObjPtr_ChopChop)		; 91
ObjID_Spiker =			id(ObjPtr_Spiker)		; 92
ObjID_SpikerDrill =		id(ObjPtr_SpikerDrill)		; 93
ObjID_Rexon =			id(ObjPtr_Rexon)		; 94
ObjID_Sol =			id(ObjPtr_Sol)			; 95
ObjID_Rexon2 =			id(ObjPtr_Rexon2)		; 96
ObjID_RexonHead =		id(ObjPtr_RexonHead)		; 97
ObjID_Projectile =		id(ObjPtr_Projectile)		; 98
ObjID_Nebula =			id(ObjPtr_Nebula)		; 99
ObjID_Turtloid =		id(ObjPtr_Turtloid)		; 9A
ObjID_TurtloidRider =		id(ObjPtr_TurtloidRider)	; 9B
ObjID_BalkiryJet =		id(ObjPtr_BalkiryJet)		; 9C
ObjID_Coconuts =		id(ObjPtr_Coconuts)		; 9D
ObjID_Crawlton =		id(ObjPtr_Crawlton)		; 9E
ObjID_Shellcracker =		id(ObjPtr_Shellcracker)		; 9F
ObjID_ShellcrackerClaw =	id(ObjPtr_ShellcrackerClaw)	; A0
ObjID_Slicer =			id(ObjPtr_Slicer)		; A1
ObjID_SlicerPincers =		id(ObjPtr_SlicerPincers)	; A2
ObjID_Flasher =			id(ObjPtr_Flasher)		; A3
ObjID_Asteron =			id(ObjPtr_Asteron)		; A4
ObjID_Spiny =			id(ObjPtr_Spiny)		; A5
ObjID_SpinyOnWall =		id(ObjPtr_SpinyOnWall)		; A6
ObjID_Grabber =			id(ObjPtr_Grabber)		; A7
ObjID_GrabberLegs =		id(ObjPtr_GrabberLegs)		; A8
ObjID_GrabberBox =		id(ObjPtr_GrabberBox)		; A9
ObjID_GrabberString =		id(ObjPtr_GrabberString)	; AA
ObjID_Balkiry =			id(ObjPtr_Balkiry)		; AC
ObjID_CluckerBase =		id(ObjPtr_CluckerBase)		; AD
ObjID_Clucker =			id(ObjPtr_Clucker)		; AE
ObjID_MechaSonic =		id(ObjPtr_MechaSonic)		; AF
ObjID_SonicOnSegaScr =	id(ObjPtr_SonicOnSegaScr)	; B0
ObjID_SegaHideTM =		id(ObjPtr_SegaHideTM)	; B1
ObjID_Tornado =			id(ObjPtr_Tornado)		; B2
ObjID_Cloud =			id(ObjPtr_Cloud)		; B3
ObjID_VPropeller =		id(ObjPtr_VPropeller)		; B4
ObjID_HPropeller =		id(ObjPtr_HPropeller)		; B5
ObjID_TiltingPlatform =		id(ObjPtr_TiltingPlatform)	; B6
ObjID_VerticalLaser =		id(ObjPtr_VerticalLaser)	; B7
ObjID_WallTurret =		id(ObjPtr_WallTurret)		; B8
ObjID_Laser =			id(ObjPtr_Laser)		; B9
ObjID_WFZWheel =		id(ObjPtr_WFZWheel)		; BA
ObjID_WFZShipFire =		id(ObjPtr_WFZShipFire)		; BC
ObjID_SmallMetalPform =		id(ObjPtr_SmallMetalPform)	; BD
ObjID_LateralCannon =		id(ObjPtr_LateralCannon)	; BE
ObjID_WFZStick =		id(ObjPtr_WFZStick)		; BF
ObjID_SpeedLauncher =		id(ObjPtr_SpeedLauncher)	; C0
ObjID_BreakablePlating =	id(ObjPtr_BreakablePlating)	; C1
ObjID_Rivet =			id(ObjPtr_Rivet)		; C2
ObjID_TornadoSmoke =		id(ObjPtr_TornadoSmoke)		; C3
ObjID_TornadoSmoke2 =		id(ObjPtr_TornadoSmoke2)	; C4
ObjID_WFZBoss =			id(ObjPtr_WFZBoss)		; C5
ObjID_Eggman =			id(ObjPtr_Eggman)		; C6
ObjID_Eggrobo =			id(ObjPtr_Eggrobo)		; C7
ObjID_Crawl =			id(ObjPtr_Crawl)		; C8
ObjID_TtlScrPalChanger =	id(ObjPtr_TtlScrPalChanger)	; C9
ObjID_CutScene =		id(ObjPtr_CutScene)		; CA
ObjID_EndingSeqClouds =		id(ObjPtr_EndingSeqClouds)	; CB
ObjID_EndingSeqTrigger =	id(ObjPtr_EndingSeqTrigger)	; CC
ObjID_EndingSeqBird =		id(ObjPtr_EndingSeqBird)	; CD
ObjID_EndingSeqSonic =		id(ObjPtr_EndingSeqSonic)	; CE
ObjID_EndingSeqTails =		id(ObjPtr_EndingSeqTails)	; CE
ObjID_TornadoHelixes =		id(ObjPtr_TornadoHelixes)	; CF
ObjID_CNZRectBlocks =		id(ObjPtr_CNZRectBlocks)	; D2
ObjID_BombPrize =		id(ObjPtr_BombPrize)		; D3
ObjID_CNZBigBlock =		id(ObjPtr_CNZBigBlock)		; D4
ObjID_Elevator =		id(ObjPtr_Elevator)		; D5
ObjID_PointPokey =		id(ObjPtr_PointPokey)		; D6
ObjID_Bumper =			id(ObjPtr_Bumper)		; D7
ObjID_BonusBlock =		id(ObjPtr_BonusBlock)		; D8
ObjID_Grab =			id(ObjPtr_Grab)			; D9
ObjID_ContinueText =		id(ObjPtr_ContinueText)		; DA
ObjID_ContinueIcons =		id(ObjPtr_ContinueIcons)	; DA
ObjID_ContinueChars =		id(ObjPtr_ContinueChars)	; DB
ObjID_RingPrize =		id(ObjPtr_RingPrize)		; DC

; Music IDs
offset :=	zMasterPlaylist
ptrsize :=	4
idstart :=	$01
; $80 is reserved for silence, so if you make idstart $80 or less,
; you may need to insert a dummy zMusIDPtr in the $80 slot

MusID__First = idstart
MusID_2PResult =	id(zMusIDPtr_2PResult)	; 81
MusID_EHZ =		id(zMusIDPtr_EHZ)	; 82
MusID_MCZ_2P =		id(zMusIDPtr_MCZ_2P)	; 83
MusID_OOZ =		id(zMusIDPtr_OOZ)	; 84
MusID_MTZ =		id(zMusIDPtr_MTZ)	; 85
MusID_HTZ =		id(zMusIDPtr_HTZ)	; 86
MusID_ARZ =		id(zMusIDPtr_ARZ)	; 87
MusID_CNZ_2P =		id(zMusIDPtr_CNZ_2P)	; 88
MusID_CNZ =		id(zMusIDPtr_CNZ)	; 89
MusID_DEZ =		id(zMusIDPtr_DEZ)	; 8A
MusID_MCZ =		id(zMusIDPtr_MCZ)	; 8B
MusID_EHZ_2P =		id(zMusIDPtr_EHZ_2P)	; 8C
MusID_SCZ =		id(zMusIDPtr_SCZ)	; 8D
MusID_CPZ =		id(zMusIDPtr_CPZ)	; 8E
MusID_WFZ =		id(zMusIDPtr_WFZ)	; 8F
MusID_HPZ =		id(zMusIDPtr_HPZ)	; 90
MusID_Options =		id(zMusIDPtr_Options)	; 91
MusID_SpecStage =	id(zMusIDPtr_SpecStage)	; 92
MusID_Boss =		id(zMusIDPtr_Boss)	; 93
MusID_EndBoss =		id(zMusIDPtr_EndBoss)	; 94
MusID_Ending =		id(zMusIDPtr_Ending)	; 95
MusID_SuperSonic =	id(zMusIDPtr_SuperSonic); 96
MusID_Invincible =	id(zMusIDPtr_Invincible); 97
MusID_ExtraLife =	id(zMusIDPtr_ExtraLife)	; 98
MusID_Title =		id(zMusIDPtr_Title)	; 99
MusID_EndLevel =	id(zMusIDPtr_EndLevel)	; 9A
MusID_GameOver =	id(zMusIDPtr_GameOver)	; 9B
MusID_Continue =	id(zMusIDPtr_Continue)	; 9C
MusID_Emerald =		id(zMusIDPtr_Emerald)	; 9D
MusID_Credits =		id(zMusIDPtr_Credits)	; 9E
MusID_Countdown =	id(zMusIDPtr_Countdown)	; 9F
MusID_SaveScreen =	id(zMusIDPtr_SaveScreen)	; 9F
MusID__End =		id(zMusIDPtr__End)	; A0
    if MOMPASS == 2
	if MusID__End > SndID__First
		fatal "You have too many SndPtrs. MusID__End ($\{MusID__End}) can't exceed SndID__First ($\{SndID__First})."
	endif
    endif

; Sound IDs
offset :=	SoundIndex
ptrsize :=	2
idstart :=	$A0
; $80 is reserved for silence, so if you make idstart $80 or less,
; you may need to insert a dummy SndPtr in the $80 slot

SndID__First = idstart
SndID_Jump =		id(SndPtr_Jump)			; A0
SndID_Checkpoint =	id(SndPtr_Checkpoint)		; A1
SndID_SpikeSwitch =	id(SndPtr_SpikeSwitch)		; A2
SndID_Hurt =		id(SndPtr_Hurt)			; A3
SndID_Skidding =	id(SndPtr_Skidding)		; A4
SndID_BlockPush =	id(SndPtr_BlockPush)		; A5
SndID_HurtBySpikes =	id(SndPtr_HurtBySpikes)		; A6
SndID_Sparkle =		id(SndPtr_Sparkle)		; A7
SndID_Beep =		id(SndPtr_Beep)			; A8
SndID_Bwoop =		id(SndPtr_Bwoop)		; A9
SndID_Splash =		id(SndPtr_Splash)		; AA
SndID_Swish =		id(SndPtr_Swish)		; AB
SndID_BossHit =		id(SndPtr_BossHit)		; AC
SndID_InhalingBubble =	id(SndPtr_InhalingBubble)	; AD
SndID_ArrowFiring =	id(SndPtr_ArrowFiring)		; AE
SndID_LavaBall =	id(SndPtr_LavaBall)		; AE
SndID_Shield =		id(SndPtr_Shield)		; AF
SndID_LaserBeam =	id(SndPtr_LaserBeam)		; B0
SndID_Zap =		id(SndPtr_Zap)			; B1
SndID_Drown =		id(SndPtr_Drown)		; B2
SndID_FireBurn =	id(SndPtr_FireBurn)		; B3
SndID_Bumper =		id(SndPtr_Bumper)		; B4
SndID_Ring =		id(SndPtr_Ring)			; B5
SndID_RingRight =	id(SndPtr_RingRight)		; B5
SndID_SpikesMove =	id(SndPtr_SpikesMove)		; B6
SndID_Rumbling =	id(SndPtr_Rumbling)		; B7
SndID_Fly =		id(SndPtr_Fly)		; B9
SndID_Smash =		id(SndPtr_Smash)		; B9
SndID_Tired =		id(SndPtr_Tired)		; B9
SndID_DoorSlam =	id(SndPtr_DoorSlam)		; BB
SndID_SpindashRelease =	id(SndPtr_SpindashRelease)	; BC
SndID_Hammer =		id(SndPtr_Hammer)		; BD
SndID_Roll =		id(SndPtr_Roll)			; BE
SndID_ContinueJingle =	id(SndPtr_ContinueJingle)	; BF
SndID_CasinoBonus =	id(SndPtr_CasinoBonus)		; C0
SndID_Explosion =	id(SndPtr_Explosion)		; C1
SndID_WaterWarning =	id(SndPtr_WaterWarning)		; C2
SndID_EnterGiantRing =	id(SndPtr_EnterGiantRing)	; C3
SndID_BossExplosion =	id(SndPtr_BossExplosion)	; C4
SndID_TallyEnd =	id(SndPtr_TallyEnd)		; C5
SndID_RingSpill =	id(SndPtr_RingSpill)		; C6
SndID_Flamethrower =	id(SndPtr_Flamethrower)		; C8
SndID_Bonus =		id(SndPtr_Bonus)		; C9
SndID_SpecStageEntry =	id(SndPtr_SpecStageEntry)	; CA
SndID_SlowSmash =	id(SndPtr_SlowSmash)		; CB
SndID_Spring =		id(SndPtr_Spring)		; CC
SndID_Blip =		id(SndPtr_Blip)			; CD
SndID_RingLeft =	id(SndPtr_RingLeft)		; CE
SndID_Signpost =	id(SndPtr_Signpost)		; CF
SndID_CNZBossZap =	id(SndPtr_CNZBossZap)		; D0
SndID_Signpost2P =	id(SndPtr_Signpost2P)		; D3
SndID_OOZLidPop =	id(SndPtr_OOZLidPop)		; D4
SndID_SlidingSpike =	id(SndPtr_SlidingSpike)		; D5
SndID_CNZElevator =	id(SndPtr_CNZElevator)		; D6
SndID_PlatformKnock =	id(SndPtr_PlatformKnock)	; D7
SndID_BonusBumper =	id(SndPtr_BonusBumper)		; D8
SndID_LargeBumper =	id(SndPtr_LargeBumper)		; D9
SndID_Gloop =		id(SndPtr_Gloop)		; DA
SndID_PreArrowFiring =	id(SndPtr_PreArrowFiring)	; DB
SndID_Fire =		id(SndPtr_Fire)			; DC
SndID_ArrowStick =	id(SndPtr_ArrowStick)		; DD
SndID_Helicopter =	id(SndPtr_Helicopter)		; DE
SndID_SuperTransform =	id(SndPtr_SuperTransform)	; DF
SndID_SpindashRev =	id(SndPtr_SpindashRev)		; E0
SndID_Rumbling2 =	id(SndPtr_Rumbling2)		; E1
SndID_CNZLaunch =	id(SndPtr_CNZLaunch)		; E2
SndID_Flipper =		id(SndPtr_Flipper)		; E3
SndID_HTZLiftClick =	id(SndPtr_HTZLiftClick)		; E4
SndID_Leaves =		id(SndPtr_Leaves)		; E5
SndID_MegaMackDrop =	id(SndPtr_MegaMackDrop)		; E6
SndID_DrawbridgeMove =	id(SndPtr_DrawbridgeMove)	; E7
SndID_QuickDoorSlam =	id(SndPtr_QuickDoorSlam)	; E8
SndID_DrawbridgeDown =	id(SndPtr_DrawbridgeDown)	; E9
SndID_LaserBurst =	id(SndPtr_LaserBurst)		; EA
SndID_Scatter =		id(SndPtr_Scatter)		; EB
SndID_LaserFloor =	id(SndPtr_LaserFloor)		; EB
SndID_Teleport =	id(SndPtr_Teleport)		; EC
SndID_Error =		id(SndPtr_Error)		; ED
SndID_MechaSonicBuzz =	id(SndPtr_MechaSonicBuzz)	; EE
SndID_LargeLaser =	id(SndPtr_LargeLaser)		; EF
SndID_OilSlide =	id(SndPtr_OilSlide)		; F0
SndID__End =		id(SndPtr__End)			; F1
    if MOMPASS == 2
	if SndID__End > CmdID__First
		fatal "You have too many SndPtrs. SndID__End ($\{SndID__End}) can't exceed CmdID__First ($\{CmdID__First})."
	endif
    endif
sfx_Switch = SndID_Blip
sfx_Starpost = SndID_Checkpoint 
sfx_Perfect = SndID_ContinueJingle
sfx_EnterSS = SndID_SpecStageEntry
sfx_SmallBumpers = SndID_Bumper
sfx_SlotMachine = SndID_CasinoBonus
; Sound command IDs
offset :=	zCommandIndex
ptrsize :=	4
idstart :=	$F8

CmdID__First = idstart
MusID_StopSFX =		id(CmdPtr_StopSFX)	; F8
MusID_FadeOut =		id(CmdPtr_FadeOut)	; F9
SndID_SegaSound =	id(CmdPtr_SegaSound)	; FA
MusID_SpeedUp =		id(CmdPtr_SpeedUp)	; FB
MusID_SlowDown =	id(CmdPtr_SlowDown)	; FC
MusID_Stop =		id(CmdPtr_Stop)		; FD
CmdID__End =		id(CmdPtr__End)		; FE

MusID_Pause =		$7F			; FE
MusID_Unpause =		$80			; FF

; 2P VS results screens
offset := TwoPlayerResultsPointers
ptrsize := 8
idstart := 0

VsRSID_Act =	id(VsResultsScreen_Act)		; 0
VsRSID_Zone =	id(VsResultsScreen_Zone)	; 1
VsRSID_Game =	id(VsResultsScreen_Game)	; 2
VsRSID_SS =	id(VsResultsScreen_SS)		; 3
VsRSID_SSZone =	id(VsResultsScreen_SSZone)	; 4

; Animation IDs
offset :=	SonicAniData
ptrsize :=	2
idstart :=	0

AniIDSonAni_Walk			= id(SonAni_Walk_ptr)			;  0 ;   0
AniIDSonAni_Run				= id(SonAni_Run_ptr)			;  1 ;   1
AniIDSonAni_Roll			= id(SonAni_Roll_ptr)			;  2 ;   2
AniIDSonAni_Roll2			= id(SonAni_Roll2_ptr)			;  3 ;   3
AniIDSonAni_Push			= id(SonAni_Push_ptr)			;  4 ;   4
AniIDSonAni_Wait			= id(SonAni_Wait_ptr)			;  5 ;   5
AniIDSonAni_Balance			= id(SonAni_Balance_ptr)		;  6 ;   6
AniIDSonAni_LookUp			= id(SonAni_LookUp_ptr)			;  7 ;   7
AniIDSonAni_Duck			= id(SonAni_Duck_ptr)			;  8 ;   8
AniIDSonAni_Spindash		= id(SonAni_Spindash_ptr)		;  9 ;   9
AniIDSonAni_Blink			= id(SonAni_Blink_ptr)			; 10 ;  $A
AniIDSonAni_GetUp			= id(SonAni_GetUp_ptr)			; 11 ;  $B
AniIDSonAni_Balance2		= id(SonAni_Balance2_ptr)		; 12 ;  $C
AniIDSonAni_Stop			= id(SonAni_Stop_ptr)			; 13 ;  $D
AniIDSonAni_Float			= id(SonAni_Float_ptr)			; 14 ;  $E
AniIDSonAni_Float2			= id(SonAni_Float2_ptr)			; 15 ;  $F
AniIDSonAni_Spring			= id(SonAni_Spring_ptr)			; 16 ; $10
AniIDSonAni_Hang			= id(SonAni_Hang_ptr)			; 17 ; $11
AniIDSonAni_Dash2			= id(SonAni_Dash2_ptr)			; 18 ; $12
AniIDSonAni_Dash3			= id(SonAni_Dash3_ptr)			; 19 ; $13
AniIDSonAni_Hang2			= id(SonAni_Hang2_ptr)			; 20 ; $14
AniIDSonAni_Bubble			= id(SonAni_Bubble_ptr)			; 21 ; $15
AniIDSonAni_DeathBW			= id(SonAni_DeathBW_ptr)		; 22 ; $16
AniIDSonAni_Drown			= id(SonAni_Drown_ptr)			; 23 ; $17
AniIDSonAni_Death			= id(SonAni_Death_ptr)			; 24 ; $18
AniIDSonAni_Hurt			= id(SonAni_Hurt_ptr)			; 25 ; $19
AniIDSonAni_Hurt2			= id(SonAni_Hurt2_ptr)			; 26 ; $1A
AniIDSonAni_Slide			= id(SonAni_Slide_ptr)			; 27 ; $1B
AniIDSonAni_Blank			= id(SonAni_Blank_ptr)			; 28 ; $1C
AniIDSonAni_Balance3		= id(SonAni_Balance3_ptr)		; 29 ; $1D
AniIDSonAni_Balance4		= id(SonAni_Balance4_ptr)		; 30 ; $1E
AniIDSupSonAni_Transform	= id(SupSonAni_Transform_ptr)	; 31 ; $1F
AniIDSonAni_Lying			= id(SonAni_Lying_ptr)			; 32 ; $20
AniIDSonAni_LieDown			= id(SonAni_LieDown_ptr)		; 33 ; $21


offset :=	TailsAniData
ptrsize :=	2
idstart :=	0

AniIDTailsAni_Walk			= id(TailsAni_Walk_ptr)			;  0 ;   0
AniIDTailsAni_Run			= id(TailsAni_Run_ptr)			;  1 ;   1
AniIDTailsAni_Roll			= id(TailsAni_Roll_ptr)			;  2 ;   2
AniIDTailsAni_Roll2			= id(TailsAni_Roll2_ptr)		;  3 ;   3
AniIDTailsAni_Push			= id(TailsAni_Push_ptr)			;  4 ;   4
AniIDTailsAni_Wait			= id(TailsAni_Wait_ptr)			;  5 ;   5
AniIDTailsAni_Balance		= id(TailsAni_Balance_ptr)		;  6 ;   6
AniIDTailsAni_LookUp		= id(TailsAni_LookUp_ptr)		;  7 ;   7
AniIDTailsAni_Duck			= id(TailsAni_Duck_ptr)			;  8 ;   8
AniIDTailsAni_Spindash		= id(TailsAni_Spindash_ptr)		;  9 ;   9
AniIDTailsAni_FlyCarryUp		= id(TailsAni_FlyCarryUp_ptr)		; 10 ;  $A
AniIDTailsAni_SwimTired		= id(TailsAni_SwimTired_ptr)		; 11 ;  $B
AniIDTailsAni_FlyCarry		= id(TailsAni_FlyCarry_ptr)		; 12 ;  $C
AniIDTailsAni_Stop			= id(TailsAni_Stop_ptr)			; 13 ;  $D
AniIDTailsAni_Float			= id(TailsAni_Float_ptr)		; 14 ;  $E
AniIDTailsAni_Float2		= id(TailsAni_Float2_ptr)		; 15 ;  $F
AniIDTailsAni_Spring		= id(TailsAni_Spring_ptr)		; 16 ; $10
AniIDTailsAni_Hang			= id(TailsAni_Hang_ptr)			; 17 ; $11
AniIDTailsAni_Blink			= id(TailsAni_Blink_ptr)		; 18 ; $12
AniIDTailsAni_Blink2		= id(TailsAni_Blink2_ptr)		; 19 ; $13
AniIDTailsAni_Hang2			= id(TailsAni_Hang2_ptr)		; 20 ; $14
AniIDTailsAni_Bubble		= id(TailsAni_Bubble_ptr)		; 21 ; $15
AniIDTailsAni_DeathBW		= id(TailsAni_DeathBW_ptr)		; 22 ; $16
AniIDTailsAni_Drown			= id(TailsAni_Drown_ptr)		; 23 ; $17
AniIDTailsAni_Death			= id(TailsAni_Death_ptr)		; 24 ; $18
AniIDTailsAni_Hurt			= id(TailsAni_Hurt_ptr)			; 25 ; $19
AniIDTailsAni_Hurt2			= id(TailsAni_Hurt2_ptr)		; 26 ; $1A
AniIDTailsAni_Slide			= id(TailsAni_Slide_ptr)		; 27 ; $1B
AniIDTailsAni_Blank			= id(TailsAni_Blank_ptr)		; 28 ; $1C
AniIDTailsAni_Swim		= id(TailsAni_Swim_ptr)		; 29 ; $1D
AniIDTailsAni_Tired		= id(TailsAni_Tired_ptr)		; 30 ; $1E
AniIDTailsAni_HaulAss		= id(TailsAni_HaulAss_ptr)		; 31 ; $1F
AniIDTailsAni_Fly			= id(TailsAni_Fly_ptr)			; 32 ; $20
AniIDTailsAni_Carry			= id(TailsAni_Carry_ptr)			; 32 ; $20

; Other sizes
palette_line_size =	$10*2	; 16 word entries
	include	"Variables.asm"
; ---------------------------------------------------------------------------
; VDP addressses
VDP_data_port =			$C00000 ; (8=r/w, 16=r/w)
VDP_control_port =		$C00004 ; (8=r/w, 16=r/w)
PSG_input =			$C00011

; ---------------------------------------------------------------------------
; Z80 addresses
Z80_RAM =			$A00000 ; start of Z80 RAM
Z80_RAM_End =			$A02000 ; end of non-reserved Z80 RAM
Z80_Bus_Request =		$A11100
Z80_Reset =			$A11200

Security_Addr =			$A14000
SRAM_access_flag =		$A130F1 ; 1 for saving something in s ram 0 is for no saving simple ?
General_SRAM =          $200011 ;$200011
Backup_SRAM =           $2000BD ;$2000BD
Game_SRAM =             $200281 ;$200281
Game_Backup_SRAM =      $20032D ;$20032D
Unk_SRAM =              $200169 ;$200169
Unk_SRAM_2 =            $2001F5 ;$2001F5
S3_SRAM_Data =          $FF0000
; ---------------------------------------------------------------------------
; I/O Area 
HW_Version =				$A10001
HW_Port_1_Data =			$A10003
HW_Port_2_Data =			$A10005
HW_Expansion_Data =			$A10007
HW_Port_1_Control =			$A10009
HW_Port_2_Control =			$A1000B
HW_Expansion_Control =		$A1000D
HW_Port_1_TxData =			$A1000F
HW_Port_1_RxData =			$A10011
HW_Port_1_SCtrl =			$A10013
HW_Port_2_TxData =			$A10015
HW_Port_2_RxData =			$A10017
HW_Port_2_SCtrl =			$A10019
HW_Expansion_TxData =		$A1001B
HW_Expansion_RxData =		$A1001D
HW_Expansion_SCtrl =		$A1001F

; ---------------------------------------------------------------------------
; Art tile stuff
flip_x              =      (1<<11)
flip_y              =      (1<<12)
palette_bit_0       =      5
palette_bit_1       =      6
palette_line_0      =      (0<<13)
palette_line_1      =      (1<<13)
palette_line_2      =      (2<<13)
palette_line_3      =      (3<<13)
high_priority_bit   =      7
high_priority       =      (1<<15)
palette_mask        =      $6000
tile_mask           =      $07FF
nontile_mask        =      $F800
drawing_mask        =      $7FFF

; ---------------------------------------------------------------------------
; VRAM and tile art base addresses.
; VRAM Reserved regions.
VRAM_Plane_A_Name_Table                  = $C000	; Extends until $CFFF
VRAM_Plane_B_Name_Table                  = $E000	; Extends until $EFFF
VRAM_Plane_A_Name_Table_2P               = $A000	; Extends until $AFFF
VRAM_Plane_B_Name_Table_2P               = $8000	; Extends until $8FFF
VRAM_Plane_Table_Size                    = $1000	; 64 cells x 32 cells x 2 bytes per cell
VRAM_Sprite_Attribute_Table              = $F800	; Extends until $FA7F
VRAM_Sprite_Attribute_Table_Size         = $0280	; 640 bytes
VRAM_Horiz_Scroll_Table                  = $FC00	; Extends until $FF7F
VRAM_Horiz_Scroll_Table_Size             = $0380	; 224 lines * 2 bytes per entry * 2 PNTs

; VRAM Reserved regions, Sega screen.
VRAM_SegaScr_Plane_A_Name_Table          = $C000	; Extends until $DFFF
VRAM_SegaScr_Plane_B_Name_Table          = $A000	; Extends until $BFFF
VRAM_SegaScr_Plane_Table_Size            = $2000	; 128 cells x 32 cells x 2 bytes per cell

; VRAM Reserved regions, Special Stage.
VRAM_SS_Plane_A_Name_Table1              = $C000	; Extends until $DFFF
VRAM_SS_Plane_A_Name_Table2              = $8000	; Extends until $9FFF
VRAM_SS_Plane_B_Name_Table               = $A000	; Extends until $BFFF
VRAM_SS_Plane_Table_Size                 = $2000	; 128 cells x 32 cells x 2 bytes per cell
VRAM_SS_Sprite_Attribute_Table           = $F800	; Extends until $FA7F
VRAM_SS_Sprite_Attribute_Table_Size      = $0280	; 640 bytes
VRAM_SS_Horiz_Scroll_Table               = $FC00	; Extends until $FF7F
VRAM_SS_Horiz_Scroll_Table_Size          = $0380	; 224 lines * 2 bytes per entry * 2 PNTs

; VRAM Reserved regions, Title screen.
VRAM_TtlScr_Plane_A_Name_Table           = $C000	; Extends until $CFFF
VRAM_TtlScr_Plane_B_Name_Table           = $E000	; Extends until $EFFF
VRAM_TtlScr_Plane_Table_Size             = $1000	; 64 cells x 32 cells x 2 bytes per cell

; VRAM Reserved regions, Ending sequence and credits.
VRAM_EndSeq_Plane_A_Name_Table           = $C000	; Extends until $DFFF
VRAM_EndSeq_Plane_B_Name_Table1          = $E000	; Extends until $EFFF (plane size is 64x32)
VRAM_EndSeq_Plane_B_Name_Table2          = $4000	; Extends until $5FFF
VRAM_EndSeq_Plane_Table_Size             = $2000	; 64 cells x 64 cells x 2 bytes per cell

; VRAM Reserved regions, menu screen.
VRAM_Menu_Plane_A_Name_Table             = $C000	; Extends until $CFFF
VRAM_Menu_Plane_B_Name_Table             = $E000	; Extends until $EFFF
VRAM_Menu_Plane_Table_Size               = $1000	; 64 cells x 32 cells x 2 bytes per cell

; From here on, art tiles are used; VRAM address is art tile * $20.
ArtTile_VRAM_Start                    = $0000

; Common to 1p and 2p menus.
ArtTile_ArtNem_FontStuff              = $0010

; Sega screen
ArtTile_ArtNem_Sega_Logo              = $0001
ArtTile_ArtNem_Trails                 = $0080
ArtTile_ArtUnc_Giant_Sonic            = $0088

; Title screen
ArtTile_ArtNem_Title                  = $0000
ArtTile_ArtNem_TitleSprites           = $0150
ArtTile_ArtNem_MenuJunk               = $03F2
ArtTile_ArtNem_Player1VS2             = $0402
ArtTile_ArtNem_CreditText             = $0500
ArtTile_ArtNem_FontStuff_TtlScr       = $0680

; Credits screen
ArtTile_ArtNem_CreditText_CredScr     = $0001

; Menu background.
ArtTile_ArtNem_MenuBox                = $0070

; Level select icons.
ArtTile_ArtNem_LevelSelectPics        = $0090

; 2p results screen.
ArtTile_ArtNem_1P2PWins               = $0070
ArtTile_ArtNem_SpecialPlayerVSPlayer  = $03DF
ArtTile_ArtNem_2p_Signpost            = $05E8
ArtTile_TwoPlayerResults              = $0600

; Special stage stuff.
ArtTile_ArtNem_SpecialEmerald         = $0174
ArtTile_ArtNem_SpecialMessages        = $01A2
ArtTile_ArtNem_SpecialHUD             = $01FA
ArtTile_ArtNem_SpecialFlatShadow      = $023C
ArtTile_ArtNem_SpecialDiagShadow      = $0262
ArtTile_ArtNem_SpecialSideShadow      = $029C
ArtTile_ArtNem_SpecialExplosion       = $02B5
ArtTile_ArtNem_SpecialSonic           = $02E5
ArtTile_ArtNem_SpecialTails           = $0300
ArtTile_ArtNem_SpecialTails_Tails     = $0316
ArtTile_ArtNem_SpecialRings           = $0322
ArtTile_ArtNem_SpecialStart           = $038A
ArtTile_ArtNem_SpecialBomb            = $038A
ArtTile_ArtNem_SpecialStageResults    = $0590
ArtTile_ArtNem_SpecialBack            = $0700
ArtTile_ArtNem_SpecialStars           = $077F
ArtTile_ArtNem_SpecialTailsText       = $07A4

; Ending.
ArtTile_EndingCharacter               = $0019
ArtTile_ArtNem_EndingFinalTornado     = $0156
ArtTile_ArtNem_EndingPics             = $0328
ArtTile_ArtNem_EndingMiniTornado      = $0493

; S1 Ending
ArtTile_ArtNem_S1EndFlicky            = $05A5
ArtTile_ArtNem_S1EndRabbit            = $0553
ArtTile_ArtNem_S1EndPenguin           = $0573
ArtTile_ArtNem_S1EndSeal              = $0585
ArtTile_ArtNem_S1EndPig               = $0593
ArtTile_ArtNem_S1EndChicken           = $0565
ArtTile_ArtNem_S1EndSquirrel          = $05B3

; Continue screen.
ArtTile_ArtNem_ContinueTails          = $0500
ArtTile_ArtNem_ContinueText           = $0500
ArtTile_ArtNem_ContinueText_2         = ArtTile_ArtNem_ContinueText + $24
ArtTile_ArtNem_MiniContinue           = $0524
ArtTile_ContinueScreen_Additional     = $0590
ArtTile_ContinueCountdown             = $06FC
; Save screen.
ArtTile_ArtKos_Save_Misc              = $029F
ArtTile_ArtKos_Save_Extra             = $0454
ArtTile_ArtKos_S3MenuBG               = $0001
; ---------------------------------------------------------------------------
; Level art stuff.
ArtTile_ArtKos_LevelArt               = $0000
ArtTile_ArtKos_NumTiles_EHZ           = $0393
ArtTile_ArtKos_NumTiles_CPZ           = $0364
ArtTile_ArtKos_NumTiles_ARZ           = $03F6
ArtTile_ArtKos_NumTiles_CNZ           = $0331
ArtTile_ArtKos_NumTiles_HTZ_Main      = $01FC ; Until this tile, equal to EHZ tiles.
ArtTile_ArtKos_NumTiles_HTZ_Sup       = $0183 ; Overwrites several EHZ tiles.
ArtTile_ArtKos_NumTiles_HTZ           = ArtTile_ArtKos_NumTiles_HTZ_Main + ArtTile_ArtKos_NumTiles_HTZ_Sup - 1
ArtTile_ArtKos_NumTiles_MCZ           = $03A9
ArtTile_ArtKos_NumTiles_OOZ           = $02AA
ArtTile_ArtKos_NumTiles_MTZ           = $0319
ArtTile_ArtKos_NumTiles_SCZ           = $036E
ArtTile_ArtKos_NumTiles_WFZ_Main      = $0307 ; Until this tile, equal to SCZ tiles.
ArtTile_ArtKos_NumTiles_WFZ_Sup       = $0073 ; Overwrites several SCZ tiles.
ArtTile_ArtKos_NumTiles_WFZ           = ArtTile_ArtKos_NumTiles_WFZ_Main + ArtTile_ArtKos_NumTiles_WFZ_Sup - 1
ArtTile_ArtKos_NumTiles_DEZ           = $0326 ; Skips several CPZ tiles.

; ---------------------------------------------------------------------------
; Shared badniks and objects.

; Objects that use the same art tiles on all levels in which
; they are loaded, even if not all levels load them.
ArtTile_ArtNem_WaterSurface           = $0400
ArtTile_ArtNem_Button                 = $0424
ArtTile_ArtNem_HorizSpike             = $042C
ArtTile_ArtNem_Spikes                 = $0434
ArtTile_ArtNem_DignlSprng             = $043C
ArtTile_ArtNem_LeverSpring            = $0440
ArtTile_ArtNem_VrtclSprng             = $045C
ArtTile_ArtNem_HrzntlSprng            = $0470

; EHZ, HTZ
ArtTile_ArtKos_Checkers               = ArtTile_ArtKos_LevelArt+$0158
ArtTile_ArtUnc_Flowers1               = $0394
ArtTile_ArtUnc_Flowers2               = $0396
ArtTile_ArtUnc_Flowers3               = $0398
ArtTile_ArtUnc_Flowers4               = $039A
ArtTile_ArtNem_Buzzer                 = $03D2

; WFZ, SCZ
ArtTile_ArtNem_WfzHrzntlPrpllr        = $03CD
ArtTile_ArtNem_Clouds                 = $054F
ArtTile_ArtNem_WfzVrtclPrpllr         = $0561
ArtTile_ArtNem_Balkrie                = $0565

; ---------------------------------------------------------------------------
; Level-specific objects and badniks.

; EHZ
ArtTile_ArtUnc_EHZPulseBall           = $039C
ArtTile_ArtNem_Waterfall              = $039E
ArtTile_ArtNem_EHZ_Bridge             = $03B6
ArtTile_ArtNem_Buzzer_Fireball        = $03BE	; Actually unused
ArtTile_ArtNem_Coconuts               = $03EE
ArtTile_ArtNem_Masher                 = $0414
ArtTile_ArtUnc_EHZMountains           = $0500

; MTZ
ArtTile_ArtNem_Shellcracker           = $031C
ArtTile_ArtUnc_Lava                   = $0340
ArtTile_ArtUnc_MTZCylinder            = $034C
ArtTile_ArtUnc_MTZAnimBack_1          = $035C
ArtTile_ArtUnc_MTZAnimBack_2          = $0362
ArtTile_ArtNem_MtzSupernova           = $0368
ArtTile_ArtNem_MtzWheel               = $0378
ArtTile_ArtNem_MtzWheelIndent         = $03F0
ArtTile_ArtNem_LavaCup                = $03F9
ArtTile_ArtNem_BoltEnd_Rope           = $03FD
ArtTile_ArtNem_MtzSteam               = $0405
ArtTile_ArtNem_MtzSpikeBlock          = $0414
ArtTile_ArtNem_MtzSpike               = $041C
ArtTile_ArtNem_MtzMantis              = $043C
ArtTile_ArtNem_MtzAsstBlocks          = $0500
ArtTile_ArtNem_MtzLavaBubble          = $0536
ArtTile_ArtNem_MtzCog                 = $055F
ArtTile_ArtNem_MtzSpinTubeFlash       = $056B

; WFZ
ArtTile_ArtNem_WfzScratch             = $0379
ArtTile_ArtNem_WfzTiltPlatforms       = $0393
ArtTile_ArtNem_WfzVrtclLazer          = $039F
ArtTile_ArtNem_WfzWallTurret          = $03AB
ArtTile_ArtNem_WfzHrzntlLazer         = $03C3
ArtTile_ArtNem_WfzConveyorBeltWheel   = $03EA
ArtTile_ArtNem_WfzHook                = $03FA
ArtTile_ArtNem_WfzHook_Fudge          = ArtTile_ArtNem_WfzHook + 4 ; Bad mappings...
ArtTile_ArtNem_WfzBeltPlatform        = $040E
ArtTile_ArtNem_WfzGunPlatform         = $041A
ArtTile_ArtNem_WfzUnusedBadnik        = $0450
ArtTile_ArtNem_WfzLaunchCatapult      = $045C
ArtTile_ArtNem_WfzSwitch              = $0461
ArtTile_ArtNem_WfzThrust              = $0465
ArtTile_ArtNem_WfzFloatingPlatform    = $046D
ArtTile_ArtNem_BreakPanels            = $048C

; SCZ
ArtTile_ArtNem_Turtloid               = $038A
ArtTile_ArtNem_Nebula                 = $036E

; HTZ
ArtTile_ArtNem_Rexon                  = $037E
ArtTile_ArtNem_HtzFireball1           = $039E
ArtTile_ArtNem_HtzRock                = $03B2
ArtTile_ArtNem_HtzSeeSaw              = $03C6
ArtTile_ArtNem_Sol                    = $03DE
ArtTile_ArtNem_HtzZipline             = $03E6
ArtTile_ArtNem_HtzFireball2           = $0416
ArtTile_ArtNem_HtzValveBarrier        = $0426
ArtTile_ArtUnc_HTZMountains           = $0500
ArtTile_ArtUnc_HTZClouds              = ArtTile_ArtUnc_HTZMountains + $18
ArtTile_ArtNem_Spiker                 = $0520

; OOZ
ArtTile_ArtUnc_OOZPulseBall           = $02B6
ArtTile_ArtUnc_OOZSquareBall1         = $02BA
ArtTile_ArtUnc_OOZSquareBall2         = $02BE
ArtTile_ArtUnc_Oil1                   = $02C2
ArtTile_ArtUnc_Oil2                   = $02D2
ArtTile_ArtNem_OOZBurn                = $02E2
ArtTile_ArtNem_OOZElevator            = $02F4
ArtTile_ArtNem_SpikyThing             = $030C
ArtTile_ArtNem_BurnerLid              = $032C
ArtTile_ArtNem_StripedBlocksVert      = $0332
ArtTile_ArtNem_Oilfall                = $0336
ArtTile_ArtNem_Oilfall2               = $0346
ArtTile_ArtNem_BallThing              = $0354
ArtTile_ArtNem_LaunchBall             = $0368
ArtTile_ArtNem_OOZPlatform            = $039D
ArtTile_ArtNem_PushSpring             = $03C5
ArtTile_ArtNem_OOZSwingPlat           = $03E3
ArtTile_ArtNem_StripedBlocksHoriz     = $03FF
ArtTile_ArtNem_OOZFanHoriz            = $0403
ArtTile_ArtNem_Aquis                  = $0500
ArtTile_ArtNem_Octus                  = $0538

; MCZ
ArtTile_ArtNem_Flasher                = $03A8
ArtTile_ArtNem_Crawlton               = $03C0
ArtTile_ArtNem_Crate                  = $03D4
ArtTile_ArtNem_MCZCollapsePlat        = $03F4
ArtTile_ArtNem_VineSwitch             = $040E
ArtTile_ArtNem_VinePulley             = $041E
ArtTile_ArtNem_MCZGateLog             = $043C

; CNZ
ArtTile_ArtNem_Crawl                  = $0340
ArtTile_ArtNem_BigMovingBlock         = $036C
ArtTile_ArtNem_CNZSnake               = $037C
ArtTile_ArtNem_CNZBonusSpike          = $0380
ArtTile_ArtNem_CNZElevator            = $0384
ArtTile_ArtNem_CNZCage                = $0388
ArtTile_ArtNem_CNZHexBumper           = $0394
ArtTile_ArtNem_CNZRoundBumper         = $039A
ArtTile_ArtNem_CNZFlipper             = $03B2
ArtTile_ArtNem_CNZMiniBumper          = $03E6
ArtTile_ArtNem_CNZDiagPlunger         = $0402
ArtTile_ArtNem_CNZVertPlunger         = $0422

; Specific to 1p CNZ
ArtTile_ArtUnc_CNZFlipTiles_1         = $0330
ArtTile_ArtUnc_CNZFlipTiles_2         = $0540
ArtTile_ArtUnc_CNZSlotPics_1          = $0550
ArtTile_ArtUnc_CNZSlotPics_2          = $0560
ArtTile_ArtUnc_CNZSlotPics_3          = $0570

; Specific to 2p CNZ
ArtTile_ArtUnc_CNZFlipTiles_1_2p      = $0330
ArtTile_ArtUnc_CNZFlipTiles_2_2p      = $0740
ArtTile_ArtUnc_CNZSlotPics_1_2p       = $0750
ArtTile_ArtUnc_CNZSlotPics_2_2p       = $0760
ArtTile_ArtUnc_CNZSlotPics_3_2p       = $0770

; CPZ
ArtTile_ArtUnc_CPZAnimBack            = $0370
ArtTile_ArtNem_CPZMetalThings         = $0373
ArtTile_ArtNem_ConstructionStripes_2  = $0394
ArtTile_ArtNem_CPZBooster             = $039C
ArtTile_ArtNem_CPZElevator            = $03A0
ArtTile_ArtNem_CPZAnimatedBits        = $03B0
ArtTile_ArtNem_CPZTubeSpring          = $03E0
ArtTile_ArtNem_CPZStairBlock          = $0418
ArtTile_ArtNem_CPZMetalBlock          = $0430
ArtTile_ArtNem_CPZDroplet             = $043C
ArtTile_ArtNem_Grabber                = $0500
ArtTile_ArtNem_Spiny                  = $052D

; DEZ
ArtTile_ArtUnc_DEZAnimBack            = $0326
ArtTile_ArtNem_ConstructionStripes_1  = $0328

; ARZ
ArtTile_ArtNem_ARZBarrierThing        = $03F8
ArtTile_ArtNem_Leaves                 = $0410
ArtTile_ArtNem_ArrowAndShooter        = $0417
ArtTile_ArtUnc_Waterfall3             = $0428
ArtTile_ArtUnc_Waterfall2             = $042C
ArtTile_ArtUnc_Waterfall1_1           = $0430
ArtTile_ArtNem_Whisp                  = $0500
ArtTile_ArtNem_Grounder               = $0509
ArtTile_ArtNem_ChopChop               = $053B
ArtTile_ArtUnc_Waterfall1_2           = $0557
ArtTile_ArtNem_BigBubbles             = $055B

; ---------------------------------------------------------------------------
; Bosses
; Common tiles for some bosses (any for which no eggpod tiles are defined,
; except for WFZ and DEZ bosses).
ArtTile_ArtNem_Eggpod_4               = $0500
; Common tiles for all bosses.
ArtTile_ArtNem_FieryExplosion         = $0580

; CPZ boss
ArtTile_ArtNem_EggpodJets_1           = $0418
ArtTile_ArtNem_Eggpod_3               = $0420
ArtTile_ArtNem_CPZBoss                = $0500
ArtTile_ArtNem_BossSmoke_1            = $0570

; EHZ boss
ArtTile_ArtNem_Eggpod_1               = $03A0
ArtTile_ArtNem_EHZBoss                = $0400
ArtTile_ArtNem_EggChoppers            = $056C

; HTZ boss
ArtTile_ArtNem_Eggpod_2               = $03C1
ArtTile_ArtNem_HTZBoss                = $0421
ArtTile_ArtNem_BossSmoke_2            = $05E4

; ARZ boss
ArtTile_ArtNem_ARZBoss                = $03E0

; MCZ boss
ArtTile_ArtNem_MCZBoss                = $03C0
ArtTile_ArtUnc_FallingRocks           = $0560

; CNZ boss
ArtTile_ArtNem_CNZBoss                = $0407
ArtTile_ArtNem_CNZBoss_Fudge          = ArtTile_ArtNem_CNZBoss - $60 ; Badly reused mappings...

; MTZ boss
ArtTile_ArtNem_MTZBoss                = $037C
ArtTile_ArtNem_EggpodJets_2           = $0560

; OOZ boss
ArtTile_ArtNem_OOZBoss                = $038C

; WFZ and DEZ
ArtTile_ArtNem_RobotnikUpper          = $0500
ArtTile_ArtNem_RobotnikRunning        = $0518
ArtTile_ArtNem_RobotnikLower          = $0564

; WFZ boss
ArtTile_ArtNem_WFZBoss                = $0379

; DEZ
ArtTile_ArtNem_DEZBoss                = $0330
ArtTile_ArtNem_DEZWindow              = $0378
ArtTile_ArtNem_SilverSonic            = $0380

; ---------------------------------------------------------------------------
; Universal locations.

; Animals.
ArtTile_ArtNem_Animal_1               = $0580
ArtTile_ArtNem_Animal_2               = $0594

; Game over.
ArtTile_ArtNem_Game_Over              = $04DE

; Titlecard.
ArtTile_ArtNem_TitleCard              = $0580
ArtTile_LevelName                     = $05DE

; End of level.
ArtTile_ArtNem_Signpost               = $0434
ArtTile_HUD_Bonus_Score               = $0520
ArtTile_ArtNem_Perfect                = $0540
ArtTile_ArtNem_ResultsText            = $05B0
ArtTile_ArtUnc_Signpost               = $05E8
ArtTile_ArtNem_MiniCharacter          = $05F4
ArtTile_ArtNem_Capsule                = $0680

; Tornado.
ArtTile_ArtNem_Tornado                = $0500
ArtTile_ArtNem_TornadoThruster        = $0561

; Some common objects; these are loaded on all aquatic levels.
ArtTile_ArtKosM_Explosion              = $05A4
ArtTile_ArtNem_Bubbles                = $05E8
ArtTile_ArtNem_SuperSonic_stars       = $05F2

; Universal (used on all standard levels).
ArtTile_ArtNem_Checkpoint             = $047C
ArtTile_ArtNem_TailsDust              = $048C
ArtTile_ArtNem_SonicDust              = $049C
ArtTile_ArtNem_Numbers                = $04AC
ArtTile_ArtUnc_Shield                 = $04BE
ArtTile_ArtUnc_Invincible_stars       = $0540
ArtTile_ArtNem_Powerups               = $0680
ArtTile_ArtUnc_Ring		      =	$06BC
ArtTile_ArtNem_Ring                   = ArtTile_ArtUnc_Ring
ArtTile_ArtNem_RingSparkle            = $06C6
ArtTile_ArtNem_HUD                    = ArtTile_ArtNem_Powerups + $4A
ArtTile_ArtUnc_Sonic                  = $0780
ArtTile_ArtUnc_Tails                  = $07A0
ArtTile_ArtUnc_Tails_Tails            = $07B0

; ---------------------------------------------------------------------------
; HUD. The HUD components are linked in a chain, and linked to
; power-ups, because the mappings of monitors and lives counter(s)
; depend on one another. If you want to alter these (for example,
; because you need the VRAM for something else), you will probably
; have to edit the mappings (or move the power-ups and HUD as a
; single block unit).
ArtTile_HUD_Score_E                   = ArtTile_ArtNem_HUD + $18
ArtTile_HUD_Score                     = ArtTile_HUD_Score_E + 2
ArtTile_HUD_Rings                     = ArtTile_ArtNem_HUD + $30
ArtTile_HUD_Minutes                   = ArtTile_ArtNem_HUD + $28
ArtTile_HUD_Seconds                   = ArtTile_HUD_Minutes + 4
ArtTile_ArtUnc_2p_life_counter        = ArtTile_ArtNem_HUD + $2A
ArtTile_ArtUnc_2p_life_counter_lives  = ArtTile_ArtUnc_2p_life_counter + 9
ArtTile_ArtNem_life_counter           = ArtTile_ArtNem_HUD + $10A
ArtTile_ArtNem_life_counter_lives     = ArtTile_ArtNem_life_counter + 9

; ---------------------------------------------------------------------------
; 2p-mode HUD.
ArtTile_Art_HUD_Text_2P               = ArtTile_ArtNem_HUD
ArtTile_Art_HUD_Numbers_2P            = ArtTile_HUD_Score_E

; ---------------------------------------------------------------------------
; Unused objects, objects with mappings never loaded, objects with
; missing mappings and/or tiles, objects whose mappings and/or tiles
; are never loaded.
ArtTile_ArtNem_MZ_Platform            = $02B8
ArtTile_ArtUnc_HPZPulseOrb_1          = $02E8
ArtTile_ArtUnc_HPZPulseOrb_2          = $02F0
ArtTile_ArtUnc_HPZPulseOrb_3          = $02F8
ArtTile_ArtNem_HPZ_Bridge             = $0300
ArtTile_ArtNem_HPZ_Waterfall          = $0315
ArtTile_ArtNem_HPZPlatform            = $034A
ArtTile_ArtNem_HPZOrb                 = $035A
ArtTile_ArtNem_HPZ_Emerald            = $0392
ArtTile_ArtNem_GHZ_Spiked_Log         = $0398
ArtTile_ArtNem_Unknown                = $03FA
ArtTile_ArtNem_BigRing                = $0400
ArtTile_ArtNem_FloatPlatform          = $0418
ArtTile_ArtNem_BigRing_Flash          = $0462
ArtTile_ArtNem_EndPoints              = $04B6
ArtTile_ArtNem_BreakWall              = $0590
ArtTile_ArtNem_GHZ_Purple_Rock        = $06C0

