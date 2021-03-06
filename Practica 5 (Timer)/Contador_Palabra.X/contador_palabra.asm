; Muestra una palabra de 11 letras la salida esta en PORTD
    
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
    CONFIG	LVP=OFF		 ;PROGRAMACI�N EN BAJO VOLTAJE APAGADO
    CONFIG	ICPRT=OFF	 ;REGISTRO ICPORT DESHABILITADO
    CONFIG	XINST=OFF	 ;SET DE EXTENCION DE INSTRUCCIONES Y DIRECCIONAMIENTO INDEXADO DESHABILITADO

    ;CONFIG5L DIR 300008H	0F
    CONFIG	CP0=OFF		 ;LOS BLOQUES DEL C�DIGO DE PROGRAMA
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
    
    ORG	.0
    
COUNT	EQU  .80	;Asigna el valor 80 a DAA
	
    #DEFINE	CERO	B'01110111' ;A
    #DEFINE	UNO	B'01110011' ;P
    #DEFINE	DOS	B'00111000' ;L
    #DEFINE	TRES	B'00000110' ;I
    #DEFINE	CUATRO	B'00111001' ;C
    #DEFINE	CINCO	B'01110111' ;A
    #DEFINE	SEIS	B'00111001' ;C
    #DEFINE	SIETE	B'00000110' ;I
    #DEFINE	OCHO	B'00111111' ;O
    #DEFINE	NUEVE	B'01010100' ;n
    #DEFINE	DIEZ	B'01111001' ;E
    #DEFINE	ONCE	B'01101101' ;S
    
INICIO
    CLRF    PORTD, 0	; Limpiar PORTD  
    CLRF    TRISD	; Configura TRISD 0000 0000 (8 Salidas)
    
    MOVLW   .7		; Asigna 7 Decimal a W
    MOVWF   CMCON, 0	; Asigna 111 (7 Binario) a CMCON para indicar que
			; Esta apagado el comparador de voltaje
    
    MOVLW   B'11000111'	; Configuracion T0CON
    MOVWF   T0CON
    
    MOVLW   .0		; Asigna 0 a W
    MOVWF   COUNT, 1	; Asigna el valor de W a COUNT
    
MAIN
    CALL    TABLA	; Se llama a la seccion TABLA
    MOVWF   PORTD, 0	; Se mueve el valor de W a PORTD
    CALL    DELAY	; Llama a Delay
    MOVLW   .22		; Asigna 22 a W
    CPFSEQ  COUNT, 1	; Compara el valor de COUNT y W
    BRA	    NOLIMIT	; COUNT != W
    BRA	    LIMIT	; COUNT = W
    BRA	    MAIN	; Regresa a Main

LIMIT
    MOVLW   .0		; Asigna 0 a W
    MOVWF   COUNT, 1	; Asigna el valor de W a COUNT
    BRA	    MAIN	; Regresa MAIN
    
NOLIMIT
    MOVF    COUNT, W, 1	; Mueve el valor de COUNT a W
    ADDLW   .1		; Suma 1 a W
    MOVWF   COUNT, 1	; Mueve el valor de W a COUNT
    BRA	    MAIN
    
DELAY
    CLRF    TMR0L, 0	; Limipia el Timer
    MOVLW   .98		; Asigna 98 a W
    
ASK 
    CPFSEQ  TMR0L, 0	; Compara el valor de TMR0L y W (98)
    BRA	    ASK		; Llama a ASK si el valor no es 98
    RETURN		; Cuando TMR0L sea 98, sale del ciclo
    
TABLA
    ADDWF   PCL, F, 0
    RETLW   CERO
    RETLW   UNO
    RETLW   DOS
    RETLW   TRES
    RETLW   CUATRO
    RETLW   CINCO
    RETLW   SEIS
    RETLW   SIETE
    RETLW   OCHO
    RETLW   NUEVE
    RETLW   DIEZ
    RETLW   ONCE
    END
    
    
	


