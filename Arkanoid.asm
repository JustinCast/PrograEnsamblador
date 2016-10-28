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