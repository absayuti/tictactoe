!- TIC-TAC-TOE-80-128
!- Ported from a QB64 version,
!- which was written based on several sources
!-
!- v 0.1 - 11 June 2021
!-              Using the C128's 80 column VDC
!-
!-------------------------------------------------------------------------------
!-
!-** Colours in C128 80 column mode
!-CONST BLACK  1
!-CONST WHITE  2
!-CONST RED    3
!-CONST AQUA   4
!-CONST PURPLE 5
!-CONST GREEN  6
!-CONST BLUE   7
!-CONST YELLOW 8
!-CONST DKPURP 9
!-CONST BROWN  10
!-CONST PINK   11
!-CONST CYAN   12
!-CONST MDGRAY 13
!-CONST LTGRN  14
!-CONST LTBLU  15
!-CONST LTGRAY 16
!-
!----------------------------------
!-  Game variables/settings
100 dim board$(3,3)
110 rem Xoffset, Xsize, Yoffset, Ysize
120 xo=4: xs=18: yo=1: ys=8
130 compu% = 1
140 human% = 2
!-  Computer will move with 'o', and human with 'x'
150 nought$ = "o"
160 cross$ = "x"
170 gosub 2170                          :rem setup color seq array
!-
!-------------------------------------------------------------------------------
!-   Main program - tic tac toe
!-------------------------------------------------------------------------------
180 color 0,1 : color 4,1               :rem Black bground + border
190 graphic 5,1                         :rem 80 column mode
200 do                                  :rem play until user quits
210   gosub 620                         :rem initialize board
220   gosub 680                         :rem show board
230   a$="do you want to move first?"
240   gosub 2010                        :rem get Y/N
250   if k$="y" then pl%=human% :else pl%=compu%
260   gosub 320                         :rem main game routine
270   a$="do you want to play again?"
280   gosub 2010                        :rem get Y/N
290 loop until k$="n"
300 print: print "bye."
310 end
!-
!-------------------------------------------------------------------------------
!-  The tic-tac-toe game routine
!-
320 gosub 680                           :rem show board
330 mv = 0 : ov = 0
340 do while mv<9
350   if pl%<>compu% then 460
!-    Computer's move
360     gosub 1390                      :rem compute computer's move
370     r=int(m/3): c=m-3*r
380     bo$(r,c)=nought$
390     gosub 770                       :rem update board
400     char 1,60,20,"  computer"
410     char 1,60,21,"  put o in"
420     char 1,60,22,"   cell "+chr$(m+49)
430     char 1,60,23,"         "
440     sleep 1
450     goto 550
!-    Human's move
460     gosub 990 :                    :rem get user input
470     r=int(m/3): c=m-3*r
480     bo$(r,c)=cross$
490     gosub 880                       :rem update board
500     char 1,60,20,"  you put "
510     char 1,60,21,"    x in  "
520     char 1,60,22,"   cell "+chr$(m+49)
530     char 1,60,23,"         "
540     sleep 1
550   gosub 1170                        :rem check if game is over
560   if ov=1 then exit                 :rem game over, exit loop
570   mv=mv+1                           :rem next move
580   if pl%=compu% then pl%=human% :else pl%=compu%
590 loop
600 gosub 1290                          :rem Declare winner
610 return
!-
!-------------------------------------------------------------------------------
!-  Initialise board
!-
620 for r=0 to 2
630   for c=0 to 2
640     board$(r,c)=" "
650   next
660 next
670 return
!-
!-------------------------------------------------------------------------------
!-  Subroutine to show board + cell numbers
!-
680 print "{light gray}{clear}";
690 gosub 2220                          :rem print empty board+title
!-
700 color 5,GREEN                       :rem put cell numbers
710 for r=0 to 2
720   for c=0 to 2
730     char 1,c*xs+xo+5,r*ys+yo+3,chr$(r*3+c+49)
740   next
750 next
760 return
!-
!-------------------------------------------------------------------------------
!-  Draw nought
!-
770 x = xo + xs*c
780 y = yo + ys*r
790 color 5,PINK
800 char 1,x,y,  "  ooooooo  "
810 char 1,x,y+1," o       o "
820 char 1,x,y+2,"o         o"
830 char 1,x,y+3,"o         o"
840 char 1,x,y+4,"o         o"
850 char 1,x,y+5," o       o "
860 char 1,x,y+6,"  ooooooo  "
870 return
!-
!-------------------------------------------------------------------------------
!-  Draw cross
!-
880 x = xo + xs*c
890 y = yo + ys*r
900 color 5,AQUA
910 char 1,x,y,  "xx       xx"
920 char 1,x,y+1,"  xx   xx"
930 char 1,x,y+2,"    xxx  "
940 char 1,x,y+3,"     x   "
950 char 1,x,y+4,"    xxx  "
960 char 1,x,y+5,"  xx   xx"
970 char 1,x,y+6,"xx       xx"
980 return
!-
!-------------------------------------------------------------------------------
!-  Subroutine to get user input
!-
990 n = 0
1000 do
1010   do
1020     color 5,sc(n)
1030     char 1,60,20,"  select  "
1040     char 1,60,21," your move"
1050     char 1,60,22,"   1-9    "
1060     get k$
1070     if k$<>"" then 1100
1080     n=n+1: if n>4 then n=0         :rem cycle marker colour
1090     for t=0 to 99 : next
1100     k = asc(k$)-48
1110   loop until k>0 and k<10
1120   m = k-1
1130   r=int(m/3): c=m-3*r
1140   gosub 1890                       :rem highlight selected cell
1150 loop until bo$(r,c)=" "
1160 return
!-
!-------------------------------------------------------------------------------
!- Subroutine to check if game is over
!- Set over=1 if game over, esle over=0
!-
!-   Check rows
1170 ov = 0
1180 for r=0 to 2
1190   if bo$(r,0)=bo$(r,1) and bo$(r,1)=bo$(r,2) and bo$(r,0)<>" " then ov=1
1200 next
1210 if ov=1 then return
!-   Check columns
1220 for c=0 to 2
1230   if bo$(0,c)=bo$(1,c) and bo$(1,c)=bo$(2,c) and bo$(0,c)<>" " then ov=1
1240 next
1250 if ov=1 then return
!-   Check diagonals
1260 if bo$(0,0)=bo$(1,1) and bo$(1,1)=bo$(2,2) and bo$(0,0)<>" " then ov=1
1270 if bo$(0,2)=bo$(1,1) and bo$(1,1)=bo$(2,0) and bo$(0,2)<>" " then ov=1
1280 return
!-
!-------------------------------------------------------------------------------
!-   Subroutine to declare the winner
!-
1290 if ov=0 and mv=9 then a$=" it's a draw   ": goto 1320
1300 if pl% = compu% then a$="computer wins!"
1310 if pl% = human% then a$= "   you win!"
1320 color 5,YELLOW
1330 char 1,15,7,"{cm a}{C*20}{cm s}"
1340 char 1,15,8,"B{space*20}B"
1350 char 1,17,8,a$
1360 char 1,15,9,"{cm z}{C*20}{cm x}"
1370 sleep 1
1380 return
!-
!-------------------------------------------------------------------------------
!-   Subroutine to compute computer's move
!-
!-   check for winning moves
1390 sy$ = nought$
1400 gosub 1590                         :rem check for winning rows
1410 if m > -1 then return
1420 gosub 1700                         :rem check for winning columns
1430 if m > -1 then return
1440 gosub 1820                         :rem check for winning diagonals
1450 if m > -1 then return
!-
!-   check for blocking moves
1460 sy$ = cross$
1470 gosub 1590                         :rem check rows if need to block
1480 if m > -1 then return
1490 gosub 1700                         :rem check for columns if need to block
1500 if m > -1 then return
1510 gosub 1820                         :rem check for diagonals if need to block
1520 if m > -1 then return
!-
!-   else, check middle cell if empty
1530 if bo$(1,1)=" " then m = 4 : return
!-   else, move to a random cell
1540 do
1550   m = int(rnd(0)*9)
1560   r = int(m/3) : c = m - r*3
1570 loop while bo$(r,c)<>" "
1580 return
!-
!-------------------------------------------------------------------------------
!-   Subroutine to check rows for a winning move or to block opponent's move
!-
1590 m = -1
1600 for r=0 to 2
1610   if bo$(r,0)=sy$ then begin
1620     if bo$(r,1)=sy$ and bo$(r,2)=" " then m = r*3+2 :return
1630     if bo$(r,2)=sy$ and bo$(r,1)=" " then m = r*3+1 :return
1640   bend
1650   if bo$(r,1)=sy$ then begin
1660     if bo$(r,2)=sy$ and bo$(r,0)=" " then m = r*3 :return
1670   bend
1680 next
1690 return
!-
!-------------------------------------------------------------------------------
!-   Subroutine to check columns for a winning move or to block opponent's move
!-
1700 m = -1
1710 for c=0 to 2
1720   if bo$(0,c)<>sy$ then 1770
1730     if bo$(1,c)<>sy$ or bo$(2,c)<>" " then 1750
1740       m = 2*3 + c : return
1750     if bo$(2,c)<>sy$ or bo$(1,c)<>" " then 1770
1760       m = 3 + c : return
1770   if bo$(1,c)<>sy$ then 1800
1780     if bo$(2,c)<>sy$ or bo$(0,c)<>" " then 1800
1790       m = c : return
1800 next
1810 return
!-
!-------------------------------------------------------------------------------
!-   Subroutine to check diagonals for a winning move or to block opponent's move
!-
1820 m = -1
1830 if bo$(1,1)<>sy$ then return
1840 if bo$(0,0)=sy$ and bo$(2,2)=" " then m = 8 : return
1850 if bo$(2,2)=sy$ and bo$(0,0)=" " then m = 0 : return
1860 if bo$(0,2)=sy$ and bo$(2,0)=" " then m = 6 : return
1870 if bo$(2,0)=sy$ and bo$(0,2)=" " then m = 2 : return
1880 return
!-
!-------------------------------------------------------------------------------
!-   Subroutine to highlight selected cell
!-
1890 color 5,AQUA
1900 x = xo + xs*c
1910 y = yo + ys*r
1920 for n=1 to 3
1930   char 1,x+2,y+3,"{cm k*2}"
1940   char 1,x+7,y+3,"{cm k*2}"
1950   for t=0 to 99 : next
1960   char 1,x+2,y+3,"  "
1970   char 1,x+7,y+3,"  "
1980   for t=0 to 99 : next
1990 next
2000 return
!-
!-------------------------------------------------------------------------------
!-   Subroutine to get user Y/N from user
!-
2010 color 5,WHITE
2020 char 1,13,15,"{cm a}{C*28}{cm s}"
2030 char 1,13,16,"B{space*28}B"
2040 char 1,15,16,a$
2050 char 1,13,17,"B{space*28}B"
2060 char 1,15,17,"press y or n..."
2070 char 1,13,18,"{cm z}{C*28}{cm x}"
2080 do
2090   getkey k$
2100   if k$="y" then return
2110   if k$="Y" then k$="y": return
2120   if k$="n" then return
2130   if k$="N" then k$="n": return
2140   char 1,15,17,"please press y or n:"
2150   for t=1 to 100: next
2160 loop
!-
!-------------------------------------------------------------------------------
!-   Subroutine to setup "glowing colours"
!-
2170 dim sc(5)
2180 rem med-gray, lt-gray, white
2190 sc(0)=13: sc(1)=16: sc(2)=2
2200 sc(3)=sc(2): sc(4)=sc(1)
2210 return
!-
!-------------------------------------------------------------------------------
!-   Subroutine to print empty board and title
!-
2220 print"{green}U{C*53}I"
2230 for i=1 to 7
2240   print"{green}B{purple}{space*17}B{space*17}B{space*17}{green}B"
2250 next
2260 print"{green}B{purple}{C*17}{sh +}{C*17}{sh +}{C*17}{green}B"
2270 for i=1 to 7
2280   print"{green}B{purple}{space*17}B{space*17}B{space*17}{green}B"
2290 next
2300 print"{green}B{purple}{C*17}{sh +}{C*17}{sh +}{C*17}{green}B"
2310 for i=1 to 7
2320   print"{green}B{purple}{space*17}B{space*17}B{space*17}{green}B"
2330 next
2340 print"{green}J{C*53}K";"{home}";
2350 color 5,RED
2360 char 1,60, 0,"  abshms 2021"
2370 color 5,GREEN
2380 char 1,60, 2,"QQQQQ QQQ  QQQQ"
2390 char 1,60, 3,"  Q    Q  Q"
2400 char 1,60, 4,"  Q    Q  Q"
2410 char 1,60, 5,"  Q    Q  Q"
2420 char 1,60, 6,"  Q   QQQ  QQQQ"
2430 char 1,60, 7,""
2440 char 1,60, 8,"QQQQQ  QQQ   QQQQ"
2450 char 1,60, 9,"  Q   Q   Q Q"
2460 char 1,60,10,"  Q   QQQQQ Q"
2470 char 1,60,11,"  Q   Q   Q Q"
2480 char 1,60,12,"  Q   Q   Q  QQQQ"
2490 char 1,60,13,""
2500 char 1,60,14,"QQQQQ  QQQ  QQQQQ"
2510 char 1,60,15,"  Q   Q   Q Q"
2520 char 1,60,16,"  Q   Q   Q QQQ"
2530 char 1,60,17,"  Q   Q   Q Q"
2540 char 1,60,18,"  Q    QQQ  QQQQQ"
2550 RETURN

