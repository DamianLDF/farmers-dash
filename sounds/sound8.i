sound8_header:
    .byte $01           ;1 stream
    
    .byte SFX_1         ;which stream
    .byte $01           ;status byte (stream enabled)
    .byte SQUARE_2      ;which channel
    .byte $70           ;initial duty (01)
    .byte ve_short_staccato ;volume envelope
    .word sound8_square2 ;pointer to stream
    .byte $FF           ;tempo..very fast tempo
    
    
sound8_square2:
    .byte EIGHTH, D3, A3, F4, D4, A4, F5
    .byte endsound