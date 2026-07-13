
; ---------------------------------------------------------------------------
; I run the main 68k RAM addresses through this function
; to let them work in both 16-bit and 32-bit addressing modes.
ramaddr function x,(-(x&$80000000)<<1)|x

Sprite_table_buffer_2: =		ramaddr(   $FF7880 ) ; $280 bytes ; alternate sprite table for player 1 in competition mode
Sprite_table_buffer_P2: =	ramaddr(   $FF7B00 ) ; $280 bytes ; sprite table for player 2 in competition mode
Sprite_table_buffer_P2_2: =	ramaddr(   $FF7D80 ) ; $280 bytes ; alternate sprite table for player 2 in competition mode
; ---------------------------------------------------------------------------
; RAM variables - General
	phase	ramaddr($FFFF0000)	; Pretend we're in the RAM

RAM_start:
RAM_Start:

Chunk_Table:			ds.b	$8000	; was "Metablock_Table"
Chunk_Table_End:

Level_Layout:			ds.b	$1000
Level_Layout_End:

			ds.b	$1000 ; this is 80% is unused so go nuts but make sure S2 ss is fine when you do so it wont glitch out you can give it dynamic ram banks
CompressionBuffer:         ; in conquest this is used to decompress exploation art and sonic 3 save in here its used by CNZ and s3 save screen (its hardcoded here for somereason)
                        ds.b    $800
CompressionBuffer_End


TempArray_LayerDef:		ds.b	$200	; used by some layer deformation routines
Decomp_Buffer:			ds.b	$200

Sprite_Table_Input:		ds.b	$400	; in custom format before being converted and stored in Sprite_Table/Sprite_Table_2
Sprite_Table_Input_End:

Object_RAM:
Player_1:
MainCharacter:			; first object (usually Sonic except in a Tails Alone game)
				ds.b	object_size
Player_2:
Sidekick:			; second object (Tails in a Sonic and Tails game)
				ds.b	object_size
Reserved_object_3		ds.b object_size	; during a level, an object whose sole purpose is to clear the collision response list is stored here


Dynamic_object_RAM:
                  ds.b  object_size  ; ususally always used (during game loading and stuff)
                  ds.b  object_size
TitleCard:                  ds.b  object_size
TitleCard_ZoneName = TitleCard
TitleCard_Zone:             ds.b  object_size
TitleCard_ActNumber:            ds.b  object_size
TitleCard_Background:           ds.b  object_size
TitleCard_Bottom:               ds.b  object_size
TitleCard_Left:                 ds.b  object_size
Dynamic_Object_RAM:	        ds.b object_size*$52	; $1A04 bytes ; 90 objects
Dynamic_Object_RAM_End =	*
Level_object_RAM:             = Dynamic_Object_RAM_End	; $4EA bytes ; various fixed in-level objects
;--------------------------------------------------------------------------------------------
;RamVarables that were not reserved in s3k but their slots still exists






LevelOnly_Object_RAM:
Tails_Tails:			; address of the Tail's Tails object
				ds.b	object_size
SuperSonicStars:
				ds.b	object_size
Sonic_BreathingBubbles:		; Sonic's breathing bubbles
				ds.b	object_size
Tails_BreathingBubbles:		; Tails' breathing bubbles
				ds.b	object_size
Sonic_Dust:			; Sonic's spin dash dust
				ds.b	object_size
Tails_Dust:			; Tails' spin dash dust
				ds.b	object_size
Shield:
Sonic_Shield:
				ds.b	object_size
Tails_Shield:
				ds.b	object_size
Sonic_InvincibilityStars:
				ds.b	object_size
				ds.b	object_size
				ds.b	object_size
				ds.b	object_size
Tails_InvincibilityStars:
				ds.b	object_size
				ds.b	object_size
				ds.b	object_size
				ds.b	object_size
Wave_Splash:               	ds.b    object_size
LevelOnly_Object_RAM_End:

Object_RAM_End:
Kos_decomp_buffer:              ds.b    $1000 ; unused data from collsion stuff
Sprite_Table_2:                = Kos_decomp_buffer+$800 ; bc KosM doesnt get used in 2p mode
Kos_decomp_stored_registers	ds.w 20			; allows decompression to be spread over multiple frames
Kos_decomp_stored_SR		ds.w 1
Kos_decomp_queue		ds.l 2*4		; 2 longwords per entry, first is source location and second is decompression location
Kos_module_queue		ds.w 3*4		; 6 bytes per entry, first longword is source location and next word is VRAM destination
Kos_decomp_bookmark		ds.l 1
Kos_decomp_queue_count:         ds.w  1
Kos_decomp_destination =	Kos_decomp_queue+4
Kos_description_field		ds.w 1
Kos_last_module_size:           ds.w    1
Kos_module_destination:         ds.w  1
Kos_modules_left:               ds.b 1
Kos_decomp_buffer_END:
Tails_Carrying_Sonic_Flag:	ds.b  1
                      ds.w   1
                                ds.l	$1	; $FFFFE740-$FFFFE7FF ; unused as far as I can tell
DMA_queue:
VDP_Command_Buffer:		ds.w	7*$12	; stores 18 ($12) VDP commands to issue the next time ProcessDMAQueue is called
VDP_Command_Buffer_Slot:	ds.l	1	; stores the address of the next open slot for a queued VDP command
DMA_queue_slot:            = VDP_Command_Buffer_Slot

Horiz_Scroll_Buf:		ds.b	$380
Horiz_Scroll_Buf_End:
Sonic_Stat_Record_Buf:		ds.b	$100
Sonic_Pos_Record_Buf:		ds.b	$100
Tails_Pos_Record_Buf:		ds.b	$100
CNZ_saucer_data:		ds.b	$40	; the number of saucer bumpers in a group which have been destroyed. Used to decide when to give 500 points instead of 10
CNZ_saucer_data_End:
Ring_Positions:			ds.b	$600
Ring_Positions_End:
Ring_start_addr_ROM =		ramaddr( Ring_Positions+Rings_Space )
Ring_end_addr_ROM =			ramaddr( Ring_Positions+Rings_Space+4 )
Ring_start_addr_ROM_P2 =	ramaddr( Ring_Positions+Rings_Space+8 )
Ring_end_addr_ROM_P2 =		ramaddr( Ring_Positions+Rings_Space+12 )
Ring_free_RAM_start =		ramaddr( Ring_Positions+Rings_Space+16 )

Camera_RAM:
Camera_X_pos:			ds.l	1
Camera_Y_pos:			ds.l	1
Camera_BG_X_pos:		ds.l	1	; only used sometimes as the layer deformation makes it sort of redundant
Camera_BG_Y_pos:		ds.l	1
Camera_BG2_X_pos:		ds.l	1	; used in CPZ
Camera_BG2_Y_pos:		ds.l	1	; used in CPZ
Camera_BG3_X_pos:		ds.l	1	; unused (only initialised at beginning of level)?
Camera_BG3_Y_pos:		ds.l	1	; unused (only initialised at beginning of level)?
Camera_X_pos_P2:		ds.l	1
Camera_Y_pos_P2:		ds.l	1
Camera_BG_X_pos_P2:		ds.l	1	; only used sometimes as the layer deformation makes it sort of redundant
Camera_BG_Y_pos_P2:		ds.l	1
Camera_BG2_X_pos_P2:	ds.w	1	; unused (only initialised at beginning of level)?
				ds.w	1	; $FFFFEE32-$FFFFEE33 ; seems unused
Camera_BG2_Y_pos_P2:	ds.l	1
Camera_BG3_X_pos_P2:	ds.w	1	; unused (only initialised at beginning of level)?
LZ_Deform:				ds.w	1
Camera_BG3_Y_pos_P2:	ds.l	1
Horiz_block_crossed_flag:	ds.b	1	; toggles between 0 and $10 when you cross a block boundary horizontally
Verti_block_crossed_flag:	ds.b	1	; toggles between 0 and $10 when you cross a block boundary vertically
Horiz_block_crossed_flag_BG:	ds.b	1	; toggles between 0 and $10 when background camera crosses a block boundary horizontally
Verti_block_crossed_flag_BG:	ds.b	1	; toggles between 0 and $10 when background camera crosses a block boundary vertically
Horiz_block_crossed_flag_BG2:	ds.b	1	; used in CPZ
				ds.b	1	; $FFFFEE45 ; seems unused
Horiz_block_crossed_flag_BG3:	ds.b	1
				ds.b	1	; $FFFFEE47 ; seems unused
Horiz_block_crossed_flag_P2:	ds.b	1	; toggles between 0 and $10 when you cross a block boundary horizontally
Verti_block_crossed_flag_P2:	ds.b	1	; toggles between 0 and $10 when you cross a block boundary vertically
				ds.b	4	; $FFFFEE4A-$FFFFEE4D ; seems unused
Scroll_flags:			ds.w	1	; bitfield ; bit 0 = redraw top row, bit 1 = redraw bottom row, bit 2 = redraw left-most column, bit 3 = redraw right-most column
Scroll_flags_BG:		ds.w	1	; bitfield ; bits 0-3 as above, bit 4 = redraw top row (except leftmost block), bit 5 = redraw bottom row (except leftmost block), bits 6-7 = as bits 0-1
Scroll_flags_BG2:		ds.w	1	; bitfield ; essentially unused; bit 0 = redraw left-most column, bit 1 = redraw right-most column
Scroll_flags_BG3:		ds.w	1	; bitfield ; for CPZ; bits 0-3 as Scroll_flags_BG but using Y-dependent BG camera; bits 4-5 = bits 2-3; bits 6-7 = bits 2-3
Scroll_flags_P2:		ds.w	1	; bitfield ; bit 0 = redraw top row, bit 1 = redraw bottom row, bit 2 = redraw left-most column, bit 3 = redraw right-most column
Scroll_flags_BG_P2:		ds.w	1	; bitfield ; bits 0-3 as above, bit 4 = redraw top row (except leftmost block), bit 5 = redraw bottom row (except leftmost block), bits 6-7 = as bits 0-1
Scroll_flags_BG2_P2:	ds.w	1	; bitfield ; essentially unused; bit 0 = redraw left-most column, bit 1 = redraw right-most column
Scroll_flags_BG3_P2:	ds.w	1	; bitfield ; for CPZ; bits 0-3 as Scroll_flags_BG but using Y-dependent BG camera; bits 4-5 = bits 2-3; bits 6-7 = bits 2-3
Camera_RAM_copy:		ds.l	2	; copied over every V-int
Camera_BG_copy:			ds.l	2	; copied over every V-int
Camera_BG2_copy:		ds.l	2	; copied over every V-int
Camera_BG3_copy:		ds.l	2	; copied over every V-int
Camera_P2_copy:			ds.l	8	; copied over every V-int
Scroll_flags_copy:		ds.w	1	; copied over every V-int
Scroll_flags_BG_copy:		ds.w	1	; copied over every V-int
Scroll_flags_BG2_copy:		ds.w	1	; copied over every V-int
Scroll_flags_BG3_copy:		ds.w	1	; copied over every V-int
Scroll_flags_copy_P2:		ds.w	1	; copied over every V-int
Scroll_flags_BG_copy_P2:	ds.w	1	; copied over every V-int
Scroll_flags_BG2_copy_P2:	ds.w	1	; copied over every V-int
Scroll_flags_BG3_copy_P2:	ds.w	1	; copied over every V-int

Camera_X_pos_diff:		ds.w	1	; (new X pos - old X pos) * 256
Camera_Y_pos_diff:		ds.w	1	; (new Y pos - old Y pos) * 256
Camera_BG_X_pos_diff:	ds.w	1	; Effective camera change used in WFZ ending and HTZ screen shake
Camera_BG_Y_pos_diff:	ds.w	1	; Effective camera change used in WFZ ending and HTZ screen shake
Camera_X_pos_diff_P2:		ds.w	1	; (new X pos - old X pos) * 256
Camera_Y_pos_diff_P2:		ds.w	1	; (new Y pos - old Y pos) * 256
Screen_Shaking_Flag_HTZ:	ds.b	1	; activates screen shaking code in HTZ's layer deformation routine
Screen_Shaking_Flag:		ds.b	1	; activates screen shaking code (if existent) in layer deformation routine
Scroll_lock:			ds.b	1	; set to 1 to stop all scrolling for P1
Scroll_lock_P2:			ds.b	1	; set to 1 to stop all scrolling for P2
unk_EEC0:			ds.l	1	; unused, except on write in LevelSizeLoad...
unk_EEC4:			ds.w	1	; same as above. The write being a long also overwrites the address below
Camera_Max_Y_pos:		ds.w	1
Camera_Min_X_pos:		ds.w	1
Camera_Max_X_pos:		ds.w	1
Camera_Min_Y_pos:		ds.w	1
Camera_Max_Y_pos_now:		ds.w	1	; was "Camera_max_scroll_spd"...
Horiz_scroll_delay_val:		ds.w	1	; if its value is a, where a != 0, X scrolling will be based on the player's X position a-1 frames ago
Sonic_Pos_Record_Index:		ds.w	1	; into Sonic_Pos_Record_Buf and Sonic_Stat_Record_Buf
Horiz_scroll_delay_val_P2:	ds.w	1
Tails_Pos_Record_Index:		ds.w	1	; into Tails_Pos_Record_Buf
Camera_Y_pos_bias:		ds.w	1	; added to y position for lookup/lookdown, $60 is center
Camera_Y_pos_bias_P2:		ds.w	1	; for Tails
Deform_lock:			ds.b	1	; set to 1 to stop all deformation
				ds.b	1	; $FFFFEEDD ; seems unused
Camera_Max_Y_Pos_Changing:	ds.b	1
Dynamic_Resize_Routine:		ds.b	1
Target_camera_max_Y_pos:	ds.b	2	; $FFFFEEE0-$FFFFEEE1
Camera_BG_X_offset:		ds.w	1	; Used to control background scrolling in X in WFZ ending and HTZ screen shake
Camera_BG_Y_offset:		ds.w	1	; Used to control background scrolling in Y in WFZ ending and HTZ screen shake
HTZ_Terrain_Delay:		ds.w	1	; During HTZ screen shake, this is a delay between rising and sinking terrain during which there is no shaking
HTZ_Terrain_Direction:		ds.b	1	; During HTZ screen shake, 0 if terrain/lava is rising, 1 if lowering
				ds.b	3	; $FFFFEEE9-$FFFFEEEB ; seems unused
Vscroll_Factor_P2_HInt:	ds.l	1
Camera_X_pos_copy:		ds.l	1
Camera_Y_pos_copy:		ds.l	1
Tails_Min_X_pos:		ds.w	1
Tails_Max_X_pos:		ds.w	1
Tails_Min_Y_pos:		ds.w	1 ; seems not actually implemented (only written to)
Tails_Max_Y_pos:		ds.w	1
Camera_RAM_End:

Block_cache:			ds.b	$80
Ring_consumption_table:		ds.b	$80	; contains RAM addresses of rings currently being consumed
Ring_consumption_table_End:

Underwater_target_palette:		ds.b palette_line_size	; This is used by the screen-fading subroutines.
Underwater_target_palette_line2:	ds.b palette_line_size	; While Underwater_palette contains the blacked-out palette caused by the fading,
Underwater_target_palette_line3:	ds.b palette_line_size	; Underwater_target_palette will contain the palette the screen will ultimately fade in to.
Underwater_target_palette_line4:	ds.b palette_line_size

Underwater_palette:		ds.b palette_line_size	; main palette for underwater parts of the screen
Underwater_palette_line2:	ds.b palette_line_size
Underwater_palette_line3:	ds.b palette_line_size
Underwater_palette_line4:	ds.b palette_line_size

BlocksAddr:                                ds.l   1
             			ds.b	$454	; $FFFFF100-$FFFFF5FF ; unused, leftover from the Sonic 1 sound driver (and used by it when you port it to Sonic 2)
Competition_saved_data:         ds.b    $54     ; whatever you wanna use in compition mode
Saved_data                      ds.b    $54     ;data select
Game_mode:
Game_Mode:			ds.w	1	; 1 byte ; see GameModesArray (master level trigger, Mstr_Lvl_Trigger)
Ctrl_1_Logical:					; 2 bytes
Ctrl_1_Held_Logical:		ds.b	1	; 1 byte
Ctrl_1_Press_Logical:		ds.b	1	; 1 byte
Ctrl_1:						; 2 bytes
Ctrl_1_Held:			ds.b	1	; 1 byte ; (pressed and held were switched around before)
Ctrl_1_Press:			ds.b	1	; 1 byte
Ctrl_2:						; 2 bytes
Ctrl_2_Held:			ds.b	1	; 1 byte
Ctrl_2_Press:			ds.b	1	; 1 byte
Ctrl_1_logical =		Ctrl_1_Logical;*			; both held and pressed
Ctrl_1_held_logical =		Ctrl_1_Held_Logical
Ctrl_1_pressed_logical =	Ctrl_1_Press_Logical		; both held and pressed
Ctrl_1_held =			Ctrl_1_Held			; all held buttons
Ctrl_1_pressed =		Ctrl_1_Press			; buttons being pressed newly this frame			; both held and pressed
Ctrl_2_held =			Ctrl_2_Held
Ctrl_2_pressed =		Ctrl_2_Press
				ds.b	4	; $FFFFF608-$FFFFF60B ; seems unused
VDP_Reg1_val:			ds.w	1	; normal value of VDP register #1 when display is disabled
VDP_reg_1_command:              = VDP_Reg1_val
_unkEF44_1:				ds.l	1	; $FFFFF60E-$FFFFF613 ; seems unused
Slotted_object_bits:		ds.b    2
Demo_Time_left:			ds.w	1	; 2 bytes

Vscroll_Factor:
Vscroll_Factor_FG:			ds.w	1
Vscroll_Factor_BG:			ds.w	1
unk_F61A:			ds.l	1	; Only ever cleared, never used
Vscroll_Factor_P2:
Vscroll_Factor_P2_FG:		ds.w	1
Vscroll_Factor_P2_BG:		ds.w	1
Teleport_timer:			ds.b	1	; timer for teleport effect
Teleport_flag:			ds.b	1	; set when a teleport is in progress
Hint_counter_reserve:		ds.w	1	; Must contain a VDP command word, preferably a write to register $0A. Executed every V-INT.
Palette_fade_range:				; Range affected by the palette fading routines
Palette_fade_start:		ds.b	1	; Offset from the start of the palette to tell what range of the palette will be affected in the palette fading routines
Palette_fade_length:		ds.b	1	; Number of entries to change in the palette fading routines

MiscLevelVariables:
VIntSubE_RunCount:		ds.b	1
				ds.b	1	; $FFFFF629 ; seems unused
V_int_routine:
Vint_routine:			ds.b	1	; was "Delay_Time" ; routine counter for V-int
				ds.b	1	; $FFFFF62B ; seems unused
Sprites_drawn:
Sprite_count:			ds.b	1	; the number of sprites drawn in the current frame
                                ds.b    1
Spritemask_flag:                                ds.w    1
				ds.b	2	; $FFFFF62D-$FFFFF631 ; seems unused
PalCycle_Frame:			ds.w	1	; ColorID loaded in PalCycle
PalCycle_Timer:			ds.w	1	; number of frames until next PalCycle call
RNG_seed:			ds.l	1	; used for random number generation
Game_paused:			ds.w	1
Use_normal_sprite_table:	ds.l	1	; $FFFFF63C-$FFFFF63F ; seems unused
DMA_data_thunk:			ds.w	1	; Used as a RAM holder for the final DMA command word. Data will NOT be preserved across V-INTs, so consider this space reserved.
				ds.w	1	; $FFFFF642-$FFFFF643 ; seems unused
Hint_flag:			ds.w	1	; unless this is 1, H-int won't run

Water_Level_1:			ds.w	1
Water_Level_2:			ds.w	1
Water_Level_3:			ds.w	1
Water_on:			ds.b	1	; is set based on Water_flag
Water_routine:			ds.b	1
Water_fullscreen_flag:		ds.b	1	; was "Water_move"
Do_Updates_in_H_int:	ds.b	1

PalCycle_Frame_CNZ:		ds.w	1
PalCycle_Frame2:		ds.w	1
PalCycle_Frame3:		ds.w	1
PalCycle_Frame2_CNZ:	ds.w	1
Flying_carrying_Sonic_flag:	= Tails_Carrying_Sonic_Flag	; $FFFFF658-$FFFFF65B ; seems unused
Palette_frame:			ds.w	1
Palette_timer:			ds.b	1	; was "Palette_frame_count"
Super_Sonic_palette:		ds.b	1

DEZ_Eggman:						; Word
DEZ_Shake_Timer:				; Word
WFZ_LevEvent_Subrout:			; Word
SegaScr_PalDone_Flag:			; Byte (cleared once as a word)
Credits_Trigger:		ds.b	1	; cleared as a word a couple times
Ending_PalCycle_flag:	ds.b	1

SegaScr_VInt_Subrout:
Ending_VInt_Subrout:
WFZ_BG_Y_Speed:			ds.w	1
				ds.w	1	; $FFFFF664-$FFFFF665 ; seems unused
PalCycle_Timer2:		ds.w	1
PalCycle_Timer3:		ds.w	1

Ctrl_2_Logical:					; 2 bytes
Ctrl_2_Held_Logical:		ds.b	1	; 1 byte
Ctrl_2_Press_Logical:		ds.b	1	; 1 byte
Sonic_Look_delay_counter:	ds.w	1	; 2 bytes
Tails_Look_delay_counter:	ds.w	1	; 2 bytes
Super_Sonic_frame_count:	ds.w	1
Camera_ARZ_BG_X_pos:		ds.l	1
				ds.b	$A	; $FFFFF676-$FFFFF67F ; seems unused
MiscLevelVariables_End

Plc_Buffer:			ds.b	$60	; Pattern load queue (each entry is 6 bytes)
Plc_Buffer_Only_End:
				; these seem to store nemesis decompression state so PLC processing can be spread out across frames
Plc_Buffer_Reg0:		ds.l	1
Plc_Buffer_Reg4:		ds.l	1
Plc_Buffer_Reg8:		ds.l	1
Plc_Buffer_RegC:		ds.l	1
Plc_Buffer_Reg10:		ds.l	1
Plc_Buffer_Reg14:		ds.l	1
Plc_Buffer_Reg18:		ds.w	1	; amount of current entry remaining to decompress
Plc_Buffer_Reg1A:		ds.w	1
				ds.b	4	; seems unused
Plc_Buffer_End:


Misc_Variables:
Flying_x_vel_unk:			ds.w	1	; unused

; extra variables for the second player (CPU) in 1-player mode
Tails_control_counter:		ds.w	1	; how long until the CPU takes control
Tails_respawn_counter:		ds.w	1
Flying_y_vel_unk:			ds.w	1	; unused
Tails_CPU_routine:		ds.w	1
Tails_CPU_target_x:		ds.w	1
Tails_CPU_target_y:		ds.w	1
Tails_interact_ID:		ds.b	1	; object ID of last object stood on
Tails_CPU_jumping:		ds.b	1
Level_started_flag:		ds.b	1

Rings_manager_routine:		ds.b	1
Ring_start_addr_RAM:		ds.w	1
Ring_start_addr_RAM_P2:	ds.w	1
						ds.w	2	; 2 words freed here

CNZ_Bumper_routine:		ds.b	1
CNZ_Bumper_UnkFlag:		ds.b	1	; Set only, never used again
CNZ_Visible_bumpers_start:			ds.l	1
CNZ_Visible_bumpers_end:			ds.l	1
CNZ_Visible_bumpers_start_P2:			ds.l	1
CNZ_Visible_bumpers_end_P2:			ds.l	1

Screen_redraw_flag:			ds.b	1	; if whole screen needs to redraw, such as when you destroy that piston before the boss in WFZ
CPZ_UnkScroll_Timer:	ds.b	1	; Used only in unused CPZ scrolling function
WFZ_SCZ_Fire_Toggle:	ds.b	1
				ds.b	1	; $FFFFF72F ; seems unused
Water_flag:			ds.b	1	; if the level has water or oil
				ds.b	1	; $FFFFF731 ; seems unused
Demo_button_index_2P:		ds.w	1	; index into button press demo data, for player 2
Demo_press_counter_2P:		ds.w	1	; frames remaining until next button press, for player 2
Tornado_Velocity_X:		ds.w	1	; speed of tails' plane in scz ($FFFFF736)
Tornado_Velocity_Y:		ds.w	1
			ds.l	1	; $FFFFF73A-$FFFFF73D
ScreenShift:			ds.b	1
Boss_CollisionRoutine:		ds.b	1
Boss_AnimationArray:		ds.b	$10	; up to $10 bytes; 2 bytes per entry
Ending_Routine:
Boss_X_pos:			ds.w	1
				ds.w	1	; Boss_MoveObject reads a long, but all other places in the game use only the high word
Boss_Y_pos:			ds.w	1
				ds.w	1	; same here
Boss_X_vel:			ds.w	1
Boss_Y_vel:			ds.w	1
Boss_Countdown:		ds.w	1
				ds.w	1	; $FFFFF75E-$FFFFF75F ; unused

Sonic_top_speed:		ds.w	1
Sonic_acceleration:		ds.w	1
Sonic_deceleration:		ds.w	1
Sonic_LastLoadedDPLC:		ds.b	1	; mapping frame number when Sonic last had his tiles requested to be transferred from ROM to VRAM. can be set to a dummy value like -1 to force a refresh DMA. was: Sonic_mapping_frame
				ds.b	1	; $FFFFF767 ; seems unused
Primary_Angle:		ds.b	1
				ds.b	1	; $FFFFF769 ; seems unused
Secondary_Angle:	ds.b	1
				ds.b	1	; $FFFFF76B ; seems unused
Obj_placement_routine:		ds.b	1
				ds.b	1	; $FFFFF76D ; seems unused
Camera_X_pos_last:		ds.w	1	; Camera_X_pos_coarse from the previous frame

Obj_load_addr_right:		ds.l	1	; contains the address of the next object to load when moving right
Obj_load_addr_left:		ds.l	1	; contains the address of the last object loaded when moving left
Obj_load_addr_2:		ds.l	1
Obj_load_addr_3:		ds.l	1
unk_F780:			ds.b	6	; seems to be an array of horizontal chunk positions, used for object position range checks
unk_F786:			ds.b	3
unk_F789:			ds.b	3
Camera_X_pos_last_P2:		ds.w	1
Obj_respawn_index_P2:		ds.b	2	; respawn table indices of the next objects when moving left or right for the second player

Demo_button_index:		ds.w	1	; index into button press demo data, for player 1
Demo_press_counter:		ds.b	1	; frames remaining until next button press, for player 1
Emeralds_converted_flag:	ds.b	1
PalChangeSpeed:			ds.w	1
Collision_addr:			ds.l	1
				ds.b	$4	; $FFFFF79A-$FFFFF7A6 ; seems unused
LastD0ObjManager:		ds.w    1
Calcword:			ds.w    1
Obj_index_Addr_Loc:			ds.l    1
                                ds.b    1
Boss_defeated_flag:		ds.b	1
Screen_Y_wrap_value:		ds.w	1	; $FFFFF7A8-$FFFFF7A9 ; seems unused
Current_Boss_ID:		ds.b	1
Super_emerald_count:            ds.b    1
Collected_special_ring_array:	ds.l	1	; $FFFFF7AB-$FFFFF7AF ; seems unused
MTZ_Platform_Cog_X:			ds.w	1	; X position of moving MTZ platform for cog animation.
MTZCylinder_Angle_Sonic:	ds.b	1
MTZCylinder_Angle_Tails:	ds.b	1
				ds.b	$A	; $FFFFF7B4-$FFFFF7BD ; seems unused
BigRingGraphics:	ds.w	1	; S1 holdover
				ds.b	7	; $FFFFF7C0-$FFFFF7C6 ; seems unused
WindTunnel_flag:		ds.b	1
				ds.b	1	; $FFFFF7C8 ; seems unused
WindTunnel_holding_flag:			ds.b	1
				ds.b	2	; $FFFFF7CA-$FFFFF7CB ; seems unused
Control_Locked:			ds.b	1
SpecialStage_flag_2P:			ds.b	1
				ds.b	1	; $FFFFF7CE ; seems unused
Control_Locked_P2:		ds.b	1
Chain_Bonus_counter:		ds.w	1	; counts up when you destroy things that give points, resets when you touch the ground
Bonus_Countdown_1:		ds.w	1	; level results time bonus or special stage sonic ring bonus
Bonus_Countdown_2:		ds.w	1	; level results ring bonus or special stage tails ring bonus
Update_Bonus_score:		ds.b	1
				ds.b	3	; $FFFFF7D7-$FFFFF7D9 ; seems unused
Camera_X_pos_coarse:		ds.w	1	; (Camera_X_pos - 128) / 256
Camera_X_pos_coarse_P2:		ds.w	1
Tails_LastLoadedDPLC:		ds.b	1	; mapping frame number when Tails last had his tiles requested to be transferred from ROM to VRAM. can be set to a dummy value like -1 to force a refresh DMA.
TailsTails_LastLoadedDPLC:	ds.b	1	; mapping frame number when Tails' tails last had their tiles requested to be transferred from ROM to VRAM. can be set to a dummy value like -1 to force a refresh DMA.
ButtonVine_Trigger:		ds.b	$10	; 16 bytes flag array, #subtype byte set when button/vine of respective subtype activated
Anim_Counters:			ds.b	$10	; $FFFFF7F0-$FFFFF7FF
Misc_Variables_End:

Sprite_Table:			ds.b	$280	; Sprite attribute table buffer
Sprite_Table_End:
				ds.b	$80	; unused, but SAT buffer can spill over into this area when there are too many sprites on-screen

Normal_palette:			ds.b	palette_line_size	; main palette for non-underwater parts of the screen
Normal_palette_line2:		ds.b	palette_line_size
Normal_palette_line3:		ds.b	palette_line_size
Normal_palette_line4:		ds.b	palette_line_size
Normal_palette_End:

Target_palette:			ds.b	palette_line_size	; This is used by the screen-fading subroutines.
Target_palette_line2:		ds.b	palette_line_size	; While Normal_palette contains the blacked-out palette caused by the fading,
Target_palette_line3:		ds.b	palette_line_size	; Target_palette will contain the palette the screen will ultimately fade in to.
Target_palette_line4:		ds.b	palette_line_size
Target_palette_End:

Object_Respawn_Table:
Obj_respawn_index:		ds.b	2		; respawn table indices of the next objects when moving left or right for the first player
Obj_respawn_data:		ds.b	$100	; Maximum possible number of respawn entries that S2 can handle; for stock S2, $80 is enough
Obj_respawn_data_End:
				ds.b	$FE	; Stack; the first $7E bytes are cleared by ObjectsManager_Init, with possibly disastrous consequences. At least $A0 bytes are needed.
System_Stack:

SS_2p_Flag:				ds.w	1	; $FFFFFE00-$FFFFFE01 ; seems unused
Level_Inactive_flag:		ds.w	1	; (2 bytes)
Timer_frames:			ds.w	1	; (2 bytes)
Level_frame_counter:                   = Timer_frames
Debug_object:			ds.b	1
				ds.b	1	; $FFFFFE07 ; seems unused
Debug_placement_mode:		ds.b	1
				ds.b	1	; the whole word is tested, but the debug mode code uses only the low byte
Debug_Accel_Timer:	ds.b	1
Debug_Speed:		ds.b	1
Vint_runcount:			ds.l	1

Current_zone_and_act:
Current_ZoneAndAct:				; 2 bytes
Current_Zone:			ds.b	1	; 1 byte
Current_Act:			ds.b	1	; 1 byte
Life_count:			ds.b	1
				ds.b	3	; $FFFFFE13-$FFFFFE15 ; seems unused

Current_Special_StageAndAct:	; 2 bytes
Current_special_stage:
Current_Special_Stage:		ds.b	1
Current_Special_Act:		ds.b	1
Continue_count:			ds.b	1
Super_Sonic_flag:		ds.b	1
Time_Over_flag:			ds.b	1
Extra_life_flags:		ds.b	1

; If set, the respective HUD element will be updated.
Update_HUD_lives:		ds.b	1
Update_HUD_rings:		ds.b	1
Update_HUD_timer:		ds.b	1
Update_HUD_score:		ds.b	1

Ring_count:			ds.w	1	; 2 bytes
Timer:						; 4 bytes
Timer_minute_word:				; 2 bytes
				ds.b	1	; filler
Timer_minute:			ds.b	1	; 1 byte
Timer_second:			ds.b	1	; 1 byte
Timer_centisecond:				; inaccurate name (the seconds increase when this reaches 60)
Timer_frame:			ds.b	1	; 1 byte

Score:				ds.l	1	; 4 bytes
				ds.b	6	; $FFFFFE2A-$FFFFFE2F ; seems unused
Last_star_pole_hit:		ds.b	1	; 1 byte -- max activated starpole ID in this act
Saved_Last_star_pole_hit:	ds.b	1
Saved_x_pos:			ds.w	1
Saved_y_pos:			ds.w	1
Saved_Ring_count:		ds.w	1
Saved_Timer:			ds.l	1
Saved_art_tile:			ds.w	1
Saved_Solid_bits:			ds.w	1
Saved_Camera_X_pos:		ds.w	1
Saved_Camera_Y_pos:		ds.w	1
Saved_Camera_BG_X_pos:		ds.w	1
Saved_Camera_BG_Y_pos:		ds.w	1
Saved_Camera_BG2_X_pos:		ds.w	1
Saved_Camera_BG2_Y_pos:		ds.w	1
Saved_Camera_BG3_X_pos:		ds.w	1
Saved_Camera_BG3_Y_pos:		ds.w	1
Saved_Water_Level:		ds.w	1
Saved_Water_routine:		ds.b	1
Saved_Water_move:		ds.b	1
Saved_Extra_life_flags:		ds.b	1
Saved_Extra_life_flags_2P:	ds.b	1	; stored, but never restored
Saved_Camera_Max_Y_pos:		ds.w	1
Saved_Dynamic_Resize_Routine:	ds.b	1

				ds.b	5	; $FFFFFE59-$FFFFFE5D ; seems unused
Oscillating_Numbers:
Oscillation_Control:			ds.w	1
Oscillating_variables:
Oscillating_Data:				ds.w	$20
Oscillating_Numbers_End

Logspike_anim_counter:		ds.b	1
Logspike_anim_frame:		ds.b	1
Rings_anim_counter:		ds.b	1
Rings_anim_frame:		ds.b	1
Unknown_anim_counter:		ds.b	1	; I think this was $FFFFFEC4 in the alpha
Unknown_anim_frame:		ds.b	1
Ring_spill_anim_counter:	ds.b	1	; scattered rings
Ring_spill_anim_frame:		ds.b	1
Ring_spill_anim_accum:		ds.w	1
				ds.b	6	; $FFFFFEA9-$FFFFFEAF ; seems unused, but cleared once
Oscillating_variables_End
Save_pointer:				   ds.l    1
                               ds.b    3    ; $FFFFFEB0-$FFFFFEBF ; seems unused
        ds.b    1
               ds.b    1
                ds.b     1
             ds.l     1
                                ds.b    1
                                ds.b     1
; values for the second player (some of these only apply to 2-player games)
Tails_top_speed:		ds.w	1	; Tails_max_vel
Tails_acceleration:		ds.w	1
Tails_deceleration:		ds.w	1
Life_count_2P:			ds.b	1
Extra_life_flags_2P:		ds.b	1
Update_HUD_lives_2P:		ds.b	1
Update_HUD_rings_2P:		ds.b	1
Update_HUD_timer_2P:		ds.b	1
Update_HUD_score_2P:		ds.b	1	; mostly unused
Time_Over_flag_2P:		ds.b	1
				ds.b	3	; $FFFFFECD-$FFFFFECF ; seems unused
Ring_count_2P:			ds.w	1
Timer_2P:					; 4 bytes
Timer_minute_word_2P:				; 2 bytes
				ds.b	1	; filler
Timer_minute_2P:		ds.b	1	; 1 byte
Timer_second_2P:		ds.b	1	; 1 byte
Timer_centisecond_2P:				; inaccurate name (the seconds increase when this reaches 60)
Timer_frame_2P:			ds.b	1	; 1 byte
Score_2P:			ds.l	1
				ds.b	6	; $FFFFFEDA-$FFFFFEDF ; seems unused
Last_star_pole_hit_2P:		ds.b	1
Saved_Last_star_pole_hit_2P:	ds.b	1
Saved_x_pos_2P:			ds.w	1
Saved_y_pos_2P:			ds.w	1
Saved_Ring_count_2P:		ds.w	1
Saved_Timer_2P:			ds.l	1
Saved_art_tile_2P:		ds.w	1
Saved_Solid_bits_2P:			ds.w	1
Rings_Collected:		ds.w	1	; number of rings collected during an act in two player mode
Rings_Collected_2P:		ds.w	1
Monitors_Broken:		ds.w	1	; number of monitors broken during an act in two player mode
Monitors_Broken_2P:		ds.w	1
Loser_Time_Left:				; 2 bytes
				ds.b	1	; seconds
				ds.b	1	; frames

				ds.b	$16	; $FFFFFEFA-$FFFFFF0F ; seems unused
Results_Screen_2P:		ds.w	1	; 0 = act, 1 = zone, 2 = game, 3 = SS, 4 = SS all
				ds.b	$E	; $FFFFFF12-$FFFFFF1F ; seems unused

Events_bg:
Results_Data_2P:				; $18 (24) bytes
EHZ_Results_2P:			ds.b	6	; 6 bytes
MCZ_Results_2P:			ds.b	6	; 6 bytes
CNZ_Results_2P:			ds.b	6	; 6 bytes
SS_Results_2P:			ds.b	6	; 6 bytes
Results_Data_2P_End:


SS_Total_Won:			ds.b	2	; 2 bytes (player 1 then player 2)
				ds.b	6	; $FFFFFF3A-$FFFFFF3F ; seems unused
Perfect_rings_left:		ds.w	1
Perfect_rings_flag:			ds.w	1
				ds.b	8	; $FFFFFF44-$FFFFFF4B ; seems unused

CreditsScreenIndex:
SlotMachineInUse:			ds.w	1
SlotMachineVariables:	; $12 values
SlotMachine_Routine:	ds.b	1
SlotMachine_Timer:		ds.b	1
				ds.b	1	; $FFFFFF50 ; seems unused except for 1 write
SlotMachine_Index:		ds.b	1
SlotMachine_Reward:		ds.w	1
SlotMachine_Slot1Pos:	ds.w	1
SlotMachine_Slot1Speed:	ds.b	1
SlotMachine_Slot1Rout:	ds.b	1
SlotMachine_Slot2Pos:	ds.w	1
SlotMachine_Slot2Speed:	ds.b	1
SlotMachine_Slot2Rout:	ds.b	1
SlotMachine_Slot3Pos:	ds.w	1
SlotMachine_Slot3Speed:	ds.b	1
SlotMachine_Slot3Rout:	ds.b	1
Dataselect_entry:               ds.b    1
                                ds.b    1 ; unused
Dataselect_nosave_player:       ds.w    1
				ds.b	$C	; $FFFFFF60-$FFFFFF6F ; seems unused

Player_mode:			ds.w	1	; 0 = Sonic and Tails, 1 = Sonic, 2 = Tails
Player_option:			ds.w	1	; 0 = Sonic and Tails, 1 = Sonic, 2 = Tails

Two_player_items:		ds.w	1
_unkEEEA:
				ds.b	$A	; $FFFFFF76-$FFFFFF7F ; seems unused

LevSel_HoldTimer:		ds.w	1
Level_select_zone:		ds.w	1
Sound_test_sound:		ds.w	1
Title_screen_option:		ds.b	1
				ds.b	1	; $FFFFFF87 ; unused
Current_Zone_2P:		ds.b	1
Current_Act_2P:			ds.b	1
Two_player_mode_copy:		ds.w	1
Options_menu_box:		ds.b	1
				ds.b	1	; $FFFFFF8D ; unused
Total_Bonus_Countdown:		ds.w	1

Level_Music:			ds.w	1
Bonus_Countdown_3:		ds.w	1
Emerald_flicker_flag:		ds.w	1
SRAM_mask_interrupts_flag:      ds.w    1
Game_Over_2P:			ds.w	1

				ds.b	6	; $FFFFFF9A-$FFFFFF9F ; seems unused

SS2p_RingBuffer:		ds.w	6
    ds.b	4	; $FFFFFFAC-$FFFFFFAF ; seems unused
Got_Emerald:			ds.b	1
Emerald_count:			ds.b	1
Got_Emeralds_array:		ds.b	7	; 7 bytes
Collected_emeralds_array =      Got_Emeralds_array
				ds.b	7	; $FFFFFFB9-$FFFFFFBF ; filler  (appearently super emeralds lmao)
Next_Extra_life_score:		ds.l	1
Next_Extra_life_score_2P:	ds.l	1
Level_Has_Signpost:		ds.w	1	; 1 = signpost, 0 = boss or nothing
Signpost_prev_frame:	ds.b	1
				ds.b	1	; $FFFFFFCB ; seems unused
Camera_Min_Y_pos_Debug_Copy:	ds.w	1
Camera_Max_Y_pos_Debug_Copy:	ds.w	1

Level_select_flag:		ds.b	1
Slow_motion_flag:		ds.b	1	; This NEEDs to be after Level_select_flag because of the call to CheckCheats
Debug_options_flag:		ds.b	1	; if set, allows you to enable debug mode and "night mode"
S1_hidden_credits_flag:		ds.b	1	; Leftover from Sonic 1. This NEEDs to be after Debug_options_flag because of the call to CheckCheats
Correct_cheat_entries:		ds.w	1
Correct_cheat_entries_2:	ds.w	1	; for 14 continues or 7 emeralds codes

Competition_mode:
Two_player_mode:		ds.w	1	; flag (0 for main game)
unk_FFDA:			ds.w	1	; Written to once at title screen, never read from
unk_FFDC:			ds.b	1	; Written to near loc_175EA, never read from
unk_FFDD:			ds.b	1	; Written to near loc_175EA, never read from
unk_FFDE:			ds.b	1	; Written to near loc_175EA, never read from
unk_FFDF:			ds.b	1	; Written to near loc_175EA, never read from

; Values in these variables are passed to the sound driver during V-INT.
; They use a playlist index, not a sound test index.
Music_to_play:			ds.b	1
SFX_to_play:			ds.b	1	; normal
SFX_to_play_2:			ds.b	1	; alternating stereo
unk_FFE3:			ds.b	1
Music_to_play_2:		ds.b	1	; alternate (higher priority?) slot
				ds.b	$1	; $FFFFFFE5-$FFFFFFEF ; seems unused

                                ds.l    1
                           ds.b    $6
Demo_mode_flag:			ds.w	1 ; 1 if a demo is playing (2 bytes)
Demo_number:			ds.w	1 ; which demo will play next (2 bytes)
Ending_demo_number:		ds.w	1 ; zone for the ending demos (2 bytes, unused)
				ds.w	1
Graphics_Flags:			ds.w	1 ; misc. bitfield
Debug_mode_flag:		ds.w	1 ; (2 bytes)
Checksum_fourcc:		ds.l	1 ; (4 bytes)

RAM_End

    if * > 0	; Don't declare more space than the RAM can contain!
	fatal "The RAM variable declarations are too large by $\{*} bytes."
    endif


; RAM variables - SEGA screen
	phase	Object_RAM	; Move back to the object RAM
SegaScr_Object_RAM:
				; Unused slot
				ds.b	object_size
SegaScreenObject:		; Sega screen
				ds.b	object_size
SegaHideTM:				; Object that hides TM symbol on JP region
				ds.b	object_size

				ds.b	($80-3)*object_size
SegaScr_Object_RAM_End:


; RAM variables - Title screen
	phase	Object_RAM	; Move back to the object RAM
TtlScr_Object_RAM:
				; Unused slot
				ds.b	object_size
IntroSonic:			; stars on the title screen
				ds.b	object_size
IntroTails:
				ds.b	object_size
IntroLargeStar:
TitleScreenPaletteChanger:
				ds.b	object_size
TitleScreenPaletteChanger3:
				ds.b	object_size
IntroEmblemTop:
				ds.b	object_size
IntroSmallStar1:
				ds.b	object_size
IntroSonicHand:
				ds.b	object_size
IntroTailsHand:
				ds.b	object_size
TitleScreenPaletteChanger2:
				ds.b	object_size

				ds.b	6*object_size

TitleScreenMenu:
				ds.b	object_size
IntroSmallStar2:
				ds.b	object_size

				ds.b	($70-2)*object_size
TtlScr_Object_RAM_End:


; RAM variables - Special stage
	phase	RAM_Start	; Move back to start of RAM
;SSRAM_ArtNem_SpecialSonicAndTails:

				ds.b	$3484 ;$353*$20	; $353 art blocks (6A60 bytes)  this is unused now
SSRAM_MiscKoz_SpecialPerspective:
                                ds.b	$1AFC
SSRAM_MiscNem_SpecialLevelLayout:
				ds.b	$180
				ds.b	$9C	; padding
SSRAM_MiscKoz_SpecialObjectLocations:
				ds.b	$1AE0

				ds.b	$1AE0     ; UNUSED
                                ds.b	$F00 ; unused
SSRAMMiscStart:
PNT_Buffer:
		           	ds.b	$700
PNT_Buffer_End:
SS_Horiz_Scroll_Buf_2:		ds.b	$380
                                ds.b $80
SSTrack_mappings_bitflags:				ds.l	1
SSTrack_mappings_uncompressed:			ds.l	1
SSTrack_anim:							ds.b	1
SSTrack_last_anim_frame:				ds.b	1
SpecialStage_CurrentSegment:			ds.b	1
SSTrack_anim_frame:						ds.b	1
SS_Alternate_PNT:						ds.b	1
SSTrack_drawing_index:					ds.b	1
SSTrack_Orientation:					ds.b	1
SS_Alternate_HorizScroll_Buf:			ds.b	1
SSTrack_mapping_frame:					ds.b	1
SS_Last_Alternate_HorizScroll_Buf:		ds.b	1
SS_New_Speed_Factor:					ds.l	1
SS_Cur_Speed_Factor:					ds.l	1
		ds.b	5
SSTrack_duration_timer:					ds.b	1
		ds.b	1
SS_player_anim_frame_timer:				ds.b	1
SpecialStage_LastSegment:				ds.b	1
SpecialStage_Started:					ds.b	1
		ds.b	4
SSTrack_last_mappings_copy:				ds.l	1
SSTrack_last_mappings:					ds.l	1
		ds.b	4
SSTrack_LastVScroll:					ds.w	1
		ds.b	3
SSTrack_last_mapping_frame:				ds.b	1
SSTrack_mappings_RLE:					ds.l	1
SSDrawRegBuffer:						ds.w	6
SSDrawRegBuffer_End
		ds.b	2
SpecialStage_LastSegment2:	ds.b	1
SS_unk_DB4D:	ds.b	1
		ds.b	$14
SS_Ctrl_Record_Buf:
				ds.w	$F
SS_Last_Ctrl_Record:
				ds.w	1
SS_Ctrl_Record_Buf_End
SS_CurrentPerspective:	ds.l	1
SS_Check_Rings_flag:		ds.b	1
SS_Pause_Only_flag:		ds.b	1
SS_CurrentLevelObjectLocations:	ds.l	1
SS_Ring_Requirement:	ds.w	1
SS_CurrentLevelLayout:	ds.l	1
		ds.b	1
SS_2P_BCD_Score:	ds.b	1
		ds.b	1
SS_NoCheckpoint_flag:	ds.b	1
		ds.b	2
SS_Checkpoint_Rainbow_flag:	ds.b	1
SS_Rainbow_palette:	ds.b	1
SS_Perfect_rings_left:	ds.w	1
		ds.b	2
SS_Star_color_1:	ds.b	1
SS_Star_color_2:	ds.b	1
SS_NoCheckpointMsg_flag:	ds.b	1
Victory_Pose:		ds.b	1
SS_NoRingsTogoLifetime:	ds.w	1
SS_RingsToGoBCD:		ds.w	1
SS_HideRingsToGo:	ds.b	1
SS_TriggerRingsToGo:	ds.b	1
			ds.b	$52	; unused
SS_Offset_X:			ds.w	1
SS_Offset_Y:			ds.w	1
                        ds.b    1
SS_Swap_Positions_Flag:	ds.b	1
SSRAMMiscEnd:
	phase	Sprite_Table_Input
SS_Sprite_Table_Input:		ds.b	$400	; in custom format before being converted and stored in Sprite_Table
SS_Sprite_Table_Input_End:

	phase	Object_RAM	; Move back to the object RAM
SS_Object_RAM:
SS_Sonic:
				ds.b	object_size
SS_Tails
				ds.b	object_size
SpecialStageHUD:
                		ds.b    object_size	; during a level, an object whose sole purpose is to clear the collision response list is stored here
SpecialStageStartBanner:
                		ds.b	object_size
SpecialStageNumberOfRings:
				ds.b	object_size
SpecialStageShadow_Sonic:
				ds.b	object_size
SpecialStageShadow_Tails:
				ds.b	object_size
SpecialStageTails_Tails:
				ds.b	object_size
				ds.b	object_size    ; also unused in ss   (used in levels unused in ss)


				ds.b	object_size  ; unused object slot (used in levels unused in ss)


                        	ds.b    object_size  ; unused object slot (used in levels unused in ss)
SpecialStageResults:
SS_Dynamic_Object_RAM:
SpecialStageResults2:           ds.b object_size*$18 ;(slots unused in SS but used by the results game mode and doesnt effect ss main gameplay)
	                        ds.b object_size*$38	; $1A04 bytes ; 90 objects
SS_Dynamic_Object_RAM_End:
            phase Object_RAM_End ; assume pretend we are in the end of obj ram location
SS_Object_RAM_End:

	phase	ramaddr(Horiz_Scroll_Buf)	; Still in SS RAM
SS_Horiz_Scroll_Buf_1:		ds.b	$400
SS_Horiz_Scroll_Buf_1_End:



	phase	ramaddr(Sprite_Table)	; Still in SS RAM
SS_Sprite_Table:			ds.b	$280	; Sprite attribute table buffer
SS_Sprite_Table_End:
				ds.b	$80	; unused, but SAT buffer can spill over into this area when there are too many sprites on-screen


; RAM variables - Continue screen
	phase	Object_RAM	; Move back to the object RAM
ContScr_Object_RAM:
				ds.b	object_size
				ds.b	object_size
ContinueText:			; "CONTINUE" on the Continue screen
				ds.b	object_size
ContinueIcons:			; The icons in the Continue screen
				ds.b	$D*object_size

				; Free slots
				ds.b	$70*object_size
ContScr_Object_RAM_End:


; RAM variables - 2P VS results screen
	phase	Object_RAM	; Move back to the object RAM
VSRslts_Object_RAM:
VSResults_HUD:			; Blinking text at the bottom of the screen
				ds.b	object_size

				; Free slots
				ds.b	$7F*object_size
VSRslts_Object_RAM_End:


; RAM variables - Menu screens
	phase	Object_RAM	; Move back to the object RAM
Menus_Object_RAM:		; No objects are loaded in the menu screens
				ds.b	$80*object_size
Menus_Object_RAM_End:


; RAM variables - Ending sequence
	phase	Object_RAM
EndSeq_Object_RAM:
				ds.b	object_size
				ds.b	object_size
Tails_Tails_Cutscene:		; Tails' tails on the cut scene
				ds.b	object_size
EndSeqPaletteChanger:
				ds.b	object_size
CutScene:
				ds.b	object_size
				ds.b	($80-5)*object_size
EndSeq_Object_RAM_End:

	dephase		; Stop pretending

	!org	0	; Reset the program counter
