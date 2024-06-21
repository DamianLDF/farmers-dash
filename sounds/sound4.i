sound4_header:
    .byte $01           ;1 stream
    
    .byte SFX_1         ;which stream
    .byte $01           ;status byte (stream enabled)
    .byte SQUARE_2      ;which channel
    .byte $70           ;initial duty (01)
    .byte ve_short_staccato ;volume envelope
    .word sound4_square2 ;pointer to stream
    .byte $FF           ;tempo..very fast tempo
    
    
sound4_square2:
    .byte THIRTYSECOND, G4,C5, E5, C5, G4, E4, C4, G3, E3, C3, C4, G3, E3, C3, EIGHTH, C3
    .byte endsound