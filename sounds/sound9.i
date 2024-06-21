sound9_header:
    .byte $01           ;1 stream
    
    .byte SFX_1         ;which stream
    .byte $01           ;status byte (stream enabled)
    .byte SQUARE_2      ;which channel
    .byte $70           ;initial duty (01)
    .byte ve_blip_echo ;volume envelope
    .word sound9_square2 ;pointer to stream
    .byte $C0           ;tempo..very fast tempo
    
    
sound9_square2:
    .byte QUARTER, E5, EIGHTH, A4, C5, E5, HALF, A5
    .byte endsound