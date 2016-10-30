stacksg segment para stack 'stack'      
stacksg ends
;---------------------------------
datasg segment 'data' 
    
    
    
    max db 20 
        
    long db ? 
    
    cadena db 10 dup ('') ,'$' 
        
    espacio db 20h, '$'
    
    message db "Nombre o apodo: ", '$'
    
    line db 13,10, '$'   
         
    cara db "1-Carita feliz", '$';    
     
    corazon db "2-Corazon", '$'; 
    
    plataforma db "3-Plataforma", '$';
    
    platform db "°°", '$' 
    
    dificultad db ? 
    
    menu db "Elija la figura a utilizar:", '$'; 
    
    otra db "4-Ingresar la figura", '$'; 
    
    mes2 db "Ingrese la figura", '$';
    
    prueba db "Prueba"
    text_size = $ - offset prueba 
    
    errorMsg db "Error con la lectura del archivo" ,'$'
    
    guardadoMsg db "Puntuacion guardada con exito!", '$'
    
    buffer db 20 dup(?) ;buffer de lectura del archivo
    
    puntuaciones db 'puntuaciones.txt',0
    
    auxiliar dw ? ; auxiliar para lectura de archivo
    
    auxiliar2 dw ? ;para guardar la direccion en memoria del archivo
    
    character db ? ;para imprimir caracter por caracter del buffer
                                                      
    char db ?; 
  
    figura db 01,'$'  
    
    x db ?
    
    y db ?   
    
    limUp db  0
    
    limDown db 25
    
    opcion db ?
    
datasg ends
;---------------------------------
codesg segment 'code'  
    assume ds:datasg, cs:codesg, ss:stacksg, 
     
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

asignarFigura proc   
sub opcion, 30h
cmp opcion,1
je call asignarCara

cmp opcion,2
je call asignarCorazon 
      
cmp opcion,3
je call asignarPlataforma   

ret
endp 

     
asignarPlataforma proc                  
mov figura, 179
ret
endp
     
asignarCorazon proc

mov figura,03
ret 
endp

asignarCara proc

mov figura,01
ret
endp

                
; imprimir espacio
space proc    
    
 lea dx, line      ;imprimiendo espacio
 mov ah,09h
 int 21h
 
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
            

opcionFigura proc

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
              
ret
endp

imprimirNombre proc
   
lea si, cadena ;lectura del nombre
    
continue:

    mov bh ,[si] ;se mueve la posicion de la cadena a un registro
    
    mov char,bh 
  
    cmp bh,0dh       ;si se llego al enter termina
    je continuacion
         
    mov dl,char
    mov ah,02h  ;imprimir el caracter del nombre en esa posicion
    int 21h
     
    inc si  ;incrementar para acceder a otra
            ;posicion
    
    
    jmp continue
    
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
 
 lea dx,plataforma
 mov ah,09h
 int 21h

 call space    
 
 lea dx,otra
 mov ah,09h
 int 21h
   
ret
endp
    
;Inicio ejecucion programa	
Inicio:        

    mov ax,datasg
    mov ds,ax 
    
    call escribirEnArchivo
    ;call leerArchivo
    ;call imprimirBuffer
    ;call ingresarNombre
    ;call imprimirNombre
    ;call imprimirMenu   
    ;call opcionFigura
    ;call asignarFigura 
    jmp terminar     
continuacion:
seguir:   

mov x,50
mov y,23 
call posicionarCursor
call imprimirFigura
    
mover:

  moverArribaI:
  
   cmp y,0     ;limite de arriba
   je moverAbajoI
       
   cmp x,0     ;limite izquierdo
   je moverArribaD
    
   call posicionarCursor
   
    mov dl,32     
    mov ah,02h
    int 21h  
   
    dec y
    dec x ;para un movimiento en diagonal

  
   call posicionarCursor
   
   ;preguntar si hay algo ahi
   ;si si borrar barra
   
   call imprimirFigura
   
   ;preguntar si hay mas barras
   
   jmp moverArribaI
               
               
  moverArribaD:
  
  cmp y,0  ;el limite de arriba
  je moverAbajoD
  
  cmp x, 80  ;limite derecho 
  je moverArribaI
  
  call posicionarCursor     
  
  
  mov dl,32     
  mov ah,02h
  int 21h  
  
  dec y
  inc x ;para un movimiento en diagonal
  
  call posicionarCursor   
  
   ;preguntar si hay algo ahi
   ;si si borrar barra
  
  call imprimirFigura
  
  ;preguntar si quedan mas barras
  
  jmp moverArribaD
  
   
  moverAbajoI:
  
  cmp y,23  ;el limite de abajo
  je moverArribaI  ;habria que quitar vida
  
  cmp x, 0  ;limite izquierdo 
  je moverAbajoD
  
  call posicionarCursor     
  
  
  mov dl,32     
  mov ah,02h
  int 21h  
  
  inc y
  dec x ;para un movimiento en diagonal
  
  call posicionarCursor   
  
   ;preguntar si hay algo ahi
   
   ;si si ir a moverArribaI
  
  call imprimirFigura
  
  ;preguntar si quedan mas barras
  
  jmp moverAbajoI
  
                
                
    moverAbajoD:
  
  cmp y,23  ;el limite de abajo
  je moverArribaD   ;habria que quitar vida
  
  cmp x,80  ;limite izquierdo 
  je moverAbajoI
  
  call posicionarCursor     
  
  
  mov dl,32     
  mov ah,02h
  int 21h  
  
  inc y
  inc x ;para un movimiento en diagonal
  
  call posicionarCursor   
  
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

