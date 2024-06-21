soundA_header:
    .byte $01           ;1 stream
    
    .byte SFX_2         ;which stream
    .byte $01           ;status byte (stream enabled)
    .byte NOISE      ;which channel
    .byte $70           ;initial duty (01)
    .byte ve_drum_decay ;volume envelope
    .word soundA_noise ;pointer to stream
    .byte $FF           ;tempo..very fast tempo
    
    
soundA_noise:
    .byte SIXTEENTH, rest
    .byte endsound