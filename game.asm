
FIELD_LIMIT_LEFT = $14
FIELD_LIMIT_RIGHT = $EC
FIELD_LIMIT_UP = $24
FIELD_LIMIT_DOWN = $CE

MIN_FENCE_DISTANCE  = $18   ;   Min distance to avoid running into the fence

farmer_animation:
;   Facing up
    .byte   $20,%00000000, $20,%01000000, $30,0, $30,%01000000, $40,0, $40,%01000000
    .byte   $20,%00000000, $20,%01000000, $30,0, $30,%01000000, $41,0, $42,0
    .byte   $21,%00000000, $21,%01000000, $31,0, $31,%01000000, $40,0, $40,%01000000
    .byte   $20,%00000000, $20,%01000000, $30,0, $30,%01000000, $42,%01000000, $41,%01000000
    
;   Facing NE
    .byte   $20,%00000000, $24,%00000000, $33,0, $34,%00000000, $43,0, $44,%00000000
    .byte   $20,%00000000, $24,%00000000, $33,0, $34,%00000000, $43,0, $44,%00000000
    .byte   $21,%00000000, $21,%01000000, $25,0, $26,%00000000, $35,0, $36,%00000000
    .byte   $20,%00000000, $24,%00000000, $33,0, $34,%00000000, $45,0, $46,%00000000

;   Facing Right
    .byte   $20,%00000000, $28,%00000000, $37,0, $38,%00000000, $47,0, $48,%00000000
    .byte   $20,%00000000, $28,%00000000, $37,0, $38,%00000000, $47,0, $48,%00000000
    .byte   $20,%00000000, $28,%00000000, $37,0, $38,%00000000, $49,0, $4A,%00000000
    .byte   $21,%00000000, $21,%01000000, $29,0, $2A,%00000000, $39,0, $3A,%00000000

;   Facing SE
    .byte   $50,%00000000, $51,%00000000, $60,0, $61,%00000000, $70,0, $71,%00000000
    .byte   $50,%00000000, $51,%00000000, $60,0, $61,%00000000, $70,0, $71,%00000000
    .byte   $50,%00000000, $51,%00000000, $60,0, $61,%00000000, $72,0, $73,%00000000
    .byte   $21,%00000000, $21,%01000000, $52,0, $53,%00000000, $62,0, $63,%00000000

;   facing down
    .byte   $28,%01000000, $28,%00000000, $13,0, $13,%01000000, $23,0, $23,%01000000
    .byte   $28,%01000000, $28,%00000000, $22,0, $13,%01000000, $23,0, $32,%01000000
    .byte   $21,%00000000, $21,%01000000, $2B,0, $2B,%01000000, $3B,0, $3B,%01000000
    .byte   $28,%01000000, $28,%00000000, $13,0, $22,%01000000, $32,0, $23,%01000000

;   Facing SW
    .byte   $51,%01000000, $50,%01000000, $61,%01000000, $60,%01000000, $71,%01000000, $70,%01000000
    .byte   $51,%01000000, $50,%01000000, $61,%01000000, $60,%01000000, $71,%01000000, $70,%01000000
    .byte   $51,%01000000, $50,%01000000, $61,%01000000, $60,%01000000, $73,%01000000, $72,%01000000
    .byte   $21,%00000000, $21,%01000000, $53,%01000000, $52,%01000000, $63,%01000000, $62,%01000000

;   Facing Left
    .byte   $28,%01000000, $20,%01000000, $38,%01000000, $37,%01000000, $48,%01000000, $47,%01000000
    .byte   $28,%01000000, $20,%01000000, $38,%01000000, $37,%01000000, $48,%01000000, $47,%01000000
    .byte   $28,%01000000, $20,%01000000, $38,%01000000, $37,%01000000, $4A,%01000000, $49,%01000000
    .byte   $21,%00000000, $21,%01000000, $2A,%01000000, $29,%01000000, $3A,%01000000, $39,%01000000

;   Facing NW   TODO
    .byte   $24,%01000000, $20,%01000000, $34,%01000000, $33,%01000000, $44,%01000000, $43,%01000000
    .byte   $24,%01000000, $20,%01000000, $34,%01000000, $33,%01000000, $44,%01000000, $43,%01000000
    .byte   $21,%00000000, $21,%01000000, $26,%01000000, $25,%01000000, $36,%01000000, $35,%01000000
    .byte   $24,%01000000, $20,%01000000, $34,%01000000, $33,%01000000, $46,%01000000, $45,%01000000

pig_animation:
;   Facing Up
    .byte   $00,%00000001, $01, %00000001, $10,%00000001, $10,%01000001
    .byte   $02,%00000001, $03, %00000001, $12,%00000001, $12,%01000001

;   Facing NE
    .byte   $04,%00000001, $05, %00000001, $14,%00000001, $15,%00000001
    .byte   $06,%00000001, $07, %00000001, $16,%00000001, $17,%00000001

; Facing Right
    .byte   $08,%00000001, $09, %00000001, $18,%00000001, $19,%00000001
    .byte   $08,%00000001, $0B, %00000001, $1A,%00000001, $1B,%00000001

;   Facing SE
    .byte   $0C,%00000001, $0D, %00000001, $1C,%00000001, $1D,%00000001
    .byte   $0E,%00000001, $0F, %00000001, $1E,%00000001, $1F,%00000001

;   Facing Down
    .byte   $2C,%00000001, $2D, %00000001, $3C,%00000001, $3C,%01000001
    .byte   $2E,%00000001, $2F, %00000001, $3E,%00000001, $3E,%01000001

;   Facing SW
    .byte   $0D,%01000001, $0C, %01000001, $1D,%01000001, $1C,%01000001
    .byte   $0F,%01000001, $0E, %01000001, $1F,%01000001, $1E,%01000001

;   Facing Right
    .byte   $09,%01000001, $08, %01000001, $19,%01000001, $18,%01000001
    .byte   $0B,%01000001, $08, %01000001, $1B,%01000001, $1A,%01000001

;   Facing NE
    .byte   $05,%01000001, $04, %01000001, $15,%01000001, $14,%01000001
    .byte   $07,%01000001, $06, %01000001, $17,%01000001, $16,%01000001


pig_held_sprites:
;   Facing Up
    .byte   $3D,%00000001, $3D, %01000001, $4D,%00000001, $4E,%00000001
;   Facing NE
    .byte   $5A,%00000001, $5B, %00000001, $6A,%00000001, $6B,%00000001
; Facing Right
    .byte   $5C,%00000001, $5D, %00000001, $6C,%00000001, $6D,%00000001
;   Facing SE
    .byte   $5E,%00000001, $5F, %00000001, $6E,%00000001, $6F,%00000001
;   Facing Down
    .byte   $3F,%00000001, $3F, %01000001, $4F,%00000001, $4F,%01000001
;   Facing SW
    .byte   $5F,%01000001, $5E, %01000001, $6F,%01000001, $6E,%01000001
;   Facing Right
    .byte   $5D,%01000001, $5C, %01000001, $6D,%01000001, $6C,%01000001
;   Facing NE
    .byte   $5B,%01000001, $5A, %01000001, $6B,%01000001, $6A,%01000001

DIR_FLAG_UP     =   $01
DIR_FLAG_DOWN   =   $02
DIR_FLAG_LEFT   =   $04
DIR_FLAG_RIGHT  =   $08

game_facing_directions: ; Map facing direction index to coord flags byte
    .byte   $01 ;Up
    .byte   $09 ;NE
    .byte   $08 ;Right
    .byte   $0A ;SE
    .byte   $02 ;Down
    .byte   $06 ;SW
    .byte   $04 ;Left
    .byte   $05 ;NW

    .rsset $0500 ;  game variables

game_sprite_count   .rs 1   ; sprite counter

game_actor_sort     .rs 6   ; List of actor numbers, sorted by Y position 
game_y_sort_count   .rs 1   ; Count for y sort entries
game_y_sort_compare   .rs 1   ; Second pointer to y_sort table for sorting
game_coord_flags    .rs 1   ; flags for D-Pad presses
game_actors         .rs 1   ; Number of actors in the game (farmers, pigs, chickens)
game_current_actor  .rs 1   ; current actor number (0...N)
game_pointer_shift  .rs 1   ; pointer shift for current actor (game_current_actor * GAME_ACTOR_VARIABLES)

game_fence_collision  .rs 1   ; flag on fence collision
game_diff_x  .rs 1   ; left (neg) or right (pos)
game_dist_x  .rs 1   ; x distance
game_diff_y  .rs 1   ; up (neg) or down (pos)
game_dist_y  .rs 1   ; y distance
game_escape_flags  .rs 1   ; a temp variable

game_level  .rs 1   
game_pigs_remaining .rs 1
game_status .rs 1   

GAME_STATUS_PLAY    =   $01
GAME_STATUS_WON     =   $02
GAME_STATUS_LOST    =   $03
GAME_ACTOR_VARIABLES    = 16    ; How many bytes of variables per actor at $0500 (the ones below)

game_actor_char .rs 1   ; Character type: 0: none (not visible), 1: farmer, 2: pig
game_actor_x .rs 1
game_actor_xd .rs 1
game_actor_y .rs 1
game_actor_yd .rs 1
game_actor_dir .rs 1   ; Facing direction $00=12:00, clock-wise
game_actor_speed_x .rs 1    ; Speed X
game_actor_speed_xd .rs 1   ; Speed X subpixel
game_actor_speed_y .rs 1
game_actor_speed_yd .rs 1
game_actor_frame .rs 1   ; Current Animation frame
game_actor_frame_timer .rs 1   ; Current Animation frame count
game_actor_stamina .rs 1   ; Player stamina
game_actor_player .rs 1   ; Is player? (0: AI, 1: Player 1, 2: Player 2)
game_actor_status .rs 1   ; Current status
game_actor_status_timer .rs 1   ; Status timer

game_actor2     .rs GAME_ACTOR_VARIABLES  ; all same variables for actor 2
game_actor3     .rs GAME_ACTOR_VARIABLES  ; all same variables for actor 3
game_actor4     .rs GAME_ACTOR_VARIABLES
game_actor5     .rs GAME_ACTOR_VARIABLES

message_timer   .rs 2   ; message timer
message_blink   .rs 1   ; blinking character tile

;----------
; inits game scene
;   A   previous scene index
game_init:


    LDA #LOW(game_draw_bg)
    sta draw_subroutine
    LDA #HIGH(game_draw_bg)
    sta draw_subroutine+1

    jsr message_init

    lda #$01
    sta game_level
    jsr init_level_data

    lda #GAME_STATUS_PLAY
    sta game_status
    
    lda #$01            ;Needs to draw new scene
    sta needdraw
    
    lda #MUSIC_GAME
    jsr song_load

    rts

;----------
; Starts the level positions
init_level_data:
    lda #$00
    sta game_actor_xd
    sta game_actor_yd
    sta game_actor_speed_x
    sta game_actor_speed_xd
    sta game_actor_speed_y
    sta game_actor_speed_yd
    sta game_actor_frame       ; animation frame
    sta game_actor_frame_timer ; animation timer for next frame

    lda game_level
    CLC
    adc #$01    ; 2 pigs in level 1
    sta game_pigs_remaining
    CLC
    adc #$01    ; pigs + farmer
    sta game_actors

    ; Init farmer
    lda #$80
    sta game_actor_x
    lda #$28
    sta game_actor_y
    lda #$04 ; looking down
    sta game_actor_dir
    lda #$01
    sta game_actor_char    ; Character farmer = $01
    lda #$01
    sta game_actor_player  ; Controlled by Player 1 = $01

    ; Init pigs
    lda game_pigs_remaining
    sta count1
    ldx #GAME_ACTOR_VARIABLES
.add_pigs:
    jsr get_random_number
    and #$7F
    clc
    adc #$40
    sta game_actor_x,x
    jsr get_random_number
    and #$3F
    clc
    adc #$70
    sta game_actor_y,x
    lda #$02    ; Pig
    sta game_actor_char,x
    lda #$00    ; IA
    sta game_actor_player,x
    lda #PIG_MAX_STAMINA
    sta game_actor_stamina,x
    txa
    clc
    adc #GAME_ACTOR_VARIABLES
    tax
    dec count1
    bne .add_pigs

;   TODO Remove Y sorting from here once it is implemented
    ldx #$05
.init_ysort:
    txa
    sta game_actor_sort,x
    dex
    bne .init_ysort

    rts

;----------------------------
; draw game background
;   this is called once when the game starts, and after closing the pause menu
game_draw_bg:

    ; Turn off screen and NMI to give time for name table update
    lda #$08
    sta $2000   ;turn off NMIs
    lda #$00
    sta $2001   ;turn PPU off

;set a couple palette colors
    lda #$3F
    sta $2006
    lda #$00
    sta $2006   ;palette data starts at $3F00
    
    LDX #$00
.LoadPalettesLoop:
    LDA game_palette, x        ; load data from address (palette + the value in x)
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
    LDA #HIGH(game_bg)
    STA pointerHi1       ; put the high byte of the address into pointer

    JSR copy_pointer_to_background

    lda game_level
    cmp #$01
    bne .message_level2
    LDA #LOW(message_box_level1)
    sta pointer3
    LDA #HIGH(message_box_level1)
    sta pointer3+1
    jmp .draw_message
.message_level2:
    cmp #$02
    bne .message_level3
    LDA #LOW(message_box_level2)
    sta pointer3
    LDA #HIGH(message_box_level2)
    sta pointer3+1
    jmp .draw_message
.message_level3:
    LDA #LOW(message_box_level3)
    sta pointer3
    LDA #HIGH(message_box_level3)
    sta pointer3+1
.draw_message:
    jsr game_draw_message  

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
; Update sprites and UI
game_draw:
    lda #$00    ; Sprite DMA
    sta $2003
    lda #$02
    sta $4014
    rts

;----------
; Game process
game_process:
    lda game_status
    cmp #GAME_STATUS_PLAY
    beq .process_actors
    cmp #GAME_STATUS_WON
    bne .check_lost
    lda game_level
    cmp #$03    ; last level
    beq .check_lost
    inc game_level
.check_lost:
    lda #GAME_STATUS_PLAY
    sta game_status
    jsr init_level_data
    
    LDA #LOW(game_draw_bg)
    sta draw_subroutine
    LDA #HIGH(game_draw_bg)
    sta draw_subroutine+1
    
    
    LDA #LOW(message_init)
    sta process_subroutine
    LDA #HIGH(message_init)
    sta process_subroutine+1

    lda #$01
    sta needdraw

    rts
.process_actors:
    lda #$00
    sta game_current_actor  ; process all actors
    
.update_actor_data:
;   Init actor data pointers
    ldx game_current_actor
    beq .init_actor_data_pointers
    lda #$00
.get_actor_data_delta:
    clc
    adc #GAME_ACTOR_VARIABLES
    dex
    bne .get_actor_data_delta
.init_actor_data_pointers:
    sta game_pointer_shift
    tax

;   Process player input/IA
    lda game_actor_player,x
    bne .get_actor_input_p1

    jsr game_process_ai

    jmp .move_actors

.get_actor_input_p1:
    jsr farmer_input_p1

;   Move actors after processing input
.move_actors:
    jsr game_move_actors

;   Get the corresponding animation frame
    jsr game_get_animation_frame

;   Get the facing direction
    jsr actor_get_facing_direction

    inc game_current_actor
    lda game_current_actor
    cmp game_actors
    bne .update_actor_data  ; Loop back to update all actors

    jsr game_y_sort

; Draw sprites
game_draw_sprites:
    lda #$00
    sta game_sprite_count    ; start using the first sprite
    sta game_y_sort_count    ; start rendering the top Y position actor (lower Y value)
    
.loop_fill_sprite_data:
    ldy game_y_sort_count
    ldx game_actor_sort,y
    beq .init_actor_data_pointers
    lda #$00
.get_actor_data_delta:
    clc
    adc #GAME_ACTOR_VARIABLES
    dex
    bne .get_actor_data_delta
.init_actor_data_pointers:
    sta game_pointer_shift
    tax

    lda game_actor_char,x
    beq .draw_invisible
    cmp #$01
    bne .draw_pig   ; For now, only invisible, farmer and pig sprites
.draw_farmer
    jsr game_draw_farmer
    jmp .finished_sprite_update
.draw_pig
    jsr game_draw_pig
.draw_invisible:
    jsr game_draw_invisible_char
.finished_sprite_update:
    inc game_y_sort_count
    lda game_y_sort_count
    cmp game_actors
    bne .loop_fill_sprite_data

    lda #$01
    sta needdraw
    rts

;----------
; Sort actors by Y pos
; Expects at least 2 actors
game_y_sort:
;     lda #$00
;     sta game_y_sort_count
;     lda #$01
;     sta game_y_sort_compare
; .loop_bubble_sort:
;     ldy game_y_sort_count
;     ldx game_actor_sort,y   ; first actor
;     beq .init_first_actor_data_pointers
;     lda #$00
; .get_actor_data_delta:
;     clc
;     adc #GAME_ACTOR_VARIABLES
;     dex
;     bne .get_actor_data_delta
; .init_first_actor_data_pointers:
;     sta pointer1

;     ldy game_y_sort_compare
;     ldx game_actor_sort,y   ; first actor
;     beq .init_second_actor_data_pointers
;     lda #$00
; .get_second_actor_data_delta:
;     clc
;     adc #GAME_ACTOR_VARIABLES
;     dex
;     bne .get_second_actor_data_delta
; .init_second_actor_data_pointers:
;     sta pointer2

;     ldx pointer1
;     ldy pointer2
;     lda game_actor_y,y
;     cmp game_actor_y,x
;     bcs .get_next_compare
;     ;switch positions
;     ldx game_y_sort_count
;     ldy game_y_sort_compare
;     lda game_actor_sort,x
;     sta count1
;     lda game_actor_sort,y
;     sta game_actor_sort,x
;     lda count1
;     sta game_actor_sort,y

;     ; go back count, if possible
;     dec game_y_sort_count
;     bpl .set_compare
;     lda #$00
;     sta game_y_sort_count
; .set_compare
;     lda game_y_sort_count
;     clc
;     adc #$01
;     sta game_y_sort_compare
;     jmp .loop_bubble_sort

; .get_next_compare:
;     inc game_y_sort_compare
;     lda game_y_sort_compare
;     cmp game_actors
;     bne .loop_bubble_sort
    
;     inc game_y_sort_count
;     lda game_y_sort_count
;     clc
;     adc #$01
;     cmp game_actors
;     beq .done
;     sta game_y_sort_compare
;     jmp .loop_bubble_sort

.done:
    rts

;----------
; Fill sprite number and attributes
;   A   Number of sprites to fill
;   pointer1    Pointer to the animation data to fill    
;   game_sprite_count   address shift from $0200 to the first byte of the sprite
game_fill_sprite_data:
    ldx game_sprite_count   ;   starts at the first byte of the sprite to fill (y position)
    sta count1
.set_sprite
    ldy #$00
    inx ; sprite
    lda [pointer1],y
    sta $0200,x

    iny
    lda [pointer1],y
    inx ; attribute
    sta $0200,x

    lda #$02    ; move the pointer 2 bytes for the next sprite in the animation (spr. nr. + attributes)
    jsr game_move_pointer
    inx ; x pos
    inx ; next y pos
    dec count1
    bne .set_sprite

    stx game_sprite_count   ; save sprite count for next object

    rts

;----------
; For no characters, set all sprites to empty. Used to make pigs disappear
;   X   Actor data pointer delta
game_draw_invisible_char:
    ldy game_sprite_count ; first sprite for invisible, 4 total (2x2)
    lda #$FF
    sta $0207,y
    sta $020F,y
    sta $0203,y
    sta $020B,y
    sta $0208,y
    sta $020C,y
    sta $0200,y
    sta $0204,y

    lda #$04    
    sta count1
    ldx game_sprite_count   ;   starts at the first byte of the sprite to fill (y position)
.set_sprite
    inx ; sprite
    lda #$FF
    sta $0200,x

    lda #$00
    inx ; attribute
    sta $0200,x

    inx ; x pos
    inx ; next y pos
    dec count1
    bne .set_sprite

    stx game_sprite_count   ; save sprite count for next object

    ldx game_pointer_shift  ; restore actor data pointer delta
.done:
    rts
;----------
; Move the pointer the given amount of bytes forward
;   A   Bytes to move the pointer to
game_move_pointer:
    clc
    adc pointer1
    sta pointer1
    bcc .done
    lda #$00
    adc pointer1+1
    sta pointer1+1
.done:
    rts

;----------
; Prepare winning message
game_win_level:

    ; TODO check time and show 'Try again' instead
    ; lda #GAME_STATUS_LOST

    lda #GAME_STATUS_WON
    sta game_status

    lda #SFX_WIN
    jsr sound_load

    lda game_level
    cmp #$01
    bne .message_level2
    LDA #LOW(message_box_well_done1)
    sta pointer3
    LDA #HIGH(message_box_well_done1)
    sta pointer3+1
    jmp .draw_message
.message_level2:
    cmp #$02
    bne .message_level3
    LDA #LOW(message_box_well_done2)
    sta pointer3
    LDA #HIGH(message_box_well_done2)
    sta pointer3+1
    jmp .draw_message
.message_level3:
    LDA #LOW(message_box_well_done3)
    sta pointer3
    LDA #HIGH(message_box_well_done3)
    sta pointer3+1
.draw_message:
    LDA #LOW(message_custom_message)
    sta draw_subroutine
    LDA #HIGH(message_custom_message)
    sta draw_subroutine+1

    LDA #LOW(message_init)
    sta process_subroutine
    LDA #HIGH(message_init)
    sta process_subroutine+1

    lda #$01
    sta needdraw

    rts

    .include "game/messages.asm"
    .include "actors/actor.asm"
    .include "actors/farmer.asm"
    .include "actors/pig.asm"