
include "emu8086.inc" ;para imprimir dos numeros
  
  
.stack 100h
;---------------------------------
datasg segment 'data' 
    max db 20    
        
    long db ? 
    
    cadena db 10 dup ('') ,'$'    
    
    message db "Nombre o apodo: ",'$' 
       
    vidasMessage db "Vidas: ",'$' 
    
    ended db " ESTE ES EL FIN DEL JUEGO ",'$'
    
    line db 10,13,'$' 
    
    mess db "Con que nivel de dificultad va a jugar?",'$'
    
    mVidas db "Cuantas vidas tendra? ",'$'                    
    
    
    presione db "Presione el boton clearScreen de la esquina Inferior Izquierda",,'$' 
    pres db "Luego presione la tecla enter",'$'
    
    niveles db "1:Facil, 2:Medio, 3:Dificil ",'$'
         
    cara db "1-Carita feliz",'$';    
     
    corazon db "2-Corazon",'$';
    
    puntos db " Puntaje: ",'$' 
    

    platform db 10 dup(?), '$' 

    diamante db "3-Diamante",'$';

    
    barra db "°°°",'$' 
    

    c1 db 0  
    
    menu db "Elija la figura a utilizar:", '$'; 

    dificultad db ?  

    
    casoEspecial db ?  
    
    vidas db ? ;conocer la cantidad de vidas
    
    prueba db " Prueba " ,'$'   
    
      
            
    finalMessage db "Tu puntuacion fue ",'$'
    
    tecla db ? ;guardar tecla ingresada por el usuario 
     
    otra db "4-Ingresar la figura",'$'; 
    
    mes2 db "Ingrese la figura",'$';
    
    errorMsg db "Error con la lectura del archivo",'$'
    
    guardadoMsg db "Puntuacion guardada con exito", '$'
    
    buffer db ? ,'$' ;buffer de lectura del archivo
    
    puntuaciones db 'puntuaciones.txt',0
    
    auxiliar dw ? ; auxiliar para lectura de archivo
    
    auxiliar2 dw ? ;para guardar la direccion en memoria del archivo
    
    character db ? ;para imprimir caracter por caracter del buffer
                                                      
    char db ?;  
    
    time2 dw ?;prueba de tiempo   
    
    temp dw ? ;util para calcular puntuacion final
    
    time db ? ;para guardar el tiempo
  
    figura db ? 
    
    cantidadBarras db ?  
    
    constant db 100  ;para el calculo de la puntuacion
    
    x db ?
    
    y db ? 
    
    total db ?          
    
    puntaje db 0,'$' ; el puntaje de la persona 
    
    ;text_size = $ - offset puntaje ,'$'
    
    respXI db ? ;utiles para el procedimiento de
                ;borrar barras
    respYI db ?
    
    respXD db ?
    
    respYD db ? 
                    
    barraJugador db  "{{****}}",'$' 
    
    borrar db "        ",'$'
    
    posBarraX db ?  ;manejar posicion de la barra del jugador
    
    posBarray db ?  ;manejar posicion de la barra del jugador
    
    limSup db 1
                   ;limites de la ventana
    limInf db 23
    
    limIzq db 0 
    
    limArriba db 1
    
    limAbajo db 23
    
    limDer db 79   
     
    finalizo db 1 ;saber si la barra se ha borrado  
    
    opcion db ?   
    
    viene db ? ;1=dai,2=dad,3=dabi,4=dabd 
    
    arrayPrueba db 11
       
    text_size = $ - offset puntaje
    
    
    
;    
datasg ends
;;---------------------------------
codesg segment 'code'  
    assume ds:datasg, cs:codesg, ss:stacksg,  


      
GOTO  MACRO hor,ver  ;macro posiciona cursor
         xor bh,bh
         mov dl,hor
         mov dh,ver   
         mov ah,02h
         int 10h
         
 ENDM
   
   
leerArchivo proc  
    mov al,0
    mov ah,3dh  ;se abre abre archivo  
    lea dx,puntuaciones 
    int 21h
    
    mov auxiliar,ax        
    jc error  ;si no se puede abrir salta a 'error' 
    mov bx,ax   
    
    mov cx,1 ; read one character at a time 
print: 
lea dx, buffer 
mov ah,3fh ; read from the opened file (its handler in bx) 
int 21h 
cmp ax, 0 ; how many bytes transfered? 
jz terminar ; end program if end of file is reached (no bytes left).   
mov al, buffer ; char is in BUF, send to ax for printing (char is in al) 
mov ah,0eh ; print character (teletype). 
int 10h 
jmp print ; repeat if not end of file.  
      
    mov ah,3eh ;instruccion para cerrar el archivo
    int 21h
    
    xor dx,dx
    mov ah,09h
    lea dx,buffer
    int 21h  
ret
endp               
               

imprimirBuffer proc
    xor bx,bx        ;apuntando al buffer
    mov cx,20        ;caracteres a imprimir
    xor si,si 
    
    loopImprimir:
        mov al,buffer[bx] ;lee el caracter del buffer en la posicion indicada
        lea dl,al    
        mov ah,09h
        int 21h
     
        inc si ;se incrementa el indice
        loop loopImprimir   ;el ciclo se repite hasta que cx = 0
        
    
    
ret
endp 


llenarPlataforma proc
    mov cx,10
    llenando:
         mov platform[si],223 
         inc si
         loop llenando
     
    xor bh,bh
    mov dl,10
    mov dh,10     
    mov ah,02h  
    int 10h  
         
    mov ah,09h
    lea dx,platform
    int 21h     
    
ret
endp

crearArchivo proc
    
                                      
ret 
endp    

     
     
imprimePuntaje proc 
    
       
goto 20,0
   
mov ah,09h
lea dx,puntos
int 21h

xor ax,ax

mov al,puntaje  

CALL PRINT_NUM ;se imprime  

ret
endp

   
escribirEnArchivo proc  
    
    lea dx, puntuaciones
    mov ah,3dh ;abrir archivo 
    mov al,01h ;lectura/escritura
    int 21h
    
    mov auxiliar2,ax
    jc error 
    
    xor cx,cx 
    xor dx,dx
    xor si,si
    ;mov ah,42h
;    mov bx,auxiliar2
;    mov al,2
;    int 21h 
    ;escribiendo en archivo 
    ;mov auxiliar2,ax       
    mov bx,auxiliar2 ;se obtiene el nombre del archivo
    mov ah,40h ;instruccion para escribir en el archivo 
    mov cx,1
    ;add arrayPrueba,30h      
    lea dx,arrayPrueba ;lo que se desea escribir en el archivo (puede ser un arreglo, buffer o variable)
    int 21h 
    
    ;;add puntaje,30h
;    mov dx,64 ;lo que se desea escribir en el archivo (puede ser un arreglo, buffer o variable)
;    ;mov cx,text_size
;    int 21h
     
    
    ;jc error
    ;cerrando archivo
    mov ah,3eh
    int 21h
    jc error
    
    lea dx,guardadoMsg    ;
    mov ah,9
    int 21h
    
      
    ;sub puntaje,30h
    
ret 
endp 
    

;funcion que posiciona el cursor
posicionarCursor proc 

xor bh,bh
mov dl,x
mov dh,y     
mov ah,02h  
int 10h    
                          
ret
endp

imprimirFigura proc

 mov dl,figura
 mov ah,02h         ;imprimir el caracter del nombre en esa posicion
 int 21h 
 
 ret
endp  


solicitarVidas proc

 lea dx, mVidas      ;imprimiendo espacio
 mov ah,09h
 int 21h     
    
 mov ah,1     ;espera dato
 int 21h
 
 mov bh,al
 
 sub bh,30h ;conversion numerica 
  
 mov vidas, bh ;asignacion de vidas
 
    
ret
endp

asignarFigura proc   

cmp opcion,1
je  asignarCara

cmp opcion,2
je asignarCorazon 
      
cmp opcion,3
je asignarDiamante   

ret
endp 

     
asignarDiamante:     
                
mov figura,04
jmp seguir

asignarCorazon:

mov figura,03
jmp seguir

asignarCara proc

mov figura,01
jmp seguir

                
; imprimir espacio
space proc    
    
 lea dx, line      ;imprimiendo espacio
 mov ah,09h
 int 21h
 
ret
endp         


solicitarNivel proc
    
call space

mov ah,09h 
lea dx,mess
int 21h

call space
                 ;desplegando mensajes
mov ah,09h
lea dx,niveles
int 21h

call space

mov ah,01h
int 21h

mov dificultad,al

sub dificultad,30h

ret
endp





ingresarNombre proc
    lea dx, message
    mov ah,09h
    int 21h    

    lea dx,max   ;recibir nombre  se guarda en la cadena
    mov ah,0ah
    int 21h
    call space
    call space 
 ret
 endp 
  
  
cls proc 
    
     xor cx,cx
     xor ax,ax
     xor bx,bx
     xor dx,dx
     mov ax,0600h   ;toda la pantalla
     mov bh,0fh    ;Fondo blanco, frente negro
     mov cx,0000h   ;desde fila 00, columna 
     mov dx,184fh   ;hasta fila 25(18h), columna 80(4Fh)
     int 10h

ret 
endp
            

capturaFigura proc

call space

call space
             
lea dx,mes2
mov ah,09h
int 21h

call space
call space

mov ah,1    ;espera el ingreso del dato
int 21h  
mov opcion,al
mov figura,al 

jmp seguir 
              
ret
endp

imprimirNombre proc
   
lea si, cadena ;lectura del nombre
    
continue:

    mov bh ,[si] ;se mueve la posicion de la cadena a un registro
         
    mov char,bh 
  
    cmp bh,0dh       ;si se llego al enter termina
    je finalize
         
    mov dl,char
    mov ah,02h  ;imprimir el caracter del nombre en esa posicion
    int 21h
     
    inc si  ;incrementar para acceder a otra
            ;posicion
    
    
    jmp continue 
    
finalize:
    
 ret
endp 

timer2  proc
    xor cx,cx
        ; esperar untiempo determinado interrupcion
        mov     dx, 4240h
        mov     ah, 86h
        int     15h      
        
        inc time2       
                
ret
endp    
   
imprimirVidas proc

xor bh,bh
mov dl,50
mov dh,0     ;posicionando cursor
mov ah,02h  
int 10h 
   
mov ah,09h
lea dx,vidasMessage
int 21h

mov bh,vidas
add bh,30h ;para vista en la ventana
mov dl,bh
mov ah,02h
int 21h

ret
endp
         
imprimirMenu proc
          
 call space
 
 lea dx,menu
 mov ah,09h
 int 21h

 call space  

 lea dx,Cara
 mov ah,09h
 int 21h

 call space  
 
 lea dx,Corazon
 mov ah,09h
 int 21h

 call space   
 
 lea dx,diamante
 mov ah,09h
 int 21h

 call space    
 
 lea dx,otra
 mov ah,09h
 int 21h
   
ret
endp   

dibujarBarra proc
  
 lea dx,barra ;imprimir barra   
 mov ah,09h
 int 21h
ret
endp     
  
dibujarBarraJugador proc
  
 lea dx,barraJugador ;imprimir barra   
 mov ah,09h
 int 21h
ret
endp 

proc dibujarDificil      ;ciclo para dibujar barras
    
    mov x,15
    xor cx,cx
    mov cx,10
    cic:
        
    add x,5
    call posicionarCursor
    call dibujarBarra  
  
    loop cic
    
    
    
ret
endp 

proc dibujarMedio      ;ciclo paa dibujar barras
    
    mov x,15
    xor cx,cx
    mov cx,7
    cicl:
        
    add x,7
    call posicionarCursor
    call dibujarBarra  
  
    loop cicl
    
    
    
ret
endp 

proc dibujarFacil      ;ciclo paa dibujar barras
    
    mov x,15
    xor cx,cx
    mov cx,5
    ci:
        
    add x,9
    call posicionarCursor
    call dibujarBarra  
  
    loop ci
    
ret
endp

facil proc
    
mov cantidadBarras,20 ;la cantidad de barras que tenga el nivel

 mov limInf,23
 mov limSup,4
 mov limIzq,18
 mov limDer,69
 
 mov y,4
 call dibujarfacil
 
 mov y,6
 call dibujarFacil   
 
 mov y,8
 call dibujarFacil
 
 mov y,10
 call dibujarFacil
 

jmp mover

ret
endp      

medio proc

mov cantidadBarras,28 ;la cantidad de barras que tenga el nivel

 mov limInf,23
 mov limSup,4
 mov limIzq,18
 mov limDer,69
 
 mov y,4
 call dibujarMedio
 
 mov y,6
 call dibujarMedio   
 
 mov y,8
 call dibujarMedio
 
 mov y,10
 call dibujarMedio
 


jmp mover  ;que vayan al juego 


ret
endp 

dificil proc


mov cantidadBarras,40 ;la cantidad de barras que tenga el nivel

 mov limInf,23
 mov limSup,4
 mov limIzq,18
 mov limDer,69
 
 mov y,4
 call dibujarDificil
 
 mov y,6
 call dibujarDificil   
 
 mov y,8
 call dibujarDificil
 
 mov y,10
 call dibujarDificil

jmp mover  ;que vayan al juego 
ret
endp      

devolver:  
  
 
 call imprimirFigura 
 
 cmp viene,1
 je  moverArribaI
 ;!!!!!!!!!!!!!!!!!
 cmp viene,2
 je  moverArribaD
 ;!!!!!!!!!!!!!!!!!
 cmp viene,3
 je  moverAbajoI 
 ;!!!!!!!!!!!!!!!!!
 cmp viene,4
 je  moverAbajoD 
 
 cmp viene,5
 je arriba
 
 cmp viene,6
 je abajo   
               
;calculo del puntaje del jugador
calcularTotal proc  
    
 xor cx,cx
 xor dx,dx
 xor ax,ax
 xor bx,bx
       
 mov bl,puntaje
 
 mov ax,time2
 
 div bx
 
 mov temp,ax
 
 xor ax,ax
 
 mov ax,temp
 
 mul constant
 
 mov temp,ax
 
 
 
    
ret
endp
       
      

borrarBarra proc  

cmp cantidadBarras,0
je finDelJuego

cmp al,32  ;si lo que hay es un espacio
je devolver    
            

mov dl,07h
mov ah,02h ;que suene 
int 21h

inc puntaje ; se suma cinco al puntaje de la persona 
inc puntaje


call imprimePuntaje

dec cantidadBarras ;se resta una barra


mov dl,32
mov ah,02h
int 21h

mov bl,x
mov bh,y

mov respXI,bl
mov respYI,bh     
mov respXD,bl      ;copia cordenadas
mov respYD,bh
 
eliI :

dec respXI ;se mueve una columna atras

goto respXI,respYI

ciclo:  

 mov ah,08h
 int 10h
 
 cmp al,0
 je eliD
 
 mov dl,32
 mov ah,02h ;borrar
 int 21h  
 
 dec respXI ;acceder otra columna 
 goto respXI,respYI ;se posiciona
 
 jmp ciclo
 
eliD:
 
 inc respXD  ;ir columna adelante 
 
 goto respXD,respYD
 
 cicle: 
 mov ah,08h
 int 10h
 
 cmp al,0
 je final
 
 mov dl,32
 mov ah,02h ;borrar
 int 21h  
 
 inc  respXD ;acceder otra columna
 goto respXD,respYD     
  
 jmp cicle 
 
final:
 
 cmp viene,1
 je  moverAbajoI
 ;!!!!!!!!!!!!!!!!!
 cmp viene,2
 je  moverAbajoD
 ;!!!!!!!!!!!!!!!!!
 cmp viene,3
 je  moverArribaI 
 ;!!!!!!!!!!!!!!!!!
 cmp viene,4
 je  moverArribaD 
 
 cmp viene,5
 je abajo
 
 cmp viene,6
 je arriba

ret
endp

moverHaciaIzquierda proc    
    
    
 mov bh,posBarraY
 mov bl,posBarraX
 
 mov respYD,bh
 mov respXD,bl


goto respXD,respYD

mov ah,9
lea dx,borrar
int 21h
     
 dec posBarraX 
 dec posBarrax
 
 
 goto posBarraX,posBarraY
 call dibujarBarraJugador 
    
    
ret
endp
 
moverHaciaDerecha proc
 
 mov bh,posBarraY
 mov bl,posBarraX
 
 mov respYD,bh
 mov respXD,bl
 

goto respXD,respYD

mov ah,9
lea dx,borrar
int 21h
     
 inc posBarraX
 inc posBarrax
 
 goto posBarraX,posBarraY
 call dibujarBarraJugador  

ret 
endp   

siguienteRevision: 
      
  
  mov ah,00h
  int 16h   
  
  cmp al,'d'
  je  moverHaciaDerecha
 
  cmp al,'a'          
  je moverHaciaIzquierda  
  
  ret


atenderTeclado proc
  
  mov ah,01h
  int 16h     
  
  jnz siguienteRevision 
  
  
  
ret 
endp 

ordenamiento_burbuja proc
;se ordena de forma ascendente    
; input : SI=offset direccion del array
; : BX=tamano del array
; output : no se sabe

;se ingresan los valores de los registros a la pila
    push ax
    push bx
    push cx 
    push dx
    push di 
    
    mov ax, si ;ax=si
    mov cx, bx ;cx=bx
    dec cx ; cx=cx-1
    
    loop_exterior:
    mov bx, cx ; set BX=CX
    
    mov si, ax ; set SI=AX
    mov di, ax ; set DI=AX
    inc di ; set DI=DI+1
    
    loop_interior:
    mov dl, [si] ; set DL=[SI]
    
    cmp dl, [di] ; comparando
    jng intercambio ; salta a intercambio si dl<[di]
    
    xchg dl, [di] ; set DL=[DI], [DI]=DL
    mov [si], dl ; set [SI]=DL
    
    intercambio: 
    inc si ; set SI=SI+1
    inc di ; set DI=DI+1
    
    dec bx ; set BX=BX-1
    jnz loop_interior ; salta a loop_interior si bx!=0
    loop loop_exterior ; salta a loop_exterior mientras CX!=0
    
    ;se sacan los valores en pila
    pop di 
    pop dx 
    pop cx 
    pop bx 
    pop ax     
    ret
    endp 
    
    outdec proc
    ; se despliega un numero decimal
    ; entrada : ax
    ; output : no se sabe
    
    ;ingresando valores a la pila
    push bx 
    push cx 
    push cx 
    
    xor cx, cx ; limpiando
    mov bx, 10 ; tamano BX=10
    
    output: 
    xor dx, dx 
    div bx ; se divide ax entre bx
    push dx ; ingresando el valor de dx a la pila
    inc cx 
    or ax, ax ; toma el or de ax con ax
    jne output ; salta a la etiqueta si la bandera ZF=0
    
    mov ah, 2 ;funcion de salida
    
    display: 
    pop dx ; saca el valor de dx almacenado en pila
    or dl, 30h ; se convierte de decimal a codigo ascii
    int 21h 
    loop display 
    
    ;saca el valor en pila de cada uno de los registros
    pop dx 
    pop cx
    pop bx 

ret 
endp
 
;Inicio ejecucion programa	
Inicio:
    ;;==================
;    MOV AX, 0A000h
;    MOV ES, AX      
;    mov ah,0h          ;SE CONFIGURA LA PANTALLA (MODO FACIL)
;    MOV Al, 12h 
;    INT 10H             ;720 x 400 
;    ;==================   
    
    
    
    mov ax,datasg
    mov ds,ax
    

    ;call timer    
    ;call llenarPlataforma

    ;call escribirEnArchivo

    ;call leerArchivo
;    jmp fin
    call escribirEnArchivo 
    jmp fin
    ;call leerArchivo
    ;call imprimirBuffer
    ;call ingresarNombre
;    call imprimirNombre  
;    
;    call imprimirMenu
;    
;    call space
    
    ;mov ah,1    ;espera el ingreso del dato
;    int 21h
;;
;       mov opcion, al
;;    
;;
;;    
;      sub opcion,30h ;se pasa a numero el dato ingresado  
;;    
;      cmp opcion,4
;      je capturaFigura
;    call asignarFigura   
    
   

seguir:   
  
call space
  
call solicitarVidas

call space

call solicitarNivel  

call space
 
 mov ah,09h
 lea dx,presione
 int 21h
 
 call space 
 
 
 mov ah,09h
 lea dx,pres
 int 21h
 
 mov ah,01h
 int 21h  
 
cmp dificultad,1
je facil           ;funciones para ajustar largo ventana

cmp dificultad,2
je medio

cmp dificultad,3
je dificil
    
mover:
   
 goto 0,0
 
 call imprimirNombre
 
 call imprimirVidas
 
 call imprimePuntaje


 
    
    
moves:  

 mov x,36
 mov y,23 
 
 mov posBarraX,36
 mov posBarraY,23
 
 call posicionarCursor
 
 call dibujarBarraJugador
  
 mov bh,y
 dec bh  
 mov x,36
 mov y,bh
  
 call posicionarCursor 
                        
 call imprimirFigura
  
;#######################  
  moverArribaI: 
                 
   call timer2     
   call atenderTeclado
   mov viene,1 ;saber de donde viene
       
   mov bh,limSup
   cmp y,bh    ;limite de arriba
   je moverAbajoI
     
   mov bh,limIzq   
   cmp x,bh   ;limite izquierdo
   je moverArribaD
   
   cmp casoEspecial,1
   je cont    
   call posicionarCursor
   
    mov dl,32     
    mov ah,02h
    int 21h    
   cont:  
    mov casoEspecial,0  ;se reestablece casoespecial
    dec y
    dec x ;para un movimiento en diagonal
   call posicionarCursor    
   mov ah,08h
   int 10h   ;saber si hay algo en esa poscion
        
   cmp al,0
   jne borrarBarra  ;si si borrar barra
     
   call imprimirFigura   
   
    cmp cantidadBarras,0
    je finDelJuego
   
   jmp moverArribaI
               
  ;#######################        
  moverArribaD:   
  call timer2
  call atenderTeclado
  mov viene,2 ;saber de donde viene
     
  mov bh, limSup
  cmp y,bh  ;el limite de arriba
  je moverAbajoD
            
  mov bh,limDer
  cmp x,bh  ;limite derecho 
  je moverArribaI
  
  cmp casoEspecial,1
  je conti      
  call posicionarCursor     
 
  mov dl,32     
  mov ah,02h
  int 21h  
  conti:      
  mov casoEspecial,0 ;se reestablece 
  dec y
  inc x ;para un movimiento en diagonal  
  call posicionarCursor         
   mov ah,08h
   int 10h   ;saber si hay algo en esa poscion
        
   cmp al,0
   jne borrarBarra  ;si si
   call imprimirFigura  
  
   cmp cantidadBarras,0
   je finDelJuego
  jmp moverArribaD      ;seguir en la etiqueta
  
  
  ;#######################   
  moverAbajoI:  
  call timer2     
  call atenderTeclado
  mov viene,3 ;saber de donde viene    
  mov bh, limIzq
  cmp x, bh ;limite izquierdo 
  je moverAbajoD 
  call posicionarCursor     
   
  mov dl,32     
  mov ah,02h
  int 21h   
  inc y
  dec x ;para un movimiento en diagonal 
  call posicionarCursor   
     
   mov ah,08h
   int 10h   ;saber si hay algo en esa poscion
   
   mov bh, limInf
   cmp y,bh  ;el limite de abajo
   je aux  ;habria que quitar vida
       
   cmp al,0
   jne borrarBarra  ;si si 
   
   cmp cantidadBarras,0   ;ver si el juego termina
   je finDelJuego  
 
   call imprimirFigura
  
   jmp moverAbajoI
  
                
  ;#######################               
  moverAbajoD:   
  call timer2   
  call atenderTeclado
  mov viene,4 ;saber de donde viene
     
  mov bh,limDer
  cmp x,bh  
  je moverAbajoI
  call posicionarCursor       
  mov dl,32     
  mov ah,02h
  int 21h  
  inc y
  inc x ;para un movimiento en diagonal
  call posicionarCursor
             
   mov ah,08h
   int 10h   ;saber si hay algo en esa poscion
    
   mov bh, limInf
   cmp y,bh  ;el limite de abajo
   je aux  ;habria que quitar vida 
       
   cmp al,0
   jne borrarBarra  ;si si borrar barra                          
     
   cmp cantidadBarras,0
   je finDelJuego 
                       
   call imprimirFigura
 
  jmp moverAbajoD  
  
  arriba:  
   mov bh,limSup
  cmp y,bh
  je abajo     
  call timer2   
  call atenderTeclado
  mov viene,5 ;saber de donde viene  
   cmp casoEspecial,1
   je contar
   call posicionarCursor
   
    mov dl,32     
    mov ah,02h
    int 21h  
   contar: 
    mov casoEspecial,0  ;se reestablece casoespecial
    dec y
    call posicionarCursor
    
   mov ah,08h
   int 10h   ;saber si hay algo en esa poscion
   cmp al,0
   jne borrarBarra  ;si si                          

   cmp cantidadBarras,0  ;preguntar si se acabaron las barras
   je finDelJuego 

   call imprimirFigura

  
  jmp arriba
            

 abajo: 
    mov bh,limInf    
    cmp y,bh
    je arriba
  call timer2      
  call atenderTeclado
  mov viene,6 ;saber de donde viene
  call posicionarCursor     
  
  mov dl,32     
  mov ah,02h
  int 21h  
  inc y  
  call posicionarCursor
               
   mov ah,08h
   int 10h   ;saber si hay algo en esa poscion 
   mov bh,limAbajo
   cmp y,bh  ;el limite de abajo
   je aux  ;habria que quitar vida 
       
   cmp al,0
   jne borrarBarra  ;ir a eliminar barra                        

   cmp cantidadBarras,0 ; ver si quedan mas barras
   je finDelJuego 

   call imprimirFigura

  jmp abajo              
    
            
 brinco:
 
 mov casoEspecial,1
 cmp viene,3
 je  moverArribaI 
 ;!!!!!!!!!!!!!!!!!
 cmp viene,4
 je  moverArribaD
 
  mif:  
    
    goto x,y
    
    mov dl,32
    mov ah,02h
    int 21h    
    
    goto posBarraX,PosBarraY

    mov ah,9
    lea dx,borrar
    int 21h 
    
    
    
    jmp moves:
  
 cambiarDir: 
 call posicionarCursor  
 mov casoEspecial,1
 cmp viene,4
 je moverArribaI
 
 cmp viene,3
 je moverArribaI    
        
 jmp moverArribaI       
        
 cambiarDir2: 
 call posicionarCursor  
 mov casoEspecial,1
 cmp viene,4
 je moverArribaD
 
 cmp viene,3
 je moverArribaD  
 
 jmp moverArribaD 
 
 
 aux2:
    mov casoEspecial,1
    jmp arriba
  
 aux:
 
 cmp al,'*'
 je aux2
 
 cmp al,'{' 
 je cambiarDir
 
 cmp al,'}'
 je cambiarDir2
 
 jmp quitarVida 
 
 quitarVida:
 
    dec vidas ;se resta a las vidas
    
    call imprimirVidas ;se imprimen las vidas
    cmp vidas,0
    jne mif   ;que vuelva a la posicion inicial del juego  
       
   
 finDelJuego: ;etiqueta de fin de juego
 
 call cls
     
 ;suponer que hay que ir a guardar los puntos del jugador
 
 goto 45,12
   
 mov ah,09h
 lea dx,ended
 int 21h   
 
 jmp terminar                 
                       
error:    
lea dx,errorMsg
    mov ah,9
    int 21h  
           
terminar:

xor ax,ax

mov ax,time2

call PRINT_NUM 

call calcularTotal
goto 45,20 

mov ah,09h
lea dx,finalMessage
int 21h
call escribirEnArchivo 
xor ax,ax 
 
mov ax,temp 
call PRINT_NUM
fin:  
mov ax,4c00h
int 21h   


DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS 


codesg ends
end Inicio

