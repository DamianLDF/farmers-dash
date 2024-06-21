MENU_FIRST_Y_POS = $70
MENU_OPTIONS_GAP = $18

menu_options:
    .byte $03   ; 3 options
    .byte $05   ; 5 chars long
    .byte $1C, $1D, $0A, $1B, $1D   ; START
    .byte $07   ; 7 chars long
    .byte $18, $19, $1D, $12, $18, $17, $1C ; OPTIONS
    .byte $07
    .byte $0C, $1B, $0E, $0D, $12, $1D, $1C ; CREDITS

menu_option_pointers:
    .byte GAME
    .byte OPTIONS
    .byte CREDITS

menu_cursor_data:
    ;       Y,  Sp,  At, X
    .byte   $70,$08,$21,$4E
    .byte   $70,$09,$21,$56
    .byte   $78,$18,$21,$4E
    .byte   $78,$19,$21,$56

    .rsset $0440 ;title and menu variables 
menu_selected    .rs 1   ; cursor position
menu_frame_count   .rs 1; flag for pending writing options
menu_run_sprite .rs 1   ; flag use run sprite

;----------
; init draw and process subroutines for main menu
;   A   Previous scene
menu_init:
    LDA #LOW(menu_update_cursor)
    sta draw_subroutine
    LDA #HIGH(menu_update_cursor)
    sta draw_subroutine+1

    LDA #LOW(menu_process)
    sta process_subroutine
    LDA #HIGH(menu_process)
    sta process_subroutine+1

    lda #$01
    sta menu_frame_count
    ldx #$00
    stx menu_selected

    jsr menu_draw

    rts

;----------
; draw menu box one time and switch to sprite DMA
menu_draw:

    ; Turn off screen and NMI to give time for name table update
    lda #$00
    sta $2001   ;turn PPU off
    lda #$08
    sta $2000   ;turn off NMIs
    jsr menu_draw_border

.vblank1:
    bit $2002
    bpl .vblank1

    ; Write options
    jsr menu_write_options

    ; Init sprite data
    LDA #$FF
    LDX #$00
.clear_spr_data:
    STA $0200, x ; sprite data
    INX
    BNE .clear_spr_data

    LDX #$10
.init_cursor:
    DEX
    LDA menu_cursor_data, x
    sta $0200, x
    txa
    bne .init_cursor

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

    RTS

;----------
; Draw menu border (also used in Options)
menu_draw_border:

    LDA #$21
    sta pointer1+1     ; High byte of address
    STA $2006             ; Top left of the menu border at $2188
    LDA #$88
    sta pointer1
    STA $2006
    LDA #$6D
    STA $2007

    LDA #$6F
    ldx #$0E
.top_border:
    STA $2007
    DEX
    BNE .top_border
    LDA #$6E
    STA $2007

    LDY #$0A    ; Menu middle part is 10 tiles high (menu border is 12 tiles high)
.middle:
    LDA #$20    ;   Add $20 to low byte of previous address = 1 row below in name table
    clc
    ADC pointer1
    STA pointer1
    LDA #$00    ; Add carry to high byte
    ADC pointer1+1
    STA pointer1+1

    STA $2006
    LDA pointer1
    sta $2006

    LDA #$7F
    STA $2007

    LDA #$2F
    ldx #$0E
.empty_menu_bg:
    STA $2007
    DEX
    BNE .empty_menu_bg
    LDA #$7F
    STA $2007
    DEY
    BNE .middle

;  Bottom border
    LDA #$20    ;   Add $20 to low byte of previous address = 1 row below in name table
    clc
    ADC pointer1
    STA pointer1
    LDA #$00    ; Add carry to high byte
    ADC pointer1+1
    STA pointer1+1

    STA $2006
    LDA pointer1
    sta $2006
    
    ; bottom left corner
    LDA #$7D
    STA $2007

    LDA #$6F
    ldx #$0E
.bottom_border:
    STA $2007
    DEX
    BNE .bottom_border
    
    LDA #$7E
    STA $2007

; Name table attributes
; 3 lines of 4x4 tiles, 4 bytes per line = 16x12 tiles
    LDA #$23
    sta pointer1+1     ; High byte of address
    LDA #$DA
    sta pointer1     ; Low byte of address
    ldx #$03
.update_attributes:
    lda pointer1+1
    STA $2006             ; Top left of the menu border at $2188
    lda pointer1     ; Low byte of address
    STA $2006
    LDA #%00000000
    STA $2007
    STA $2007
    STA $2007
    STA $2007
    
    LDA #$08
    CLC
    ADC pointer1
    sta pointer1
    dex
    bne .update_attributes

    rts

;----------
; Write option labels
menu_write_options:
    LDA #$ED    ; Start at $21ED (PPU VRAM)
    STA pointer1
    LDA #$21    ; Add carry to high byte
    STA pointer1+1

    LDX #$00
    LDA menu_options    ; options count
    STA count1
.fetch_text:
    INX
    LDY menu_options, x  ; char count for option
    
    LDA pointer1+1
    STA $2006
    LDA pointer1
    sta $2006

.show_char:
    INX
    LDA menu_options, x
    STA $2007
    DEY
    bne .show_char

    LDA #$60    ;   Add $60 address = 3 rows below
    clc
    ADC pointer1
    STA pointer1
    LDA #$00    ; Add carry to high byte
    ADC pointer1+1
    STA pointer1+1

    DEC count1
    BNE .fetch_text

    RTS

;-----------
; Animate and move cursor
menu_update_cursor:
    ; position
    LDA #MENU_FIRST_Y_POS
    LDX menu_selected
    beq .update_cursor_position
.set_cursor_position:
    clc
    adc #MENU_OPTIONS_GAP
    dex
    bne .set_cursor_position
.update_cursor_position:
    sta $0200
    sta $0204
    clc
    adc #$08
    sta $0208
    sta $020C

.cursor_sprite:
    lda menu_run_sprite
    bne .run
    ; first sprite
    lda #$09
    sta $0205
    lda #$18
    sta $0209
    lda #$19
    sta $020D
    jmp .update_sprites
.run:
    lda #$0B
    sta $0205
    lda #$1A
    sta $0209
    lda #$1B
    sta $020D
.update_sprites:
    lda #$00
    sta $2003
    lda #$02
    sta $4014
    RTS

;----------
; Process input for menu
menu_process:
    dec menu_frame_count
    bne .check_joypad_accept

    lda #$05
    sta menu_frame_count
    sta needdraw
    lda menu_run_sprite
    beq .set_run
    lda #$00
    sta menu_run_sprite
    jmp .check_joypad_accept
.set_run:
    lda #$01
    sta menu_run_sprite

.check_joypad_accept:
    lda joypad1_pressed
    and #$90 ;A or start
    beq .check_joypad_back
    lda #SFX_MENU_ACCEPT
    jsr sound_load
    ldx menu_selected
    lda menu_option_pointers, x
    jsr init_scene
    jmp .done
.check_joypad_back:
    lda joypad1_pressed
    and #$40 ;B
    beq .check_joypad_down
    lda #SFX_MENU_CANCEL
    jsr sound_load
    lda #TITLE
    jsr init_scene
    jmp .done
.check_joypad_down:
    lda joypad1_pressed
    and #$24 ;select or down
    beq .check_joypad_up
    lda #SFX_MENU_MOVE
    jsr sound_load
    sta needdraw
    inc menu_selected
    lda menu_selected
    cmp menu_options
    bne .done   ; if below last option, loop around
    lda #$00
    sta menu_selected
    jmp .done
.check_joypad_up:
    lda joypad1_pressed
    and #$08 ;up
    beq .done
    lda #SFX_MENU_MOVE
    jsr sound_load
    sta needdraw
    dec menu_selected
    bpl .done
    lda menu_options
    sta menu_selected
    dec menu_selected
    
.done:
    rts