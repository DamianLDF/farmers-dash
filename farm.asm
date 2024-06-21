    .inesprg 2 ;2x 16kb PRG code
    .ineschr 1 ;1x 8kb CHR data
    .inesmap 0 ; mapper 0 = NROM, no bank swapping
    .inesmir 0 ;background mirroring (horizontal)


; Joypad button values
J1_A        =   $80
J1_B        =   $40
J1_SELECT   =   $20
J1_START    =   $10
J1_UP       =   $08
J1_DOWN     =   $04
J1_LEFT     =   $02
J1_RIGHT    =   $01

    .rsset $0000
joypad1 .rs 1           ;button states for the current frame
joypad1_old .rs 1       ;last frame's button states
joypad1_pressed .rs 1   ;current frame's off_to_on transitions
sleeping .rs 1          ;main program sets this and waits for the NMI to clear it.  Ensures the main program is run only once per frame.  
                        ;   for more information, see Disch's document: http://nesdevhandbook.googlepages.com/theframe.html
needdraw .rs 1          ;drawing flag.
dbuffer_index .rs 1     ;current position in the drawing buffer
sound_ptr .rs 2
sound_ptr2 .rs 2
current_song .rs 1

pointerLo  .rs 1   ; pointer variables are declared in RAM
pointerHi  .rs 1   ; low byte first, high byte immediately after
pointerLo1  .rs 1   ; pointer variables are declared in RAM
pointerHi1  .rs 1   ; low byte first, high byte immediately after

current_scene .rs 1
draw_subroutine .rs 2
process_subroutine  .rs 2

pointer1 .rs 2              ;a pointer
pointer2 .rs 2              ;a pointer
pointer3 .rs 2              ;a pointer
count1 .rs 1              ;a counter for quantities
count2 .rs 1              ;a counter for quantities

rng_pointer .rs 1           ; a pointer shift in the RNG table

;----- first 8k bank of PRG-ROM
    .bank 0
    .org $8000  ;we have two 16k PRG banks now.  We will stick our sound engine in the first one, which starts at $8000.
    
    .include "sound_engine/sound_engine.asm"

;----- second 8k bank of PRG-ROM    
    .bank 1
    .org $A000
    .include "game_bg.i"
game_palette:
    .db  $1A,$1D,$00,$20,  $1A,$1D,$06,$35,  $1A,$08,$1A,$2A,  $1A,$08,$07,$18   ; background palette
    .db  $1A,$1D,$21,$36,  $1A,$1D,$25,$35,  $1A,$1D,$07,$27,  $1A,$02,$38,$3C   ; sprite palette
    .include "game.asm"
    
;----- third 8k bank of PRG-ROM    
    .bank 2
    .org $C000
    

RESET:
    SEI          ; disable IRQs
    CLD          ; disable decimal mode
    LDX #$FF
    TXS          ; Set up stack
    INX          ; now X = 0
    
vblankwait1:       ; First wait for vblank to make sure PPU is ready
    BIT $2002
    BPL vblankwait1

clrmem:
    LDA #$00
    STA $0000, x ; general variables
    STA $0100, x 
    STA $0300, x ; sound system
    STA $0400, x ; title and menu
    STA $0500, x ; game data
    STA $0600, x
    STA $0700, x
    LDA #$F0
    STA $0200, x ; sprite data
    INX
    BNE clrmem
    
vblankwait2:      ; Second wait for vblank, PPU is ready after this
    bit $2002
    bpl vblankwait2

    lda #TITLE
    jsr init_scene
    jsr call_draw_subroutine
    
;Enable sound channels
    jsr sound_init

forever:
    inc sleeping ;go to sleep (wait for NMI).
.loop:
    inc rng_pointer
    lda sleeping
    bne .loop ;wait for NMI to clear the sleeping flag and wake us up
    
    ;when NMI wakes us up, handle input, fill the drawing buffer and go back to sleep
    jsr read_joypad
    jsr call_process_subroutine
    jmp forever ;go back to sleep
    
    
irq:
    rti
NMI:
    pha     ;save registers
    txa
    pha
    tya
    pha
    
    ;do sprite DMA
    ;update palettes if needed
    ;draw stuff on the screen
    
    lda needdraw
    beq .drawing_done   ;if drawing flag is clear, skip drawing
    lda $2002           ;else, draw
    jsr call_draw_subroutine
    lda #$00            ;finished drawing, so clear drawing flag
    sta needdraw
    
.drawing_done:
    
    jsr sound_play_frame    ;run our sound engine after all drawing code is done.
                            ;this ensures our sound engine gets run once per frame.
                            
    lda #$00
    sta sleeping            ;wake up the main program
    
    pla     ;restore registers
    tay
    pla
    tax
    pla
    rti

;----------
; call_draw_subroutine 
call_draw_subroutine:
    jmp [draw_subroutine]

;----------
; call_process_subroutine
call_process_subroutine:
    jmp [process_subroutine]
    
;----------------------------
; read_joypad will capture the current button state and store it in joypad1.  
;       Off-to-on transitions will be stored in joypad1_pressed
read_joypad:
    lda joypad1
    sta joypad1_old ;save last frame's joypad button states
    
    lda #$01
    sta $4016
    lda #$00
    sta $4016
    
    ldx #$08
.loop:    
    lda $4016
    lsr a
    rol joypad1  ;A, B, select, start, up, down, left, right
    dex
    bne .loop
    
    lda joypad1_old ;what was pressed last frame.  EOR to flip all the bits to find ...
    eor #$FF    ;what was not pressed last frame
    and joypad1 ;what is pressed this frame
    sta joypad1_pressed ;stores off-to-on transitions
;----------
; Used for sub routine pointers that do not need to do anything
do_nothing:
    rts

;----------
; init_scene    updates current_scene and calls init subroutine
;   A:  Scene
init_scene:
    ldx current_scene
    sta current_scene
    asl a
    tay
    lda scene_inits, y
    sta pointer1
    lda scene_inits+1, y
    sta pointer1+1
    txa
    jmp [pointer1]
    ; RTS expected inside the subroutine


scene_inits:
    .word title_init
    .word menu_init
    .word options_init
    .word credits_init
    .word game_init

TITLE   = $00
MENU    = $01
OPTIONS = $02
CREDITS = $03
GAME    = $04

    .include "common.asm"

;----- fourth 8k bank of PRG-ROM    
    .bank 3
    .org $E000    
    .include "title_bg.i"   ; needs to start at a position XX00 for the drawing routine to work
    .include "credits_bg.i"   ; needs to start at a position XX00 for the drawing routine to work
    .include "field_bg.i"   ; needs to start at a position XX00 for the drawing routine to work
    .include "rng_table.i"  ; Random Number Generator table
main_palette:
    .db $22,$1D,$10,$20,  $22,$1D,$17,$35,  $22,$08,$1A,$2A,  $22,$1D,$25,$35   ; title background palette
    .db $22,$1D,$21,$36,  $22,$1D,$25,$35,  $22,$1D,$07,$27,  $22,$02,$38,$3C   ; sprite palette

    .include "title.asm"
    .include "menu.asm"
    .include "options.asm"
    .include "credits.asm"
    
;---- vectors
    .org $FFFA     ;first of the three vectors starts here
    .dw NMI        ;when an NMI happens (once per frame if enabled) the 
                   ;processor will jump to the label NMI:
    .dw RESET      ;when the processor first turns on or is reset, it will jump
                   ;to the label RESET:
    .dw irq        ;external interrupt IRQ is not used in this tutorial
    
    .bank 4
    .org $0000
    .incbin "bg.chr"
    .incbin "sprites.chr"