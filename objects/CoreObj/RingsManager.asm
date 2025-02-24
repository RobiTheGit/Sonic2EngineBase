; ===========================================================================
; ----------------------------------------------------------------------------
; Pseudo-object that manages where rings are placed onscreen
; as you move through the level, and otherwise updates them.
; This is a version ported from Sonic 3 & Knuckles
; ----------------------------------------------------------------------------

; loc_16F88:
RingsManager:
	moveq	#0,d0
	move.b	(Rings_manager_routine).w,d0
	move.w	RingsManager_States(pc,d0.w),d0
	jmp	RingsManager_States(pc,d0.w)
; ===========================================================================
; off_16F96:
RingsManager_States:
	dc.w RingsManager_Init - RingsManager_States
	dc.w RingsManager_Main - RingsManager_States
; ===========================================================================
; loc_16F9A:
RingsManager_Init:
	addq.b	#2,(Rings_manager_routine).w ; => RingsManager_Main
	bsr.w	RingsManager_Setup	; perform initial setup
	movea.l	(Ring_start_addr_ROM).w,a1
	lea	(Ring_Positions).w,a2
	move.w	(Camera_X_pos).w,d4
	subq.w	#8,d4
	bhi.s	+
	moveq	#1,d4	; no negative values allowed
	bra.s	+
-
	addq.w	#4,a1	; load next ring
	addq.w	#2,a2
+
	cmp.w	(a1),d4	; is the X pos of the ring < camera X pos?
	bhi.s	-		; if it is, check next ring
	move.l	a1,(Ring_start_addr_ROM).w	; set start addresses in both ROM and RAM
	move.l	a1,(Ring_start_addr_ROM_P2).w
	move.w	a2,(Ring_start_addr_RAM).w
	move.w	a2,(Ring_start_addr_RAM_P2).w
	addi.w	#320+16,d4	; advance by a screen
	bra.s	+
-
	addq.w	#4,a1	; load next ring
+
	cmp.w	(a1),d4		; is the X pos of the ring < camera X + 336?
	bhi.s	-	; if it is, check next ring
	move.l	a1,(Ring_end_addr_ROM).w	; set end addresses
	move.l	a1,(Ring_end_addr_ROM_P2).w
	rts
; ===========================================================================
; loc_16FDE:
RingsManager_Main:
	lea	(Ring_consumption_table).w,a2
	move.w	(a2)+,d1
	subq.w	#1,d1	; are any rings currently being consumed?
	bcs.s	++	; if not, branch

	move.b	#5,(a1)	; reset timer
-	move.w	(a2)+,d0	; is there a ring in this slot?
	beq.s	-	; if not, branch
	movea.w	d0,a1	; load ring address
	subq.b	#1,(a1)	; decrement timer
	bne.s	+	; if it's not 0 yet, branch
	move.b	#5,(a1)	; reset timer
	addq.b	#1,1(a1); increment frame
	cmpi.b	#8,1(a1); is it destruction time yet?
	bne.s	+	; if not, branch
	move.w	#-1,(a1); destroy ring
	move.w	#0,-2(a2)	; clear ring entry
	subq.w	#1,(Ring_consumption_table).w	; subtract count
+	dbf	d1,-	; repeat for all rings in table
+
	; update ring start addresses
	movea.l	(Ring_start_addr_ROM).w,a1
	movea.w	(Ring_start_addr_RAM).w,a2
	move.w	(Camera_X_pos).w,d4
	subq.w	#8,d4
	bhi.s	+
	moveq	#1,d4
	bra.s	+
-
	addq.w	#4,a1
	addq.w	#2,a2
+
	cmp.w	(a1),d4
	bhi.s	-
	bra.s	+
-
	subq.w	#4,a1
	subq.w	#2,a2
+
	cmp.w	-4(a1),d4
	bls.s	-
	move.l	a1,(Ring_start_addr_ROM).w	; update start addresses
	move.w	a2,(Ring_start_addr_RAM).w
	tst.w	(Two_player_mode).w	; are we in 2P mode?
	bne.s	+	; if we are, avoid copying over the P1 address
	move.w	a2,(Ring_start_addr_RAM_P2).w
+
	movea.l	(Ring_end_addr_ROM).w,a2	; set end address
	addi.w	#320+16,d4	; advance by a screen
	bra.s	+
-
	addq.w	#4,a2
+
	cmp.w	(a2),d4
	bhi.s	-
	bra.s	+
-
	subq.w	#4,a2
+
	cmp.w	-4(a2),d4
	bls.s	-
	move.l	a2,(Ring_end_addr_ROM).w	; update end address
	tst.w	(Two_player_mode).w	; are we in 2P mode?
	bne.s	+	; if we are, update P2 addresses
	move.l	a1,(Ring_start_addr_ROM_P2).w	; otherwise, copy over P1 addresses
	move.l	a2,(Ring_end_addr_ROM_P2).w
	rts
+
	; update ring start and end addresses for P2
	movea.l	(Ring_start_addr_ROM_P2).w,a1
	movea.w	(Ring_start_addr_RAM_P2).w,a2
	move.w	(Camera_X_pos_P2).w,d4
	subq.w	#8,d4
	bhi.s	+
	moveq	#1,d4
	bra.s	+
-
	addq.w	#4,a1
	addq.w	#2,a2
+
	cmp.w	(a1),d4
	bhi.s	-
	bra.s	+
-
	subq.w	#4,a1
	subq.w	#2,a2
+
	cmp.w	-4(a1),d4
	bls.s	-
	move.l	a1,(Ring_start_addr_ROM_P2).w	; update start addresses
	move.w	a2,(Ring_start_addr_RAM_P2).w
	movea.l	(Ring_end_addr_ROM_P2).w,a2		; set end address
	addi.w	#320+16,d4	; advance by a screen
	bra.s	+
-
	addq.w	#4,a2
+
	cmp.w	(a2),d4
	bhi.s	-
	bra.s	+
-
	subq.w	#4,a2
+
	cmp.w	-4(a2),d4
	bls.s	-
	move.l	a2,(Ring_end_addr_ROM_P2).w		; update end address
	rts

; ---------------------------------------------------------------------------
; Subroutine to handle ring collision
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_170BA:
Touch_Rings:
	movea.l	(Ring_start_addr_ROM).w,a1	; load start and end addresses
	movea.l	(Ring_end_addr_ROM).w,a2
	cmpa.w	#MainCharacter,a0	; are we the main character?
	beq.s	+		; if we are, continue on
	movea.l	(Ring_start_addr_ROM_P2).w,a1	; load start and end addresses for P2
	movea.l	(Ring_end_addr_ROM_P2).w,a2
+
	cmpa.l	a1,a2	; are there no rings in this area?
	beq.w	Touch_Rings_Done	; if so, return
	movea.w	(Ring_start_addr_RAM).w,a4	; load start address
	cmpa.w	#MainCharacter,a0	; are we the main character?
	beq.s	+		; if we are, continue on
	movea.w	(Ring_start_addr_RAM_P2).w,a4	; load start address for P2
+
;	cmpi.w	#$5A,invulnerable_time(a0)
;	bcc.w	Touch_Rings_Done
	btst	#status_sec_hasShield,status_secondary(a0)	; does character have a lightning shield?
	beq.s	Touch_Rings_NoAttraction	; if not, branch
	move.w	x_pos(a0),d2
	move.w	y_pos(a0),d3
	subi.w	#$40,d2
	subi.w	#$40,d3
	move.w	#6,d1
	move.w	#$C,d6
	move.w	#$80,d4
	move.w	#$80,d5
	bra.s	Touch_Rings_Loop
; ===========================================================================

Touch_Rings_NoAttraction:
	move.w	x_pos(a0),d2	; get character's position
	move.w	y_pos(a0),d3
	subi.w	#8,d2	; assume X radius to be 8
	moveq	#0,d5
	move.b	y_radius(a0),d5
	subq.b	#3,d5
	sub.w	d5,d3	; subtract (Y radius - 3) from Y pos
	cmpi.b	#$4D,mapping_frame(a0)
	bne.s	+	; if you're not ducking, branch
	addi.w	#$C,d3
	moveq	#$A,d5
+
	move.w	#6,d1	; set ring radius
	move.w	#$C,d6	; set ring diameter
	move.w	#$10,d4	; set character's X diameter
	add.w	d5,d5	; set Y diameter
; loc_17112:
Touch_Rings_Loop:
	tst.w	(a4)	; has this ring already been collided with?
	bne.w	Touch_NextRing	; if it has, branch
	move.w	(a1),d0		; get ring X pos
	sub.w	d1,d0		; get ring left edge X pos
	sub.w	d2,d0		; subtract character's left edge X pos
	bcc.s	+		; if character's to the left of the ring, branch
	add.w	d6,d0		; add ring diameter
	bcs.s	++		; if character's colliding, branch
	bra.w	Touch_NextRing	; otherwise, test next ring
+
	cmp.w	d4,d0		; has character crossed the ring?
	bhi.w	Touch_NextRing	; if they have, branch
+
	move.w	2(a1),d0	; get ring Y pos
	sub.w	d1,d0		; get ring top edge pos
	sub.w	d3,d0		; subtract character's top edge pos
	bcc.s	+		; if character's above the ring, branch
	add.w	d6,d0		; add ring diameter
	bcs.s	++		; if character's colliding, branch
	bra.w	Touch_NextRing	; otherwise, test next ring
+
	cmp.w	d5,d0		; has character crossed the ring?
	bhi.w	Touch_NextRing	; if they have, branch
+
	btst	#status_sec_hasShield,status_secondary(a0)	; does character have a lightning shield?
	bne.s	AttractRing			; if so, attract the ring towards the player
-
	move.w	#$604,(a4)		; set frame and destruction timer
	bsr.s	Touch_ConsumeRing
	lea	(Ring_consumption_table+2).w,a3

-	tst.w	(a3)+		; is this slot free?
	bne.s	-		; if not, repeat until you find one
	move.w	a4,-(a3)	; set ring address
	addq.w	#1,(Ring_consumption_table).w	; increase count
; loc_1715C:
Touch_NextRing:
	addq.w	#4,a1
	addq.w	#2,a4
	cmpa.l	a1,a2		; are we at the last ring for this area?
	bne.w	Touch_Rings_Loop	; if not, branch
; return_17166:
Touch_Rings_Done:
	rts
; ===========================================================================
; loc_17168:
Touch_ConsumeRing:
	subq.w	#1,(Perfect_rings_left).w
	cmpa.w	#MainCharacter,a0	; who collected the ring?
	beq.w	Jmp_CollectRing		; if it was Sonic, branch here
	bra.w	jmp_CollectRing_Tails	; if it was Tails, branch here
; ===========================================================================
AttractRing:
	movea.l	a1,a3
	jsr	SingleObjLoad
	bne.w	AttractRing_NoFreeSlot
	move.l #Obj4C,(a1)
	move.w	(a3),x_pos(a1)
	move.w	2(a3),y_pos(a1)
	move.w	a0,parent(a1)
	move.w	#-1,(a4)
	rts
; ===========================================================================
AttractRing_NoFreeSlot:
	movea.l	a3,a1
	bra.s	-

; ---------------------------------------------------------------------------
; Subroutine to draw on-screen rings
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_17178:
BuildRings:
	movea.l	(Ring_start_addr_ROM).w,a0
	move.l	(Ring_end_addr_ROM).w,d7
	sub.l	a0,d7		; are there any rings on-screen?
	bne.s	+		; if there are, branch
	rts			; otherwise, return
+
	movea.w	(Ring_start_addr_RAM).w,a4	; load start address
	lea	(Camera_X_pos).w,a3		; load camera x position

BuildRings_Loop:
	tst.w	(a4)+		; has this ring been consumed?
	bmi.w	BuildRings_NextRing	; if it has, branch
	move.w	(a0),d3		; get ring X pos
	sub.w	(a3),d3		; subtract camera X pos
	addi.w	#128,d3		; screen top is 128x128 not 0x0
	move.w	2(a0),d2	; get ring Y pos
	sub.w	4(a3),d2	; subtract camera Y pos
	andi.w	#$7FF,d2
	addi_.w	#8,d2
	bmi.s	BuildRings_NextRing	; dunno how this check is supposed to work
	cmpi.w	#240,d2
	bge.s	BuildRings_NextRing	; if the ring is not on-screen, branch
	addi.w	#128-8,d2
	lea	(MapUnc_Rings).l,a1
	moveq	#0,d1
	move.b	-1(a4),d1	; get ring frame
	bne.s	+		; if this ring is using a specific frame, branch
	moveq	#0,d1
+
	add.w	d1,d1
	adda.w	(a1,d1.w),a1	; get frame data address
	move.b	(a1)+,d0	; get Y offset
	ext.w	d0
	add.w	d2,d0		; add Y offset to Y pos
	move.w	d0,(a2)+	; set Y pos
	move.b	(a1)+,(a2)+	; set size
	addq.b	#1,d5
	move.b	d5,(a2)+	; set link field
	move.w	(a1)+,d0	; get art tile
	addi.w	#make_art_tile(ArtTile_ArtUnc_Ring,1,0),d0	; add base art tile
	move.w	d0,(a2)+	; set art tile and flags
	addq.w	#2,a1		; skip 2P art tile
	move.w	(a1)+,d0	; get X offset
	add.w	d3,d0		; add base X pos
	move.w	d0,(a2)+	; set X pos
; loc_171EC:
BuildRings_NextRing:
	addq.w	#4,a0
	subq.w	#4,d7
	bne.w	BuildRings_Loop
	rts

; ---------------------------------------------------------------------------
; Subroutine to perform initial rings manager setup
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_172A4:
RingsManager_Setup:
	clearRAM Ring_Positions,Ring_Positions_End
	; d0 = 0
	lea	(Ring_consumption_table).w,a1
	; in the Sonic 2 version a coding error is present that causes only half of the Ring_consumption_table to be cleared.
	move.w	#bytesToLcnt(Ring_consumption_table_End-Ring_consumption_table),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	moveq	#0,d5
	moveq	#0,d0
	move.w	(Current_ZoneAndAct).w,d0	; get the current zone and act
	ror.b	#1,d0
	lsr.w	#6,d0			; get the act
	lea	(Off_Rings).l,a1	; get the rings for the act
	move.w	(a1,d0.w),d0
	lea	(a1,d0.w),a1
	move.l	a1,(Ring_start_addr_ROM).w
	addq.w	#4,a1
	moveq	#0,d5
	move.w	#(Max_Rings-1),d0
-
	tst.l	(a1)+	; get the next ring
	bmi.s	+		; if there's no more, carry on
	addq.w	#1,d5	; increment perfect counter
	dbf	d0,-
+
	move.w	d5,(Perfect_rings_left).w	; set the perfect ring amount for the act
	move.w	#0,(Perfect_rings_flag).w	; clear the perfect ring flag
	rts
; ===========================================================================

; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Jmp_CollectRing:
	jmp 	CollectRing
jmp_CollectRing_Tails:
	jmp	CollectRing_Tails
; off_1736A:
MapUnc_Rings:	BINCLUDE "mappings/sprite/Rings.bin"

    if ~~removeJmpTos
	align 4
    endif
	align 4
; ---------------------------------------------------------------------------
; Queue ring frame graphics loading
; ---------------------------------------------------------------------------

LoadRingFrame:
                moveq   #0,d1                           ; Get ring frame offset for regular rings
                move.b  (Rings_anim_frame).w,d1
                lsl.w   #7,d1                           ; Each ring frame takes $80 bytes, so multiply by $80
                add.l   #ArtUnc_Ring,d1                    ; Queue a DMA transfer for this ring frame
                move.w  #$D780,d2
                move.w  #$80/2,d3
                jsr     QueueDMATransfer

                moveq   #0,d1                           ; Get ring frame offset for lost rings
                move.b  (Ring_spill_anim_frame).w,d1
                lsl.w   #7,d1                           ; Each ring frame takes $80 bytes, so multiply by $80
                add.l   #ArtUnc_Ring,d1                    ; Queue a DMA transfer for this ring frame
                move.w  #$D780+$80,d2
                move.w  #$80/2,d3
                jmp     QueueDMATransfer

.noringloss:
                rts
	align 4






