sound2_header:
    .byte $01           ;1 stream
    
    .byte SFX_1         ;which stream
    .byte $01           ;status byte (stream enabled)
    .byte SQUARE_2      ;which channel
    .byte $70           ;initial duty (01)
    .byte ve_short_staccato ;volume envelope
    .word sound2_square2 ;pointer to stream
    .byte $FF           ;tempo..very fast tempo
    
    
sound2_square2:
    .byte THIRTYSECOND, C4, E4, G4, C5, E5, G5, C6, E6, G6, C7
    .byte endsound