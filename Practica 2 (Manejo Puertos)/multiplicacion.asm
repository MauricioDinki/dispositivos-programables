;Este programa multiplica F(80) * F(81) = F(82)
;BNK = 5 F(80) = 15, F(81) = 6
    LIST P=18F4550
    #INCLUDE<P18F4550.INC>

DAA    EQU  B'01010000' ;Asigna el valor 80 a DAA
DBB    EQU  B'01010001' ;Asigna el valor 81 a DAA
RESULT EQU  B'01010010' ;Asigna el valor 82 a DAA

    ORG    .0

MULT
    MOVLB   .5            ;Selecciona el banco 5
    MOVLW   .15           ;Asigna 15 a W
    MOVWF   DAA, 1        ;Asigna el valor de W en F(80)
    MOVLW   .6            ;Asigna 6 a W
    MOVWF   DBB, 1        ;Asigna el valor de  W en F(81)
    MULWF   DAA, 1        ;Multiplica el valor de F(80) y W
    MOVFF   PRODL, RESULT ;Mueve el restultado almacenado en PRODL a RESULT
    GOTO    MULT
    END
