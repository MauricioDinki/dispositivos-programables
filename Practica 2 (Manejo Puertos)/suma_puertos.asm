; PB = PA + 5
; PA tiene 2 swiches RA4 y RA3
    LIST P=18F4550
    #INCLUDE <P18F4550.INC>

    #DEFINE  CTE  .5

    ORG  .0


INICIO
    CLRF     PORTA
    CLRF     PORTB
    CLRF     TRISB   ; TB = 0000 0000 (8 Salidas)
    SETF     TRISA   ; TA = 0111 1111 (7 Entradas)
    MOVLW    .15     ; Asigna 15 a W
    MOVWF    ADCON1  ; Asigna 1111 (15 Binario) a ADCON1 para indicar que
		     ; Todas las entradas son digitales

    MOVLW    .7      ; Asigna 7 a W
    MOVWF    CMCON   ; Asigna 111 (7 Binario) a ADCON1 para indicar que
		     ; Esta apagado el comparador de voltaje

SUMA
    MOVF    PORTA, W, 0 ; PA = 17 W = 00010001
    RRNCF   WREG, F, 0  ; PA = 17 W = 10001000
    RRNCF   WREG, F, 0  ; PA = 17 W = 01000100
    RRNCF   WREG, F, 0  ; PA = 17 W = 00100010
    ANDLW   B'00000011' ; PA = 17 W = 2
    ADDLW   CTE         ; PA = 17 W = 7
    MOVWF   PORTB, 0    ; Mueve el valor de W a PORTB
    GOTO    SUMA

    END
