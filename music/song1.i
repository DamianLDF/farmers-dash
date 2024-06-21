song1_header:
    .byte $03 
    
    .byte MUSIC_SQ1         ;which stream
    .byte $01           ;status byte (stream enabled)
    .byte SQUARE_1      ;which channel
    .byte $70           ;initial duty (01)
    .byte ve_short_staccato ;volume envelope
    .word song1_square1 ;pointer to stream
    .byte $C0           ;tempo
    
    
    .byte MUSIC_TRI     ;which stream
    .byte $01           ;status byte (stream enabled)
    .byte TRIANGLE      ;which channel
    .byte $80           ;initial volume (on)
    .byte ve_tgl_2      ;volume envelope
    .word song1_tri     ;pointer to stream
    .byte $C0           ;tempo
    
    .byte MUSIC_NOI     ;which stream
    .byte $01
    .byte NOISE
    .byte 30
    .byte ve_drum_decay
    .word song1_noise
    .byte $C0

song1_square1:
    ; .byte QUARTER, C4, EIGHTH, E4, G4, E4, G4, QUARTER, G3, C4, EIGHTH, E4, G4, E4, G4, QUARTER, G3
    ; .byte QUARTER, C4, EIGHTH, E4, G4, E4, G4, QUARTER, G3, G4, E4, E3, G3
    ; .byte QUARTER, C4, EIGHTH, E4, G4, E4, G4, QUARTER, G3, C4, EIGHTH, E4, G4, E4, G4, QUARTER, G3
    ; .byte QUARTER, C4, EIGHTH, E4, G4, E4, G4, QUARTER, G3, G3, E4, C4, G4
    ; .byte QUARTER, C4, EIGHTH, E4, G4, E4, G4, QUARTER, G3, C4, EIGHTH, E4, G4, E4, G4, QUARTER, G3
    ; .byte QUARTER, C4, EIGHTH, E4, G4, E4, G4, QUARTER, G3, G4, E4, E3, G3
    ; .byte QUARTER, C4, EIGHTH, E4, G4, E4, G4, QUARTER, G3, C4, EIGHTH, E4, G4, E4, G4, QUARTER, G3
    ; .byte QUARTER, C4, rest, rest, rest, G4, G4, D4, E4
    .byte rest
    .byte SONG_LOOP
    .word song1_square1

song1_tri:
    .byte QUARTER, C4, E4, C4, E4, C4, E4, C4, E4, F4, A4, F4, A4, F4, A4, F4, A4  
    .byte QUARTER, C4, E4, C4, E4, C4, E4, C4, E4, G3, B3, G3, B3, G3, B3, G3, B3  
    .byte SONG_LOOP
    .word song1_tri


song1_noise:
    .byte HALF, $0D, $07, $0D, QUARTER, $07, $17
    .byte HALF, $0D, $07, $0D, QUARTER, $07, $17
    .byte HALF, $0D, $07, $0D, QUARTER, $07, $17
    .byte QUARTER, $0D, $0D, $07, $07
    .byte QUARTER, $0D, $0D, $07, $07
    .byte SONG_LOOP
    .word song1_noise