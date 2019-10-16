; Un LED en RD0 se enciende y apaga presionando sus respectivos botones en 
; RB0 (Apagado) y RB1 (Encendido)
    LIST P=18F4550

    #INCLUDE <P18F4550.INC>
    
    #DEFINE	LED	PORTD, 0, 0
    #DEFINE	BOTON0	PORTB, 0, 0 ; Pull UP
    #DEFINE	BOTON1	PORTB, 1, 0 ; Pull Down
    
    ORG		.0
    
INICIO
    CLRF    PORTB, 0	; Limpiar PORTB
    CLRF    PORTD, 0	; Limpiar PORTD
    
    SETF    TRISB	; Configura TRISB 1111 1111 (8 Entradas)
    CLRF    TRISD	; Configura TRISD 0000 0000 (8 Salidas)
    
    MOVLW   .15		; Asigna 15 W
    MOVWF   ADCON1, 0	; Asigna 1111 (15 Binario) a ADCON1 para indicar que
			; Todas las entradas son digitales
    
    MOVLW   .7		; Asigna 7 W
    MOVWF   CMCON	; Asigna 111 (7 Binario) a CMCON (Apagado)
    
    MOVLW   B'11010111'	; Valores de configuracion del T0CON
    MOVWF   T0CON	; Asigna la configracion al T0CON

MAIN	
    BTFSC   BOTON0	; Consulta si el valor de BOTON0 es 0 (Boton Presionado)
    GOTO    BOTON_0_ON	; Si el valor es 1 (Consulta BOTON1)
    GOTO    BOTON_0_OFF	; Si el valor es 0 (Apaga el LED)

BOTON_0_OFF
    CALL    DELAY	; Llama al DELAY
    BTFSS   BOTON0	; Consulta si el valor de BOTON0 es 1
    GOTO    BOTON_0_OFF	; Si el valor es 0 (El boton sigue presionado)
    BCF	    LED		; Si el valor es 1 (Apaga el LED)
    GOTO    MAIN	; Regresa a MAIN

BOTON_0_ON
    BTFSS   BOTON1	; Consulta si el valor de BOTON1 es 1 (Boton Presionado)
    GOTO    MAIN	; Si el valor es 0 (Regresa a MAIN)
    GOTO    BOTON_1_ON	; Si el valor es 1 (Enciende el LED)

BOTON_1_ON
    CALL    DELAY	; Llama al DELAY
    BTFSC   BOTON1	; Consulta si el valor de BOTON0 es 0
    GOTO    BOTON_1_ON	; Si el valor es 1 (El boton sigue presionado)
    BSF	    LED		; Si el valor es 0 (Enciende el LED)
    GOTO    MAIN	; Regresa a MAIN
    
DELAY
    CLRF    TMR0L, 0
    MOVLW   .10	
    BRA	    ASK		
ASK 
    CPFSEQ  TMR0L, 0
    BRA	    ASK	
    RETURN	
    END
    
			
    