stacksg segment para stack 'stack'      
stacksg ends
;---------------------------------
datasg segment 'data' 
    
   
    max db 20 
        
    long db ? 
    
    cadena db 10 dup ('') ,'$'    
    
    message db "Nombre o apodo: ",'$'
    
    line db 10,13,'$' 
    
    mess db "Con que nivel de dificultad va a jugar?",'$'
    
    mVidas db "Cuantas vidas tendra? ",'$'                    
    
    vidasMessage db "Vidas: ",'$' 
    
    presione db "Presione el boton clearScreen de la esquina Inferior Izquierda",,'$' 
    pres db "Luego presione la tecla enter",'$'
    
    niveles db "1:Facil, 2:Medio, 3:Dificil ",'$'
         
    cara db "1-Carita feliz",'$';    
     
    corazon db "2-Corazon",'$'; 
    
    diamante db "3-Diamante",'$';
    
    barra db "����",'$' 
    
    dificultad db ?    
    
    vidas db ? ;conocer la cantidad de vidas
    
    menu db "Elija la figura a utilizar:",'$'; 
    
    tecla db ? ;guardar tecla ingresada por el usuario 
     
    otra db "4-Ingresar la figura",'$'; 
    
    mes2 db "Ingrese la figura",'$';
    
    prueba db "Prueba",'$'
    text_size = $ - offset prueba 
    
    errorMsg db "Error con la lectura del archivo",'$'
    
    guardadoMsg db "Puntuacion guardada con exito!",'$'
    
    buffer db 20 dup(?) ;buffer de lectura del archivo
    
    puntuaciones db 'puntuaciones.txt',0
    
    auxiliar dw ? ; auxiliar para lectura de archivo
    
    auxiliar2 dw ? ;para guardar la direccion en memoria del archivo
    
    character db ? ;para imprimir caracter por caracter del buffer
                                                      
    char db ?; 
  
    figura db ? 
    
    x db ?
    
    y db ?  
    
    respXI db ? ;utiles para el procedimiento de
                ;borrar barras
    respYI db ?
    
    respXD db ?
    
    respYD db ? 
    
    barraJugador db  "[][][][]",'$'
    
    posBarraX db ?  ;manejar posicion de la barra del jugador
    
    posBarray db ?  ;manejar posicion de la barra del jugador
    
    limSup db 1
                   ;limites de la ventana
    limInf db 23
    
    limIzq db 0
    
    limDer db 79   
     
    finalizo db 1 ;saber si la barra se ha borrado  
    
    opcion db ?   
    
    viene db ? ;1=dai,2=dad,3=dabi,4=dabd   
    
    
datasg ends
;---------------------------------
codesg segment 'code'  
    assume ds:datasg, cs:codesg, ss:stacksg, 
      
GOTOXY  MACRO hor,ver  ;macro posiciona cursor
         xor bh,bh
         mov dl,hor
         mov dh,ver   
         mov ah,02h
         int 10h
         
 ENDM
   
   
leerArchivo proc
    
    lea dx,puntuaciones
    mov ax,3d00h  ;se abre abre archivo 
    int 21h        
    jc error  ;si no se puede abrir salta a 'error' 
    
    mov auxiliar,ax
    mov bx,auxiliar
    mov ah,3fh ;instruccion para leer de un dispositivo o archivo
    mov cx,20
    lea dx,buffer ;lee caracteres almacenados en buffer
    int 21h        
    jc error    
    mov ah,3eh ;instruccion para cerrar el archivo
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

escribirEnArchivo proc  
          ;base para apuntar los tres buffers
   ; mov ah, 3ch
;    mov cx, 0
    lea dx, puntuaciones
    mov ah,3dh ;abrir archivo 
    mov al,02h
    int 21h
    
    
    jc error 
    
    mov auxiliar2,ax
    ;escribiendo en archivo 
    ;mov auxiliar2,ax
    mov bx,auxiliar2 ;se obtiene el nombre del archivo
    mov ah,40h ;instruccion para escribir en el archivo
    mov cx,text_size
    lea dx, prueba ;lo que se desea escribir en el archivo (puede ser un arreglo, buffer o variable)
    ;mov cx,text_size
    int 21h 
    
    ;jc error
    ;cerrando archivo
    mov ah,3eh
    int 21h
    jc error
    
    lea dx,guardadoMsg    ;
    mov ah,9
    int 21h 
    

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
 mov ah,02h  ;imprimir el caracter del nombre en esa posicion
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

facil proc
    
;aqui iria el tamano de la ventana pequena
;luego habria que llamar una funcion que la llene con barras
;asignar variables limites de ventana segun al tamano
jmp mover
ret
endp      

medio proc
  
;aqui iria el tamano de la ventana pequena
;luego habria que llamar una funcion que la llene con barras
jmp mover

ret
endp 

dificil proc

mov ah,00h
mov al,02h
int 10h              
 
;aqui iria el tamano de la ventana pequena
;luego habria que llamar una funcion que la llene con barras 

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


borrarBarra proc
 
cmp al,32  ;si lo que hay es un espacio
je devolver
 
mov dl,07h
mov ah,02h ;que suene 
int 21h

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

gotoxy respXI,respYI

ciclo:  

 mov ah,08h
 int 10h
 
 cmp al,0
 je eliD
 
 mov dl,32
 mov ah,02h ;borrar
 int 21h  
 
 dec respXI ;acceder otra columna 
 gotoxy respXI,respYI ;se posiciona
 
 jmp ciclo
 
eliD:
 
 inc respXD  ;ir columna adelante 
 
 gotoxy respXD,respYD
 
 cicle: 
 mov ah,08h
 int 10h
 
 cmp al,0
 je final
 
 mov dl,32
 mov ah,02h ;borrar
 int 21h  
 
 inc  respXD ;acceder otra columna
 gotoxy respXD,respYD     
  
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

ret
endp
 
proc moverHaciaIzquierda
    
ret
endp
 
proc moverHaciaDerecha
 
 mov cx,8   ;seria el tamano de la barra
 mov bh,posBarraY
 mov bl,posBarraX
 etiqueta:
 
     gotoxy bl,bh
     
     mov dl,32
     mov ah,02h
     int 21h
     
     loop etiqueta
     
 inc posBarraX
 inc posBarraX
 
 gotoxy posBarraX,posBarraY
 call dibujarBarraJugador  

ret 
endp

proc verificarTecla
  
  mov ah,00h
  int 16h
  
  cmp ah,0x4D
  je  moverHaciaDerecha
 
  cmp ah,0x4B          
  je moverHaciaIzquierda

ret 
endp   
 
;Inicio ejecucion programa	
Inicio:        

    mov ax,datasg
    mov ds,ax 
    
    ;call escribirEnArchivo
    ;call leerArchivo
    ;call imprimirBuffer
    call ingresarNombre
    call imprimirNombre  
    
    call imprimirMenu
    
    call space
    
    mov ah,1    ;espera el ingreso del dato
    int 21h

    mov opcion, al
    
    sub opcion,30h ;se pasa a numero el dato ingresado  
    
    cmp opcion,4
    je capturaFigura
    
    call asignarFigura   
    
   

seguir:   
  
call space
  
call solicitarVidas

call space

call solicitarNivel    

cmp dificultad,1
je facil           ;funciones para ajustar largo ventana

cmp dificultad,2
je medio

cmp dificultad,3
je dificil
    
mover:
 
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
   
 gotoxy 0,0
 
 call imprimirNombre
 
 call imprimirVidas

 mov x,2
mov y,1

call posicionarCursor
call dibujarBarra

mov x,9
mov y,1
call posicionarCursor
call dibujarBarra

mov x,16
mov y,1
call posicionarCursor
call dibujarBarra
      
mov x,26
mov y,1
call posicionarCursor
call dibujarBarra

mov x,38
mov y,1
call posicionarCursor
call dibujarBarra

mov x,60
mov y,1
call posicionarCursor
call dibujarBarra 


mov x,43
mov y,17
call posicionarCursor
call dibujarBarra     
  
 mov x,50
 mov y,23 
 
 mov posBarraX,50
 mov posBarraY,23
 
 call posicionarCursor
 
 call dibujarBarraJugador
  
 mov bh,y
 dec bh  
 mov x,50
 mov y,bh
  
 call posicionarCursor 
                        
 call imprimirFigura


;#######################  
  moverArribaI: 
  
   mov ah,01h
   int 16
    
  cmp ah,0x4D
  je  moverHaciaDerecha
 
  cmp ah,0x4B          
  je moverHaciaIzquierda
  
   mov viene,1 ;saber de donde viene
     
   mov bh,limSup
   cmp y,bh    ;limite de arriba
   je moverAbajoI
     
   mov bh,limIzq   
   cmp x,bh   ;limite izquierdo
   je moverArribaD
    
   call posicionarCursor
   
    mov dl,32     
    mov ah,02h
    int 21h  
   
    dec y
    dec x ;para un movimiento en diagonal

  
   call posicionarCursor
    
   mov ah,08h
   int 10h   ;saber si hay algo en esa poscion
        
   cmp al,0
   jne borrarBarra  ;si si
   
   ;preguntar si hay algo ahi
   ;si si borrar barra
   
   call imprimirFigura
   
   ;preguntar si hay mas barras
   
   jmp moverArribaI
               
  ;#######################        
  moverArribaD: 
  
  mov viene,2 ;saber de donde viene
     
  mov bh, limSup
  cmp y,bh  ;el limite de arriba
  je moverAbajoD
            
  mov bh,limDer
  cmp x,bh  ;limite derecho 
  je moverArribaI
  
  call posicionarCursor     
  
  
  mov dl,32     
  mov ah,02h
  int 21h  
  
  dec y
  inc x ;para un movimiento en diagonal
  
  call posicionarCursor   
      
   mov ah,08h
   int 10h   ;saber si hay algo en esa poscion
        
   cmp al,0
   jne borrarBarra  ;si si
   
   ;preguntar si hay algo ahi
   ;si si borrar barra
  
  call imprimirFigura
  
  ;preguntar si quedan mas barras
  
  jmp moverArribaD
  
  
  ;#######################   
  moverAbajoI:
  
  mov viene,3 ;saber de donde viene
    
  mov bh, limInf
  cmp y,bh  ;el limite de abajo
  je moverArribaI  ;habria que quitar vida
     
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
        
   cmp al,0
   jne borrarBarra  ;si si                
   
   ;&&&como diferenicar las barras de la plataforma de la figura&&&
   
   ;preguntar si hay algo ahi
   ;si si ir a moverArribaI
  
  call imprimirFigura
  
  ;preguntar si quedan mas barras
  
  jmp moverAbajoI
  
                
  ;#######################               
  moverAbajoD:
  
  mov viene,4 ;saber de donde viene
     
  mov bh, limInf
  cmp y,bh  ;el limite de abajo
  je moverArribaD   ;habria que quitar vida
  
  mov bh,limDer
  cmp x,bh  ;limite izquierdo 
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
        
   cmp al,0
   jne borrarBarra  ;si si                          
        
   ;&&&como diferenicar las barras de la plataforma de la figura&&&
        
                        
   ;preguntar si hay algo ahi 
   ;si si ir a moverArribaD
  
  call imprimirFigura
  
  ;preguntar si quedan mas barras
  
  jmp moverAbajoD  


error:    
lea dx,errorMsg
    mov ah,9
    int 21h  
           
terminar:

    
mov ax,4c00h
int 21h 

codesg ends
end Inicio

