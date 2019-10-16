; Este programa es una calculadora (Suma, Resta y Multiplicacion) de cantidades
; de 3 bits, la cantidad 1 esta en RB2 RB1 RB0 y la cantidad 2 esta en
; RB5 RB4 RB3, la operacion esta delimitada por ls bits RB7 y RB6 segun las
; siguientes combinaciones:
; 00 - Suma
; 01 - Resta
; 10 - Multiplicacion
; Los leds de salida estan en PORTA
    
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
    
NUM1	EQU	.80	;Asigna el valor 80 a NUM1
NUM2    EQU	.81	;Asigna el valor 81 a NUM2
    	
   
	ORG	.0
    
INICIO
    CLRF    PORTA, 0	; Limpiar PORTA
    CLRF    PORTB, 0	; Limpiar PORTB
    
    SETF    TRISB	; Configura TRISB 1111 1111 (8 Entradas)
    CLRF    TRISA	; Configura TRISA 0000 0000 (7 Salidas)
    
    MOVLW   .15		; Asigna 15 W
    MOVWF   ADCON1, 0	; Asigna 1111 (15 Binario) a ADCON1 para indicar que
			; Todas las entradas son digitales
    
    MOVLW   .7		; Asigna 7 W
    MOVWF   CMCON	; Asigna 111 (7 Binario) a CMCON para indicar que
			; Esta apagado el comparador de voltaje

MAIN
    MOVF    PORTB, W, 0 ; Asigna el valor de PORTB a W
			; W = 00111111

    ANDLW   B'00000111' ; Aplicar una mascara para obtener el valor de
			; RB2 RB1 RB0

    MOVWF   NUM1, 1     ; Se mueve el valor de W A NUM1


    MOVF    PORTB, W, 0 ; Asigna el valor de PORTB a W
			; W = 00111111

    RRNCF   WREG, F, 0	; W = 10011111
    RRNCF   WREG, F, 0	; W = 11001111
    RRNCF   WREG, F, 0	; W = 11100111

    ANDLW   B'00000111' ; Aplicar una mascara para obtener el valor de
			; RB5 RB4 RB3
    
    MOVWF   NUM2, 1     ; Se mueve el valor de W A NUM2
    BTFSS   PORTB, 7, 0
    GOTO    OFF1	; Se ejecuta si esta apagado (0)
    GOTO    ON1		; Se ejecuta si esta encendido (1)

OFF1
    BTFSS   PORTB, 6, 0
    GOTO    SUMA	; Se ejecuta si esta apagado (0) (00)
    GOTO    RESTA	; Se ejecuta si esta apagado (1) (01)

ON1
    BTFSS   PORTB, 6, 0
    GOTO    MULT	; Se ejecuta si esta apagado (0) (10)
    GOTO    NADA	; Se ejecuta si esta apagado (1) (11)

SUMA
    ADDWF   NUM1, W, 1  ; Se suma el valor de W y NUM1 y se almacena en W
    MOVWF   PORTA, 0    ; Mueve el valor de W a PORTA
    GOTO    MAIN	; Regresa al inicio del programa

RESTA
    SUBWF   NUM1, W, 1  ; Se resta el valor de NUM1 y W y se almacena en W
    MOVWF   PORTA, 0    ; Mueve el valor de W a PORTA
    GOTO    MAIN	; Regresa al inicio del programa

MULT
    MULWF   NUM1, 1     ; Multiplica el valor de NUM1 y W
    MOVF    PRODL, W, 0 ; Mueve el valor almacenado en PRODL a W
    MOVWF   PORTA, 0    ; Mueve el valor de W a PORTA
    GOTO    MAIN	; Regresa al inicio del programa

NADA
    CLRF    PORTA, 0	; Limpia PORTA
    GOTO    MAIN
    END