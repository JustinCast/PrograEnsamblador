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
    
    menu db "Elija la figura a utilizar:", '$'; 
    
    otra db "4-Ingresar la figura", '$'; 
    
    mes2 db "Ingrese la figura", '$';
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
    call ingresarNombre
    ;call imprimirNombre
    call imprimirMenu   
    call opcionFigura
    call asignarFigura      
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
           
           
terminar:

    
mov ax,4c00h
int 21h 

codesg ends
end Inicio

