
;----------
; Get lowest decimal digit from value
;   A   Value to get the digit from
;   Returns value $00-$09 in A
get_first_digit:
    cmp #10
    bcc .done
    clc
    adc #246    ;   -10
    jmp get_first_digit
.done:
    rts

;----------
; Get second lowest decimal digit from value
;   A   Value to get the digit from
;   Returns value $00-$09 in A
get_second_digit:
    cmp #100
    bcc .sum
    clc
    adc #156    ;   -100
    jmp get_second_digit
.sum:
    ldx #0
.add:
    cmp #10
    bcc .done
    clc
    adc #246    ;-10
    inx
    jmp .add
.done:
    txa
    rts

;----------
; Sets Accumulator with a random number 00-FF
;   returns A   Random number
get_random_number:
    ldy rng_pointer
    lda rng_table, y 
    inc rng_pointer
    rts

;----------
; Name table fill subroutine. Copies 32x30 tiles and 64 bytes of palette data
copy_pointer_to_background:
    LDX #$00            ; start at pointer + 0
    LDY #$00
.OutsideLoop:
  
.InsideLoop:
    LDA [pointerLo1], y  ; copy one background byte from address in pointer plus Y
    STA $2007           ; this runs 256 * 4 times
    
    INY                 ; inside loop counter
    CPY #$00
    BNE .InsideLoop      ; run the inside loop 256 times before continuing down
    
    INC pointerHi1       ; low byte went 0 to 256, so high byte needs to be changed now
    
    INX
    CPX #$04
    BNE .OutsideLoop     ; run the outside loop 256 times before continuing down

    RTS

;----------
; Wait for VBlank
wait_vblank:
    bit $2002
    bpl wait_vblank
    rts