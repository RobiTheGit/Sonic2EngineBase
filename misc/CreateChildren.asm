; this is an important ConQuest  Routine (Dulled Towork with s2 childs since the orignal is fucked for somereason)
CreateChildSimplePositons:
		moveq	#0,d2				; child routine that sets a timer and a child distance
		move.w	(a2)+,d6

CreateChildSimplePositons2:
		jsr	(Create_New_Sprite3).l
		bne.s	+
		move.w	a0,parent3(a1)
		move.l	mappings(a0),mappings(a1)
		move.w	art_tile(a0),art_tile(a1)
		move.l	(a2)+,(a1)
		move.b  (a2)+,subtype(a1)
		move.w	x_pos(a0),x_pos(a1)
		move.w	y_pos(a0),y_pos(a1)
		dbf	d6,CreateChildSimplePositons2
                moveq	#0,d0

+
		rts
; End of function CreateChildComplexPositons
