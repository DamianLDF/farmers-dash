song2_header:
    .byte $03 
    
    .byte MUSIC_SQ1         ;which stream
    .byte $01           ;status byte (stream enabled)
    .byte SQUARE_1      ;which channel
    .byte $70           ;initial duty (01)
    .byte ve_short_staccato ;volume envelope
    .word song2_square1 ;pointer to stream
    .byte $80           ;tempo
    
    
    .byte MUSIC_TRI     ;which stream
    .byte $01           ;status byte (stream enabled)
    .byte TRIANGLE      ;which channel
    .byte $80           ;initial volume (on)
    .byte ve_short_staccato      ;volume envelope
    .word song2_tri     ;pointer to stream
    .byte $80           ;tempo
    
    .byte MUSIC_NOI     ;which stream
    .byte $01
    .byte NOISE
    .byte 30
    .byte ve_drum_decay
    .word song2_noise
    .byte $80

song2_square1:
    .byte WHOLE, rest, rest, rest, rest
    .byte SONG_LOOP
    .word song2_square1

song2_tri:
    .byte EIGHTH, C4, C4, QUARTER, E4, G4, EIGHTH, G4, G4
    .byte EIGHTH, C4, C4, QUARTER, E4, G4, EIGHTH, G4, G4
    .byte EIGHTH, G3, G3, QUARTER, B3, D4, EIGHTH, D4, D4
    .byte EIGHTH, G3, G3, QUARTER, B3, D4, EIGHTH, D4, D4
    .byte EIGHTH, A3, A3, QUARTER, C4, E4, EIGHTH, E4, E4
    .byte EIGHTH, A3, A3, QUARTER, C4, E4, EIGHTH, E4, E4
    .byte EIGHTH, F4, F4, QUARTER, A4, C5, EIGHTH, C5, C5
    .byte EIGHTH, F4, F4, QUARTER, A4, C5, EIGHTH, C5, C5
    .byte SONG_LOOP
    .word song2_tri


song2_noise:
    .byte HALF, $0D, QUARTER, $07, HALF, $0D, QUARTER, $0D, HALF, $07
    .byte SONG_LOOP
    .word song2_noise