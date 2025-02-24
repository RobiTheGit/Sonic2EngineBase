; --------------------------------------------------------------------------------
; Sprite mappings - output from SonMapEd - Sonic 2 format
; --------------------------------------------------------------------------------

SME_uO15G:	
		dc.w SME_uO15G_C-SME_uO15G, SME_uO15G_16-SME_uO15G	
		dc.w SME_uO15G_20-SME_uO15G, SME_uO15G_2A-SME_uO15G	
		dc.w SME_uO15G_34-SME_uO15G, SME_uO15G_3E-SME_uO15G	
SME_uO15G_C:	dc.b 0, 1	
		dc.b $F8, 5, 0, 0, 0, 0, $FF, $F8	
SME_uO15G_16:	dc.b 0, 1	
		dc.b $F8, 5, 0, $A, 0, 5, $FF, $F8	
SME_uO15G_20:	dc.b 0, 1	
		dc.b $F8, 5, $18, $A, $18, 5, $FF, $F8	
SME_uO15G_2A:	dc.b 0, 1	
		dc.b $F8, 5, 8, $A, 8, 5, $FF, $F8	
SME_uO15G_34:	dc.b 0, 1	
		dc.b $F8, 5, $10, $A, $10, 5, $FF, $F8	
SME_uO15G_3E:	dc.b 0, 0	
		even