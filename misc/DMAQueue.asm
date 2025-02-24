

; ---------------------------------------------------------------------------
; Subroutine for queueing VDP commands (seems to only queue transfers to VRAM),
; to be issued the next time ProcessDMAQueue is called.
; Can be called a maximum of 18 times before the buffer needs to be cleared
; by issuing the commands (this subroutine DOES check for overflow)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_144E: DMA_68KtoVRAM: QueueCopyToVRAM: QueueVDPCommand: Add_To_DMA_Queue:
Add_To_DMA_Queue:
QueueDMATransfer:

		movea.l	(VDP_Command_Buffer_Slot).w,a1
		cmpa.w	#VDP_Command_Buffer_Slot,a1	; is the queue full?
		beq.s	Add_To_DMA_Queue_Done	; if it is, return

		move.w	#$9300,d0
		move.b	d3,d0
		move.w	d0,(a1)+	; command to specify transfer length in words & $00FF

		move.w	#$9400,d0
		lsr.w	#8,d3
		move.b	d3,d0
		move.w	d0,(a1)+	; command to specify transfer length in words & $FF00

		move.w	#$9500,d0

		lsr.l	#1,d1

		move.b	d1,d0
		move.w	d0,(a1)+	; command to specify transfer source & $0001FE

		move.w	#$9600,d0
		lsr.l	#8,d1
		move.b	d1,d0
		move.w	d0,(a1)+	; command to specify transfer source & $01FE00

		move.w	#$9700,d0
		lsr.l	#8,d1
		andi.b	#$7F,d1		; this instruction safely allows source to be in RAM; S2's lacks this
		move.b	d1,d0
		move.w	d0,(a1)+	; command to specify transfer source & $FE0000

		andi.l	#$FFFF,d2
		lsl.l	#2,d2
		lsr.w	#2,d2
		swap	d2
		ori.l	#vdpComm($0000,VRAM,DMA),d2
		move.l	d2,(a1)+	; command to specify transfer destination and begin DMA

		move.l	a1,(VDP_Command_Buffer_Slot).w	; set new free slot address
		cmpa.w	#VDP_Command_Buffer_Slot,a1	; has the end of the queue been reached?
		beq.s	Add_To_DMA_Queue_Done	; if it has, branch
		move.w	#0,(a1)	; place stop token at the end of the queue

Add_To_DMA_Queue_Done:
		rts


; ---------------------------------------------------------------------------
; Subroutine for issuing all VDP commands that were queued
; (by earlier calls to QueueDMATransfer)
; Resets the queue when it's done
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_14AC: CopyToVRAM: IssueVDPCommands: Process_DMA: Process_DMA_Queue:
ProcessDMAQueue:
	lea	(VDP_control_port).l,a5
		lea	(DMA_queue).w,a1

-
		move.w	(a1)+,d0	; has a stop token been encountered?
		beq.s	+	; if it has, branch
		move.w	d0,(a5)
		move.w	(a1)+,(a5)
		move.w	(a1)+,(a5)
		move.w	(a1)+,(a5)
		move.w	(a1)+,(a5)
		move.w	(a1)+,(a5)
		move.w	(a1)+,(a5)
		cmpa.w	#DMA_queue_slot,a1	; has the end of the queue been reached?
		bne.s	-	; if not, loop

+
		move.w	#0,(DMA_queue).w
		move.l	#DMA_queue,(DMA_queue_slot).w
		rts


; End of function ProcessDMAQueue
