%d RO$�"" Wn CO$�"" fx COMPU% � 1 u� HUMAN% � 2 �� � BOARD$(3,3): XO�5: XS�9: YO�4: YS�8 �� NOUGHT$ � "O" �� CROSS$ � "X" �� � 2150                          :� SETUP SPRITE DATA 9� � 2540                          :� SETUP TITLE TEXT ARRAY s� � 0,1 : � 4,1               :� BLACK BGROUND + BORDER }� � 1,1 �� �                                  :� PLAY UNTIL USER QUITS �� � 660                         :� INITIALIZE BOARD #� � 2340                        :� SHOW BOARD G� A$�"DO YOU WANT TO MOVE FIRST?" t� � 2010                        :� GET Y/N �� K$�"Y" � PL%�HUMAN% :� PL%�COMPU% �� 340                         :� MAIN GAME ROUTINE �A$�"DO YOU WANT TO PLAY AGAIN?" $"� 2010                        :� GET Y/N 3,� � K$�"N" ;6� 0 K@�: � "BYE." QJ� �T� 2340                          :� SHOW EMPTY BOARD �^MV � 0 : OV � 0 �h� � MV�9 �r� PL%��COMPU% � 490 �|� 1290 ��R��(M�3): C�M�3�R ��BO$(R,C)�NOUGHT$ 0 �� 860                       :� DRAW NOUGHT ON BOARD : �� 1,3 U �� 1,29,19,"  COMPUTER" p �� 1,29,20,"  PUT O IN" � �� 1,29,21,"   CELL "��(M�49) � �� 1,29,22,"         " � �� 1 � �� 590 � �� 1010 : � 1790          :� GET USER INPUT !�R��(M�3): C�M�3�R !�BO$(R,C)�CROSS$ N!� 920                       :� DRAW CROSS ON BOARD Y!� 1,15 t!� 1,29,19,"  YOU PUT " �!&� 1,29,20,"    X IN  " �!0� 1,29,21,"   CELL "��(M�49) �!:� 1,29,22,"         " �!D� 1 "N� 1070                        :� CHECK IF GAME IS OVER E"X� OV�1 � �                 :� GAME OVER, EXIT LOOP Q"bMV�MV�1 }"l� PL%�COMPU% � PL%�HUMAN% :� PL%�COMPU% �"v� �"�� 1190                          :� DECLARE WINNER �"�� 3000                          :� PLAY SHORT TUNE �"�� #�� R�0 � 2 #�� C�0 � 2 &#�BOARD$(R,C)�" " ,#�� 2#�� 8#�� X#�� 2340 :� PRINT EMPTY BOARD f#�� R�0 � 2 t#�� C�0 � 2 �#�� BOARD$(R,C)��NOUGHT$ � 780 �#�� 860       :� DRAW NOUGHT �#� 830 �#� BOARD$(R,C)��CROSS$ � 810 �#� 920      :� DRAW CROSS $ � 830 $*� 1,6 4$4� 1,C�XS�XO,R�YS�YO, �(R�3�C�49) :$>� @$H� F$R� c$\� 1,C�XS�XO,R�YS�YO, " " {$fX � 5 � 72�C � 72�2 �$pY � 5 � 64�R � 64�2 �$z� 1,9 �$�� 1,X,Y,72�4 �$�� �$�� 1,C�XS�XO,R�YS�YO, " " �$�X � 5 � 72�C � 72�4 %�Y � 5 � 64�R � 64�4 !%�X2 � 5 � 72�C � 72�2 � 72�4 A%�Y2 � 5 � 64�R � 64�2 � 64�4 L%�� 1,15 `%�� 1,X,Y � X2,Y2 t%�� 1,X,Y2 � X2,Y z%�� �%�� 1,14 �%�� 1,29,19,"  SELECT  " �%� 1,29,20," YOUR MOVE" �%� 1,29,21,"          " �%� 1,29,22,"  1 - 9  " �%$� &.OV � 0 &8� R�0 � 2 R&B� BO$(R,0)�BO$(R,1) � BO$(R,1)�BO$(R,2) � BO$(R,0)��" " � OV�1 X&L� g&V� OV�1 � � u&`� C�0 � 2 �&j� BO$(0,C)�BO$(1,C) � BO$(1,C)�BO$(2,C) � BO$(0,C)��" " � OV�1 �&t� �&~� OV�1 � � '�� BO$(0,0)�BO$(1,1) � BO$(1,1)�BO$(2,2) � BO$(0,0)��" " � OV�1 S'�� BO$(0,2)�BO$(1,1) � BO$(1,1)�BO$(2,0) � BO$(0,2)��" " � OV�1 Y'�� �'�� OV�0 � MV�9 � A$�" IT'S A DRAW   ": � 1220 �'�� PL% � COMPU% � A$�"COMPUTER WINS!" �'�� PL% � HUMAN% � A$� "   YOU WIN!" �'�� 1,8 	(�� 1,3,7,"��������������������î" .(�� 1,3,8,"�                    �" =(�� 1,5,8,A$ b(�� 1,3,9,"��������������������ý" k(�� 1 q( � �(
SY$ � NOUGHT$ �(� 1480: � CHECK FOR WINNING ROWS �(� M � �1 � � �((� 1600: � CHECK FOR WINNING COLUMNS �(2� M � �1 � � )<� 1720: � CHECK FOR WINNING DIAGONALS -)F� M � �1 � � >)PSY$ � CROSS$ h)Z� 1480: � CHECK ROWS IF NEED TO BLOCK y)d� M � �1 � � �)n� 1600: � CHECK FOR COLUMNS IF NEED TO BLOCK �)x� M � �1 � � �)�� 1720: � CHECK FOR DIAGONALS IF NEED TO BLOCK �)�� M � �1 � � *�� BO$(1,1)�" " � M � 4 : � 0*�M � �(�(0)�9) M*�R � �(M�3) : C � M � R�3 h*�� BO$(R,C)��" " � 1440 n*�� y*�M � �1 �*�� R�0 � 2 �*�� BO$(R,0)��SY$ � 1550 �*�� BO$(R,1)��SY$ � BO$(R,2)��" " � 1530 �*�M � R�3 � 2 : � +�� BO$(R,2)��SY$ � BO$(R,1)��" " � 1550  +M � R�3 � 1 : � ;+� BO$(R,1)��SY$ � 1580 f+� BO$(R,2)��SY$ � BO$(R,0)��" " � 1580 v+"M � R�3 : � |+,� �+6� �+@M � �1 �+J� C�0 � 2 �+T� BO$(0,C)��SY$ � 1670 �+^� BO$(1,C)��SY$ � BO$(2,C)��" " � 1650 �+hM � 2�3 � C : �  ,r� BO$(2,C)��SY$ � BO$(1,C)��" " � 1670 2,|M � 3 � C : � M,�� BO$(1,C)��SY$ � 1700 x,�� BO$(2,C)��SY$ � BO$(0,C)��" " � 1700 �,�M � C : � �,�� �,�� �,�M � �1 �,�� BO$(1,1)��SY$ � � �,�� BO$(0,0)�SY$ � BO$(2,2)�" " � M � 8 : � -�� BO$(2,2)�SY$ � BO$(0,0)�" " � M � 0 : � ?-�� BO$(0,2)�SY$ � BO$(2,0)�" " � M � 6 : � m-�� BO$(2,0)�SY$ � BO$(0,2)�" " � M � 2 : � s-�� �-�� 1,0                         :� TURN OFF MARKER SPRITE �-� 1,SX(9),SY(9)               :� PUT MARKER AT INPUT AREA 1.� 1,1,12,0,1,1,0              :� TURN ON SPRITE, EXPANDED XY ;.N � 0 U.&� K$: � K$��"" � 1880 �.0� 1,1,SC(N)                 :� SET MARKER COLOUR �.:N�N�1: � N�5 � N�0           :� CYCLE MARKER COLOUR �.D� T�0 � 99 : � �.N� 1830 �.XK � �(K$)�48 	/b� K�1 � K�9 � 1790 /lM � K�1 +/vR��(M�3): C�M�3�R m/�� 1,SX(M),SY(M)               :� PUT MARKER AT SELECTED CELL {/�� P�0 � 6 �/�� 1,1,SC(N)                 :� SET MARKER COLOUR �/�N�N�1: � N�5 � N�0           :� CYCLE MARKER COLOUR �/�� T�0 � 99 : � 0�� 80�� 1,0                         :� TURN OFF MARKER S0�� BO$(R,C)��" " � 1790 Y0�� �0�� 1,2,15,"��������������������������î" �0�� 1,2,16,"�                          �" �0�� 1,3,16,A$ �0�� 1,2,17,"�                          �" 1� 1,3,17,"PRESS Y OR N..." 81� 1,2,18,"��������������������������ý" R1� K$ : � K$�"" � 2070 c1 � K$�"Y" � � |1*� K$�"�" � K$�"Y": � �14� K$�"N" � � �1>� K$�"�" � K$�"N": � �1H� 1,3,17,"�LEASE ENTER Y OR N:" �1R� T�1 � 100: � �1\� 2010 �1fV�53248 2p� N�0 � 62 E2z� Q : � 3584�N,Q           :� DEFAULT SPRITE STORAGE FOR C128 K2�� �2�� ** MARKER COORDINATES ON SCREEN FOR SPRITE POSITION �2�SX(0)�40: SX(1)�SX(0)�72: SX(2)�SX(1)�72 �2�SX(3)�SX(0) : SX(4)�SX(1) : SX(5)�SX(2) 
3�SX(6)�SX(0) : SX(7)�SX(1) : SX(8)�SX(2) 3�SX(9)� SX(8)�84 E3�SY(0)�66: SY(1)�SY(0): SY(2)�SY(0) r3�SY(3)�SY(0)�64: SY(4)�SY(3): SY(5)�SY(3) �3�SY(6)�SY(3)�64: SY(7)�SY(6): SY(8)�SY(6) �3�SY(9)�SY(8)�24 �3�� ** SHADES OF COLORS FOR THE SPRITES �3�� SC(6) 4�� GRAY, MED-GRAY, LT-GRAY, WHITE 74	SC(0)�12: SC(1)�13: SC(2)�16: SC(3)�2 T4	SC(4)�SC(2): SC(5)�SC(1) Z4	� `4$	� k4.	� 1,14 z48	� I�0 � 16 �4B	� 1,29,I,TT$(I) �4L	� �4V	� 1,6 �4`	X�5 : Y�5 �4j	X2�5�72�3: Y2�5�64�3 �4t	� 1,X,Y,X2,Y2 �4~	� 1,5,5�64 � 5�72�3,5�64 5�	� 1,5,5�64�2 � 5�72�3,5�64�2 25�	� 1,5�72,5 � 5�72,5�64�3 S5�	� 1,5�72�2,5 � 5�72�2,5�64�3 ]5�	� 1,6 k5�	� R�0 � 2 y5�	� C�0 � 2 �5�	� 1,C�XS�XO,R�YS�YO, �(R�3�C�49) �5�	� �5�	� �5�	� �5�	� TT$(17) �5�	TT$(0) � " ��� �  ��" �5 
TT$(1) � "  �  � �" 6

TT$(2) � "  �  � �"  6
TT$(3) � "  �  � �" :6
TT$(4) � "  �  �  ��" J6(
TT$(5) � "" e62
TT$(6) � "���  �   ��" ~6<
TT$(7) � " �  � � �" �6F
TT$(8) � " �  � � �" �6P
TT$(9) � " �  ��� �" �6Z
TT$(10) � " �  � �  ��" �6d
TT$(11) � "" �6n
TT$(12) � "���  �  ���" 7x
TT$(13) � " �  � � �" .7�
TT$(14) � " �  � � ��" H7�
TT$(15) � " �  � � �" d7�
TT$(16) � " �   �  ���" j7�
� �7�� ITSY BITSY SPIDER �7��"T9 O4 DGGGABB.  B.AGABG R" �7��"T9 O4 B.B. O5CD. D.C O4B O5CD O4B R" �7��"T9 O4 GGAB. BAGABG R" 8��"T9 O4 D.DGGGABB. B.AGABG R" 8�� (8p� 255,255,255 68�� 128,0,1 D8�� 128,0,1 R8�� 128,0,1 `8�� 128,0,1 n8�� 128,0,1 |8�� 128,0,1 �8�� 128,0,1 �8�� 128,0,1 �8�� 128,0,1 �8�� 128,0,1 �8�� 128,0,1 �8�� 128,0,1 �8�� 128,0,1 �8� 128,0,1 �8� 128,0,1 9� 128,0,1 9$� 128,0,1 $9.� 128,0,1 298� 128,0,1 D9B� 255,255,255 h9p� SPRITE DATA FOR TARGET MARKER z9z� 255,255,255 �9�� 128,0,1 �9�� 128,0,1 �9�� 128,0,1 �9�� 128,0,1 �9�� 128,0,1 �9�� 128,0,1 �9�� 128,0,1 �9�� 128,0,1 �9�� 128,0,1 :�� 128,0,1 :�� 128,0,1 ":�� 128,0,1 0:�� 128,0,1 >:� 128,0,1 L:� 128,0,1 Z:� 128,0,1 h:$� 128,0,1 v:.� 128,0,1 �:8� 128,0,1 �:B� 255,255,255   