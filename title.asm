
title_start_text:
    .byte $0B   ; 11 chars long
    .byte $19, $1B, $0E, $1C, $1C, $2F, $1C, $1D, $0A, $1B, $1D ; Press Start

    .rsset $0400 ;title and menu variables 
    
title_frame_counter   .rs 1   ; count frames to flicker start text at the title
title_show_text  .rs 1   ; text visible or not


;----------
; init draw and process subroutines
;   A   Previous scene
title_init:
    ; LDA #LOW(title_draw_bg)
    LDA #LOW(title_draw_text)
    sta draw_subroutine
    ; LDA #HIGH(title_draw_bg)
    LDA #HIGH(title_draw_text)
    sta draw_subroutine+1

    LDA #LOW(title_process)
    sta process_subroutine
    LDA #HIGH(title_process)
    sta process_subroutine+1
    
    lda #$00
    sta $2005
    sta $2005
    ; lda #$01            ;Needs to draw new scene
    ; sta needdraw
    jsr title_draw_bg

.done:
    rts

;----------------------------
; title_draw_bg    draws title screen
;   this is called once when going to the title screen
title_draw_bg:

    ; Turn off screen and NMI to give time for name table update
    lda #$00
    sta $2001   ;turn PPU off
    lda #$08
    sta $2000   ;turn off NMIs

    jsr wait_vblank

;set a couple palette colors.  This demo only uses two
    lda #$3F
    sta $2006
    lda #$00
    sta $2006   ;palette data starts at $3F00
    
    LDX #$00
.LoadPalettesLoop:
    LDA main_palette, x        ; load data from address (palette + the value in x)
    STA $2007             ; write to PPU
    INX                   ; X = X + 1
    CPX #$20              ; Compare X to hex $10, decimal 16 - copying 16 bytes = 4 sprites
    BNE .LoadPalettesLoop  ; Branch to LoadPalettesLoop if compare was Not Equal to zero
                          ; if compare was equal to 32, keep going down

    ; map background tiles
    LDA #$20
    STA $2006             ; write the high byte of $2000 address (top left tile)
    LDA #$00
    STA $2006             ; write the low byte of $2000 address 

    LDA #$00
    STA pointerLo1       ; put the low byte of the address of background into pointer
    LDA #HIGH(title_bg)
    STA pointerHi1       ; put the high byte of the address into pointer

    JSR copy_pointer_to_background

    ; Sky screen above for vertical scrolling to credits
    LDA #$28
    STA $2006             ; write the high byte of $2800 address (bottom left tile)
    LDA #$00
    STA $2006             ; write the low byte of $2800 address 

    LDA #$00
    STA pointerLo1       ; put the low byte of the address of background into pointer
    LDA #HIGH(credits_bg)
    STA pointerHi1       ; put the high byte of the address into pointer

    JSR copy_pointer_to_background

    LDA #$20
    STA $2006             ; write the high byte of $2800 address (bottom left tile)
    LDA #$00
    STA $2006             ; write the low byte of $2800 address 


    ; After first call, draw only the text
    LDA #LOW(title_draw_text)
    sta draw_subroutine
    LDA #HIGH(title_draw_text)
    sta draw_subroutine+1

    jsr wait_vblank

    ; Turn NMI and screen back on
    lda #$88
    sta $2000   ;enable NMIs
    lda #$0E
    sta $2001   ;turn PPU on, sprites off

    rts

;----------
; title_draw_text
title_draw_text:
    lda title_start_text    ; char count
    tax
    lda #$21
    sta $2006
    lda #$EB
    sta $2006
    lda title_show_text
    beq .show
.hide:
    lda #$00
    sta title_show_text
    lda #$2F    ; empty tile
.hide_loop:
    sta $2007
    dex
    bne .hide_loop
    jmp .done
.show:
    lda #$01
    sta title_show_text
    ldy #$01
.show_loop:
    lda title_start_text, y
    sta $2007
    iny
    dex
    bne .show_loop
.done:
    lda #$20    ;   Reset name table pointer to top left tile
    sta $2006
    lda #$00
    sta $2006

    rts

;----------
; title_process is called once after Vsync and reading joypad
title_process:

    inc title_frame_counter
    lda title_frame_counter
    cmp #$10
    bcc .check_joypad
    sta needdraw
    lda #$00
    sta title_frame_counter
.check_joypad
    lda joypad1_pressed
    and #$10 ;start
    beq .play_music
    lda #SFX_MENU_ACCEPT
    jsr sound_load
    lda #MENU
    jsr init_scene
.play_music:
    lda #MUSIC_TITLE
    cmp current_song
    beq .done
    jsr song_load
.done:
    RTS