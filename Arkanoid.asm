stacksg segment para stack 'stack'      
stacksg ends
;---------------------------------
datasg segment 'data'
    ingresarApodo db 10,13, "Ingrese su nombre o apodo: ", "$" 
    max db 25 ,"$"
    long db ? ,"$"
    apodo db 25 dup(''),"$" 
    linea db 10,13,"$"
    char db ? ,"$"
    x db ?
    y db ?
    figura db ?    
    message db "Escriba su nombre de usuario", '$'
    
    line db 13,10, '$'; espacios en blanco    
         
    cara db "1-Carita feliz", '$';    
     
    corazon db "2-Corazon", '$'; 
    
    diamante db "3-Diamante", '$'; 
    
    menu db "Elija la figura a utilizar:", '$'; 
    
    otra db "4-Ingresar la figura", '$'; 
    
    mes2 db "Ingrese la figura", '$';
  
  
     
    
    x db ?
    
    y db ?   
    
    limUp db  0
    
    limDown db 25
    
    opcion db ?
    
    
                                         
datasg ends

codesg segment 'code'  
    assume ds:datasg, cs:codesg, ss:stacksg,

gotoxy macro x,y
		mov ah,02h ;posiciona el cursor
		mov dh,x ;fila
		mov dl,y ;columna
		mov bh,0 ;pagina de video
		int 10h
endm
         

imprimirFigura proc

 mov dl,figura
 mov ah,02h  ;imprimir el caracter del nombre en esa posicion
 int 21h 
 
 ret
 endp

asignarFigura proc   

cmp opcion,1
je  asignarCara

cmp opcion,2
je  asignarCorazon 
      
cmp opcion,3
je asignarDiamante   

ret
endp 

     
asignarDiamante:   ;asigna figura

mov figura,04
jmp seguir
     
asignarCorazon:

mov figura,03
jmp seguir

asignarCara:

mov figura,01
jmp seguir         
        

capturaNombre proc    
    
  lea dx,message
    mov ah,09h
    int 21h
    
 lea dx,max   ;recibir nombre  se guarda en la cadena
    mov ah,0ah
    int 21h 
 ret
 endp 
        
  
Limpiar proc 
     mov ax,0600h   ;toda la pantalla
     mov bh,0fh    ;Fondo blanco, frente negro
     mov cx,0000h   ;desde fila 00, columna 
     mov dx,184fh   ;hasta fila 25(18h), columna 80(4Fh)
     int 10h

ret 
endp 

capturaFigura proc

call espace

call espace
             
lea dx,mes2
mov ah,09h
int 21h

call espace
call espace

mov ah,1    ;espera el ingreso del dato
int 21h  

mov figura,al

jmp seguir  
              
ret
endp  

imprimeMenu proc
          
 call espace
 
 lea dx,menu
 mov ah,09h
 int 21h

 call espace  

 lea dx,Cara
 mov ah,09h
 int 21h

 call espace  
 
 lea dx,Corazon
 mov ah,09h
 int 21h

 call espace   
 
 lea dx,Diamante
 mov ah,09h
 int 21h

 call espace    
 
 lea dx,otra
 mov ah,09h
 int 21h
   
ret
endp
       

Inicio proc  
    ;Cambio modo de video
    mov al, 03h
    mov ah,0
    int 10h
    ;;;;;;;;;;;;;;;;
    mov ax,datasg
    mov ds,ax
    
    mov dx,offset ingresarApodo
    mov ah,09h
    int 21h 
    
    lea dx,max
    mov ah,0ah
    int 21h   
    call imprimirLinea 
    ;call imprimirApodo
    
ret 
endp     
           
imprimirLinea proc  
    gotoxy 0,60 ;macro gotoxy
	mov ah,09h ;mostramos la cadena
	lea Dx,max
	int 21h
	
	mov ah,01h ;pedimos un caracter
	int 21h
ret 
endp

posicionarCursor proc
    mov ah,02h
    mov dh,10
    mov dl,10
    int 10h
ret
endp

Final:
     mov ax, 4c00h
     int 21h
     
codesg ends    

    
end Inicio     