' Tic-Tac-Toe PicoCalc
' #6
' August 2025

' Game variables/setting
Dim board$(3,3)
nought$ = "o"
cross$  = "x"
x0 = 40 : y0 = 20 ' Board's position
size    = 80      ' Row / column size
width   = size*3  ' Size of the board
height  = width
ybox    = 265     ' Y-coord of text area
yprompt = 275     ' Text y-coord
compu   = 1
human   = 2
over    = 0
move    = 0
level   = 1
round   = 0
score   = 0
hiscore = 0
fname$  = "ttt-hiscore.txt"

' Setup musical note frequencies
Dim note$(14)
Dim notef(14)
Data "C",262,"D",294,"E",330,"F",349
Data "G",392,"A",440,"B",494
Data "c",523,"d",587,"e",659,"f",698
Data "g",784,"a",880,"b",988
For i=0 To 13
  Read note$(i)
  Read notef(i)
Next

' Main routine
read_high_score
show_title
play_tune
Do
  k$ = ask_turn()
  If k$ = "Y" Then
    pl = human
  Else
    pl = compu
  EndIf
  init_board
  show_board
  play_game
  declare_winner
  If winner=human Then
    score = score+10
    If score=30 Then level=2
    If score=60 Then level=3
    If score>hiscore Then
      hiscore=score
      save_high_score
    EndIf
  EndIf
  k$ = ask_play_again()
Loop Until k$ = "N"
Print
Print_info("Bye.")
End


' Game routine
Sub play_game
  show_board
  print_stat
  move = 0
  over = 0
  Do While move<9
    If pl = compu Then
      m = computer_move()
      r = Int(m/3)
      c = m-3*r
      board$(r,c) = nought$
      draw_nought(r,c)
      txt$ = "Computer's move = "
      txt$ = txt$+Str$(m+1)
      print_info(txt$)
      Pause 1500
    Else
      m = get_user_move()
      r = Int(m/3)
      c = m-3*r
      board$(r,c) = cross$
      draw_cross(r,c)
      txt$ = "Your move = "
      txt$ = txt$+Str$(m+1)
      print_info(txt$)
      Pause 1500
    EndIf
    over = check_game_over()
    If over=1 Then Exit Sub
    move = move+1
    ' swap turns
    If pl = compu Then
      pl = human
    Else
      pl = compu
    EndIf
  Loop
End Sub


Function computer_move()
  ' Check for winning moves
  If level>1 Then
    sy$ = nought$
    m = check_rows(sy$)
    If m>-1 Then
      computer_move = m
      Exit Function
    EndIf
    m = check_columns(sy$)
    If m>-1 Then
      computer_move = m
      Exit Function
    EndIf
    m = check_diagonals(sy$)
    If m>-1 Then
      'Text 30,1,Str$(m)
      computer_move = m
      Exit Function
    EndIf
  EndIf
  '
  ' Check for blocking moves
  If level>2 Then
    sy$ = cross$
    m = check_rows(sy$)
    If m>-1 Then
      computer_move = m
      Exit Function
    EndIf
    m = check_columns(sy$)
    If m>-1 Then
      computer_move = m
      Exit Function
    EndIf
    m = check_diagonals(sy$)
    If m>-1 Then
      computer_move = m
      Exit Function
    EndIf
  EndIf
  ' Otherwise...
  ' Check middle cell if empty
  If board$(1,1)=" " Then
    m = 4
    computer_move = m
    Exit Function
  Else ' pick random cell
    Do
      m = Int(Rnd(0)*9)
      r = Int(m/3)
      c = m-r*3
    Loop Until board$(r,c)=" "
    computer_move = m
    Exit Function
  EndIf
End Function


Function check_rows(sy$) As integer
  m = -1
  For r=0 To 2
    If board$(r,0)=sy$ Then
      If board$(r,1)=sy$ And board$(r,2)=" " Then
        m = r*3+2
      Else
        If board$(r,2)=sy$ And board$(r,1)=" " Then
          m = r*3+1
        End If
      EndIf
    Else
      If board$(r,1)=sy$ Then
        If board$(r,2)=sy$ And board$(r,0)=" " Then
          m = r*3
        EndIf
      EndIf
    EndIf
  Next
  check_rows = m
End Function


Function check_columns(sy$)
  m = -1
  For c=0 To 2
    If board$(0,c)=sy$ Then
      If board$(1,c)=sy$ And board$(2,c)=" " Then
        m = 2*3+c
      Else
        If board$(2,c)=sy$ And board$(1,c)=" " Then
          m = 3+c
        EndIf
      EndIf
    Else
      If board$(1,c)=sy$ Then
        If board$(2,c)=sy$ And board$(0,c)=" " Then
          m = c
        EndIf
      EndIf
    EndIf
  Next
  check_columns = m
End Function


Function check_diagonals(sy$)
  If board$(1,1) <> sy$ Then
    check_diagonals = -1
    Exit Function
  EndIf
  'Text 10,12,sy$
  If board$(0,0)=sy$ And board$(2,2)=" " Then
    check_diagonals = 8
    Exit Function
  EndIf
  If board$(2,2)=sy$ And board$(0,0)=" " Then
    check_diagonals = 0
    Exit Function
  EndIf
  If board$(0,2)=sy$ And board$(2,0)=" "Then
    check_diagonals = 6
    Exit Function
  EndIf
  If board$(2,0)=sy$ And board$(0,2)=" " Then
    check_diagonals = 2
    Exit Function
  EndIf
  check_diagonals = -1
End Function


Function check_game_over()
  cr = RGB(green)
  ' Check rows
  For r=0 To 2
    If board$(r,0)<>" " Then
      If board$(r,0)=board$(r,1) And board$(r,0)=board$(r,2) Then
        y = y0 + (r+0.5)*size
        Line x0,y,x0+width,y,3,cr
        check_game_over = 1
        Exit Function
      EndIf
    EndIf
  Next
  'if over = 1 then exit function
  ' Check columns
  For c=0 To 2
    If board$(0,c)<>" " Then
      If board$(0,c)=board$(1,c) And board$(0,c)=board$(2,c) Then
        x = x0 + (c+0.5)*size
        Line x,y0,x,y0+height,3,cr
        check_game_over = 1
        Exit Function
      EndIf
    EndIf
  Next
  ' Check diagonals
  x2 = x0+width
  y2 = y0+height
  If board$(0,0)<>" " Then
    If board$(0,0)=board$(1,1) And board$(0,0)=board$(2,2) Then
      Line x0,y0,x2,y2,,cr
      Line x0+1,y0,x2+1,y2,,cr
      Line x0-1,y0,x2-1,y2,,cr
      check_game_over = 1
      Exit Function
    EndIf
  EndIf
  If board$(0,2)<>" " Then
    If board$(0,2)=board$(1,1) And board$(0,2)=board$(2,0) Then
      Line x2,y0,x0,y2,,cr
      Line x2+1,y0,x0+1,y2,,cr
      Line x2-1,y0,x0-1,y2,,cr
      check_game_over = 1
      Exit Function
    EndIf
  EndIf
  check_game_over = 0
End Function


' Initialise/reset contents of board
Sub init_board
  For r = 0 To 2
    For c = 0 To 2
       board$(r,c) = " "
    Next
  Next
End Sub


Sub show_board
  CLS
  ' Lines for game area
  cr = RGB(gray)
  Line x0,y0+size,x0+width,y0+size,2,cr
  Line x0,y0+size*2,x0+width,y0+size*2,2,cr
  Line x0+size,y0,x0+size,y0+height,2,cr
  Line x0+size*2,y0,x0+size*2,y0+height,2,cr
  ' Print cell numbers
  For n=1 To 9
    m = n-1
    r = Int(m/3)
    c = m - r*3
    Text (c+0.5)*size+x0,(r+0.5)*size+y0,Str$(n),,,,RGB(gray)
  Next
End Sub


Sub show_title
  'text x,y,"string",align,font,scl,c,bc
  Text 30,120,"Tic-Tac-Toe",,5,1,RGB(red)
  Text 30,150,"Noughts & Crosses",,3,1,RGB(blue)
End Sub


Sub draw_nought(r,c)
  x = x0 + (c+0.5)*size
  y = y0 + (r+0.5)*size
  Circle x,y,size/3,3,1,RGB(red)
End Sub


Sub draw_cross(r,c)
  x = x0 + (c+0.25)*size
  y = y0 + (r+0.25)*size
  x2 = x0 + (c+0.75)*size
  y2 = y0 + (r+0.75)*size
  Line x,y,x2,y2,,RGB(white)
  Line x,y2,x2,y,,RGB(white)
  Line x+1,y,x2+1,y2,,RGB(white)
  Line x+1,y2,x2+1,y,,RGB(white)
  Line x-1,y,x2-1,y2,,RGB(white)
  Line x-1,y2,x2-1,y,,RGB(white)
End Sub


Function ask_turn() As string
  txt$ = "Do you want to move first?"
  txt$ = txt$+" (Y/N): "
  print_info(txt$)
  ask_turn = get_yn()
End Function


Function ask_play_again() As string
  txt$ = "Do you want to play again?"
  txt$ = txt$+" (Y/N): "
  print_info(txt$)
  ask_play_again = get_yn()
End Function


Function get_yn() As string
  Do
    Do
      k$ = Inkey$
    Loop While k$ = ""
    k$ = UCase$(k$)
    If k$<>  "Y" And k$ <> "N" Then
      print_info2("Y or N only")
    EndIf
  Loop Until k$="Y" Or k$="N"
  get_yn = k$
End Function


Function get_user_move()
  txt$ = "Use 'cursor' & 'Enter' keys to select"
  print_info(txt$)
  col = 1
  row = 1
  Do
    'm = col + row*3
    k$ = Inkey$
    If k$<>"" Then
      Select Case Asc(k$)
        Case 10, 13   ' Enter
          If board$(row,col)<>" " Then
            txt$ = "Selected cell is not empty"
            print_info2(txt$)
          Else
            get_user_move = col+row*3
            Exit Function
          EndIf
        Case 128
          row = row-1
          If row<0 Then row = 0
        Case 129
          row = row+1
          If row>2 Then row = 2
        Case 130
          col = col-1
          If col<0 Then col = 0
        Case 131
          col = col+1
          If col>2 Then col = 2
      End Select
    EndIf
    ' show box cursor
    x = col*size+8+x0
    y = row*size+8+y0
    Box x,y,65,65,3,RGB(cyan)
    Pause 100
    Box x,y,65,65,3,RGB(black)
    Pause 100
  Loop Until false
End Function


Function ask_user_move() As integer
  Do
    txt$ = "Enter/choose your move"
    txt$ = txt$+" (1 - 9): "
    print_info(txt$)
    Input n
    If n<1 Or n>9 Then
      Play tone 250,250,300
      print_info2("Invalid input")
    Else
      m = n - 1
      r = Int(m/3)
      c = m-r*3
      If board$(r,c)<>" " Then
        txt$ = "Cell "+Str$(n)+" is not empty"
        print_info2(txt$)
        n = 0
      EndIf
    EndIf
  Loop Until n>0 And n<10
  ask_user_move = n-1
End Function


Sub declare_winner
  If over=0 And move=9 Then
    txt$ = "It's a draw!"
    print_info txt$,,1
    winner = 0
    soundfx_draw
  Else
    If pl = compu Then
      txt$ = "Computer wins!"
      print_info txt$,,1
      winner = compu
      soundfx_lose
    Else
      txt$ = "You win!"
      print_info txt$,,1
      winner = human
      soundfx_win
    EndIf
  EndIf
  Pause 1500
End Sub


Sub print_stat
  Text 4,2,"LEVEL "+Str$(level),,,,RGB(white)
  Text 110,2,"SCORE "+Str$(score),,,,RGB(white)
  Text 210,2,"HI SCORE "+Str$(hiscore),,,,RGB(white)
  RBox 0,0,319,15,2,RGB(blue)
End Sub


Sub print_info txt$, txt2$, ft
  ' Draw new empty box
  RBox 0,ybox,319,319-ybox,10,RGB(blue),RGB(black)
  Play tone 500,500,50

  If ft=0 Then
    x = 160 - 4*Len(txt$)
    x2 = 160 - 4*Len(txt2$)
    Text x,yprompt,txt$,,,,RGB(cyan)
    Text x2,yprompt,txt2$,,,,RGB(cyan)
  Else
    x = 160 - 8*Len(txt$)
    x2 = 160 - 8*Len(txt2$)
    Text x,yprompt,txt$,,2,,RGB(gold)
  EndIf
End Sub


Sub print_info2( txt$ )
  x = 160 - 4*Len(txt$)
  Text x,yprompt+16,txt$,,,,RGB(yellow)
  For f=1 To 10
    Play tone 300,300,20
    Pause 20
  Next
  Pause 1500
  spc$ = " "
  For i=1 To 38
    spc$ = spc$+" "
  Next
  Text 4,yprompt+16,spc$
End Sub


Sub play_tune
  tune$ = "G G d d e e d  "
  tune$ = tune$+"c c B B A A G  "
  tune$ = tune$+"d d c c B B A  "
  tune$ = tune$+"d d c c B B G  "
  For i=1 To Len(tune$)
    a$ = Mid$(tune$,i,1)
    f = 0
    For j=0 To 13
      If a$=note$(j) Then f = notef(j)
    Next
    Play tone f,f
    'Print i,a$,j,f
    Pause 200
    If Inkey$<>"" Then Exit Sub
  Next
  Pause 500
End Sub


Sub soundfx_win
  Play tone 350,400: Pause 200
  Play tone 0,0: Pause 50
  Play tone 400,350: Pause 200
  Play tone 0,0: Pause 50
  Play tone 700,650: Pause 1000
  Play tone 0,0
  'Pause 1000
End Sub


Sub soundfx_draw
  For f=400 To 600 Step 20
    Play tone f,f: Pause 50
  Next
    For f=600 To 400 Step -20
    Play tone f,f: Pause 50
  Next
  Play tone 0,0
  'Pause 1000
End Sub


Sub soundfx_lose
  For f=600 To 300 Step -50
    Play tone f,f: Pause 200
  Next
  Play tone 0,0
  'Pause 1000
End Sub



Sub read_high_score
  If MM.Info(exists file fname$) Then
    Open fname$ For input As #1
    Line Input #1,a$
    Close #1
    hiscore = Val(a$)
  EndIf
End Sub


Sub save_high_score
  Open fname$ For output As #1
  Print #1, hiscore
  Close #1
End Sub

