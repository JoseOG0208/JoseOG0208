LOOP_START	;SE CREA UN FOR CON EL TAMAÑO DE LOS MULTIPLICANDOS
	  	;SE CARGA EÑ SIZE Y SE COMPARA CON EL ITERADOR
LOAD_SIZE 	
		MOV ACC, CTE ;SE CARGA EN ACC LA DIRECCION CTE DE SIZE
		SIZE
		MOV DPTR, ACC ;MUEVE LA DIRECCION DE ACC(PREVIAMENTE SIZE) A DPTR
		MOV ACC, [DPTR] ;MUEVE CONTENIDO DPTR (DIRECCION DE SIZE)
NEGATIVE_SIZE
		INV ACC ;INVIERTE BITS DE ACC (PREVIAMENTE SIZE)
		MOV A, ACC ;CARGA RESULTADO EN A
		MOV ACC, CTE ;CARGA ITERADOR EN ACC
		0X01 ;EL VALOR DE LA CONSTANTE SE LE SUMA 1
		ADD ACC,A ;SUMA ACC (+1) CON A (BITS PREVIEMANTE INVERTIDOS)
		MOV A, ACC ;CARGA EL RESULTADO DE LA SUMA
LOAD_ITERATOR
		MOV ACC,CTE ;CARGA EN ACC LA DIRECCION DE LA CONSTANTE DEL ITERADOR
		ITERADOR
		MOV DPTR,ACC ;MUEVE LA DIRECCION DEL ACC (PREVIAMENTE ITERADOR) A DPTR
		MOV ACC, [DPTR] ;MUEVE CONTENIDO DE DPTR A ACC
		ADD ACC,A ;SUMA -SIZE+ITERADOR Y LO GUARDA EN ACC
LOOP_TEST
		JN ;SI ITERADOR-SIZE<0, ENTONCES ITERADOR ES MENOR QUE SIZE
		ALGORITMO_BOOTH ;SI ENTRA A ESA CONDICION, HACE ALGORITMO BOOTH
		JMP CTE ;SI ITERADOR-SIZE>0, ENTONCES ITERADOR ES MAYOR QUE SIZE Y SALE DE FOR
		CICLO
		END_LOOP ;SI ENTRA, EL CICLO TERMINA
BOOTH_ALGOR
		MOV ACC, CTE ; Carga en ACC la dirección de bit menos significativo
		QLSB(Q) 
		MOV DPTR, ACC
		MOV ACC, [DPTR] ; Mueve el bit menos significativo de Q a ACC
		MOV A, ACC ; Guarda el valor en el registro A

		MOV ACC, CTE ; Carga en ACC la dirección de Q1
		Q1
		MOV DPTR, ACC
		MOV ACC, [DPTR] ; Mueve el bit menos significativo de Q1 a ACC

		AND ACC, A ; Realiza una operación AND entre ACC y A
		JZ CTE ; Si el resultado es cero, ambos bits son iguales
		; Si el resultado no es cero, entonces son diferentes
		JMP CTE ; Salta a la etiqueta correspondiente
DISTINTOS
		MOV ACC, CTE ;CARGAMOS EN EL ACC LA DIRECCION DEL BIT MENOS SIGNIFICATIVO DE Q
		QLSB(Q)
		MOV DPTR ACC ;MUEVE LA DIRECCION DEL ACC (O SEA QLSB Q) AL DPTR
		MOV ACC, [DPTR] ;TRANSLADA EL CONTENIDO EN LA DIRECCIÓN APUNTADA POR DPTR HACIA ACC
		JZ ;SI EL ACC ES 0, SIGNIFICA QUE Q - 0, Y Q1 - 1
		DISTINTOS01 ;SE PASA A HACER EL RESPECTIVO PROCEDIMIENTO
		JMP CTE ;SI EL ACC NO ES 0, SIGNIFICA QUE Q - 1, Y Q1 - 0
		DISTINTOS10 ;SE PASA A HACER EL RESPECTIVO PROCEDIMIENTO
DISPLACEMENT
		MOV ACC, CTE ;CARGAMOS EN EL ACC LA DIRECCION DEL BIT MENOS SIGNIFICATIVO DE Q
		QLSB(Q)
		MOV DPTR,ACC ;MUEVE LA DIRECCION DEL ACC (O SEA EL QLSB Q) AL DPTR
		MOV ACC, [DPTR] ;MUEVE LO QUE HAY EN EL DPTR AL ACC
		MOV A, ACC ;LO CARGA EN A
		#DESPLAZAMIENTO DE Q1:
		MOV ACC,CTE ;SE CARGA EN EL ACC LA DIRECCION DE Q1
		Q1
		MOV DPTR,ACC ;MUEVE LA DIRECCION DEL ACC (O SEA DE Q1) AL DPTR
		MOV [DPTR], A ;SE CARGA A LA DIRECCION DEL DPTR (O SEA Q1) A A (AL QLSB DE Q)
			      ;DESPLAZAMIENTO DE Q
		MOV ACC, CTE ;CARGAMOS EN EL ACC LA DIRECCION DEL BIT MAS SIGNIFICATIVO
		QMSB(Q)
		MOV DPTR, ACC ;MUEVE LA DIRECCION DEL ACC (O SEA DEL LSB) AL DPTR
		MOV ACC, [DPTR] ;MUEVE LA DIRECCION DEL ACC AL DPTR
		MOV A, ACC ;LO CARGA EN A
		MOV ACC, CTE ;CARGAMOS EN EL ACC LA DIRECCION DE Q
		Q
		MOV DPTR, ACC ;MUEVE LA DIRECCION DEL ACC (O SEA DE Q) AL DPTR
		MOV ACC, [DPTR] ;MUEVE LO QUE HAY EN EL DPTR (DIRECCION DE Q) AL ACC
		SHIFTLR ACC ;SHIFT LOGICAL A LA DERECHA
		MOV [DPTR], ACC ;SE ALMACENA EL Q CON EL SHIFT EN LA DIRECCION DE Q
		MOV ACC, CTE ;SE CARGA EN EL ACC LA DIRECCION DEL BIT MAS SIGNIFICATIVO
		QMSB(Q)
		MOV DPTR, ACC ;SE MUEVE LA DIRECCION DEL ACC (O SEA DEL MSB) AL DPTR
		MOV [DPTR], A ;SE ALMACENA EL QUE ERA EL BIT MAS SIGNIFICATIVO DE Q, EN EL
			      ;Q QUE YA SE ENCUENTRA DESPLAZADO
			      ;DESPLAZAMIENTO DE AUX
		MOV ACC,CTE ;SE CARGA EN EL ACC LA DIRECCION DEL BIT MAS SIGNIFICATIVO
		QMSB(AUX)
		MOV DPTR, ACC ;SE MUEVE LA DIRECCION DEL ACC (O SEA DEL MSB) AL DPTR
		MOV ACC,[DPTR] ;SE MUEVE LO QUE HAY EN LA DIRECCION DEL DPTR AL ACC
		MOV A, ACC ;LO CARGA EN A
		MOV ACC, CTE ;SE CARGA EN EL ACC LA DIRECCION DE AUX
		AUX
		MOV DPTR, ACC ;SE MUEVE LA DIRECCION DEL ACC (O SEA DE AUX) AL DPTR
		MOV ACC, [DPTR] ;SE MUEVE LO QUE HAY EN LA DIRECCION DEL DPTR (DIRECCION AUX) AL ACC
		SHIFTLR ACC ;SHIFT LOGICAL A LA DERECHA
		MOV [DPTR], ACC ;ALMACENAMOS EL AUX CON EL SHIFT EN LA DIRECCION DE AUX
		MOV DPTR, ACC ;MUEVE LA DIRECCION DEL ACC (O SEA DEL MSB) AL DPTR
		MOV[DPTR], A ;SE ALMACENA EL QUE ERA EL MBS DE AUX, EN EL AUX YA DESPLAZADO
		INIT_LOOP
DISTINTOS01
		MOV ACC, CTE ;CARGAMOS EN EL ACC LA DIRECCION DE LA CONSTANTE DEL
		M MULTIPLICANDO (M)
		MOV DPTR, ACC ;MUEVE LA DIRECCION DEL ACC (O SEA DE M) AL DPTR
		MOV ACC, [DPTR] ;MUEVE LO QUE HAY EN LA DIRECCION DEL DPTR (DIRECCION DE M) AL ACC
		MOV A,ACC ;LO CARGA EN A
		MOV ACC, CTE ;SE CARGA EN EL ACC LA DIRECCION DE LA CONSTANTE (AUX)
		MOV DPTR, ACC ;MUEVE LA DIRECCION DEL ACC (O SEA DE AUX) AL DPTR
		MOV ACC,[DPTR] ;MUEVE LO QUE HAY EN LA DIRECCION DEL DPTR (AUX) AL ACC
		ADD ACC, A ;HACE LA SUMA DE AUX CON A (M)
		MOV AUX, ACC ;CARGA LA SUMA A AUX
		JMP CTE ;DESPUES DE TERMINAR, SE DEBE HACER EL DESPLAZAMIENTO
		DESPLAZAMIENTO
DISTINTOS10
		MOV ACC, CTE ;CARGA EN ACC LA DIRECCION DE LA CTE M
		M
		MOV DPTR, ACC ;MUEVE LA DIRECCION DE ACC A DPTR (PREVIEMANETE M)
		MOV ACC, [DPTR] ;MUEVE CONTENIDO DE DPTR A ACC (PREVIEMANTE M)
		INV ACC ;INVIERTE LOS BITS PARA HACER COMPLEMENTO A2
		MOV A, ACC ;CARGA EL RESULTADO EN A
		MOV ACC, CTE ;CARGA EL ITERADOR EN ACC CTE +1
		0X01
		ADD ACC, A ;SUMA EL ACC (CONSTANTE 1) CON A (LOS BITS ESTAN INVERTIDOS)
		MOV A, ACC ;SE CARGA EL RESULTADO EN A
		MOV ACC, CTE ;CARGA EN ACC EL VALOR DE ACC (PREVIAMENTE AUX)
		AUX
		MOV DPTR, ACC
		MOV DPTR, ACC ;MUEVE LA DIRECCION DEL ACC A DPTR (PREVIEMANETE AUX)
		MOV ACC, [DPTR] ;MUEVE CONTENIDO DE [DPTR] A ACC (PREVIAMENTE ACC)
		ADD ACC, A ;HACE LA SUMADE AUX CON A (-M)
		MOV AUX, ACC ;CARGA LA SUMA A AUX
		JMP CTE ;HACER DESPLAZAMIENTO DESPUES DE TERMINAR
		DESPLAZAMINETO
END_LOOP

SIZE 		0x08
Q: 		0xFF
Q1: 		0x00
ITERADOR 	0x00
M: 		0xA0
AUX
				
