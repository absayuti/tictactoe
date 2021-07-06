This is a repository for several BASIC programs for a Tic-tac-toe a.k.a. Noughts and Crosses game.

<h2>The versions</h2>

<ul>
<li>C64: Commodore 64 BASIC 2.0</li>
<li>C128: Commodore 128 BASIC 7.0</li>
<li>QBASIC: QuickBASIC (QB64 or FreeBASIC)</li>
<li>xcBASIC: XC=BASIC for Commodore 64</li>
</ul>

<h3>C64: Commodore 64 BASIC 2.0 version</h3>
This version was ported from the C128 version where the bitmap graphic output have been resplaced with normal text (PETSCII) output. BASIC 2.0 does not have built-in bitmap graphic drawing instructions. Structured programming constructs such as WHILE-WEND, DO-REPEAT-UNTIL have been replaced with IF-THEN-GOTO constructs. 

<h3>C128: Commodore 128 BASIC 7.0 version</h3>
This version was ported from the QBASIC version. Due to the C128 BASIC lack any PROCEDURE/FUNCTION structure, procedures and functions have been replaced with GOSUB-RETURN constucts instead.

<h3>QBASIC: QB64 version</h3>
This is the initial program, written for QB64, thus should be compatible with any QuickBASIC compatible compiler/interpreter such as FreeBASIC and QBASIC, to name a couple. The program was based on a C program found on the web and another version published as type-in in COMPUTE! magazine. The C program was written as an automated program that put noughts and crosses at random cells for both players. But it was structured and easy to follow. The COMPUTE!'s version was written in Commodore BASIC, thus not that structured but has routines where the computer has some kind of "intelligence" in deciding where to put its noughts or crosses.

This version sort of combined the two said programs with added graphic output routines.

