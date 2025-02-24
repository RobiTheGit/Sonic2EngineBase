MapEni_S3MenuBG:
       binclude "art/Save Menu/Enigma Map/S3 Menu BG.bin"

        even
MapEni_SaveScreen_Layout:
         binclude "art/Save Menu/Enigma Map/Save Screen Layout.bin"
         even
MapPtrs_SaveScreenStatic:
 	        dc.l MapUnc_SaveScreenStatic1
		dc.l MapUnc_SaveScreenStatic2
		dc.l MapUnc_SaveScreenStatic3
		dc.l MapUnc_SaveScreenStatic4
                even
ArtKos_S3MenuBG:
    binclude   "art/Save Menu/Kosinski Art/Menu BG.bin"
    even
ArtKos_SaveScreenMisc:
    binclude   "art/Save Menu/Kosinski Art/Misc.bin"
    even
ArtKos_SaveScreenS3Zone:
      binclude  "art/Save Menu/Kosinski Art/Zone Art.bin"
      even
ArtKos_SaveScreen:
          binclude  "art/Save Menu/Kosinski Art/SK Extra.bin"
          even
ArtKos_SaveScreenSKZone:
          binclude  "art/Save Menu/Kosinski Art/SK Zone Art.bin"
          even
ArtKos_SaveScreenPortrait:
           binclude  "art/Save Menu/Kosinski Art/Portraits.bin"
           even
MapUnc_SaveScreenStatic1:
		binclude "art/Save Menu/Uncompressed Map/Static 1.bin"
		even
MapUnc_SaveScreenStatic2:
		binclude "art/Save Menu/Uncompressed Map/Static 2.bin"
		even
MapUnc_SaveScreenStatic3:
		binclude "art/Save Menu/Uncompressed Map/Static 3.bin"
		even
MapUnc_SaveScreenStatic4:
		binclude "art/Save Menu/Uncompressed Map/Static 4.bin"
		even
MapUnc_SaveScreenNEW:
      binclude	"art/Save Menu/Uncompressed Map/NEW.bin"
		even
Map_FirewormSegments: BINCLUDE "mappings/Map - Fireworm Segments.bin"
       even
Map_Fireworm:  BINCLUDE "mappings/Map - Fireworm.bin"
       even
ArtUnc_Fireworm: BINCLUDE "art/Fireworm.bin";BInclude "HPZ/FireWorm/Art/FireWorm_Head_Art.bin"                                     ;unused BINCLUDE "HPZ/Fireworm.bin"
       even
DPLC_Fireworm: BINCLUDE "art/dplc/DPLC - Fireworm.asm"
	   even
