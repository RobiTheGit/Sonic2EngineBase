; Nemesis compressed art (32 blocks)
; Shield			; ArtNem_71D8E:
ArtUnc_Shield:	BINCLUDE	"art/uncompressed/Shield.unc"
	even
;--------------------------------------------------------------------------------------
; Nemesis compressed art (34 blocks)
; Invincibility stars		; ArtNem_71F14:
ArtUnc_Invincible_stars:	BINCLUDE	"art/uncompressed/Invincibility stars.unc"
	even
;--------------------------------------------------------------------------------------
; Uncompressed art
; Splash in water and dust from skidding	; ArtUnc_71FFC:
ArtUnc_SplashAndDust:	BINCLUDE	"art/uncompressed/Splash and skid dust.bin"
       even
;--------------------------------------------------------------------------------------
; Nemesis compressed art (14 blocks)
; Supersonic stars		; ArtNem_7393C:
ArtNem_SuperSonic_stars:	BINCLUDE	"art/nemesis/Super Sonic stars.bin"
	even
;---------------------------------------------------------------------------------------
; Uncompressed art
; Patterns for Sonic  ; ArtUnc_50000:
;---------------------------------------------------------------------------------------
	align $8000
ArtUnc_Sonic:	BINCLUDE	"art/uncompressed/Sonic's art.bin"
;---------------------------------------------------------------------------------------
; Uncompressed art
; Patterns for Tails  ; ArtUnc_64320:
;---------------------------------------------------------------------------------------
	align $8000
ArtUnc_Tails:	BINCLUDE	"art/uncompressed/Tails's art.bin"
;--------------------------------------------------------------------------------------
; Sprite Mappings
; Sonic			; MapUnc_6FBE0: SprTbl_Sonic:
;--------------------------------------------------------------------------------------
Mapunc_Sonic:	BINCLUDE	"mappings/sprite/Sonic.bin"
        even
;--------------------------------------------------------------------------------------
; Sprite Dynamic Pattern Reloading
; Sonic DPLCs   		; MapRUnc_714E0:
;--------------------------------------------------------------------------------------
; WARNING: the build script needs editing if you rename this label
;          or if you move Sonic's running frame to somewhere else than frame $2D
MapRUnc_Sonic:	BINCLUDE	"mappings/spriteDPLC/Sonic.bin"
        even
;--------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------
; Sprite Mappings
; Tails			; MapUnc_739E2:
;--------------------------------------------------------------------------------------
MapUnc_Tails:	BINCLUDE	"mappings/sprite/Tails.bin"
        even
;--------------------------------------------------------------------------------------
; Sprite Dynamic Pattern Reloading
; Tails DPLCs	; MapRUnc_7446C:
;--------------------------------------------------------------------------------------
MapRUnc_Tails:	BINCLUDE	"mappings/spriteDPLC/Tails.bin"
	even