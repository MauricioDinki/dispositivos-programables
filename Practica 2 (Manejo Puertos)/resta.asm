;Este programa resta el valor de W a F(80)
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
    MOVLW   .30           ;Asigna 30 a W
    MOVWF   DBB, 1        ;Asigna el valor de  W en F(81)
    SUBWF   DAA, 1        ;Resta a F(80) el valor de W
    GOTO    MULT
    END
