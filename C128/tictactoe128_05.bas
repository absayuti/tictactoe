!- TIC-TAC-TOE-128
!- Ported from a QB64 version,
!- which was written based on several sources
!-
!- v 0.1 - 3 June 2021
!- v 0.3 - 8 June 2021
!-              Copy/pasted from 64 version
!-              Sprite does not appear to work.
!-              Different memory location in C128?
!- v 0.4 - 8 June 2021
!-              Making the sprite work first
!-              Changing to keywords/constructs unique to C128
!- v 0.5 - 10 June 2021
!-              To use C128's graphic/bitmap screen
!-
!-------------------------------------------------------------------------------
!-
!-** Colours in C128 mode
!-CONST BLACK  1
!-CONST WHITE  2
!-CONST RED    3
!-CONST CYAN   4
!-CONST PURPLE 5
!-CONST GREEN  6
!-CONST BLUE   7
!-CONST YELLOW 8
!-CONST ORANGE 9
!-CONST BROWN  10
!-CONST PINK   11
!-CONST DKGRY  12
!-CONST YELLOW 13
!-CONST LTGRN  14
!-CONST LTBLU  15
!-CONST LTGRY  16
!-
!-** REGISTERS **
!-CONST BORDER 53280
!-CONST BGROUND 53281
!-CONST COLRAM 55296
!-
!-** Key Positions For The Game Area
!-CONST XOFFSET 5
!-CONST XSIZE   72
!-CONST YOFFSET 5
!-CONST YSIZE   64
!-
!-
!-------------------------------------------------------------------------------
!-  Game variables/settings
100 ro$="{home}{down*24}"
110 co$="{right*39}"
120 compu% = 1
130 human% = 2
140 dim board$(3,3): xo=5: xs=9: yo=4: ys=8
!-
!-  Computer will move with 'o', and human with 'x'
150 nought$ = "o"
160 cross$ = "x"
!-
170 gosub 2150                          :rem setup sprite data
180 gosub 2540                          :rem setup Title text array
!-
!-------------------------------------------------------------------------------
!-   Main program - tic tac toe
!-------------------------------------------------------------------------------
190 color 0,1 : color 4,1               :rem black bground + border
200 graphic 1,1
210 do                                  :rem play until user quits
220   gosub 660                         :rem initialize board
230   gosub 2340                        :rem show board
240   a$="do you want to move first?"
250   gosub 2010                        :rem get Y/N
260   if k$="y" then pl%=human% :else pl%=compu%
270   gosub 340                         :rem main game routine
280   a$="do you want to play again?"
290   gosub 2010                        :rem get Y/N
300 loop until k$="n"
310 graphic 0
320 print: print "bye."
330 end
!-
!-------------------------------------------------------------------------------
!-  The tic-tac-toe game routine
!-
340 gosub 2340                          :rem show empty board
350 mv = 0 : ov = 0
360 do while mv<9
370   if pl%<>compu% then 490
!-    Computer's move
380     gosub 1290
390     r=int(m/3): c=m-3*r
400     bo$(r,c)=nought$
410     gosub 860                       :rem draw nought on board
420     color 1,RED
430     char 1,29,19,"  computer"
440     char 1,29,20,"  put o in"
450     char 1,29,21,"   cell "+chr$(m+49)
460     char 1,29,22,"         "
470     sleep 1
480     goto 590
!-    Human's move
490     gosub 1010 : gosub 1790          :rem get user input
500     r=int(m/3): c=m-3*r
510     bo$(r,c)=cross$
520     gosub 920                       :rem draw cross on board
530     color 1,LTBLU
540     char 1,29,19,"  you put "
550     char 1,29,20,"    x in  "
560     char 1,29,21,"   cell "+chr$(m+49)
570     char 1,29,22,"         "
580     sleep 1
590   gosub 1070                        :rem check if game is over
600   if ov=1 then exit                 :rem game over, exit loop
610   mv=mv+1
620   if pl%=compu% then pl%=human% :else pl%=compu%
630 loop
640 gosub 1190                          :rem Declare winner
645 gosub 3000                          :rem play short tune
650 return
!-
!-------------------------------------------------------------------------------
!-  Initialise board
!-
660 for r=0 to 2
670   for c=0 to 2
680     board$(r,c)=" "
690   next
700 next
710 return
!-
!-------------------------------------------------------------------------------
!-  Subroutine to show board + contents
!-
720 gosub 2340 :rem print empty board
!-
!-  Draw symbols or put cell numbers
730 for r=0 to 2
740   for c=0 to 2
750     if board$(r,c)<>nought$ then 780
760       gosub 860       :rem draw nought
770       goto 830
780     if board$(r,c)<>cross$ then 810
790       gosub 920      :rem draw cross
800       goto 830
!-      Else print cell number
810     color 1,GREEN
820     char 1,c*xs+xo,r*ys+yo, chr$(r*3+c+49)
830   next
840 next
850 return
!-
!-------------------------------------------------------------------------------
!-  Draw nought
!-
860 char 1,c*xs+xo,r*ys+yo, " "
870 x = XOFFSET + XSIZE*c + XSIZE/2
880 y = YOFFSET + YSIZE*r + YSIZE/2
890 color 1,ORANGE
900 circle 1,x,y,XSIZE/4
910 return
!-
!-------------------------------------------------------------------------------
!-  Draw cross
!-
920 char 1,c*xs+xo,r*ys+yo, " "
930 x = XOFFSET + XSIZE*c + XSIZE/4
940 y = YOFFSET + YSIZE*r + YSIZE/4
950 x2 = XOFFSET + XSIZE*c + XSIZE/2 + XSIZE/4
960 y2 = YOFFSET + YSIZE*r + YSIZE/2 + YSIZE/4
970 color 1,LTBLU
980 draw 1,x,y to x2,y2
990 draw 1,x,y2 to x2,y
1000 return
!-
!-------------------------------------------------------------------------------
!-  Subroutine to show the instructions
!-
1010 color 1,LTGRN
1020 char 1,29,19,"  select  "
1030 char 1,29,20," your move"
1040 char 1,29,21,"          "
1050 char 1,29,22,"  1 - 9  "
1060 return
!-
!-------------------------------------------------------------------------------
!- Subroutine to check if game is over
!- Set over=1 if game over, esle over=0
!-
!-   Check rows
1070 ov = 0
1080 for r=0 to 2
1090   if bo$(r,0)=bo$(r,1) and bo$(r,1)=bo$(r,2) and bo$(r,0)<>" " then ov=1
1100 next
1110 if ov=1 then return
!-   Check columns
1120 for c=0 to 2
1130   if bo$(0,c)=bo$(1,c) and bo$(1,c)=bo$(2,c) and bo$(0,c)<>" " then ov=1
1140 next
1150 if ov=1 then return
!-   Check diagonals
1160 if bo$(0,0)=bo$(1,1) and bo$(1,1)=bo$(2,2) and bo$(0,0)<>" " then ov=1
1170 if bo$(0,2)=bo$(1,1) and bo$(1,1)=bo$(2,0) and bo$(0,2)<>" " then ov=1
1180 return
!-
!-------------------------------------------------------------------------------
!-   Subroutine to declare the winner
!-
1190 if ov=0 and mv=9 then a$=" it's a draw   ": goto 1220
1200 if pl% = compu% then a$="computer wins!"
1210 if pl% = human% then a$= "   you win!"
1220 color 1,YELLOW
1230 char 1,3,7,"{cm a}{C*20}{cm s}"
1240 char 1,3,8,"B{space*20}B"
1250 char 1,5,8,a$
1260 char 1,3,9,"{cm z}{C*20}{cm x}"
1270 sleep 1
1280 return
!-
!-------------------------------------------------------------------------------
!-   Subroutine to compute computer's move
!-
!-   check for winning moves
1290 sy$ = nought$
1300 gosub 1480: rem check for winning rows
1310 if m > -1 then return
1320 gosub 1600: rem check for winning columns
1330 if m > -1 then return
1340 gosub 1720: rem check for winning diagonals
1350 if m > -1 then return
!-
!-   check for blocking moves
1360 sy$ = cross$
1370 gosub 1480: rem check rows if need to block
1380 if m > -1 then return
1390 gosub 1600: rem check for columns if need to block
1400 if m > -1 then return
1410 gosub 1720: rem check for diagonals if need to block
1420 if m > -1 then return
!-
!-   else, check middle cell if empty
1430 if bo$(1,1)=" " then m = 4 : return
!-   else, move to a random cell
1440 m = int(rnd(0)*9)
1450 r = int(m/3) : c = m - r*3
1460 if bo$(r,c)<>" " then 1440
1470 return
!-
!-------------------------------------------------------------------------------
!-   Subroutine to check rows for a winning move or to block opponent's move
!-
1480 m = -1
1490 for r=0 to 2
1500   if bo$(r,0)<>sy$ then 1550
1510     if bo$(r,1)<>sy$ or bo$(r,2)<>" " then 1530
1520       m = r*3 + 2 : return
1530       if bo$(r,2)<>sy$ or bo$(r,1)<>" " then 1550
1540         m = r*3 + 1 : return
1550   if bo$(r,1)<>sy$ then 1580
1560     if bo$(r,2)<>sy$ or bo$(r,0)<>" " then 1580
1570         m = r*3 : return
1580 next
1590 return
!-
!-------------------------------------------------------------------------------
!-   Subroutine to check columns for a winning move or to block opponent's move
!-
1600 m = -1
1610 for c=0 to 2
1620   if bo$(0,c)<>sy$ then 1670
1630     if bo$(1,c)<>sy$ or bo$(2,c)<>" " then 1650
1640       m = 2*3 + c : return
1650     if bo$(2,c)<>sy$ or bo$(1,c)<>" " then 1670
1660       m = 3 + c : return
1670   if bo$(1,c)<>sy$ then 1700
1680     if bo$(2,c)<>sy$ or bo$(0,c)<>" " then 1700
1690       m = c : return
1700 next
1710 return
!-
!-------------------------------------------------------------------------------
!-   Subroutine to check diagonals for a winning move or to block opponent's move
!-
1720 m = -1
1730 if bo$(1,1)<>sy$ then return
1740 if bo$(0,0)=sy$ and bo$(2,2)=" " then m = 8 : return
1750 if bo$(2,2)=sy$ and bo$(0,0)=" " then m = 0 : return
1760 if bo$(0,2)=sy$ and bo$(2,0)=" " then m = 6 : return
1770 if bo$(2,0)=sy$ and bo$(0,2)=" " then m = 2 : return
1780 return
!-
!-------------------------------------------------------------------------------
!-   Subroutine to get user input/move
!-
1790 sprite 1,0                         :rem turn off marker sprite
1800 movspr 1,sx(9),sy(9)               :rem put marker at input area
1810 sprite 1,1,12,0,1,1,0              :rem turn on sprite, expanded XY
1820 n = 0
1830 get k$: if k$<>"" then 1880
1840   sprite 1,1,sc(n)                 :rem set marker colour
1850   n=n+1: if n>5 then n=0           :rem cycle marker colour
1860   for t=0 to 99 : next
1870 goto 1830
1880 k = asc(k$)-48
1890 if k<1 or k>9 then 1790
1900 m = k-1
1910 r=int(m/3): c=m-3*r
!-   Highlight the selected cell
1920 movspr 1,sx(m),sy(m)               :rem put marker at selected cell
1930 for p=0 to 6
1940   sprite 1,1,sc(n)                 :rem set marker colour
1950   n=n+1: if n>5 then n=0           :rem cycle marker colour
1960   for t=0 to 99 : next
1970 next
1980 sprite 1,0                         :rem turn off marker
1990 if bo$(r,c)<>" " then 1790
2000 return
!-
!-------------------------------------------------------------------------------
!-   Subroutine to get user Y/N from user
!-
2010 char 1,2,15,"{cm a}{C*26}{cm s}"
2020 char 1,2,16,"B{space*26}B"
2030 char 1,3,16,a$
2040 char 1,2,17,"B{space*26}B"
2050 char 1,3,17,"press y or n..."
2060 char 1,2,18,"{cm z}{C*26}{cm x}"
2070 get k$ : if k$="" then 2070
2080 if k$="y" then return
2090 if k$="Y" then k$="y": return
2100 if k$="n" then return
2110 if k$="N" then k$="n": return
2120 char 1,3,17,"Please enter y or n:"
2130 for t=1 to 100: next
2140 goto 2010
!-
!-------------------------------------------------------------------------------
!-   Subroutine to setup sprite for target marker
!-
2150 v=53248
2160 for n=0 to 62
2170   read q : poke 3584+n,q           :rem default sprite storage for C128
2180 next
2190 rem ** Marker coordinates on screen for sprite position
2200 sx(0)=40: sx(1)=sx(0)+72: sx(2)=sx(1)+72
2210 sx(3)=sx(0) : sx(4)=sx(1) : sx(5)=sx(2)
2220 sx(6)=sx(0) : sx(7)=sx(1) : sx(8)=sx(2)
2230 sx(9)= sx(8)+84
2240 sy(0)=66: sy(1)=sy(0): sy(2)=sy(0)
2250 sy(3)=sy(0)+64: sy(4)=sy(3): sy(5)=sy(3)
2260 sy(6)=sy(3)+64: sy(7)=sy(6): sy(8)=sy(6)
2270 sy(9)=sy(8)+24
2280 rem ** Shades of colors for the sprites
2290 dim sc(6)
2300 rem gray, med-gray, lt-gray, white
2310 sc(0)=12: sc(1)=13: sc(2)=16: sc(3)=2
2320 sc(4)=sc(2): sc(5)=sc(1)
2330 return
!-
!-------------------------------------------------------------------------------
!-   Subroutine to print TICTACTOE title and empty board
!-
2340 scnclr
2350 color 1,LTGRN
2360 for i=0 to 16
2370   char 1,29,i,tt$(i)
2380 next
!-
!-   Draw outer box
2390 color 1,GREEN
2400 x=XOFFSET : y=YOFFSET
2410 x2=XOFFSET+XSIZE*3: y2=YOFFSET+YSIZE*3
2420 box 1,x,y,x2,y2
!-
!-   Draw lines inside the box
2430 draw 1,XOFFSET,YOFFSET+YSIZE to XOFFSET+XSIZE*3,YOFFSET+YSIZE
2440 draw 1,XOFFSET,YOFFSET+YSIZE*2 to XOFFSET+XSIZE*3,YOFFSET+YSIZE*2
2450 draw 1,XOFFSET+XSIZE,YOFFSET to XOFFSET+XSIZE,YOFFSET+YSIZE*3
2460 draw 1,XOFFSET+XSIZE*2,YOFFSET to XOFFSET+XSIZE*2,YOFFSET+YSIZE*3
!-
!-   Put cell numbers
2470 color 1,GREEN
2480 for r=0 to 2
2490   for c=0 to 2
2500     char 1,c*xs+xo,r*ys+yo, chr$(r*3+c+49)
2510   next
2520 next
2530 return
!-
!-------------------------------------------------------------------------------
!-   Subroutine to define TICTACTOE title
!-
2540 dim tt$(17)
2550 tt$(0) = " {166}{166}{166} {166}  {166}{166}"
2560 tt$(1) = "  {166}  {166} {166}"
2570 tt$(2) = "  {166}  {166} {166}"
2580 tt$(3) = "  {166}  {166} {166}"
2590 tt$(4) = "  {166}  {166}  {166}{166}"
2600 tt$(5) = ""
2610 tt$(6) = "{166}{166}{166}  {166}   {166}{166}"
2620 tt$(7) = " {166}  {166} {166} {166}"
2630 tt$(8) = " {166}  {166} {166} {166}"
2640 tt$(9) = " {166}  {166}{166}{166} {166}"
2650 tt$(10) = " {166}  {166} {166}  {166}{166}"
2660 tt$(11) = ""
2670 tt$(12) = "{166}{166}{166}  {166}  {166}{166}{166}"
2680 tt$(13) = " {166}  {166} {166} {166}"
2690 tt$(14) = " {166}  {166} {166} {166}{166}"
2700 tt$(15) = " {166}  {166} {166} {166}"
2710 tt$(16) = " {166}   {166}  {166}{166}{166}"
2720 return
!-
!-------------------------------------------------------------------------------
!-   Play a short tune
!-
3000 rem itsy bitsy spider
3010 play"t9 o4 dgggabb.  b.agabg r"
3020 play"t9 o4 b.b. o5cd. d.c o4b o5cd o4b r"
3030 play"t9 o4 ggab. bagabg r"    
3040 play"t9 o4 d.dgggabb. b.agabg r"
3050 return
!-
!-------------------------------------------------------------------------------
!-   Sprite data for target marker
!-
6000 data 255,255,255
6020 data 128,0,1
6030 data 128,0,1
6040 data 128,0,1
6050 data 128,0,1
6060 data 128,0,1
6070 data 128,0,1
6080 data 128,0,1
6090 data 128,0,1
6100 data 128,0,1
6110 data 128,0,1
6120 data 128,0,1
6130 data 128,0,1
6140 data 128,0,1
6150 data 128,0,1
6160 data 128,0,1
6170 data 128,0,1
6180 data 128,0,1
6190 data 128,0,1
6200 data 128,0,1
6210 data 255,255,255
