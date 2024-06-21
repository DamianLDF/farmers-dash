OPTIONS_FIRST_Y_POS = $70
OPTIONS_LABEL_GAP = $10

option_labels:
    .byte $04   ; 4 options
    .byte $05   ; 5 chars long
    .byte $16, $1E, $1C, $12, $0C ; MUSIC
    .byte $05   ; 5 chars long
    .byte $1C, $18, $1E, $17, $0D   ; SOUND
    .byte $06
    .byte $1F, $18, $15, $1E, $16, $0E ; VOLUME
    .byte $04
    .byte $0B, $0A, $0C, $14 ; BACK

options_cursor_data:
    ;       Y,  Sp,  At, X
    .byte   $68,$08,$21,$4E
    .byte   $68,$09,$21,$56
    .byte   $70,$18,$21,$4E
    .byte   $70,$19,$21,$56

options_actions:    ; action depending on cursor position
    .word options_play_song     ; Music
    .word options_play_sound    ; SFX
    .word options_switch_volume ; Volume
    .word options_back          ; Back

options_next:
    .word options_next_song
    .word options_next_sound
    .word options_switch_volume
    .word do_nothing

options_prev:
    .word options_prev_song
    .word options_prev_sound
    .word options_switch_volume
    .word do_nothing

    .rsset $0480 ;title and menu variables 
options_previous_scene  .rs 1   ; previous scene index
options_selected    .rs 1   ; cursor position
options_sfx .rs 1   ; selected sound fx
options_music   .rs 1   ; selected song

;----------
; init options subroutines
;   A   Previous scene
options_init:
    sta options_previous_scene

    LDA #LOW(options_update)
    sta draw_subroutine
    LDA #HIGH(options_update)
    sta draw_subroutine+1

    LDA #LOW(options_process)
    sta process_subroutine
    LDA #HIGH(options_process)
    sta process_subroutine+1
    
    lda #$01            ;Needs to draw new scene
    sta needdraw
    sta options_sfx
    sta options_music
    lda #$03
    sta options_selected

    jsr options_draw

    rts

;----------
; Draw options box
options_draw:

    ; Turn off screen and NMI to give time for name table update
    lda #$00
    sta $2001   ;turn PPU off
    lda #$08
    sta $2000   ;turn off NMIs

.vblank1:
    bit $2002
    bpl .vblank1

    jsr menu_draw_border

    ; Write options
    jsr options_write_options

    LDX #$10 ; 16 bytes of cursor data
.init_cursor:
    DEX
    LDA options_cursor_data, x
    sta $0200, x
    txa
    bne .init_cursor
    jsr update_cursor_position

    lda #$00
    sta $2003
    lda #$02
    sta $4014

    lda #$20    ;   Reset name table pointer to top left tile
    sta $2006
    lda #$00
    sta $2006

.vblank2:
    bit $2002
    bpl .vblank2

    ; Turn NMI back on
    lda #$88
    sta $2000   ;enable NMIs
    lda #$1E
    sta $2001   ;turn PPU on, sprites on

    rts

;----------
; Write option labels
options_write_options:
    LDA #$ED    ; Start at $21ED (PPU VRAM)
    STA pointer1
    LDA #$21    ; Add carry to high byte
    STA pointer1+1

    LDX #$00
    LDA option_labels    ; options count
    STA count1
.fetch_text:
    INX
    LDY option_labels, x  ; char count for option
    
    LDA pointer1+1
    STA $2006
    LDA pointer1
    sta $2006

.show_char:
    INX
    LDA option_labels, x
    STA $2007
    DEY
    bne .show_char

    LDA #$40    ;   Add $40 address = 2 rows below
    clc
    ADC pointer1
    STA pointer1
    LDA #$00    ; Add carry to high byte
    ADC pointer1+1
    STA pointer1+1

    DEC count1
    BNE .fetch_text

    rts

;----------
; Update options on screen
options_update:
    ; Option values
    LDA #$21    ; Song number start at $21F4 (PPU VRAM)
    STA $2006
    LDA #$F4
    STA $2006
    LDA options_music
    jsr get_second_digit
    STA $2007
    LDA options_music
    jsr get_first_digit
    STA $2007

    LDA #$22    ; Sound FX number start at $2234 (PPU VRAM)
    STA $2006
    LDA #$34
    STA $2006
    LDA options_sfx
    jsr get_second_digit
    STA $2007
    LDA options_sfx
    jsr get_first_digit
    STA $2007

    LDA #$22    ; Volume status start at $2274 (PPU VRAM)
    STA $2006
    LDA #$74
    STA $2006
    LDA #$18
    STA $2007
    LDA sound_disable_flag
    bne .sound_off  ; if flag is set, sound is disabled 
    LDA #$17
    STA $2007
    LDA #$2F
    STA $2007
    jmp .update_sprites
.sound_off:
    LDA #$0F
    STA $2007
    STA $2007

.update_sprites: ; Sprite DMA address $0200
    lda #$00
    sta $2003
    lda #$02
    sta $4014

    lda #$20    ;   Reset name table pointer to top left tile
    sta $2006
    lda #$00
    sta $2006

    RTS

;----------
; Process options input
options_process:
    dec menu_frame_count
    bne .check_joypad_accept
    jsr update_cursor_sprite
.check_joypad_accept:
    lda joypad1_pressed
    and #$90 ;A or start
    beq .check_joypad_back
    jsr options_accept
    jmp .done
.check_joypad_back:
    lda joypad1_pressed
    and #$40 ;B
    beq .check_joypad_left
    jsr options_back
    jmp .done
.check_joypad_left:
    lda joypad1_pressed
    and #$02 ;Left
    beq .check_joypad_right
    jsr options_go_prev
    jmp .done
.check_joypad_right:
    lda joypad1_pressed
    and #$01 ;Right
    beq .check_joypad_down
    jsr options_go_next
    jmp .done
.check_joypad_down:
    lda joypad1_pressed
    and #$24 ;select or down
    beq .check_joypad_up
    inc options_selected
    lda options_selected
    cmp option_labels
    bne .update_cursor_down   ; if below last option, loop around
    lda #$00
    sta options_selected
.update_cursor_down:
    jsr update_cursor_position
    jmp .done
.check_joypad_up:
    lda joypad1_pressed
    and #$08 ;up
    beq .done
    dec options_selected
    bpl .update_cursor_up
    lda option_labels
    sta options_selected
    dec options_selected
.update_cursor_up:
    jsr update_cursor_position
.done:
    rts

;----------
; Update cursor's sprites positions
update_cursor_position:
    lda #SFX_MENU_MOVE
    jsr sound_load
    sta needdraw

    LDA #OPTIONS_FIRST_Y_POS
    LDX options_selected
    beq .update_position
.set_cursor_position:
    clc
    adc #OPTIONS_LABEL_GAP
    dex
    bne .set_cursor_position
.update_position:
    sta $0200
    sta $0204
    clc
    adc #$08
    sta $0208
    sta $020C
    rts

;----------
; Update cursor sprite (animation)
update_cursor_sprite:
    lda #$05
    sta menu_frame_count
    sta needdraw
    lda menu_run_sprite
    beq .set_run
    lda #$00
    sta menu_run_sprite
    ; first sprite
    lda #$09
    sta $0205
    lda #$18
    sta $0209
    lda #$19
    sta $020D
    jmp .done

    jmp .done
.set_run:
    lda #$01
    sta menu_run_sprite
    ; run sprite
    lda #$0B
    sta $0205
    lda #$1A
    sta $0209
    lda #$1B
    sta $020D
.done
    rts

;----------
; Execute one of the options from the options menu
options_accept:
    lda options_selected
    asl A
    tax
    lda options_actions, x
    sta pointer1
    lda options_actions+1, x
    sta pointer1+1
    jmp [pointer1]

options_go_prev:
    lda options_selected
    asl A
    tax
    lda options_prev, x
    sta pointer1
    lda options_prev+1, x
    sta pointer1+1
    jmp [pointer1]

options_go_next:
    lda options_selected
    asl A
    tax
    lda options_next, x
    sta pointer1
    lda options_next+1, x
    sta pointer1+1
    jmp [pointer1]

;----------
; select previous sound FX
options_prev_sound:
    dec options_sfx
    bpl .done
    lda #NUM_SOUNDS
    sta options_sfx
.done:
    lda #$01
    sta needdraw
    rts
;----------
; Select next Sound FX
options_next_sound:
    lda options_sfx
    cmp #NUM_SOUNDS
    bcs .wrap_around
    inc options_sfx
    jmp .done
.wrap_around:
    lda #$00
    sta options_sfx 
.done:
    lda #$01
    sta needdraw
    rts

;----------
; Play the selected sound
options_play_sound:
    lda options_sfx
    jsr sound_load
    rts

;----------
; Go to previous song
options_prev_song:
    dec options_music
    bpl .done
    lda #NUM_SONGS
    sta options_music
.done:
    lda #$01
    sta needdraw
    rts
options_next_song:
    lda options_music
    cmp #NUM_SONGS
    bcs .wrap_around
    inc options_music
    jmp .done
.wrap_around:
    lda #$00
    sta options_music
.done:
    lda #$01
    sta needdraw
    rts

;----------
; Play the selected song
options_play_song:
    lda options_music
    jsr song_load
    rts

;----------
; switch volume disable flag
options_switch_volume:
    LDA sound_disable_flag
    beq .disable
    jsr sound_init
    lda #SFX_MENU_ACCEPT
    jsr sound_load
    jmp .done
.disable:
    jsr sound_disable
.done:
    rts

;----------
; Go back to main menu
options_back:
    lda #SFX_MENU_CANCEL
    jsr sound_load
    lda options_previous_scene
    jsr init_scene

    rts