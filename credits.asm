


    .rsset $04C0 ;title and menu variables 
credits_frame_count    .rs 1   ; frame count for animation
credits_scroll_pos  .rs 1   ; screen scrolling position

;----------
; inits credits scene
;   A   previous scene index
credits_init:
    lda #$00
    sta credits_scroll_pos

    LDA #LOW(credits_switch_screen)
    sta draw_subroutine
    LDA #HIGH(credits_switch_screen)
    sta draw_subroutine+1

    LDA #LOW(credits_scroll_in)
    sta process_subroutine
    LDA #HIGH(credits_scroll_in)
    sta process_subroutine+1
    rts

;----------
; Drawing routine for credits
credits_switch_screen:
    lda #$8A
    sta $2000   ;Change mapped page to $2800 (bottom left)
    lda #$0E
    sta $2001   ;turn PPU on, sprites off
    
    LDA #LOW(do_nothing)
    sta draw_subroutine
    LDA #HIGH(do_nothing)
    sta draw_subroutine+1
    rts

;----------
; Scroll screen
credits_scroll_in:
    lda #$F8
    sta needdraw
    clc
    adc credits_scroll_pos
    sta credits_scroll_pos
    ldx #$00
    stx $2005   ; Horizontal scroll (none)
    sta $2005   ; Vertical scroll
    cmp #$10
    bne .done

    ; stop scrolling
    LDA #LOW(credits_process)
    sta process_subroutine
    LDA #HIGH(credits_process)
    sta process_subroutine+1
.done:
    rts

;----------;
; Credits input processing
credits_process:
    lda joypad1_pressed
    beq .done
    lda #SFX_MENU_ACCEPT
    jsr sound_load

    ; scroll back down
    LDA #LOW(credits_scroll_out)
    sta process_subroutine
    LDA #HIGH(credits_scroll_out)
    sta process_subroutine+1
.done:
    rts

;----------
; Scroll screen
credits_scroll_out:
    lda #$08
    ; sta needdraw
    clc
    adc credits_scroll_pos
    sta credits_scroll_pos
    ldx #$00
    stx $2005   ; Horizontal scroll (none)
    sta $2005   ; Vertical scroll
    cmp #$F8
    bne .done

    ; stop scrolling
    lda #MENU
    jsr init_scene
.done:
    rts