
FARMER_FRAME_DELTA = $40    ; sums until carry flag, then advances 1 frame

MAX_X_SPEED = $01
MAX_XD_SPEED = $80
MIN_X_SPEED = $FE
MIN_XD_SPEED = $80
MAX_Y_SPEED = $01
MAX_YD_SPEED = $00
MIN_Y_SPEED = $FF
MIN_YD_SPEED = $00

; Delta from farmer position and distance from that spot to the pig
FARMER_CATCH_DIFF_X     = $06
FARMER_CATCH_DIFF_X_M   = $FA
FARMER_CATCH_DIFF_Y     = $04
FARMER_CATCH_DIFF_Y_M   = $FC
FARMER_CATCH_DISTANCE_X   = $0F
FARMER_CATCH_DISTANCE_Y   = $0A

FARMER_HOLDING_HEIGHT   = $FD

FARMER_HOLDING_PIG  =   $FF ;   Status


;----------
; Player 1 input, as a farmer
;   X   Actor data pointer delta
farmer_input_p1:
    lda #$00
    sta game_coord_flags

    lda joypad1
    and #J1_UP
    beq .joypad_down
    lda #MIN_Y_SPEED
    sta game_actor_speed_y,x
    lda #MIN_YD_SPEED
    sta game_actor_speed_yd,x
    inc game_coord_flags
    jmp .joypad_left
.joypad_down:
    lda joypad1
    and #J1_DOWN
    beq .no_y_input
    lda #MAX_Y_SPEED
    sta game_actor_speed_y,x
    lda #MAX_YD_SPEED
    sta game_actor_speed_yd,x
    inc game_coord_flags
    inc game_coord_flags
    jmp .joypad_left
.no_y_input:
    lda #$00
    sta game_actor_speed_y,x
    sta game_actor_speed_yd,x
.joypad_left:
    lda joypad1
    and #J1_LEFT
    beq .joypad_right
    lda #MIN_X_SPEED
    sta game_actor_speed_x,x
    lda #MIN_XD_SPEED
    sta game_actor_speed_xd,x
    lda #DIR_FLAG_LEFT
    clc
    adc game_coord_flags
    sta game_coord_flags
    jmp .joypad_a
.joypad_right:
    lda joypad1
    and #J1_RIGHT
    beq .no_x_input
    lda #MAX_X_SPEED
    sta game_actor_speed_x,x
    lda #MAX_XD_SPEED
    sta game_actor_speed_xd,x
    lda #DIR_FLAG_RIGHT
    clc
    adc game_coord_flags
    sta game_coord_flags
    jmp .joypad_a
.no_x_input
    lda #$00
    sta game_actor_speed_x,x
    sta game_actor_speed_xd,x
.joypad_a:
    lda joypad1_pressed
    and #J1_A
    beq .check_hold
    jsr farmer_try_catch
.check_hold:
    lda game_actor_status,x
    cmp #FARMER_HOLDING_PIG
    bne .done
    lda joypad1
    and #J1_A
    beq .release_pig
    jsr farmer_move_pig_along
    jsr bring_pig_inside
    jmp .done
.release_pig
    jsr farmer_release_pig
.done:
    rts

;----------
; Check if there is a pig nearby and catch it
;   X                   Actor data pointer delta
farmer_try_catch:
    jsr farmer_get_catching_diff_pos

.make_diff_negative:
    lda game_diff_x
    eor #$FF
    clc
    adc #$01
    sta game_diff_x
    lda game_diff_y
    eor #$FF
    clc
    adc #$01
    sta game_diff_y

.look_for_pigs:
    ldy #$00
    sty count1
.check_next_pig:
    lda game_actor_char,y
    cmp #ACTOR_CHAR_PIG
    bne .continue_loop
    ; check pig distance to farmer
    lda game_actor_x,y
    clc
    adc game_diff_x
    bpl .check_x_distance
    eor #$FF
    clc
    adc #$01
.check_x_distance:
    cmp #FARMER_CATCH_DISTANCE_X
    bcs .continue_loop

    lda game_actor_y,y
    clc
    adc game_diff_y
    bpl .check_y_distance
    eor #$FF
    clc
    adc #$01
.check_y_distance:
    cmp #FARMER_CATCH_DISTANCE_Y
    bcs .continue_loop
    ; pig within catch distance. Catch it!
    lda #FARMER_HOLDING_PIG
    sta game_actor_status,x ;   Farmer is holding pig
    sta game_actor_status,y ;   Pig is being held
    tya
    sta game_actor_status_timer,x ; keep reference of which pig is holding
    lda #SFX_CATCH
    jsr sound_load
    ldx game_pointer_shift
    jmp .done
.continue_loop:
    tya
    clc
    adc #GAME_ACTOR_VARIABLES
    tay
    inc count1
    lda game_actors
    cmp count1
    bne .check_next_pig
    ; None caught
    lda #SFX_MISS_CATCH
    jsr sound_load
    ldx game_pointer_shift
.done:
    rts

;----------
; Calculates catching position depending on farmer position and facing direction
;   X   Actor data pointer delta
;   game_diff_x     is set with X Pos
;   game_diff_y     is set with Y Pos
farmer_get_catching_diff_pos:
    lda game_actor_x,X
    sta game_diff_x
    lda game_actor_y,X
    sta game_diff_y

    ldy game_actor_dir,X
    lda game_facing_directions,y
    and #DIR_FLAG_UP
    beq .check_facing_down
    lda #FARMER_CATCH_DIFF_Y_M
    clc
    adc game_diff_y
    sta game_diff_y
    jmp .check_facing_left
.check_facing_down:
    lda game_facing_directions,y
    and #DIR_FLAG_DOWN
    beq .check_facing_left
    lda #FARMER_CATCH_DIFF_Y
    clc
    adc game_diff_y
    sta game_diff_y
.check_facing_left:
    lda game_facing_directions,y
    and #DIR_FLAG_LEFT
    beq .check_facing_right
    lda #FARMER_CATCH_DIFF_X_M
    clc
    adc game_diff_x
    sta game_diff_x
    jmp .done
.check_facing_right:
    lda game_facing_directions,y
    and #DIR_FLAG_RIGHT
    beq .done
    lda #FARMER_CATCH_DIFF_X
    clc
    adc game_diff_x
    sta game_diff_x
.done:
    rts

;----------
; Release the pig being hold
;   X   Actor data pointer delta
;   game_actor_status_timer     Pig data pointer delta
farmer_release_pig:
    lda game_actor_status_timer,x
    tay
    lda #$00
    sta game_actor_status,x
    sta game_actor_status_timer,x
    sta game_actor_status,y
    rts

;----------
; When holding a pig, move it along
;   X   Actor data pointer delta
farmer_move_pig_along:
    jsr farmer_get_catching_diff_pos
    lda game_actor_status_timer,x
    tay
    lda game_diff_x
    sta game_actor_x,y
    lda #FARMER_HOLDING_HEIGHT
    clc
    adc game_diff_y
    sta game_actor_y,y
    lda game_actor_dir,X
    sta game_actor_dir,y
    rts

;----------
; Check if the farmer (holding the pig) is at the barn's door
;   X   Actor data pointer delta
bring_pig_inside:
    lda game_actor_y,X
    cmp #FIELD_LIMIT_UP
    bne .done
    lda game_actor_x,X
    cmp #$70
    bcc .done
    cmp #$90
    bcs .done
    ; bring pig inside
    lda game_actor_status_timer,x
    tay
    lda #$00
    sta game_actor_char,y
    jsr farmer_release_pig
    dec game_pigs_remaining
    beq .won
    lda #SFX_PIG_INSIDE
    jsr sound_load
    ldx game_pointer_shift
    jmp .done
.won:
    LDA #LOW(do_nothing)
    sta draw_subroutine
    LDA #HIGH(do_nothing)
    sta draw_subroutine+1

    LDA #LOW(game_win_level)
    sta process_subroutine
    LDA #HIGH(game_win_level)
    sta process_subroutine+1

.done:
    rts

;----------
; Draw farmer
;   X                   Actor data pointer delta
;   game_sprite_count   First free sprite to use
game_draw_farmer:
    ldy game_sprite_count ; first sprite for farmer, 6 total (2x3)

    lda game_actor_x,x   ; X pos
    sta $0207,y
    sta $020F,y
    sta $0217,y
    clc
    adc #$F8
    sta $0203,y
    sta $020B,y
    sta $0213,y

    lda game_actor_y,x   ; Y pos
    clc
    adc #$F8
    sta $0210,y
    sta $0214,y
    clc
    adc #$F8
    sta $0208,y
    sta $020C,y
    clc
    adc #$F8
    sta $0200,y
    sta $0204,y
    
    LDA #LOW(farmer_animation)
    sta pointer1
    LDA #HIGH(farmer_animation)
    sta pointer1+1
    ; move pointer to first frame of direction
    ldy game_actor_dir,x
    beq .move_pointer_to_frame
.move_to_direction:
    lda #$30    ; 12 bytes per frame x 4 frames per direction = 48 bytes = $30
    jsr game_move_pointer
    dey
    bne .move_to_direction

.move_pointer_to_frame:
    ; set starting shift, depending on frame
    ldy game_actor_frame,x
    beq .frame_found
.find_frame
    lda #$0C    ; each sprite is 12 bytes: 6 sprites x (sprite nr.+sprite attributes)  
    jsr game_move_pointer
    dey
    bne .find_frame
.frame_found

    lda #$06
    jsr game_fill_sprite_data   ; Overrides X
    ldx game_pointer_shift  ; restore actor data pointer delta

    rts