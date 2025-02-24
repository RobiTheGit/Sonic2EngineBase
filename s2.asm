; Sonic the Hedgehog 2 disassembled binary
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ASSEMBLY OPTIONS:
;
    ifndef gameRevision
gameRevision = 2
    endif
;	| If 0, a REV00 ROM is built
;	| If 1, a REV01 ROM is built, which contains some fixes
;	| If 2, a (probable) REV02 ROM is built, which contains even more fixes
padToPowerOfTwo = 1
;	| If 1, pads the end of the ROM to the next power of two bytes (for real hardware)
;
allOptimizations = 1
;	| If 1, enables all optimizations
;
skipChecksumCheck = 1|allOptimizations
;	| If 1, disables the unnecessary (and slow) bootup checksum calculation
;
zeroOffsetOptimization = 1|allOptimizations
;	| If 1, makes a handful of zero-offset instructions smaller
;
removeJmpTos = 1|gameRevision=2|allOptimizations
;	| If 1, many unnecessary JmpTos are removed, improving performance
;
addsubOptimize = 1|gameRevision=2|allOptimizations
;	| If 1, some add/sub instructions are optimized to addq/subq
;
relativeLea = 1|gameRevision<>2|allOptimizations
;	| If 1, makes some instructions use pc-relative addressing, instead of absolute long
;
useFullWaterTables = 0
;	| If 1, zone offset tables for water levels cover all level slots instead of only slots 8-$F
;	| Set to 1 if you've shifted level IDs around or you want water in levels with a level slot below 8

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; AS-specific macros and assembler settings
	CPU 68000
	include "s2.macrosetup.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equates section - Names for variables.
	include "s2.constants.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Simplifying macros and functions
	include "s2.macros.asm"
; Including SMPS2ASM so we can edit music
SonicDriverVer = 2
use_s2_samples = 1
	include "sound/code/_smps2asm_inc.asm"
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; start of ROM

StartOfRom:
    if * <> 0
	fatal "StartOfRom was $\{*} but it should be 0"
    endif
Vectors:
;Vectors:
   dc.l System_Stack   ; Initial stack pointer value
   dc.l EntryPoint       ; Start of program
   dc.l BusError       ; Bus error
   dc.l AddressError   ; Address error (4)
   dc.l IllegalInstr   ; Illegal instruction
   dc.l ZeroDivide       ; Division by zero
   dc.l ChkInstr       ; CHK exception
   dc.l TrapvInstr       ; TRAPV exception (8)
   dc.l PrivilegeViol   ; Privilege violation
   dc.l Trace           ; TRACE exception
   dc.l Line1010Emu   ; Line-A emulator
   dc.l Line1111Emu   ; Line-F emulator (12)
   dc.l ErrorExcept   ; Unused (reserved)
   dc.l ErrorExcept   ; Unused (reserved)
   dc.l ErrorExcept   ; Unused (reserved)
   dc.l ErrorExcept   ; Unused (reserved) (16)
   dc.l ErrorExcept   ; Unused (reserved)
   dc.l ErrorExcept   ; Unused (reserved)
   dc.l ErrorExcept   ; Unused (reserved)
   dc.l ErrorExcept   ; Unused (reserved) (20)
   dc.l ErrorExcept   ; Unused (reserved)
   dc.l ErrorExcept   ; Unused (reserved)
   dc.l ErrorExcept   ; Unused (reserved)
   dc.l ErrorExcept   ; Unused (reserved) (24)
   dc.l ErrorExcept   ; Spurious exception
   dc.l ErrorExcept   ; IRQ level 1
   dc.l ErrorExcept   ; IRQ level 2
   dc.l ErrorExcept   ; IRQ level 3 (28)
   dc.l H_Int           ; IRQ level 4 (horizontal retrace interrupt)
   dc.l ErrorExcept   ; IRQ level 5
   dc.l V_Int           ; IRQ level 6 (vertical retrace interrupt)
   dc.l ErrorExcept   ; IRQ level 7 (32)
   dc.l ErrorExcept   ; TRAP #00 exception
   dc.l ErrorExcept   ; TRAP #01 exception
   dc.l ErrorExcept   ; TRAP #02 exception
   dc.l ErrorExcept   ; TRAP #03 exception (36)
   dc.l ErrorExcept   ; TRAP #04 exception
   dc.l ErrorExcept   ; TRAP #05 exception
   dc.l ErrorExcept   ; TRAP #06 exception
   dc.l ErrorExcept   ; TRAP #07 exception (40)
   dc.l ErrorExcept   ; TRAP #08 exception
   dc.l ErrorExcept   ; TRAP #09 exception
   dc.l ErrorExcept   ; TRAP #10 exception
   dc.l ErrorExcept   ; TRAP #11 exception (44)
   dc.l ErrorExcept   ; TRAP #12 exception
   dc.l ErrorExcept   ; TRAP #13 exception
   dc.l ErrorExcept   ; TRAP #14 exception
   dc.l ErrorExcept   ; TRAP #15 exception (48)
   dc.l ErrorExcept   ; Unused (reserved)
   dc.l ErrorExcept   ; Unused (reserved)
   dc.l ErrorExcept   ; Unused (reserved)
   dc.l ErrorExcept   ; Unused (reserved) (52)
   dc.l ErrorExcept   ; Unused (reserved)
   dc.l ErrorExcept   ; Unused (reserved)
   dc.l ErrorExcept   ; Unused (reserved)
   dc.l ErrorExcept   ; Unused (reserved) (56)
   dc.l ErrorExcept   ; Unused (reserved)
   dc.l ErrorExcept   ; Unused (reserved)
   dc.l ErrorExcept   ; Unused (reserved)
   dc.l ErrorExcept   ; Unused (reserved) (60)
   dc.l ErrorExcept   ; Unused (reserved)
   dc.l ErrorExcept   ; Unused (reserved)
   dc.l ErrorExcept   ; Unused (reserved)
   dc.l ErrorExcept   ; Unused (reserved) (64)

; byte_100:
Header:
	dc.b "SEGA GENESIS    " ; Console name
	dc.b "(C)SEGA 1992.SEP" ; Copyright holder and release date (generally year)
	dc.b "SONIC THE             HEDGEHOG 2                " ; Domestic name
	dc.b "SONIC THE             HEDGEHOG 2                " ; International name
    if gameRevision=0
	dc.b "GM 00001051-00"   ; Version (REV00)
    elseif gameRevision=1
	dc.b "GM 00001051-01"   ; Version (REV01)
    elseif gameRevision=2
	dc.b "GM 00001051-02"   ; Version (REV02)
    endif
; word_18E
Checksum:
	dc.w $D951		; Checksum (patched later if incorrect)
	dc.b "J               " ; I/O Support
	dc.l StartOfRom		; Start address of ROM
; dword_1A4
ROMEndLoc:
	dc.l EndOfRom-1		; End address of ROM
	dc.l RAM_Start&$FFFFFF		; Start address of RAM
	dc.l (RAM_End-1)&$FFFFFF		; End address of RAM
ExternalRam:       dc.b  "RA"
RamType:        dc.b  $F8
Space        dc.b  " "
RamStartLocation  dc.l  $200001
RamEndingLocation  dc.l  $2003FF
	dc.b "            "	; Modem support
	dc.b "                                        "	; Notes (unused, anything can be put in this space, but it has to be 52 bytes.)
	dc.b "JUE             " ; Country code (region)
EndOfHeader:
          even
; ===========================================================================
; Crash/Freeze the 68000. Note that the Z80 continues to run, so the music keeps playing.
; loc_200:
ErrorTrap:
	nop	; delay
	nop	; delay
	bra.s	ErrorTrap	; Loop indefinitely.

; ===========================================================================
; loc_206:
EntryPoint:
	tst.l	(HW_Port_1_Control-1).l	; test ports A and B control
	bne.s	PortA_Ok	; If so, branch.
	tst.w	(HW_Expansion_Control-1).l	; test port C control
; loc_214:
PortA_Ok:
	bne.s	PortC_OK ; Skip the VDP and Z80 setup code if port A, B or C is ok...?
	lea	SetupValues(pc),a5	; Load setup values array address.
	movem.w	(a5)+,d5-d7
	movem.l	(a5)+,a0-a4
	move.b	HW_Version-Z80_Bus_Request(a1),d0	; Get hardware version
	andi.b	#$F,d0	; Compare
	beq.s	SkipSecurity	; If the console has no TMSS, skip the security stuff.
	move.l	#'SEGA',Security_Addr-Z80_Bus_Request(a1) ; Satisfy the TMSS
; loc_234:
SkipSecurity:
	move.w	(a4),d0	; check if VDP works
	moveq	#0,d0	; clear d0
	movea.l	d0,a6	; clear a6
	move.l	a6,usp	; set usp to $0

	moveq	#VDPInitValues_End-VDPInitValues-1,d1 ; run the following loop $18 times
; loc_23E:
VDPInitLoop:
	move.b	(a5)+,d5	; add $8000 to value
	move.w	d5,(a4)	; move value to VDP register
	add.w	d7,d5	; next register
	dbf	d1,VDPInitLoop

	move.l	(a5)+,(a4)	; set VRAM write mode
	move.w	d0,(a3)	; clear the screen
	move.w	d7,(a1)	; stop the Z80
	move.w	d7,(a2)	; reset the Z80
; loc_250:
WaitForZ80:
	btst	d0,(a1)	; has the Z80 stopped?
	bne.s	WaitForZ80	; if not, branch

	moveq	#Z80StartupCodeEnd-Z80StartupCodeBegin-1,d2
; loc_256:
Z80InitLoop:
	move.b	(a5)+,(a0)+
	dbf	d2,Z80InitLoop

	move.w	d0,(a2)
	move.w	d0,(a1)	; start the Z80
	move.w	d7,(a2)	; reset the Z80

; loc_262:
ClrRAMLoop:
	move.l	d0,-(a6)	; clear 4 bytes of RAM
	dbf	d6,ClrRAMLoop	; repeat until the entire RAM is clear
	move.l	(a5)+,(a4)	; set VDP display mode and increment mode
	move.l	(a5)+,(a4)	; set VDP to CRAM write

	moveq	#bytesToLcnt($80),d3	; set repeat times
; loc_26E:
ClrCRAMLoop:
	move.l	d0,(a3)	; clear 2 palettes
	dbf	d3,ClrCRAMLoop	; repeat until the entire CRAM is clear
	move.l	(a5)+,(a4)	; set VDP to VSRAM write

	moveq	#bytesToLcnt($50),d4	; set repeat times
; loc_278: ClrVDPStuff:
ClrVSRAMLoop:
	move.l	d0,(a3)	; clear 4 bytes of VSRAM.
	dbf	d4,ClrVSRAMLoop	; repeat until the entire VSRAM is clear
	moveq	#PSGInitValues_End-PSGInitValues-1,d5	; set repeat times.
; loc_280:
PSGInitLoop:
	move.b	(a5)+,PSG_input-VDP_data_port(a3) ; reset the PSG
	dbf	d5,PSGInitLoop	; repeat for other channels
	move.w	d0,(a2)
	movem.l	(a6),d0-a6	; clear all registers
	move	#$2700,sr	; set the sr
 ; loc_292:
PortC_OK: ;;
	jmp	GameProgram	; Branch to game program.
; ===========================================================================  '

; byte_294:
SetupValues:
	dc.w	$8000,bytesToLcnt($10000),$100

	dc.l	Z80_RAM
	dc.l	Z80_Bus_Request
	dc.l	Z80_Reset
	dc.l	VDP_data_port, VDP_control_port

VDPInitValues:	; values for VDP registers
	dc.b 4			; Command $8004 - HInt off, Enable HV counter read
	dc.b $14		; Command $8114 - Display off, VInt off, DMA on, PAL off
	dc.b $30		; Command $8230 - Scroll A Address $C000
	dc.b $3C		; Command $833C - Window Address $F000
	dc.b 7			; Command $8407 - Scroll B Address $E000
	dc.b $6C		; Command $856C - Sprite Table Address $D800
	dc.b 0			; Command $8600 - Null
	dc.b 0			; Command $8700 - Background color Pal 0 Color 0
	dc.b 0			; Command $8800 - Null
	dc.b 0			; Command $8900 - Null
	dc.b $FF		; Command $8AFF - Hint timing $FF scanlines
	dc.b 0			; Command $8B00 - Ext Int off, VScroll full, HScroll full
	dc.b $81		; Command $8C81 - 40 cell mode, shadow/highlight off, no interlace
	dc.b $37		; Command $8D37 - HScroll Table Address $DC00
	dc.b 0			; Command $8E00 - Null
	dc.b 1			; Command $8F01 - VDP auto increment 1 byte
	dc.b 1			; Command $9001 - 64x32 cell scroll size
	dc.b 0			; Command $9100 - Window H left side, Base Point 0
	dc.b 0			; Command $9200 - Window V upside, Base Point 0
	dc.b $FF		; Command $93FF - DMA Length Counter $FFFF
	dc.b $FF		; Command $94FF - See above
	dc.b 0			; Command $9500 - DMA Source Address $0
	dc.b 0			; Command $9600 - See above
	dc.b $80		; Command $9780	- See above + VRAM fill mode
VDPInitValues_End:

	dc.l	vdpComm($0000,VRAM,DMA) ; value for VRAM write mode

	; Z80 instructions (not the sound driver; that gets loaded later)
Z80StartupCodeBegin: ; loc_2CA:
    if (*)+$26 < $10000
    save
    CPU Z80 ; start assembling Z80 code
    phase 0 ; pretend we're at address 0
	xor	a	; clear a to 0
	ld	bc,((Z80_RAM_End-Z80_RAM)-zStartupCodeEndLoc)-1 ; prepare to loop this many times
	ld	de,zStartupCodeEndLoc+1	; initial destination address
	ld	hl,zStartupCodeEndLoc	; initial source address
	ld	sp,hl	; set the address the stack starts at
	ld	(hl),a	; set first byte of the stack to 0
	ldir		; loop to fill the stack (entire remaining available Z80 RAM) with 0
	pop	ix	; clear ix
	pop	iy	; clear iy
	ld	i,a	; clear i
	ld	r,a	; clear r
	pop	de	; clear de
	pop	hl	; clear hl
	pop	af	; clear af
	ex	af,af'	; swap af with af'
	exx		; swap bc/de/hl with their shadow registers too
	pop	bc	; clear bc
	pop	de	; clear de
	pop	hl	; clear hl
	pop	af	; clear af
	ld	sp,hl	; clear sp
	di		; clear iff1 (for interrupt handler)
	im	1	; interrupt handling mode = 1
	ld	(hl),0E9h ; replace the first instruction with a jump to itself
	jp	(hl)	  ; jump to the first instruction (to stay there forever)
zStartupCodeEndLoc:
    dephase ; stop pretending
	restore
    padding off ; unfortunately our flags got reset so we have to set them again...
    else ; due to an address range limitation I could work around but don't think is worth doing so:
	message "Warning: using pre-assembled Z80 startup code."
	dc.w $AF01,$D91F,$1127,$0021,$2600,$F977,$EDB0,$DDE1,$FDE1,$ED47,$ED4F,$D1E1,$F108,$D9C1,$D1E1,$F1F9,$F3ED,$5636,$E9E9
    endif                     
Z80StartupCodeEnd:

	dc.w	$8104	; value for VDP display mode
	dc.w	$8F02	; value for VDP increment
	dc.l	vdpComm($0000,CRAM,WRITE)	; value for CRAM write mode
	dc.l	vdpComm($0000,VSRAM,WRITE)	; value for VSRAM write mode

PSGInitValues:
	dc.b	$9F,$BF,$DF,$FF	; values for PSG channel volumes
PSGInitValues_End:
; ===========================================================================

	even
; loc_300:
	include "misc/ErrorHandler/Debugger.asm"
GameProgram:
	tst.w	(VDP_control_port).l
; loc_306:
CheckSumCheck:
    if gameRevision>0
	move.w	(VDP_control_port).l,d1
	btst	#1,d1
	bne.s	CheckSumCheck	; wait until DMA is completed
    endif
	btst	#6,(HW_Expansion_Control).l
	beq.s	ChecksumTest
	cmpi.l	#'init',(Checksum_fourcc).w ; has checksum routine already run?
	beq.w	GameInit

; loc_328:
ChecksumTest:
    if skipChecksumCheck=0	; checksum code
	movea.l	#EndOfHeader,a0	; start checking bytes after the header ($200)
	movea.l	#ROMEndLoc,a1	; stop at end of ROM
	move.l	(a1),d0
	moveq	#0,d1
; loc_338:
ChecksumLoop:
	add.w	(a0)+,d1
	cmp.l	a0,d0
	bhs.s	ChecksumLoop
	movea.l	#Checksum,a1	; read the checksum
	cmp.w	(a1),d1	; compare correct checksum to the one in ROM
	bne.w	ChecksumError	; if they don't match, branch
    endif
;checksum_good:
	lea	(System_Stack).w,a6
	moveq	#0,d7

	move.w	#bytesToLcnt($200),d6
-	move.l	d7,(a6)+
	dbf	d6,-

	move.b	(HW_Version).l,d0
	andi.b	#$C0,d0
	move.b	d0,(Graphics_Flags).w
	move.l	#'init',(Checksum_fourcc).w ; set flag so checksum won't be run again
; loc_370:
GameInit:
	lea	(RAM_Start&$FFFFFF).l,a6
	moveq	#0,d7
	move.w	#bytesToLcnt(System_Stack&$FFFF),d6
; loc_37C:
GameClrRAM:
	move.l	d7,(a6)+
	dbf	d6,GameClrRAM	; clear RAM ($0000-$FDFF)

	jsr	VDPSetupGame
	jsr	JmpTo_SoundDriverLoad
	jsr	JoypadInit
	jsr     (SRAM_Load).l ; s ram wont even work without this lol
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; set Game Mode to Sega Screen
; loc_394:
MainGameLoop:
	move.b	(Game_mode).w,d0
	andi.w	#$7C,d0
	movea.l	GameModesArray(pc,d0.w),a0
	jsr	(a0)
	bra.s	MainGameLoop	; loop indefinitely

	include	"gamemodes/Gamemodes.asm"
  	include	"misc/VDP.asm"
	include	"sound/code/PlaySound.asm"
  	include	"misc/Pause.asm"
  	include	"misc/PlaneToVRAM.asm"
  	include	"misc/DMAQueue.asm"
  	include	"misc/NemDec.asm"
  	include	"misc/LoadPLC.asm"
  	include	"misc/EniDec.asm"
  	include	"misc/KosDec.asm"
  	include	"misc/Palettes.asm"
	include	"misc/OscData.asm"
	include	"gamemodes/SEGA.asm"
	include	"gamemodes/Title.asm"
	include	"sound/code/MusicLists.asm"
	include	"gamemodes/Level.asm"
	include	"gamemodes/SpecialStage.asm"
	include	"gamemodes/Continue.asm"
	include	"gamemodes/Menus.asm"
	include	"gamemodes/Ending.asm"
	include	"level/data/CameraBoundaries.asm"
	include	"level/data/StartPositions.asm"
	include	"level/data/Deformation.asm"
	include	"level/data/DrawTilesAsYouMove.asm"
    include	"level/data/DynamicLevelEvents.asm"
	include	"objects/Bridge.asm"
	include	"objects/SwingingPlatform.asm"
	include	"objects/SpikeHelix.asm"
	include	"objects/Platform.asm"
	include	"objects/BridgePost.asm"
	include	"objects/Stomper.asm"
	include	"objects/OneWayDoor.asm"
	include	"objects/CoreObj/Points.asm"
	include	"objects/CoreObj/Rings.asm"
	include	"objects/CoreObj/Monitors.asm"
	include	"objects/TitlescreenObj_0E_0F_C9.asm"
	include	"objects/Titlecards_GameOver.asm"
	include "level/data/LevelOrder.asm"
	include	"objects/CoreObj/Spikes.asm"
	include	"objects/UnusedBreakableObjects.asm"
	include	"misc/SpriteRendering.asm"
	include	"misc/Kos_Bookmarks.asm"
	include	"objects/CoreObj/RingsManager.asm"
	include	"objects/SpecialCNZBumpers.asm"
	include	"objects/CoreObj/ObjectManager.asm"
	include	"objects/CoreObj/Springs.asm"
	include	"objects/CoreObj/Signpost.asm"
	include	"misc/SolidObject.asm"
	include	"objects/Players/Sonic.asm"
	include	"objects/Players/Tails.asm"
	include	"objects/CoreObj/SmallBubbles.asm"
	include	"objects/CoreObj/ShieldInvinc.asm"
	include	"objects/CoreObj/Dust.asm"
	include	"misc/Floor_Angle_Wall.asm"
	include	"objects/CoreObj/Starpost.asm"
	include	"objects/UnusedPoints.asm"
	include	"objects/Bumpers.asm"
	include	"objects/CoreObj/AirBubble.asm"
	include	"objects/CoreObj/PlaneSwitcher.asm"
	include	"objects/TippingCPZPipe.asm"
	include	"objects/HPZ_Stuff.asm"
	include	"objects/CoreObj/WaterSurface.asm"
	include	"objects/Waterfall.asm"
	include	"objects/CoreObj/Lava.asm"
	include	"objects/CoreObj/SolidBlock.asm"
	include	"objects/ObjectPtrs.asm"
	include	"objects/Pylon.asm"
	include	"objects/CoreObj/AnimalPoints.asm"
	include	"objects/CoreObj/ForcedRoll.asm"
	include	"objects/WFZPalSwitch.asm"
	include	"objects/CoreObj/Spiral.asm"
	include	"objects/SeeSaw.asm"
	include	"objects/DiagLift.asm"
	include	"objects/Elevator.asm"
	include	"objects/SpeedBooster.asm"
	include	"objects/CPZ_BlueDrops.asm"
	include	"objects/CPZ_SpinTube.asm"
	include	"objects/HTZBoss_LavaBall.asm"
	include	"objects/SmashableGround.asm"
	include	"objects/BreakableRock.asm"
	include	"objects/RisingLava.asm"
	include	"objects/BurnerLid.asm"
	include	"objects/OOZ_SlidingSpike.asm"
	include	"objects/Oil.asm"
	include	"objects/PressureSpring.asm"
	include	"objects/OOZ_BetaBall.asm"
	include	"objects/CoreObj/Button.asm"
	include	"objects/OOZ_Canons.asm"
	include	"objects/ArrowShooter.asm"
	include	"objects/ARZPilars.asm"
	include	"objects/Leaves.asm"
	include	"objects/CoreObj/LeverSpring.asm"
	include	"objects/SteamSpring.asm"
	include	"objects/TwinStompers.asm"
	include	"objects/MTZLongMovingPlatform.asm"
	include	"objects/SpringWall.asm"
	include	"objects/MTZ_SpinTube.asm"
	include	"objects/BlockWithSpikes.asm"
	include	"objects/SpikesThatComeOutOfFloor.asm"
	include	"objects/Nut.asm"
	include	"objects/VariousMTZPlatforms.asm"
	include	"objects/GiantRotatingCog.asm"
	include	"objects/ConveyorBelt.asm"
	include	"objects/MCZBrickPlatforms.asm"
	include	"objects/CPZ_Platforms.asm"
	include	"objects/Vines.asm"
	include	"objects/DetachingPlatform.asm"
	include	"objects/Fan.asm"
	include	"objects/CNZSpring.asm"
	include	"objects/Flipper.asm"
	include	"objects/WeirdMovingBlocks.asm"
	include	"objects/CNZPinball.asm"
	include	"objects/InvisibleHang.asm"
	include	"objects/Octus.asm"
	include	"objects/Aquis.asm"
	include	"objects/Buzzer.asm"
	include	"objects/Masher.asm"
	include	"objects/BossExplosion.asm"
	include	"objects/CPZBoss.asm"
	include	"misc/ObjAttributes.asm"
	include	"objects/EHZBoss.asm"
	include	"objects/HTZBoss.asm"
	include	"objects/ARZBoss.asm"
	include	"objects/MCZBoss.asm"
	include	"objects/CNZBoss.asm"
	include	"objects/MTZBoss.asm"
	include	"objects/OOZBoss.asm"
	include "objects/SpecialStageObjects.asm"
	include	"misc/Subobjects.asm"
	include	"objects/Whisp.asm"
	include	"objects/Grounder.asm"
	include	"objects/ChopChop.asm"
	include	"objects/Spiker.asm"
	include	"objects/Sol.asm"
	include	"objects/Rexon.asm"
	include	"objects/CoreObj/Projectile.asm"
	include	"objects/Nebula.asm"
	include	"objects/Turtloid.asm"
	include	"objects/Coconuts.asm"
	include	"objects/Crawlton.asm"
	include	"objects/ShellCracker.asm"
	include	"objects/Slicer.asm"
	include	"objects/Flasher.asm"
	include	"objects/Asteron.asm"
	include	"objects/Spiny.asm"
	include	"objects/Grabber.asm"
	include	"objects/Balkiry.asm"
	include	"objects/Clucker.asm"
	include	"objects/SilverSonic.asm"
	include	"objects/SegaSonic.asm"
	include	"objects/Tornado.asm"
	include	"objects/WFZBoss.asm"
    include	"misc/CreateChildren.asm"
	include	"objects/Eggman.asm"
	include	"objects/CrawlBadnik.asm"
	include	"objects/EggMech.asm"
    include	"misc/SpriteScaling.asm"
	include	"objects/SonicTeam.asm"
	include	"objects/CoreObj/Capsule.asm"
    include	"misc/TouchResponse.asm"
	include "gamemodes/Savescreen.asm"
	include	"level/data/AnimatedTiles.asm"
	include	"objects/CoreObj/HUD.asm"
	include	"objects/CoreObj/Debug.asm"
	include "level/data/PatternLoadCues.asm"
	include "level/data/CollisionData.asm"
	include "level/data/Layouts.asm"
	include	"level/data/AnimatedTilesArt.asm"
	include	"objects/Players/PlayerArtMaps.asm"
	include	"mappings/EnigmaMaps.asm"
	include	"level/ObjectArt.asm"
	include	"art/Save Menu/LoadMapsData.asm"
	include	"level/data/LevelArtMaps.asm"
	include	"level/special/SpecialArtMaps.asm"
	include	"level/data/RingPositions.asm"
	include	"level/data/ObjectPositions.asm"
	include	"sound/code/LoadDriver.asm"
	include	"sound/code/SoundBanks.asm"

; end of 'ROM'
	if padToPowerOfTwo && (*)&(*-1)
		cnop	-1,2<<lastbit(*-1)
		dc.b	0
paddingSoFar	:= paddingSoFar+1
	else
		even
	endif
	if MOMPASS=2
		; "About" because it will be off by the same amount that Size_of_Snd_driver_guess is incorrect (if you changed it), and because I may have missed a small amount of internal padding somewhere
		message "ROM size is $\{*} bytes (\{*/1024.0} kb). About $\{paddingSoFar} bytes are padding. "
	endif
	; share these symbols externally (WARNING: don't rename, move or remove these labels!)
	shared word_728C_user,Obj5F_MapUnc_7240,off_3A294,MapRUnc_Sonic,movewZ80CompSize
	include	"misc/ErrorHandler/ErrorHandler.asm"
	;NO MORE DATA AFTER THIS

EndOfRom:
	END
