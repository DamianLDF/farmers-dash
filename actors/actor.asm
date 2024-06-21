

ACTOR_CHAR_NONE     = $00
ACTOR_CHAR_FARMER   = $01
ACTOR_CHAR_PIG      = $02

;----------
; IA 
;   X   Actor data pointer delta
game_process_ai:
    lda game_actor_char,x
    cmp #ACTOR_CHAR_PIG
    beq .pig_logic
    jmp .done
.pig_logic:
    jsr pig_process

.done:
    rts

;----------
; Check if the actor is colliding with the fence
;   X   Actor data pointer delta
;   game_fence_collision    Flag set if is colliding
game_check_limit_collision:
    lda #$00
    sta game_fence_collision
    
    lda game_actor_y,x
    cmp #FIELD_LIMIT_UP
    bne .check_limit_down
    ; Is at the upper limit
    lda game_coord_flags
    and #DIR_FLAG_UP
    beq .check_limit_down
    lda #DIR_FLAG_UP
    sta game_fence_collision
    jmp .done
.check_limit_down:
    lda game_actor_y,x
    cmp #FIELD_LIMIT_DOWN
    bne .check_limit_left
    ; Is at the lower limit
    lda game_coord_flags
    and #DIR_FLAG_DOWN
    beq .check_limit_left
    lda #DIR_FLAG_DOWN
    sta game_fence_collision
    jmp .done
.check_limit_left:
    lda game_actor_x,x
    cmp #FIELD_LIMIT_LEFT
    bne .check_limit_right
    ; Is at the left limit
    lda game_coord_flags
    and #DIR_FLAG_LEFT
    beq .check_limit_right
    lda #DIR_FLAG_LEFT
    sta game_fence_collision
    jmp .done
.check_limit_right:
    lda game_actor_x,x
    cmp #FIELD_LIMIT_RIGHT
    bne .done
    ; Is at the right limit
    lda game_coord_flags
    and #DIR_FLAG_RIGHT
    beq .done
    lda #DIR_FLAG_RIGHT
    sta game_fence_collision
.done:
    rts

;----------
; Get possible directions for an actor to not collide with a fence
;   X   actor data pointer delta
;   game_fence_collision    Is set with the possible flags
game_get_possible_directions:
    lda #$00
    sta game_fence_collision
    
    ; check limit left
    lda #FIELD_LIMIT_LEFT
    clc
    adc #MIN_FENCE_DISTANCE
    cmp game_actor_x,X
    bcs .check_limit_right
    lda #DIR_FLAG_LEFT
    sta game_fence_collision
.check_limit_right:
    lda #MIN_FENCE_DISTANCE
    eor #$FF
    clc
    adc #$01
    adc #FIELD_LIMIT_RIGHT
    cmp game_actor_x,X
    bcc .check_limit_up 
    lda #DIR_FLAG_RIGHT
    ora game_fence_collision
    sta game_fence_collision
.check_limit_up:
    lda #MIN_FENCE_DISTANCE
    clc
    adc #FIELD_LIMIT_UP
    cmp game_actor_y,X
    bcs .check_limit_down
    lda #DIR_FLAG_UP
    ora game_fence_collision
    sta game_fence_collision
.check_limit_down:
    lda #MIN_FENCE_DISTANCE
    eor #$FF
    clc
    adc #$01
    adc #FIELD_LIMIT_DOWN
    cmp game_actor_y,X
    bcc .done
    lda #DIR_FLAG_DOWN
    ora game_fence_collision
    sta game_fence_collision
.done:
    rts

;----------
; Move current actor according to speed
;   X   Actor data pointer delta
game_move_actors:
    lda game_actor_xd,x
    clc
    adc game_actor_speed_xd,x
    sta game_actor_xd,x
    lda game_actor_x,x
    adc game_actor_speed_x,x
    sta game_actor_x,x
.left_limit:
    cmp #FIELD_LIMIT_LEFT
    bcs .right_limit
    lda #FIELD_LIMIT_LEFT
    jmp .stop_movement_x
.right_limit:
    cmp #FIELD_LIMIT_RIGHT
    bcc .vertical_move
    lda #FIELD_LIMIT_RIGHT
.stop_movement_x:
    sta game_actor_x,x
    lda #$00    ; Stop move on X if going off limits
    sta game_actor_speed_xd,x
    sta game_actor_speed_x,x

.vertical_move
    lda game_actor_yd,x
    clc
    adc game_actor_speed_yd,x
    sta game_actor_yd,x
    lda game_actor_y,x
    adc game_actor_speed_y,x
    sta game_actor_y,x
.upper_limit:
    cmp #FIELD_LIMIT_UP
    bcs .lower_limit
    lda #FIELD_LIMIT_UP
    jmp .stop_movement_y
.lower_limit:
    cmp #FIELD_LIMIT_DOWN
    bcc .done
    lda #FIELD_LIMIT_DOWN
.stop_movement_y:
    sta game_actor_y,x
    lda #$00
    sta game_actor_speed_yd,x
    sta game_actor_speed_y,x

.done:
    rts


;----------
; Get animation frame for current actor
;   X   Actor data pointer delta
game_get_animation_frame:
    lda game_actor_char,x
    beq .done    ; Not visible, then omit
    cmp #$01 ; Farmer
    bne .game_get_pig_animation_frame ; if not farmer, animate pig

; Farmer animation
.game_get_farmer_animation_frame:
    lda game_coord_flags
    beq .idle_frame ;   if the coord flags are empty, there is no movement, so use the idle frame

    lda game_actor_frame,x
    bne .advance_timer  ; Frame 0 is idle, so go back to last animation frame. 
    lda #$03    ; This reset is only used when changing from idle to moving
    sta game_actor_frame,x
.advance_timer:
    lda game_actor_frame_timer,x
    clc
    adc #FARMER_FRAME_DELTA
    sta game_actor_frame_timer,x
    bcc .done
    dec game_actor_frame,x
    bne .done   ; if not frame 0 (idle), finish frame calculation
    lda #$03    ; start from the fourth frame
.idle_frame: ; frame 0 is for idle
    sta game_actor_frame,x 
    jmp .done

; Pig animation
; Pretty much the same as for farmer, but only 2 frames, and idle frame (0) is also used while running
.game_get_pig_animation_frame:
    lda game_coord_flags
    beq .pig_idle_frame
    lda game_actor_frame,x
    bpl .pig_advance_timer  
    lda #$01    ; TODO This can be removed? frame should not be negative at this point
    sta game_actor_frame,x
.pig_advance_timer
    lda game_actor_frame_timer,x
    clc
    adc #PIG_FRAME_DELTA
    sta game_actor_frame_timer,x
    bcc .done
    dec game_actor_frame,x
    bpl .done   ; if not frame FF (out of bound), finish frame calculation
    lda #$01        ; start from the fourth frame
.pig_idle_frame:    ; frame 0 is for idle
    sta game_actor_frame,x 
.done:
    rts


;----------
; Set the facing direction for the actor, depending on the coord flags (movement)
;   X   Actor data pointer delta
actor_get_facing_direction:
    ldy #$00
.get_player_direction:
    lda game_facing_directions,y
    cmp game_coord_flags
    beq .set_direction
    iny
    cpy #$08    ; if it gets to $08, means the movement match no direction, so it is not moving. Then do not update direction
    beq .done
    jmp .get_player_direction
.set_direction:
    tya
    sta game_actor_dir,x
.done:
    rts