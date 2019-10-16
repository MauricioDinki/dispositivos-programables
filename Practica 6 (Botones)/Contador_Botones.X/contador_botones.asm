; Un contador aumenta o disminuye presionando sus respectivos botones en 
; RB0 (Aumenta) y RB1 (Disminuye)
    LIST P=18F4550

    #INCLUDE <P18F4550.INC>
    
    ;CONFIG1L dir 300000h 	20
    ;CONFIG	PLLDIV=1	 ; 
    ;CONFIG	CPUDIV=OSC1_PLL2 ;CUANDO SE USA XTAL	
    ;CONFIG	USBDIV=2

    ;CONFIG1H dir 300001h	08
    CONFIG	FOSC=INTOSCIO_EC ;OSCILADOR INTERNO, RA6 COMO PIN, USB USA OSC EC
    CONFIG	FCMEN=OFF        ;DESHABILITDO EL MONITOREO DEL RELOJ
    CONFIG	IESO=OFF

    ;CONFIG2L DIR 300002H	38
    CONFIG	PWRT=ON          ;PWRT HABILITADO
    CONFIG  BOR=OFF		 ;BROWN OUT RESET DESHABILITADO
    CONFIG BORV=3		 ;RESET AL MINIMO VOLTAJE NO UTILZADO EN ESTE CASO
    CONFIG	VREGEN=ON	 ;REULADOR DE USB ENCENDIDO

    ;CONFIG2H DIR 300003H	1E
    CONFIG	WDT=OFF          ;WACH DOG DESHABILITADO
    CONFIG WDTPS=32768      ;TIMER DEL WATCHDOG 

    ;CONFIG3H DIR 300005H	81
    CONFIG	CCP2MX=ON	 ;CCP2 MULTIPLEXADAS CON RC1	
    CONFIG	PBADEN=OFF       ;PUERTO B PINES DEL 0 AL 4 ENTRADAS DIGITALES
    CONFIG  LPT1OSC=OFF	 ;TIMER1 CONFIURADO PARA OPERAR EN BAJA POTENCIA
    CONFIG	MCLRE=ON         ;MASTER CLEAR HABILITADO

    ;CONFIG4L DIR 300006H	81
    CONFIG	STVREN=ON	 ;SI EL STACK SE LLENA CAUSE RESET		
    CONFIG	LVP=OFF		 ;PROGRAMACIÒN EN BAJO VOLTAJE APAGADO
    CONFIG	ICPRT=OFF	 ;REGISTRO ICPORT DESHABILITADO
    CONFIG	XINST=OFF	 ;SET DE EXTENCION DE INSTRUCCIONES Y DIRECCIONAMIENTO INDEXADO DESHABILITADO

    ;CONFIG5L DIR 300008H	0F
    CONFIG	CP0=OFF		 ;LOS BLOQUES DEL CÒDIGO DE PROGRAMA
    CONFIG	CP1=OFF          ;NO ESTAN PROTEGIDOS
    CONFIG	CP2=OFF		 
    CONFIG	CP3=OFF

    ;CONFIG5H DR 300009H	C0
    CONFIG	CPB=OFF		 ;SECTOR BOOT NO ESTA PROTEGIDO
    CONFIG	CPD=OFF		 ;EEPROM N PROTEGIDA

    ;CONFIG6L DIR 30000AH	0F
    CONFIG	 WRT0=OFF	 ;BLOQUES NO PROTEGIDOS CONTRA ESCRITURA
    CONFIG	 WRT1=OFF
    CONFIG	 WRT2=OFF
    CONFIG	 WRT3=OFF

    ;CONFIG6H DIR 30000BH	E0
    CONFIG	 WRTC=OFF	 ;CONFIGURACION DE REGISTROS NO PROTEGIDO
    CONFIG	 WRTB=OFF	 ;BLOQUE BOOTEBLE NO PROTEGIDO
    CONFIG	 WRTD=OFF	 ;EEPROMDE DATOS NO PROTGIDA

    ;CONFIG7L DIR 30000CH	0F
    CONFIG	 EBTR0=OFF	 ;TABLAS DE LETURA NO PROTEGIDAS
    CONFIG	 EBTR1=OFF
    CONFIG	 EBTR2=OFF
    CONFIG	 EBTR3=OFF

    ;CONFIG7H DIR 30000DH	40
    CONFIG	 EBTRB=OFF	 ;TABLAS NO PROTEGIDAS
    
    ORG		.0
    
COUNT	EQU  .80	;Asigna el valor 80 a DAA
    
    #DEFINE	BOTON0	PORTB, 0, 0 ; Pull UP
    #DEFINE	BOTON1	PORTB, 1, 0 ; Pull Down
    
    #DEFINE	CERO	B'00111111'
    #DEFINE	UNO	B'00000110' 
    #DEFINE	DOS	B'01011011'
    #DEFINE	TRES	B'01001111'
    #DEFINE	CUATRO	B'01100110'
    #DEFINE	CINCO	B'01101101'
    

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
    
    MOVLW   CERO
    MOVWF   PORTD, 0	; Se mueve el valor de W a PORTD
    MOVLW   .0		; Asigna 0 a W
    MOVWF   COUNT, 1	; Asigna el valor de W a COUNT

MAIN	
    BTFSC   BOTON0	; Consulta si el valor de BOTON0 es 0 (Boton Presionado)
    GOTO    BOTON_0_ON	; Si el valor es 1 (Consulta BOTON1)
    GOTO    BOTON_0_OFF	; Si el valor es 0 (Aumenta el Contador)

BOTON_0_OFF
    CALL    DELAY	; Llama al DELAY
    BTFSS   BOTON0	; Consulta si el valor de BOTON0 es 1
    GOTO    BOTON_0_OFF	; Si el valor es 0 (El boton sigue presionado)
    MOVLW   .5		; Asigna 5 a W
    CPFSEQ  COUNT, 1	; Compara el valor de COUNT y W
    BRA	    NO_MAX_LIMIT; COUNT != 5
    BRA	    MAIN	; COUNT == 5

BOTON_0_ON
    BTFSS   BOTON1	; Consulta si el valor de BOTON1 es 1 (Boton Presionado)
    GOTO    MAIN	; Si el valor es 0 (Regresa a MAIN)
    GOTO    BOTON_1_ON	; Si el valor es 1 (Resta al Contador)

BOTON_1_ON
    CALL    DELAY	; Llama al DELAY
    BTFSC   BOTON1	; Consulta si el valor de BOTON0 es 0
    GOTO    BOTON_1_ON	; Si el valor es 1 (El boton sigue presionado)
    MOVLW   .0		; Asigna 0 a W
    CPFSEQ  COUNT, 1	; Compara el valor de COUNT y W
    BRA	    NO_MIN_LIMIT; COUNT != 0
    BRA	    MAIN	; COUNT == 0
    
MAX_LIMIT
    MOVLW   .5		; Asigna 0 a W
    MOVWF   COUNT, 1	; Asigna el valor de W a COUNT
    CALL    TABLA	; Llamar a Tabla
    MOVWF   PORTD, 0	; Se mueve el valor de W a PORTD
    BRA	    MAIN	; Regresa MAIN
    
NO_MAX_LIMIT
    MOVF    COUNT, W, 1	; Mueve el valor de COUNT a W
    ADDLW   .1		; Suma 1 a W
    MOVWF   COUNT, 1	; Asigna el valor de W a COUNT
    MULLW   .2	;	;Se multiplica por 2 el valor de W
    MOVF    PRODL, W, 0	; Se mueve el valor de la multiplciacion de PRODL a W
    CALL    TABLA	; Llamar a Tabla
    MOVWF   PORTD, 0	; Se mueve el valor de W a PORTD
    BRA	    MAIN

MIN_LIMIT
    MOVLW   .0		; Asigna 0 a W
    MOVWF   COUNT, 1	; Asigna el valor de W a COUNT
    CALL    TABLA	; Llamar a Tabla
    MOVWF   PORTD, 0	; Se mueve el valor de W a PORTD
    BRA	    MAIN	; Regresa MAIN
    
NO_MIN_LIMIT
    MOVF    COUNT, W, 1	; Mueve el valor de COUNT a W
    SUBLW   .1		; Resta 1 a W
    NEGF    WREG, 0	; Se niega el valor de W para obtener el posisitivo
    MOVWF   COUNT, 1	; Asigna el valor de W a COUNT
    MULLW   .2		; Se multiplica por 2 el valor de W
    MOVF    PRODL, W, 0	; Se mueve el valor de la multiplciacion de PRODL a W
    CALL    TABLA	; Llamar a Tabla
    MOVWF   PORTD, 0	; Se mueve el valor de W a PORTD
    BRA	    MAIN
    
DELAY
    CLRF    TMR0L, 0
    MOVLW   .10	
    BRA	    ASK		
ASK 
    CPFSEQ  TMR0L, 0
    BRA	    ASK	
    RETURN	

TABLA
    ADDWF   PCL, F, 0
    RETLW   CERO
    RETLW   UNO
    RETLW   DOS
    RETLW   TRES
    RETLW   CUATRO
    RETLW   CINCO
    END