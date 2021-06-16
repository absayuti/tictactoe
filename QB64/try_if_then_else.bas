INPUT "Enter X=", x

IF x < 10 THEN
    FOR i = 1 TO x
        PRINT i;
    NEXT
    PRINT
ELSE
    PRINT "X is too large!"
    PRINT "X="; x
END IF

