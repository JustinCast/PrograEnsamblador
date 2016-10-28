stacksg segment para stack 'stack'      
stacksg ends
;---------------------------------
datasg segment 'data'
    ingresarApodo db 10,13, "Ingrese su nombre o apodo:", '$' 
    
    msgVidas db 10,13, "Ingrese la cantidad de vidas:",'$'
     
    numVidas db 0  ,'$'
    
    max db 25 ,'$' 
    
    long db ? 
    
    apodo db 10 dup(''),'$' 
    
    linea db 10,13,'$'
    
    char db ? ,'$'
    
    x db ? ,'$' 
    
    y db ? ,'$' 
    
    figura db ? ,'$'    
    
    line db 13,10, '$'; espacios en blanco    
         
    cara db "1-Carita feliz", '$';    
     
    corazon db "2-Corazon", '$'; 
    
    diamante db "3-Diamante", '$'; 
    
    menu db "Elija la figura a utilizar:", '$'; 
    
    otra db "4-Ingresar la figura", '$'; 
    
    mes2 db "Ingrese la figura", '$';  
    
    limUp db  0  ,'$'
    
    limDown db 25    ,'$'
    
    opcion db ? , '$'
    
    
                                         
datasg ends

codesg segment 'code'  
    assume ds:datasg, cs:codesg, ss:stacksg,

gotoxy macro x,y  
		mov ah,02h ;posiciona el cursor
		mov dh,x ;fila
		mov dl,y ;columna
		int 10h
endm
         


       

Inicio: 
    mov ax,datasg
    mov ds,ax 
    ;Cambio modo de video
    mov al, 03h
    mov ah,0
    int 10h
    ;;;;;;;;;;;;;;;;
    
    call capturaNombre
    ;call imprimirNombre 
    call capturarVidas
    ;call imprimirVidas
    call espace
    call espace

    call imprimeMenu
    
    lea dx,opcion
    mov ah,01h
    int 21h
    ;=======
    ;mueve la opcion ingresada por el usuario 
    mov opcion,al
    sub opcion,30h
    cmp opcion,4
    je capturaFigura
    call asignarFigura
      
           
imprimirNombre proc  
    xor dx,dx 
    mov x,0
    mov y,60 
    gotoxy x,y ;macro gotoxy
	mov ah,09h ;mostramos la cadena
	lea Dx,max
	int 21h 
	  
	
ret 
endp

posicionarCursor proc
    mov ah,02h
    mov dh,0
    mov dl,60
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
    ;jmp seguir
         
    asignarCorazon:
    
    mov figura,03
    ;jmp seguir
    
    asignarCara:
    
    mov figura,01
    ;jmp seguir         
        

capturaNombre proc        
  lea dx,ingresarApodo
    mov ah,09h
    int 21h
    
 lea dx,max   ;recibir nombre  se guarda en la cadena
    mov ah,0ah
    int 21h 
ret
endp 

capturarVidas proc
    lea dx, msgVidas
    mov ah,09h
    int 21h
    
    
    lea dx,numVidas
    mov ah,01h
    int 21h

ret
endp            

imprimirVidas proc
    xor dx,dx  
    mov x,1
    mov y,60
    gotoxy x,y ;macro gotoxy
	mov ah,09h ;mostramos la cadena
	lea Dx,numVidas
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
    
    ;jmp seguir  
              
ret
endp  

imprimeMenu proc
    
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


espace proc
    lea dx,line
    mov ah,09h
    int 21h
ret
endp    

Final:
     mov ax, 4c00h
     int 21h
     
codesg ends    

    
end Inicio     