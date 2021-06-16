' Tic-Tac-Toe
' Ref: https://www.geeksforgeeks.org/implementation-of-tic-tac-toe-game/
'      Tic-Tac-Toe in COMPUTE! Magazine
'
' 3 Jun 2021 -- changed to QB64
'
'--------------------------------------------------------------------------------------------------

' Screen 12's colours (Add 8 FOR bright colours)
Const Black = 0
Const Blue = 1
Const Green = 2
Const Cyan = 3
Const Red = 4
Const Magenta = 5
Const Yellow = 6
Const White = 7
Const Bright = 8

' For the game area
Const Xoffset = 10
Const Xsize = 120
Const Yoffset = 10
Const Ysize = 120

' For text row and column when using LOCATE
Const ColumnStart = 8
Const ColumnSize = 16
Const RowStart = 4
Const RowSize = 8
Const TextRow = 25
Const TextColumn = 50

' Game constants
Const Computer = 1
Const Human = 2
Const Side = 3 'Length of board

'Computer will move with 'O', and human with 'X'
Const Nought = "O"
Const Cross = "X"

'--------------------------------------------------------------------------------------------------
' Main program - Tic Tac Toe
'--------------------------------------------------------------------------------------------------

' Initialise random number generator
Randomize Timer
Screen 12 '640x480 256k colors

Dim choice As String
Print
Print "TIC-TAC-TOE"
Print

Do
    Print
    Print "Do you want to have the first move? (Y/N): ";
    Do
        Input choice
        If choice <> "Y" And choice <> "y" And choice <> "N" And choice <> "n" Then
            Print "Please enter Y or N: ";
        Else
            Exit Do
        End If
    Loop
    If choice = "Y" Or choice = "y" Then
        Call playTicTacToe(Human)
    Else
        Call playTicTacToe(Computer)
    End If

    Print
    Print "Do you want to play again? (Y/N): ";
    Do
        Input choice
        If choice <> "Y" And choice <> "y" And choice <> "N" And choice <> "n" Then
            Print "Please enter Y or N: ";
        Else
            Exit Do
        End If
    Loop
    If choice = "N" Or choice = "n" Then
        Print
        Print "Bye."
        Print
        Exit Do
    End If
Loop



'--------------------------------------------------------------------------------------------------
' The Tic-tac-toe game procedure
'
Sub playTicTacToe (whoseTurn As Integer)

    ' The board and moves
    Dim board(Side, Side) As String

    Call initialise(board())
    Call showBoardGraphic(board())
    Call showInstructions

    moveIndex = 0

    ' Keep playing game until game is over
    While gameOver(board()) = 0 And moveIndex <> Side * Side
        If whoseTurn = Computer Then
            computerMove = getComputerMove(board())
            x = Int(computerMove / Side)
            y = computerMove Mod Side
            board(x, y) = Nought
            Locate TextRow + 1, 2
            Print "Computer has put a "; Nought; " in cell "; computerMove + 1
            Call showBoardGraphic(board())
            moveIndex = moveIndex + 1
            whoseTurn = Human
        Else 'whoseTurn = Human
            humanMove = getUserInput(board())
            x = Int(humanMove / Side)
            y = humanMove Mod Side
            board(x, y) = Cross
            Locate TextRow + 1, 2
            Print "YOU have put a "; Cross; " in cell "; humanMove + 1
            Call showBoardGraphic(board())
            moveIndex = moveIndex + 1
            whoseTurn = Computer
        End If
    Wend

    If gameOver(board()) = 0 And moveIndex = Side * Side Then
        Locate TextRow + 1, 2
        Print "It's a DRAW"
    Else
        If whoseTurn = Computer Then
            whoseTurn = Human
        Else
            whoseTurn = Computer
        End If

        Call declareWinner(whoseTurn)
    End If
End Sub


'--------------------------------------------------------------------------------------------------
' Procedure to initialize the game
'
Sub initialise (board() As String)
    ' Initially the board is empty
    For r = 0 To Side - 1
        For c = 0 To Side - 1
            board(r, c) = " "
        Next
    Next
End Sub


'--------------------------------------------------------------------------------------------------
' Procedure to show board on graphic screen
'
Sub showBoardGraphic (board() As String)
    Dim As Integer x, y, x2, y2

    Cls
    Color Blue + Bright
    x = Xoffset
    y = Yoffset
    x2 = Xoffset + Xsize * 3
    y2 = Yoffset + Ysize * 3
    ' Draw outer box
    Line (x, y)-(x2, y)
    Line -(x2, y2)
    Line -(x, y2)
    Line -(x, y)
    ' Draw lines inside the box
    Line (Xoffset, Yoffset + Ysize)-(Xoffset + Xsize * 3, Yoffset + Ysize)
    Line (Xoffset, Yoffset + Ysize * 2)-(Xoffset + Xsize * 3, Yoffset + Ysize * 2)
    Line (Xoffset + Xsize, Yoffset)-(Xoffset + Xsize, Yoffset + Ysize * 3)
    Line (Xoffset + Xsize * 2, Yoffset)-(Xoffset + Xsize * 2, Yoffset + Ysize * 3)

    ' Draw symbols or put cell numbers
    For i = 0 To Side - 1 ' i = row
        For j = 0 To Side - 1 ' j = column
            If board(i, j) = Nought Then
                x = Xoffset + Xsize * j + Xsize / 2
                y = Yoffset + Ysize * i + Ysize / 2
                Call drawNought(x, y, Red + Bright)
            ElseIf board(i, j) = Cross Then
                x = Xoffset + Xsize * j + Xsize / 2
                y = Yoffset + Ysize * i + Ysize / 2
                Call drawCross(x, y, Yellow + Bright)
            Else
                Color Blue + Bright
                col = j * ColumnSize + ColumnStart
                row = i * RowSize + RowStart
                Locate row, col
                Print i * 3 + j + 1
            End If
        Next
    Next
End Sub


'--------------------------------------------------------------------------------------------------
' Procedure to draw Nought (CIRCLE) in specific cell
'
Sub drawNought (x As Integer, y As Integer, colr As Integer)
    Color colr
    For i = 0 To 5
        Circle (x, y), Xsize / 3 - i
    Next
End Sub


'--------------------------------------------------------------------------------------------------
' Procedure to draw cross (X) in specific cell
'
Sub drawCross (x As Integer, y As Integer, colr As Integer)
    Color colr
    For i = 0 To 5
        Line (x - Xsize / 3 + i, y - Ysize / 3)-(x + Xsize / 3 + i, y + Ysize / 3)
        Line (x - Xsize / 3 + i, y + Ysize / 3)-(x + Xsize / 3 + i, y - Ysize / 3)
    Next
End Sub


'--------------------------------------------------------------------------------------------------
' Procedure to show the instructions
'
Sub showInstructions
    Locate 2, TextColumn
    Print "Tic-Tac-Toe"
    Locate TextRow, 2
    Print "Choose a cell numbered from 1 to 9 as above and enter"
End Sub


'--------------------------------------------------------------------------------------------------
' Function that returns true IF game is over
' ELSE return false
Function gameOver (board() As String)

    check = rowCrossed(board()) + columnCrossed(board()) + diagonalCrossed(board())
    'check = rowCrossed( board())
    'PRINT "Check = "; rowCrossed( board() )
    'PRINT
    If check > 0 Then
        gameOver = 1
    Else
        gameOver = 0
    End If
End Function


'--------------------------------------------------------------------------------------------------
' Function that returns true IF any row is crossed
'
Function rowCrossed (board() As String)
    crossed = 0
    For i = 0 To Side - 1
        'PRINT "ROW:";i;" = ";board(i,0);board(i,1);board(i,2)
        IF board(i,0)=board(i,1) and board(i,1)=board(i,2) and _
           board(i,0)<>" " THEN
            crossed = 1
            'PRINT "***"
            Exit For
        End If
        'PRINT "??"
    Next
    rowCrossed = crossed
End Function


'--------------------------------------------------------------------------------------------------
' Function that returns true IF any column is crossed
'
Function columnCrossed (board() As String)
    crossed = 0
    For j = 0 To Side - 1
        IF board(0,j)=board(1,j) and board(1,j)=board(2,j) and _
           board(0,j)<>" "  THEN
            crossed = 1
            Exit For
        End If
    Next
    columnCrossed = crossed
End Function


'--------------------------------------------------------------------------------------------------
' Function that returns true IF any diagonal is crossed
'
Function diagonalCrossed (board() As String)
    crossed = 0
    IF board(0,0) = board(1,1) and  board(1,1) = board(2,2) and _
       board(0,0)<>" " THEN
        crossed = 1
    End If
    IF board(0,2) = board(1,1) and  board(1,1) = board(2,0) and _
       board(0,2)<>" " THEN
        crossed = 1
    End If
    diagonalCrossed = crossed
End Function


'--------------------------------------------------------------------------------------------------
' Procedure to declare the winner
'
Sub declareWinner (whoseTurn As Integer)
    Locate TextRow, 2
    If whoseTurn = Computer Then
        Print "Computer wins!"
    Else
        Print "YOU win!"
    End If
End Sub


'--------------------------------------------------------------------------------------------------
' Function to compute Computer's move
'
Function getComputerMove (board() As String)

    ' Check for winning moves
    move = winBlockRow(board(), Nought)
    If move = -1 Then
        move = winBlockColumn(board(), Nought)
    End If
    If move = -1 Then
        move = winBlockDiagonal(board(), Nought)
    End If

    'Check for blocking moves"
    If move = -1 Then
        move = winBlockRow(board(), Cross)
    End If
    If move = -1 Then
        move = winBlockColumn(board(), Cross)
    End If
    If move = -1 Then
        move = winBlockDiagonal(board(), Cross)
    End If

    If move = -1 Then
        ' Check middle cell if empty
        If board(1, 1) = " " Then
            move = 4
        Else 'move to a random cell
            Do
                move = Int(Rnd * Side * Side)
                x = Int(move / Side)
                y = move Mod Side
            Loop While board(x, y) <> " "
        End If
    End If
    getComputerMove = move
End Function


'--------------------------------------------------------------------------------------------------
' Function to check rows FOR a winning move or to block opponent's move
'
Function winBlockRow (board() As String, symbol As String)
    move = -1
    For i = 0 To Side - 1
        If board(i, 0) = symbol Then
            If board(i, 1) = symbol And board(i, 2) = " " Then
                move = i * Side + 2
                Exit For
            End If
            If board(i, 2) = symbol And board(i, 1) = " " Then
                move = i * Side + 1
                Exit For
            End If
        End If
        If board(i, 1) = symbol Then
            If board(i, 2) = symbol And board(i, 0) = " " Then
                move = i * Side
                Exit For
            End If
        End If
    Next
    winBlockRow = move
End Function


'--------------------------------------------------------------------------------------------------
' Function to check columns FOR a winning move or to block opponent's move
'
Function winBlockColumn (board() As String, symbol As String)
    move = -1
    For j = 0 To Side - 1
        If board(0, j) = symbol Then
            If board(1, j) = symbol And board(2, j) = " " Then
                move = 2 * Side + j
                Exit For
            End If
            If board(2, j) = symbol And board(1, j) = " " Then
                move = Side + j
                Exit For
            End If
        End If
        If board(1, j) = symbol Then
            If board(2, j) = symbol And board(0, j) = " " Then
                move = j
                Exit For
            End If
        End If
    Next
    winBlockColumn = move
End Function


'--------------------------------------------------------------------------------------------------
' Function that check FOR a winning move or to block opponent's move
'
Function winBlockDiagonal (board() As String, symbol As String)
    move = -1
    If board(1, 1) = symbol Then
        If board(0, 0) = symbol And board(2, 2) = " " Then
            move = 8
        ElseIf board(0, 2) = symbol And board(2, 0) = " " Then
            move = 6
        End If
    End If
    winBlockDiagonal = move
End Function


'--------------------------------------------------------------------------------------------------
' Function to get user input/move
'
Function getUserInput (board() As String)
    Locate TextRow, 2
    userInput = 0
    While userInput < 1 Or userInput > 9
        Input "Enter move # (1 to 9): ", userInput
        If userInput < 1 Or userInput > 9 Then
            Print "INVALID input"
        Else
            index = userInput - 1
            r = Int(index / Side)
            c = index Mod Side
            If board(r, c) <> " " Then
                Print "Cell "; userInput; " is NOT empty"
                userInput = 0
            End If
        End If
    Wend
    getUserInput = userInput - 1
End Function



