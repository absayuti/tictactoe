; TIC-TAC-TOE-64 XC-BASIC version
; Ported from a C64 version written in CBM Prg Studio
; which was written based on several sources
;
; v 0.1 - 29 June 2021
; v 0.2
;------------------------------------------------------------------------------

include "../inc/xcb-ext-sprite.bas"

;------------------------------------------------------------------------------
; General constants
const BORDER  = $D020
const BGROUND = $D021
const COLRAM  = 55296
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
; Game constants
; Computer will move with 'o', and human with 'x'
const COMPUTER! = 1
const HUMAN! = 2
const XO = 2
const XS = 9
const YO = 2
const YS = 8

; Game variables/settings
dim board![3,3]

;rem Coords for marker sprite                
data sx[] = 40,112,184,  40,112,184,  40,112,184, 268   
data sy[] = 66,66,66, 130,130,130, 194,194,194, 218
;rem Shades of colors for the sprites
data sc[]  = 11,12,15,1,15,12

;------------------------------------------------------------------------------
;   Subroutine to setup sprite for target marker
; 
proc setup_sprites
    data sprite![] = 255,255,255, 255,255,255, 255,255,255, 255,255,255, 255,255,255, 255,255,255, ~
                     255,255,255, 255,255,255, 255,255,255, 255,255,255, 255,255,255, 255,255,255, ~
                     255,255,255, 255,255,255, 255,255,255, 255,255,255, 255,255,255, 255,255,255, ~
                     255,255,255, 255,255,255, 255,255,255, 0
    v = 53248

    for n=0 to 62
        poke 832+n, sprite![n]  ;rem sprite data in tape buffer
    next
    poke 2040, 13        ;rem sprite 0 image -> tape buffer
    poke v+39, 7 : rem sprite 0 colour
    poke v+23, 1 : poke v+29,1 : rem expand sprite 0 both direction
    poke v+27, 1 : rem set all sprites behind text
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
;   Subroutine to print empty board and title
;
proc print_empty_board
    print "{CLEAR}{REV_OFF}";
    PRINT "{LIGHT_GRAY}{176}CCCCCCCCCCCCCCCCCCCCCCCCCC{174}  {REV_ON}{LIGHT_RED}{160}{160}{160}{REV_OFF} {REV_ON}{160}{REV_OFF} {REV_ON}{169}{160}{127}"
    PRINT "{LIGHT_GRAY}{125}        {CYAN}{125}        {125}        {LIGHT_GRAY}{125}   {REV_ON}{LIGHT_RED}{160}{REV_OFF}  {REV_ON}{160}{REV_OFF} {REV_ON}{160}"
    PRINT "{LIGHT_GRAY}{125}        {CYAN}{125}        {125}        {LIGHT_GRAY}{125}   {REV_ON}{LIGHT_RED}{160}{REV_OFF}  {REV_ON}{160}{REV_OFF} {REV_ON}{160}"
    PRINT "{LIGHT_GRAY}{125}        {CYAN}{125}        {125}        {LIGHT_GRAY}{125}   {REV_ON}{LIGHT_RED}{160}{REV_OFF}  {REV_ON}{160}{REV_OFF} {REV_ON}{160}"
    PRINT "{LIGHT_GRAY}{125}        {CYAN}{125}        {125}        {LIGHT_GRAY}{125}   {REV_ON}{LIGHT_RED}{160}{REV_OFF}  {REV_ON}{160}{REV_OFF} {127}{REV_ON}{160}{REV_OFF}{169}"
    PRINT "{LIGHT_GRAY}{125}        {CYAN}{125}        {125}        {LIGHT_GRAY}{125}"
    PRINT "{125}        {CYAN}{125}        {125}        {LIGHT_GRAY}{125} {REV_ON}{CYAN}{160}{160}{160}{REV_OFF} {REV_ON}{169}{160}{127}{REV_OFF} {REV_ON}{169}{160}{127}";
    PRINT "{REV_OFF}{LIGHT_GRAY}{125}        {CYAN}{125}        {125}        {LIGHT_GRAY}{125}  {REV_ON}{CYAN}{160}{REV_OFF}  {REV_ON}{160}{REV_OFF} {REV_ON}{160}{REV_OFF} {REV_ON}{160}"
    PRINT "{LIGHT_GRAY}{125}{CYAN}CCCCCCCC{123}CCCCCCCC{123}CCCCCCCC{LIGHT_GRAY}{125}  {REV_ON}{CYAN}{160}{REV_OFF}  {REV_ON}{160}{REV_OFF} {REV_ON}{160}{REV_OFF} {REV_ON}{160}"
    PRINT "{LIGHT_GRAY}{125}        {CYAN}{125}        {125}        {LIGHT_GRAY}{125}  {REV_ON}{CYAN}{160}{REV_OFF}  {REV_ON}{160}{160}{160}{REV_OFF} {REV_ON}{160}"
    PRINT "{LIGHT_GRAY}{125}        {CYAN}{125}        {125}        {LIGHT_GRAY}{125}  {REV_ON}{CYAN}{160}{REV_OFF}  {REV_ON}{160}{REV_OFF} {REV_ON}{160}{REV_OFF} {127}{REV_ON}{160}{REV_OFF}{169}";
    PRINT "{LIGHT_GRAY}{125}        {CYAN}{125}        {125}        {LIGHT_GRAY}{125}"
    PRINT "{125}        {CYAN}{125}        {125}        {LIGHT_GRAY}{125} {REV_ON}{LIGHT_GREEN}{160}{160}{160}{REV_OFF} {REV_ON}{169}{160}{127}{REV_OFF} {REV_ON}{160}{160}{160}";
    PRINT "{REV_OFF}{LIGHT_GRAY}{125}        {CYAN}{125}        {125}        {LIGHT_GRAY}{125}  {REV_ON}{LIGHT_GREEN}{160}{REV_OFF}  {REV_ON}{160}{REV_OFF} {REV_ON}{160}{REV_OFF} {REV_ON}{160}"
    PRINT "{LIGHT_GRAY}{125}        {CYAN}{125}        {125}        {LIGHT_GRAY}{125}  {REV_ON}{LIGHT_GREEN}{160}{REV_OFF}  {REV_ON}{160}{REV_OFF} {REV_ON}{160}{REV_OFF} {REV_ON}{160}{160}"
    PRINT "{LIGHT_GRAY}{125}        {CYAN}{125}        {125}        {LIGHT_GRAY}{125}  {REV_ON}{LIGHT_GREEN}{160}{REV_OFF}  {REV_ON}{160}{REV_OFF} {REV_ON}{160}{REV_OFF} {REV_ON}{160}"
    PRINT "{LIGHT_GRAY}{125}{CYAN}CCCCCCCC{123}CCCCCCCC{123}CCCCCCCC{LIGHT_GRAY}{125}  {REV_ON}{LIGHT_GREEN}{160}{REV_OFF}  {127}{REV_ON}{160}{REV_OFF}{169} {REV_ON}{160}{160}{160}";
    PRINT "{REV_OFF}{LIGHT_GRAY}{125}        {CYAN}{125}        {125}        {LIGHT_GRAY}{125}"
    PRINT "{125}        {CYAN}{125}        {125}        {LIGHT_GRAY}{125}"
    PRINT "{125}        {CYAN}{125}        {125}        {LIGHT_GRAY}{125}"
    PRINT "{125}        {CYAN}{125}        {125}        {LIGHT_GRAY}{125}"
    PRINT "{125}        {CYAN}{125}        {125}        {LIGHT_GRAY}{125}"
    PRINT "{125}        {CYAN}{125}        {125}        {LIGHT_GRAY}{125}"
    PRINT "{125}        {CYAN}{125}        {125}        {LIGHT_GRAY}{125}"
    PRINT "{173}CCCCCCCCCCCCCCCCCCCCCCCCCC{189}{HOME}";
endproc

;--------------------------------------------------------------------------------------------------
; Subroutine to show board + contents
;
proc show_board
    rem print "{HOME}{LIGHT_GRAY}";
    call print_empty_board
    'x = \XO : y = \YO
    'x2 = \XO + \XS*3: y2 = \YO + \YS*3
    ' Draw symbols or put cell numbers
    for i=0 to 2
        for j=0 to 2
            if \board![i,j] = \COMPUTER! then
                x = \XO + \XS*j
                y = \YO + \YS*i
                curpos x, y : print "{PINK}UCCCCI"
                curpos x, y+1 : print "B    B"
                curpos x, y+2 : print "B    B"
                curpos x, y+3 : print "B    B"
                curpos x, y+4 : print "JCCCCK"
            else 
                if \board![i,j] = \HUMAN! then
                    x = \XO + \XS*j
                    y = \YO + \YS*i
                    curpos x, y : print "{LIGHT_GREEN}M   N"
                    curpos x, y+1 : print " M N"
                    curpos x, y+2 : print "  V"
                    curpos x, y+3 : print " N M"
                    curpos x, y+4 : print "N   M"
                else
                    textat j*\XS + \XO + 2, i*\YS + \YO + 2, i*3 + j + 1
                endif
            endif
        next
    next
endproc

;--------------------------------------------------------------------------------------------------
;  Procedure to show message at bottom right
;
proc show_message( rev!, col$, a$, b$, c$ )
    if rev! = 1 then
        f$="{REV_ON}"
    else
        f$="{REV_OFF}"
    endif
    curpos 29, 21: print f$,col$,a$;
    curpos 29, 22: print f$,col$,b$;
    curpos 29, 23: print f$,col$,c$;
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
        a$ = "  it's a draw   "
    else
        if p! = \COMPUTER! then 
            a$ = " computer wins! "
        else 
            a$ = "   you win!     "
        endif
    endif 
    curpos 0, 7: print "{WHITE}{REV_ON}                            "
    curpos 0, 8: print "{REV_ON}                            "
    curpos 6, 8: print "{REV_ON}",a$
    curpos 0, 9: print "{REV_ON}                            {REV_OFF}"
    call delay(100)
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
 
        repeat
            call show_message( n!, "{LIGHT_GREEN}", "  select   ", " your move ", "   1 - 9   ")
            k! = inkey!()
            call delay(10)
            if n! = 1 then n! = 0 else n! = 1
        until k! > 48 and k! < 58

        m! = k! - 49
        r! = m!/3
        c! = m! - 3*r!
        
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
        if \board![r!,c!] <> 0 then m! = 255
    until m! <> 255

    return m! 

endfun

;--------------------------------------------------------------------------------------------------
;   Subroutine to get user Y/N from user
;
fun get_yes_no!( a$ )
    curpos 0, 14: print "{YELLOW}{REV_ON}                            "
    curpos 0, 15: print "{REV_ON}                            "
    curpos 1, 15: print "{REV_ON}",a$
    curpos 0, 16: print "{REV_ON}      press y or n ...      "
    curpos 0, 17: print "{REV_ON}                            {REV_OFF}"
    yn! = 255
    while yn! = 255
        repeat
            k! = inkey!()
        until k! <> 0
        if k! = 'y' or k! = 'Y' then 
            yn! = 1
        else
            if k! = 'n' or k! = 'N' then 
                yn! = 0
            else
                textat 3, 16, "please enter y or n:"
                call delay(10)
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
    print"{CLEAR}" 
    call show_board
    moves! = 0
    gameover! = 0
    win! = 0
    player! = start!
    repeat
        if player! = \COMPUTER! then 
            m! = compute_move!()
            r! = m!/3
            c! = m!-3*r!
            \board![r!,c!] = \COMPUTER!
            call show_board
            call show_message(0, "{PINK}", " computer  ", " put o in  ", " cell      ")
            textat 34, 23, m!+1
        else
            rem call show_instructions(1) 
            m! = get_user_move!()
            r! = m!/3
            c! = m! - 3*r!
            \board![r!,c!] = \HUMAN!
            call show_board
            call show_message(0, "{LIGHT_GREEN}", " you put   ", "   x in    ", " cell      ")
            textat 34, 23, m!+1
        endif
        call delay(100)
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
print "{LIGHT_GRAY}{CLEAR}"
poke BGROUND,_BLUE : poke BORDER,_BLUE
call setup_sprites

repeat    
    call init_board
    call show_board
    k! = get_yes_no!("do you want to move first?")
    if k! = 1 then 
        player! = HUMAN!
    else 
        player! = COMPUTER!
    endif
    call play_game( player! )      : rem main game routine
    a$ = "do you want to play again?"
    y! = get_yes_no!("do you want to play again?")
until y! = 0
print "{DOWN}bye."
end
