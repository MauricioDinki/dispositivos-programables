; Giro de Motor a Pasos
    LIST P=18F4550

    #INCLUDE <P18F4550.INC>
    
    GIRA    EQU	.0
    
    ORG		.0
    
INICIO
    CLRF    PORTD, 0
    CLRF    PORTA, 0
    
    CLRF    TRISD, 0
    SETF    TRISA, 0
    
    MOVLW    .15     ; Asigna 15 a W
    MOVWF    ADCON1  ; Asigna 1111 (15 Binario) a ADCON1 para indicar que
		     ; Todas las entradas son digitales

    MOVLW    .7      ; Asigna 7 a W
    MOVWF    CMCON   ; Asigna 111 (7 Binario) a ADCON1 para indicar que
		     ; Esta apagado el comparador de voltaje
    
    MOVLW   B'11010111'
    MOVWF   T0CON
    
    MOVLW   B'11001100'
    MOVWF   GIRA
    
MAIN
    BTFSS   PORTA, 0, 0 ; Aanaliza el valor del bit 0 de PORTA
    GOTO    OFF	; Se ejecuta si esta apagado (0)
    GOTO    ON	; Se ejecuta si esta encendido (1)

ON
    MOVFF   GIRA, PORTD
    CALL    DELAY
    RRNCF   GIRA, 1, 1
    GOTO    MAIN

OFF
    MOVFF   GIRA, PORTD
    CALL    DELAY
    RLNCF   GIRA, 1, 1
    GOTO    MAIN

DELAY
    CLRF    TMR0L, 0
    MOVLW   .200
 
ASK 
    CPFSEQ  TMR0L, 0
    GOTO    ASK
    RETURN
    END