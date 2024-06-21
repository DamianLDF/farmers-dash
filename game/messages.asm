
MESSAGE_WAITING_TIME = $40      ;   60 cycles: ~1 second at 60Hz (NTSC)
MESSAGE_BLINKING_ARROW_TIME = $20
MESSAGE_BLINKING_ARROW      = $9E
MESSAGE_BLINKING_EMPTY      = $2F

message_text_top:
    .byte   $6D,$6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F,$6E ; Top border
message_text_empty:
    .byte   $7F,$2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F,$2F,$7F ; Empty
message_text_bottom:
    .byte   $7D,$6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F,$6F,$7E ; bottom border
message_text_level1:
    .byte   $7F,$2F,$2F,$2F,$15,$0E,$1F,$0E,$15,$2F,$2F,$01,$2F,$2F,$2F,$7F ;|   Level  1   |
message_text_level2:
    .byte   $7F,$2F,$2F,$2F,$15,$0E,$1F,$0E,$15,$2F,$2F,$02,$2F,$2F,$2F,$7F ;|   Level  2   |
message_text_level3:
    .byte   $7F,$2F,$2F,$2F,$15,$0E,$1F,$0E,$15,$2F,$2F,$03,$2F,$2F,$2F,$7F ;|   Level  3   |
message_text_catch:
    .byte   $7F,$0C,$0A,$1D,$0C,$11,$2F,$1D,$11,$0E,$2F,$19,$12,$10,$1C,$7F ;|Catch the pigs|
message_text_bring:
    .byte   $7F,$0A,$17,$0D,$2F,$0B,$1B,$12,$17,$10,$2F,$1D,$11,$0E,$16,$7F ;|and bring them|
message_text_before:
    .byte   $7F,$12,$17,$1C,$12,$0D,$0E,$2F,$0B,$0E,$0F,$18,$1B,$0E,$26,$7F ;|inside before:|
message_text_inside:
    .byte   $7F,$2F,$2F,$2F,$2F,$12,$17,$1C,$12,$0D,$0E,$28,$2F,$2F,$2F,$7F ;|    inside.   |
message_text_1m:
    .byte   $7F,$2F,$2F,$2F,$2F,$2F,$00,$01,$26,$00,$00,$2F,$2F,$2F,$2F,$7F ;|     01:00    |
message_text_50s:
    .byte   $7F,$2F,$2F,$2F,$2F,$2F,$00,$00,$26,$05,$00,$2F,$2F,$2F,$2F,$7F ;|     00:50    |
message_text_40s:
    .byte   $7F,$2F,$2F,$2F,$2F,$2F,$00,$00,$26,$04,$00,$2F,$2F,$2F,$2F,$7F ;|     00:40    |
message_text_well_done:
    .byte   $7F,$2F,$2F,$20,$0E,$15,$15,$2F,$0D,$18,$17,$0E,$25,$2F,$2F,$7F ;|  Well done!  |
message_text_you_won:
    .byte   $7F,$2F,$2F,$27,$22,$18,$1E,$2F,$20,$18,$17,$25,$27,$2F,$2F,$7F ;|   You won!   |
message_text_try_again:
    .byte   $7F,$2F,$2F,$1D,$1B,$22,$27,$0A,$10,$0A,$12,$17,$25,$2F,$2F,$7F ;|  Try again!  |
message_text_time:
    .byte   $7F,$2F,$22,$18,$1E,$1B,$2F,$1D,$12,$16,$0E,$2F,$12,$1C,$26,$7F ;| your time is:|

message_background:
    .byte $4B,$3B,$4B,$5B,$3B,$4B,$3B,$4B,$5B,$3B,$4B,$3B,$4B,$5B,$3B,$4B
    .byte $5B,$3B,$4B,$3B,$4B,$5B,$3B,$4B,$3B,$4B,$5B,$4B,$5B,$3B,$4B,$5B
    .byte $4B,$5B,$3B,$4B,$5B,$3B,$4B,$5B,$3B,$4B,$5B,$3B,$4B,$5B,$3B,$4B
    .byte $5B,$3B,$4B,$3B,$4B,$5B,$3B,$4B,$3B,$4B,$5B,$4B,$5B,$3B,$4B,$5B
    .byte $3B,$4B,$5B,$3B,$4B,$5B,$3B,$4B,$5B,$3B,$4B,$5B,$3B,$4B,$5B,$3B
    .byte $4B,$3B,$4B,$5B,$3B,$4B,$3B,$4B,$5B,$3B,$4B,$3B,$4B,$5B,$3B,$4B
    .byte $5B,$3B,$4B,$3B,$4B,$5B,$3B,$4B,$3B,$4B,$5B,$4B,$5B,$3B,$4B,$5B
    .byte $4B,$5B,$3B,$4B,$5B,$3B,$4B,$5B,$3B,$4B,$5B,$3B,$4B,$5B,$3B,$4B

message_box_level1:
    .word message_text_top
    .word message_text_level1
    .word message_text_empty
    .word message_text_catch
    .word message_text_bring
    ; .word message_text_before
    ; .word message_text_1m
    .word message_text_inside
    .word message_text_empty
    .word message_text_bottom

message_box_level2:
    .word message_text_top
    .word message_text_level2
    .word message_text_empty
    .word message_text_catch
    .word message_text_bring
    ; .word message_text_before
    ; .word message_text_50s
    .word message_text_inside
    .word message_text_empty
    .word message_text_bottom

message_box_level3:
    .word message_text_top
    .word message_text_level3
    .word message_text_empty
    .word message_text_catch
    .word message_text_bring
    ; .word message_text_before
    ; .word message_text_40s
    .word message_text_inside
    .word message_text_empty
    .word message_text_bottom


message_box_well_done1:
    .word message_text_top
    .word message_text_level1
    .word message_text_empty
    .word message_text_empty
    .word message_text_well_done
    .word message_text_empty
    .word message_text_empty
    .word message_text_bottom

message_box_well_done2:
    .word message_text_top
    .word message_text_level2
    .word message_text_empty
    .word message_text_empty
    .word message_text_well_done
    .word message_text_empty
    .word message_text_empty
    .word message_text_bottom


message_box_well_done3:
    .word message_text_top
    .word message_text_empty
    .word message_text_empty
    .word message_text_you_won
    .word message_text_empty
    .word message_text_empty
    .word message_text_empty
    .word message_text_bottom
    
;----------
; init with the message subroutines 
message_init:
    
    lda #MESSAGE_WAITING_TIME
    sta message_timer

    LDA #LOW(message_wait)
    sta process_subroutine
    LDA #HIGH(message_wait)
    sta process_subroutine+1

    rts

;----------
; Redraws only with message
;   pointer3    should point to (the first byte of) the message box to show
message_custom_message:
    
    ; Turn off screen and NMI to give time for name table update
    lda #$08
    sta $2000   ;turn off NMIs
    lda #$00
    sta $2001   ;turn PPU off

    jsr wait_vblank
    jsr game_draw_message
    jsr wait_vblank

    ; After first call, wait for a while
    LDA #LOW(do_nothing)
    sta draw_subroutine
    LDA #HIGH(do_nothing)
    sta draw_subroutine+1
    
    ; Turn NMI and screen back on
    lda #$88
    sta $2000   ;enable NMIs
    lda #$0E
    sta $2001   ;turn PPU on, sprites off

    rts

;----------
; Draw a message during PPU off
;   pointer3    should point to (the first byte of) the message box to show
game_draw_message:

    lda #$08    ; each message is 8 lines
    sta count1

    LDA #$21
    sta pointer1+1     ; High byte of address
    LDA #$88            ; Top left of the menu border at $2188
    sta pointer1

    ldx #$00

.copy_line:
    LDA pointer1+1
    STA $2006
    LDA pointer1
    STA $2006

    ldy #$00
    lda [pointer3],y
    sta pointer2
    iny
    lda [pointer3],y
    sta pointer2+1

    ldy #$00
.copy_char:
    lda [pointer2],y
    STA $2007
    iny
    cpy #$10    ; 16 bytes of data for each line
    bne .copy_char

    inx ; move 2 bytes forward for next address
    inx

    lda #$20    ; move to the row below in name table
    clc
    adc pointer1
    sta pointer1
    lda #$00
    adc pointer1+1
    sta pointer1+1
    
    lda #$02    ; move to the row below in name table
    clc
    adc pointer3
    sta pointer3
    lda #$00
    adc pointer3+1
    sta pointer3+1

    dec count1
    bne .copy_line

; Name table attributes
; 2 lines of 4x4 tiles, 4 bytes per line = 16x8 tiles
    LDA #$23
    sta pointer1+1     ; High byte of address
    LDA #$DA
    sta pointer1     ; Low byte of address
    ldx #$02
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

.done
    ; scroll back to top-left tile
    LDA #$20
    STA $2006             
    LDA #$00
    STA $2006           

    rts

;----------
; Draw blinking arrow on message
message_draw_blink:
    
    LDA #$22
    sta $2006     ; High byte of address
    LDA #$56           ; bottom left of the menu border
    sta $2006
    lda message_blink
    sta $2007
    
    ; scroll back to top-left tile
    LDA #$20
    STA $2006             
    LDA #$00
    STA $2006         
    rts


;----------
; Draw background tiles / remove message box
message_draw_background:

    ; Turn off screen and NMI to give time for name table update
    lda #$08
    sta $2000   ;turn off NMIs
    lda #$00
    sta $2001   ;turn PPU off

    lda #$08    ; each line is 8 lines
    sta count1
    
    jsr wait_vblank

    LDA #$21
    sta pointer1+1     ; High byte of address
    LDA #$88            ; Top left of the menu border at $2188
    sta pointer1

    ldx #$00
.copy_line:
    LDA pointer1+1
    STA $2006
    LDA pointer1
    STA $2006

.copy_char:
    lda message_background,x
    STA $2007
    inx
    txa
    and #$0F    ; 16 bytes of data for each line
    bne .copy_char

    lda #$20    ; move to the row below in name table
    clc
    adc pointer1
    sta pointer1
    lda #$00
    adc pointer1+1
    sta pointer1+1

    dec count1
    bne .copy_line


; Name table attributes
; 2 lines of 4x4 tiles, 4 bytes per line = 16x8 tiles
    LDA #$23
    sta pointer1+1     ; High byte of address
    LDA #$DA
    sta pointer1     ; Low byte of address
    ldx #$02
.update_attributes:
    lda pointer1+1
    STA $2006             ; Top left of the menu border at $2188
    lda pointer1     ; Low byte of address
    STA $2006
    LDA #%10101010
    STA $2007
    STA $2007
    STA $2007
    STA $2007
    
    LDA #$08    ; move to next attributes line
    CLC
    ADC pointer1
    sta pointer1
    dex
    bne .update_attributes

.done
    ; scroll back to top-left tile
    LDA #$20
    STA $2006             
    LDA #$00
    STA $2006           

    LDA #LOW(game_draw)
    sta draw_subroutine
    LDA #HIGH(game_draw)
    sta draw_subroutine+1

    LDA #LOW(game_process)
    sta process_subroutine
    LDA #HIGH(game_process)
    sta process_subroutine+1

    jsr wait_vblank

    ; Turn NMI and screen back on
    lda #$88
    sta $2000   ;enable NMIs
    lda #$1E
    sta $2001   ;turn PPU on, sprites on

    rts

;----------
; Wait a bit after showing the message
message_wait:

    LDA #LOW(do_nothing)
    sta draw_subroutine
    LDA #HIGH(do_nothing)
    sta draw_subroutine+1

    dec message_timer
    bne .done

    lda #MESSAGE_BLINKING_ARROW
    sta message_blink
    sta needdraw
    lda #MESSAGE_BLINKING_ARROW_TIME
    sta message_timer

    LDA #LOW(message_draw_blink)
    sta draw_subroutine
    LDA #HIGH(message_draw_blink)
    sta draw_subroutine+1

    LDA #LOW(message_wait_for_input)
    sta process_subroutine
    LDA #HIGH(message_wait_for_input)
    sta process_subroutine+1

.done:
    rts

;----------
; Wait until the player presses a button
message_wait_for_input:
    dec message_timer
    bne .check_joypad

    lda #MESSAGE_BLINKING_ARROW_TIME
    sta message_timer
    sta needdraw

    lda message_blink
    cmp #MESSAGE_BLINKING_EMPTY
    beq .set_arrow
    LDa #MESSAGE_BLINKING_EMPTY
    sta message_blink
    jmp .check_joypad
.set_arrow:
    LDa #MESSAGE_BLINKING_ARROW
    sta message_blink

.check_joypad:
    lda joypad1_pressed
    beq .done

    LDA #LOW(message_draw_background)
    sta draw_subroutine
    LDA #HIGH(message_draw_background)
    sta draw_subroutine+1

    LDA #LOW(do_nothing)
    sta process_subroutine
    LDA #HIGH(do_nothing)
    sta process_subroutine+1
    sta needdraw

.done:
    rts