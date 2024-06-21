sound7_header:
    .byte $01           ;1 stream
    
    .byte SFX_2         ;which stream
    .byte $01           ;status byte (stream enabled)
    .byte NOISE      ;which channel
    .byte $70           ;initial duty (01)
    .byte ve_drum_decay ;volume envelope
    .word sound7_noise ;pointer to stream
    .byte $FF           ;tempo..very fast tempo
    
    
sound7_noise:
    .byte SIXTEENTH, $18, $17, $16, $15, $04, $03, $14, EIGHTH, $13, $14
    .byte endsound