
PIG_FRAME_DELTA     = $40    ; sums until carry flag, then advances 1 frame
PIG_RUN_FRAME_DELTA = $60    ; sums until carry flag, then advances 1 frame
PIG_DISTANCE        = $38   ; Distance from the farmer to make the pig safe
PIG_RUN_AWAY_BIT    = $80
PIG_WALK_BIT        = $40   
PIG_RUN_BIT         = $20
PIG_CAUGHT_BIT      = $40
PIG_MAX_STAMINA     = $A0
PIG_MIN_STAMINA     = $10   ; Min stamina for the pig to run

PIG_MAX_X_SPEED = $01
PIG_MAX_XD_SPEED = $00
PIG_MIN_X_SPEED = $FF
PIG_MIN_XD_SPEED = $00
PIG_MAX_Y_SPEED = $00
PIG_MAX_YD_SPEED = $AA
PIG_MIN_Y_SPEED = $FF
PIG_MIN_YD_SPEED = $66

PIG_RUN_MAX_X_SPEED = $02
PIG_RUN_MAX_XD_SPEED = $00
PIG_RUN_MIN_X_SPEED = $FE
PIG_RUN_MIN_XD_SPEED = $00
PIG_RUN_MAX_Y_SPEED = $01
PIG_RUN_MAX_YD_SPEED = $54
PIG_RUN_MIN_Y_SPEED = $FE
PIG_RUN_MIN_YD_SPEED = $AB

pig_squeals:
    .byte SFX_PIG_SQUEAL
    .byte SFX_PIG_SQUEAL2
    .byte SFX_PIG_SQUEAL3
    .byte SFX_NO_SQUEAL

;----------
; Pig logic
; Assume the first actor is always the farmer
;   X   Actor data pointer delta
;   game_diff_x     Farmer to the left(FF) or to the right (01)
;   game_diff_y     Farmer is above (FF) or below (01)
;   game_dist_x     Distance to the farmer on X (positive)
;   game_dist_y     Distance to the farmer on Y (positive)
pig_process:
    lda game_actor_status,X
    cmp #FARMER_HOLDING_PIG
    bne .continue_processing
    lda #$00
    sta game_actor_speed_x,x
    sta game_actor_speed_xd,x
    sta game_actor_speed_y,x
    sta game_actor_speed_yd,x
    jmp .done
.continue_processing:
    lda #$01
    sta game_diff_x
    sta game_diff_y
    lda game_actor_x    ; get Farmer's X position
    cmp game_actor_x,x
    bcs .substract_x
    ldy #$FF
    sty game_diff_x
.substract_x:
    eor #$FF    ;   flip all bits
    clc
    adc #$01    ;   add 1 to get negative X Pos from farmer
    adc game_actor_x,X  ; substraction
    bpl .check_x_distance
    eor #$FF    ;   flip all bits of negative substraction
    adc #$01    ;   add 1 to get positive distance 
.check_x_distance:
    sta game_dist_x  ; save X distance for later
    cmp #PIG_DISTANCE
    bcs .pig_safe

    lda game_actor_y    ; get Farmer's Y position
    cmp game_actor_y,x
    bcs .substract_y
    ldy #$FF
    sty game_diff_y
.substract_y:
    eor #$FF    ;   flip all bits
    clc
    adc #$01    ;   add 1 to get negative Y Pos from farmer
    adc game_actor_y,X  ; substraction
    bpl .check_y_distance
    eor #$FF    ;   flip all bits of negative substraction
    adc #$01    ;   add 1 to get positive distance 
.check_y_distance:
    sta game_dist_y  ; save Y distance for later
    cmp #PIG_DISTANCE
    bcs .pig_safe
    ; The farmer is near
    lda #$00
    sta game_fence_collision
    lda game_actor_status,x
    and #PIG_RUN_AWAY_BIT   ; check if running
    beq .set_run_state  
    lda game_actor_status,x
    and #PIG_RUN_BIT
    beq .escape_no_stamina_use
    dec game_actor_stamina,x   ; if running, decrease stamina
    beq .set_run_state
    jmp .escape_full_stamina
.escape_no_stamina_use:
    lda game_actor_stamina,x   ; if not running, replenish stamina
    cmp #PIG_MAX_STAMINA
    bcs .escape_full_stamina
    inc game_actor_stamina,x   ; if not running, replenish stamina
.escape_full_stamina:
    dec game_actor_status_timer,x   ; if running/walking, decrease timer
    beq .set_run_state
    jsr pig_set_coord_from_status
    jsr game_check_limit_collision   ; sets flag if colliding with the fence
    lda game_fence_collision
    bne .set_run_state
    jmp .set_speed

.set_run_state
    ;Squeal
    jsr get_random_number
    and #$03
    tay
    lda pig_squeals,y
    jsr sound_load
    ldx game_pointer_shift
    
    jsr pig_escape_status
    jmp .set_speed

.pig_safe:
    lda #$00
    sta game_fence_collision
    lda game_actor_status,x
    and #PIG_RUN_BIT
    beq .chill_no_stamina_use
    dec game_actor_stamina,x   ; if running, decrease stamina
    beq .set_chill_state
    jmp .chill_full_stamina
.chill_no_stamina_use:
    lda game_actor_stamina,x   ; if not running, replenish stamina
    cmp #PIG_MAX_STAMINA
    bcs .chill_full_stamina
    inc game_actor_stamina,x   ; if not running, replenish stamina
.chill_full_stamina:
    dec game_actor_status_timer,x   ; if running/walking, decrease timer
    beq .set_chill_state
    jsr pig_set_coord_from_status
    jsr game_check_limit_collision   ; sets flag if colliding with the fence
    lda game_fence_collision
    bne .set_chill_state
    jmp .set_speed

.set_chill_state
    jsr pig_chill_status

.set_speed:
    lda #$00
    sta game_actor_speed_x,x
    sta game_actor_speed_y,x
    sta game_actor_speed_xd,x
    sta game_actor_speed_yd,x

    lda game_actor_status,X
    and #PIG_RUN_BIT
    bne .running_speed
    lda game_actor_status,X
    and #PIG_WALK_BIT
    beq .done
    jsr pig_set_walk_speed
    jmp .done

.running_speed:
    jsr pig_set_run_speed
    jmp .done

.done:
    rts

    
;----------
; Set new status for pig escaping
;   X   Actor data pointer delta
;   game_diff_x Farmer X diff
;   game_diff_y Farmer Y diff
pig_escape_status:
    jsr game_get_possible_directions ; set game_fence_collision with possible directions
    jsr pig_get_escape_directions      ; set game_escape_flags with possible directions
    lda game_fence_collision
    and game_escape_flags
    sta game_escape_flags
    bne .choose_direction
    lda game_fence_collision
    sta game_escape_flags
.choose_direction
    jsr get_random_number
    and #$07
    tay
    lda game_facing_directions,y
    and game_escape_flags
    beq .choose_direction
    sta game_coord_flags

    ; update status
    lda #PIG_RUN_AWAY_BIT
    sta game_actor_status,x
    lda game_actor_stamina,x   ; if not running, replenish stamina
    cmp #PIG_MIN_STAMINA
    bcc .not_enough_stamina
    lda #PIG_RUN_BIT
    jmp .escape_add_action
.not_enough_stamina:
    lda #PIG_WALK_BIT
.escape_add_action
    ora game_actor_status,x
    sta game_actor_status,x

    ldy #$FF
.escape_check_direction
    iny
    lda game_facing_directions,y
    cmp game_coord_flags
    bne .escape_check_direction
    tya
    ora game_actor_status,x
    sta game_actor_status,x

    ; Set status timer
    jsr get_random_number
    and #$0F
    clc
    adc #$20
    sta game_actor_status_timer,x
    rts

;----------
; Set new status for pig chilling
;   X   Actor data pointer delta
pig_chill_status:
    jsr get_random_number
    and #$07
    tay
    lda game_facing_directions,y
    sta game_coord_flags

    ; update status
    jsr get_random_number
    and #PIG_WALK_BIT
    sta game_actor_status,x

    ldy #$08
.chill_check_direction
    dey
    lda game_facing_directions,y
    cmp game_coord_flags
    bne .chill_check_direction
    ora game_actor_status,x
    sta game_actor_status,x

    ; Set status timer
    jsr get_random_number
    and #$1F
    clc
    adc #$20
    sta game_actor_status_timer,x
    rts


;----------
; Sets game_coord_flags depending on pig status
;   X   Actor data pointer delta
;   game_coord_flags    flags set if moving, empty if not moving
pig_set_coord_from_status:
    lda game_actor_status,x
    cmp #FARMER_HOLDING_PIG
    bne .check_flags
    lda #$00
    sta game_coord_flags
    jmp .done
.check_flags:
    lda game_actor_status,x
    bmi .set_coord_flags    ; PIG_RUN_AWAY_BIT is the last bit, so it makes it negative
    and #PIG_WALK_BIT
    bne .set_coord_flags
    sta game_coord_flags    ; set it to empty
    jmp .done
.set_coord_flags:
    lda game_actor_status,X
    and #$07 ; first 4 flags are the direction
    tay
    lda game_facing_directions,y
    sta game_coord_flags
.done
    rts


;----------
; Set possible escape directions depending on farmer position
;   X   Actor data pointer delta
pig_get_escape_directions:
    lda #$00
    sta game_escape_flags

    ldy game_diff_x
    bpl .check_x_pos
    ; farmer on the left, can escape right
    lda #DIR_FLAG_RIGHT
    sta game_escape_flags
    ldy game_dist_x
    cpy #$10    ;   if not far to the left, can also escape left
    bcs .check_y
    ora #DIR_FLAG_LEFT
    sta game_escape_flags
    jmp .check_y
.check_x_pos:
    lda #DIR_FLAG_LEFT  ; Farmer on the right, can escape to the left
    sta game_escape_flags
    ldy game_dist_x
    cpy #$10
    bcs .check_y
    ora #DIR_FLAG_RIGHT
    sta game_escape_flags
.check_y:
    ldy game_diff_y
    bpl .check_y_pos
    ;farmer above
    ora #DIR_FLAG_DOWN
    sta game_escape_flags
    ldy game_dist_y
    cpy #$10
    bcs .done
    ora #DIR_FLAG_UP
    sta game_escape_flags
    jmp .done
.check_y_pos:
    ora #DIR_FLAG_UP
    sta game_escape_flags
    ldy game_dist_y
    cpy #$10
    bcs .done
    ora #DIR_FLAG_DOWN
    sta game_escape_flags
.done:
    rts

;----------
; Set pig walking speed
pig_set_walk_speed:
    ; walking speed
    lda game_coord_flags
    and #DIR_FLAG_UP
    beq .check_walk_down
    lda #PIG_MIN_YD_SPEED
    sta game_actor_speed_yd,x
    lda #PIG_MIN_Y_SPEED
    sta game_actor_speed_y,x
    jmp .check_walk_left
.check_walk_down:
    lda game_coord_flags
    and #DIR_FLAG_DOWN
    beq .check_walk_left
    lda #PIG_MAX_YD_SPEED
    sta game_actor_speed_yd,x
    lda #PIG_MAX_Y_SPEED
    sta game_actor_speed_y,x
.check_walk_left:
    lda game_coord_flags
    and #DIR_FLAG_LEFT
    beq .check_walk_right
    lda #PIG_MIN_XD_SPEED
    sta game_actor_speed_xd,x
    lda #PIG_MIN_X_SPEED
    sta game_actor_speed_x,x
    jmp .done
.check_walk_right:
    lda game_coord_flags
    and #DIR_FLAG_RIGHT
    beq .done
    lda #PIG_MAX_XD_SPEED
    sta game_actor_speed_xd,x
    lda #PIG_MAX_X_SPEED
    sta game_actor_speed_x,x
.done:
    rts

;----------
; Set pig running speed
pig_set_run_speed:
    lda game_coord_flags
    and #DIR_FLAG_UP
    beq .check_run_down
    lda #PIG_RUN_MIN_YD_SPEED
    sta game_actor_speed_yd,x
    lda #PIG_RUN_MIN_Y_SPEED
    sta game_actor_speed_y,x
    jmp .check_run_left
.check_run_down:
    lda game_coord_flags
    and #DIR_FLAG_DOWN
    beq .check_run_left
    lda #PIG_RUN_MAX_YD_SPEED
    sta game_actor_speed_yd,x
    lda #PIG_RUN_MAX_Y_SPEED
    sta game_actor_speed_y,x
.check_run_left:
    lda game_coord_flags
    and #DIR_FLAG_LEFT
    beq .check_run_right
    lda #PIG_RUN_MIN_XD_SPEED
    sta game_actor_speed_xd,x
    lda #PIG_RUN_MIN_X_SPEED
    sta game_actor_speed_x,x
    jmp .done
.check_run_right:
    lda game_coord_flags
    and #DIR_FLAG_RIGHT
    beq .done
    lda #PIG_RUN_MAX_XD_SPEED
    sta game_actor_speed_xd,x
    lda #PIG_RUN_MAX_X_SPEED
    sta game_actor_speed_x,x
.done:
    rts


;----------
; Draw pig
;   X                   Actor data pointer delta
;   game_sprite_count   First free sprite to use
game_draw_pig:
    ldy game_sprite_count ; first sprite for pig, 4 total (2x2)

    lda game_actor_x,x   ; X pos
    sta $0207,y
    sta $020F,y
    clc
    adc #$F8
    sta $0203,y
    sta $020B,y

    lda game_actor_y,x   ; Y pos
    clc
    adc #$F8
    sta $0208,y
    sta $020C,y
    clc
    adc #$F8
    sta $0200,y
    sta $0204,y
    
    lda game_actor_status,X
    cmp #FARMER_HOLDING_PIG
    beq .held_pig

    LDA #LOW(pig_animation)
    sta pointer1
    LDA #HIGH(pig_animation)
    sta pointer1+1
    ; move pointer to first frame of direction
    ldy game_actor_dir,x
    beq .move_pointer_to_frame
.move_to_direction:
    lda #$10    ; 8 bytes per frame x 2 frames per direction = 16 bytes = $10
    jsr game_move_pointer   ; move the pointer 16 bytes forward
    dey
    bne .move_to_direction

.move_pointer_to_frame:
    ; set starting shift, depending on frame
    ldy game_actor_frame,x
    beq .frame_found
.find_frame
    lda #$08    ; each sprite is 8 bytes: 4 sprites x (sprite nr.+sprite attributes)  
    jsr game_move_pointer
    dey
    bne .find_frame
.frame_found

    lda #$04
    jsr game_fill_sprite_data   ; Overrides X
    ldx game_pointer_shift  ; restore actor data pointer delta
    jmp .done

.held_pig:
    LDA #LOW(pig_held_sprites)
    sta pointer1
    LDA #HIGH(pig_held_sprites)
    sta pointer1+1
    ; move pointer to first frame of direction
    ldy game_actor_dir,x
    beq .held_direction_found
.held_move_to_direction:
    lda #$08    ; 8 bytes per frame x 1 frames per direction = 8 bytes
    jsr game_move_pointer
    dey
    bne .held_move_to_direction
 .held_direction_found:
    lda #$04
    jsr game_fill_sprite_data   ; Overrides X
    ldx game_pointer_shift  ; restore actor data pointer delta

.done:
    rts