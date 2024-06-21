sound5_header:
    .byte $01           ;1 stream
    
    .byte SFX_2         ;which stream
    .byte $01           ;status byte (stream enabled)
    .byte NOISE      ;which channel
    .byte $70           ;initial duty (01)
    .byte ve_drum_decay ;volume envelope
    .word sound5_noise ;pointer to stream
    .byte $FF           ;tempo..very fast tempo
    
    
sound5_noise:
    .byte THIRTYSECOND, $18, $17, $16, $15, $04, $03, $14, EIGHTH, $13, $14
    ;.byte THIRTYSECOND, $18, $17, $16, $15, $04, $03, $14, $13, $04, $03, $14, $13, $04, $03, $14, $13, $05, $06
    .byte endsound