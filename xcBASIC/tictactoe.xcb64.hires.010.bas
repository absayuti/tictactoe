; TIC-TAC-TOE-64 XC-BASIC version with HIRES graphics
; Ported from a C64 version written in CBM Prg Studio
; which was written based on several sources
;
; v 0.10 - 3 July 2021
; 
;------------------------------------------------------------------------------

include "../inc/xcb-ext-hires.bas"
include "../inc/xcb-ext-sprite.bas"
include "../inc/xcb-ext-sfx.bas"

;------------------------------------------------------------------------------
; General constants
const VIC_RASTER = $d012
const BORDER     = $D020
const BGROUND    = $D021
const COLRAM     = 55296

const _BLACK   = 0
const _WHITE   = 1
const _RED     = 2
const _CYAN    = 3
const _PURPLE  = 4
const _GREEN   = 5 
const _BLUE    = 6
const _YELLOW  = 7
const _ORANGE  = 8
const _BROWN   = 9
const _LIGHTRED = 10
const _DARKGRAY = 11
const _MEDGRAY  = 12
const _LIGHTGREEN = 13
const _LIGHTBLUE  = 14
const _LIGHTGRAY  = 15


proc play_sound( n! )
    call sfx_start( n! )
    for i = 1 to 10
        watch \VIC_RASTER, 100
        call sfx_play
    next
endproc

;------------------------------------------------------------------------------
; General functions/procedures

proc delay( tt )
    for t=1 to tt
        for i=1 to 1000
        next
    next
endproc

fun getkey!()
    repeat
        k! = inkey!()
    until k! <> 0
    return k! 
endfun

;------------------------------------------------------------------------------
; Hi-Res bitmap graphic related functions/procedures
;
; Procedure to write text in hi-res graphic in 4 sizes
; 0 = normal, 1 = double width, 2 = double height, 3 = double width and height

proc hires_text( x, y, text$, size! )

    charrom = $D800                 'Mixed case char ROM
    bitmap = \HI_BITMAPADDR
    bitmapmax = bitmap+8001

    if size!>3 then goto abort 

    poke 56334, peek(56334)&254     'disable interrupt 
    poke 1, peek(1)&251             'char ROM online

    for i!=0 to strlen!(text$)-1

        n! = peek(text$+i!)
        if n!>63 and n!<96 then 
            n! = n! - 64
        else
            if n!>95 and n!<123 then
                n! = n! - 32
            endif
        endif

        on size! goto normal, wide, tall, large

        normal:
            for j!=0 to 7
                addr = bitmap + y*320 + (x+i!)*8+j!
                if addr<bitmapmax then 
                    c! = peek(charrom + n!*8 + j!)
                    poke addr, c!
                endif
            next
            goto done

        wide:
            for j!=0 to 7
                addr = bitmap + y*320 + x*8 + i!*16 + j!
                if addr<bitmapmax then
                    c! = peek(charrom + n!*8 + j!)
                    d! = (c!&8)*24 + (c!&4)*12 + (c!&2)*6 + (c!&1)*3
                    c! = rshift!(c!,4)
                    e! = (c!&8)*24 + (c!&4)*12 + (c!&2)*6 + (c!&1)*3
                    poke addr, e!
                    poke addr+8,d!
                endif
            next
            goto done

        tall:
            for j! = 0 to 3
                addr = bitmap + y*320 + (x+i!)*8+j!
                if addr < bitmapmax then 
                    c! = peek(charrom + n!*8 + j!)
                    poke addr+j!, c!
                    poke addr+j!+1, c!
                endif
            next
            for j! = 4 to 7
                addr = bitmap + 312 + y*320 + (x+i!)*8+j!
                if addr < bitmapmax then 
                    c! = peek(charrom + n!*8 + j!)
                    poke addr+j!, c!
                    poke addr+j!+1, c!
                endif
            next
            goto done

        large:
            for j! = 0 to 3
                addr = bitmap + y*320 + x*8 + i!*16 + j!
                if addr < bitmapmax then 
                    c! = peek(charrom + n!*8 + j!)
                    d! = (c!&8)*24 + (c!&4)*12 + (c!&2)*6 + (c!&1)*3
                    c! = rshift!(c!,4)
                    e! = (c!&8)*24 + (c!&4)*12 + (c!&2)*6 + (c!&1)*3
                    poke addr+j!, e!
                    poke addr+j!+1, e!
                    poke addr+8+j!, d!
                    poke addr+8+j!+1, d!
                endif
            next
            for j! = 4 to 7
                addr = bitmap + 312 + y*320 + x*8 + i!*16 + j!
                if addr < bitmapmax then 
                    c! = peek(charrom + n!*8 + j!)
                    d! = (c!&8)*24 + (c!&4)*12 + (c!&2)*6 + (c!&1)*3
                    c! = rshift!(c!,4)
                    e! = (c!&8)*24 + (c!&4)*12 + (c!&2)*6 + (c!&1)*3
                    poke addr+j!, e!
                    poke addr+j!+1, e!
                    poke addr+8+j!, d!
                    poke addr+8+j!+1, d!
                endif
            next
            goto done

    done:
    next

    poke 1, peek(1)|4
    poke 56334, peek(56334)|1
    abort:
endproc

;------------------------------------------------------------------------------
; Game constants
; Computer will move with 'o', and human with 'x'
const COMPUTER! = 1
const HUMAN! = 2
const XO = 36
const XS = 72
const YO = 32
const YS = 64

; Game variables/settings
dim board![3,3]
data cellnum$[] = "1","2","3","4","5","6","7","8","9"

;rem Coords for marker sprite                
data sx[] = 36,108,180,  36,108,180,  36,108,180, 268   
data sy[] = 62,62,62, 126,126,126, 190,190,190, 218
;rem Shades of colors for the sprites
data sc[]  = 11,12,15,1,15,12

;------------------------------------------------------------------------------
;   Procedure to setup sprite for target marker
; 
proc setup_sprites
    data sprite![] = 255,255,255, 255,255,255, 255,255,255, 255,255,255, 255,255,255, 255,255,255, ~
                     255,255,255, 255,255,255, 255,255,255, 255,255,255, 255,255,255, 255,255,255, ~
                     255,255,255, 255,255,255, 255,255,255, 255,255,255, 255,255,255, 255,255,255, ~
                     255,255,255, 255,255,255, 255,255,255, 0

;   In Hires mode, VIC is pointing to Bank 2 i.e. $8000-$BFFF.
;   +---------------------------------------------------------------+
;   | $8000           | $8C00-$8C39 | $9000 - ...     | $A000-$BF3F |
;   | sprites?        | TEXT SCREEN |                 | BITMAP SCRN |
;   +---------------------------------------------------------------+
;   Hires bitmap screen at $A000-$BF3F
;   Text screen at $8C00-$8C40

    for n=0 to 62
        poke $8000+n, sprite![n]  ; sprite data in $8000...
    next
    spr_setshape 0, 0           ; sprite 0 image -> $8000
    spr_setcolor 0, \_BLUE      ; sprite 0 colour
    spr_setdblwidth 0           ; expand sprite 0 both direction
    spr_setdblheight 0        
    spr_behindbg 0              ; set all sprites behind text

    ;spr_enable 0
    ;spr_setposx 0, 100
    ;spr_setposy 0, 100
endproc

;------------------------------------------------------------------------------
; Initialise board
;
proc init_board
    for r! = 0 to 2
        for c! = 0 to 2
            \board![r!,c!] = 0
        next
    next
endproc

;------------------------------------------------------------------------------
;   Procedure to draw empty board and title
;
proc draw_empty_board
    hi_clear
    x1 = 0
    y1 = 0
    x2 = \XS*3
    y2 = \YS*3
    rem Draw outer box
    hi_rect x1, y1, x2, y2
    rem Draw lines inside the box
    hi_line x1, \YS, x2, \YS
    hi_line x1, \YS*2, x2, \YS*2
    hi_line \XS, 0, \XS, \YS*3
    hi_line \XS*2, 0, \XS*2, \YS*3

    call hires_text(30,0, "TIC", 3)
    call hires_text(32,3, "TAC", 3)
    call hires_text(34,6, "TOE", 3)

 endproc

;--------------------------------------------------------------------------------------------------
;   Procedure to show board + contents
;
proc show_board

    ;call draw_empty_board

    for i=0 to 2
        for j=0 to 2
            x = 4 + 9*j
            y = 4 + 8*i
            call hires_text( x, y, " ", 0)
            if \board![i,j] = \HUMAN! then
                x1 = \XS*j + 10
                y1 = \YS*i + 8
                x2 = x1 + \XS - 20
                y2 = y1 + \YS - 16
                hi_line x1,y1, x2,y2
                hi_line x1,y2, x2,y1
            else 
                if \board![i,j] = \COMPUTER! then
                    x = \XO + \XS*j
                    y = \YO + \YS*i
                    hi_circle x,y, \XS/3
                else
                    x = 4 + 9*j
                    y = 4 + 8*i
                    call hires_text( x, y, \cellnum$[i*3+j], 0)
                endif
            endif
        next
    next
endproc

;--------------------------------------------------------------------------------------------------
;  Procedure to show message at bottom right
;
proc show_message( rev!, a$, b$, c$, d$ )
    if rev! = 1 then
        f$="{REV_ON}"
    else
        f$="{REV_OFF}"
    endif
    call hires_text( 29, 21, a$, 0 )
    call hires_text( 29, 22, b$, 0 )
    call hires_text( 29, 23, c$, 0 )
    call hires_text( 35, 23, d$, 0 )
endproc

;--------------------------------------------------------------------------------------------------
; Subroutine to check if game is over
; Set over=1 if game over, else over=0
;
fun check_winner!()
    w! = 0
    ; check rows
    for r = 0 to 2
        if \board![r,0] <> 0 then
            if \board![r,0] = \board![r,1] and \board![r,1] = \board![r,2] then 
                w! = 1
                return w! 
            endif
        endif
    next
    ;  Check columns
    for c = 0 to 2
        if \board![0,c] <> 0 then
            if \board![0,c] = \board![1,c] and \board![1,c] = \board![2,c] then 
                w! = 2
                return w! 
            endif
        endif
    next
    ;  Check diagonals
    if \board![0,0] <> 0 then 
        if \board![0,0] = \board![1,1] and \board![1,1] = \board![2,2] then 
            w! = 3
            return w!
        endif
    endif
    if \board![0,2] <> 0 then
        if \board![0,2] = \board![1,1] and \board![1,1] = \board![2,0] then
            w! = 4
            return w!
        endif
    endif
    
    return w!
endfun


;--------------------------------------------------------------------------------------------------
;   Subroutine to declare the winner
;
proc declare_winner( w!, p! )
    if w! = 0 then 
        a$ = " it's a draw  "
    else
        if p! = \COMPUTER! then 
            a$ = "computer wins!"
        else 
            a$ = " you win! "
        endif
    endif 
    call play_sound(18)
    call hires_text(1, 8, a$, 3)
    call delay(10)
endproc


;--------------------------------------------------------------------------------------------------
;   Subroutine to check rows for a winning move or to block opponent's move
;
fun check_rows!( s! )
    m! = 255
    for r! = 0 to 2
        if \board![r!,0] = s! then
            if \board![r!,1] = s! and \board![r!,2] = 0 then
                m! = r!*3 + 2
                return m!
            endif
            if \board![r!,2] = s! and \board![r!,1] = 0 then
                m! = r!*3 + 1
                return m!
            endif
        endif
        if \board![r!,1] = s! then
            if \board![r!,2] = s! and \board![r!,0] = 0 then
                m! = r!*3
                return m!
            endif
        endif
    next
    return m!
endfun


;--------------------------------------------------------------------------------------------------
;   Subroutine to check columns for a winning move or to block opponent's move
;
fun check_columns!( s! )
    m! = 255 
    for c! = 0 to 2
        if \board![0,c!] = s! then
            if \board![1,c!] = s! and \board![2,c!] = 0 then
                m! = 2*3 + c!
                return m!
            endif
            if \board![2,c!] = s! and \board![1,c!] = 0 then
                m! = 3 + c!
                return m!
            endif
        endif 
        if \board![1,c!] = s! then
            if \board![2,c!]=s! and \board![0,c!] = 0 then
                m! = c!
                return m! 
            endif
        endif
    next
    return m!
endfun


;--------------------------------------------------------------------------------------------------
;   Subroutine to check diagonals for a winning move or to block opponent's move
;
fun check_diagonals!( s! )
    m! = 255
    if \board![1,1] <> s! then return m!
    if \board![0,0]=s! and \board![2,2]=0 then m! = 8 : return m!
    if \board![2,2]=s! and \board![0,0]=0 then m! = 0 : return m!
    if \board![0,2]=s! and \board![2,0]=0 then m! = 6 : return m!
    if \board![2,0]=s! and \board![0,2]=0 then m! = 2 : return m!
    return m!
endfun

;--------------------------------------------------------------------------------------------------
;   Subroutine to compute computer's move
;
fun compute_move!()
    m! = 255
    ;rem check for winning move
    m! = check_rows!( \COMPUTER! )  :rem check for winning rows
    if m! <> 255 then return m!
    m! = check_columns!( \COMPUTER! )   :rem check for winning columns
    if m! <> 255 then return m!
    m! = check_diagonals!( \COMPUTER! ) :rem check for winning diagonals
    if m! <> 255 then return m!

    ;rem  check for blocking moves
    m! = check_rows!( \HUMAN! )  :rem check rows if need to block
    if m! <> 255 then return m!
    m! = check_columns!( \HUMAN! )   :rem check columns if need to block
    if m! <> 255 then return m!
    m! = check_diagonals!( \HUMAN! ) :rem check diagonals if need to block
    if m! <> 255 then return m!

    ;rem otherwise make a move, first by checking if middle cell is empty
    if \board![1,1] = 0 then return 4
    ;rem  else, move to a random cell
    repeat
        m! = cast!(rnd%()*9)
        r! = m!/3
        c! = m! - r!*3
    until \board![r!,c!] = 0
    return m!
endfun

;--------------------------------------------------------------------------------------------------
;   Subroutine to get user input/move
;
fun get_user_move!()

    m! = 255
    n! = 0

    repeat
 
        call show_message( 0, "  Select   ", " your move ", "  1 - ", "9")
        repeat
            k! = inkey!()
            if n! = 1 then n! = 0 else n! = 1
        until k! > 48 and k! < 58
        call play_sound(16)

        m! = k! - 49
        r! = m!/3
        c! = m! - 3*r!
        


        ; Sprites omitted in this version ******
        spr_setposx 0, \sx[m!]      ;rem  Highlight the selected cell
        spr_setposy 0, \sy[m!]
        spr_enable 0
        for i = 0 to 10
            spr_setcolor 0, \sc[n!]
            inc n! 
            if n!>5 then n! = 0
            call delay(2)
        next
        spr_disable 0
                                    ;rem I selected cell empty?
        if \board![r!,c!] <> 0 then 
            m! = 255
            call play_sound(2)
        endif
    until m! <> 255

    return m! 

endfun

;--------------------------------------------------------------------------------------------------
;   Subroutine to get user Y/N from user
;
fun get_yes_no!( a$ )
    hires_text 1, 15, a$, 2 
    hires_text 1, 17, "Press Y or N", 1
    yn! = 255
    while yn! = 255
        repeat
            k! = inkey!()
        until k! <> 0
        call play_sound(16)
        if k! = 'y' or k! = 'Y' then 
            yn! = 1
        else
            if k! = 'n' or k! = 'N' then 
                yn! = 0
            else
                hires_text 1, 17, "Please enter Y or N", 1
                call delay(2)
            endif
        endif
    endwhile
    return yn!
endfun


;--------------------------------------------------------------------------------------------------
;  The tic-tac-toe game routine
;--------------------------------------------------------------------------------------------------
;
proc play_game( start! ) 

    call draw_empty_board
    call show_board
    moves! = 0
    gameover! = 0
    win! = 0
    player! = start!
    repeat
        if player! = \COMPUTER! then 
            call show_message(0, "Computer is", "thinking...", "          ", " ")
            call delay(50)
            m! = compute_move!()
            r! = m!/3
            c! = m!-3*r!
            \board![r!,c!] = \COMPUTER!
            call show_board
            call play_sound(16)
            call show_message(0, " Computer  ", " put O in  ", " cell", \cellnum$[m!])
            call delay(50)
        else
            m! = get_user_move!()
            r! = m!/3
            c! = m! - 3*r!
            \board![r!,c!] = \HUMAN!
            call show_board
            call show_message(0, " You put   ", "   X in    ", " cell", \cellnum$[m!])
            call delay(50)
        endif
        win! = check_winner!()
        if win! <> 0 then 
            gameover! = 1
        else
            inc moves!
            if moves! = 9 then 
                gameover! = 1
            else 
                if player! = \COMPUTER! then 
                    player! = \HUMAN!
                else 
                    player! = \COMPUTER!
                endif
            endif
        endif
    until gameover! = 1
    call declare_winner( win!, player! )
endproc


;--------------------------------------------------------------------------------------------------
;   Main program - tic tac toe
;--------------------------------------------------------------------------------------------------
;
call sfx_init(@sound_data, 1)
poke BORDER, _GREEN
hi_bitmapon
hi_setcolor _BLACK, _GREEN
;
; Could not make sprites work properly in HIRES screen
; Maybe will work on it later
call setup_sprites
;k! = getkey!()

repeat    
    call init_board
    call draw_empty_board
    call show_board
    k! = get_yes_no!("Do you want to move first?")
    if k! = 1 then 
        player! = HUMAN!
    else 
        player! = COMPUTER!
    endif
    delay(2)
    call play_game( player! )      : rem main game routine
    y! = get_yes_no!("Do you want to play again?")
until y! = 0

hi_bitmapoff
print "{DOWN}bye."
end

sound_data:
incbin "../inc/outlaw.sfx"