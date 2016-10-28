stacksg segment para stack 'stack'      
stacksg ends
;---------------------------------
datasg segment 'data'
    ingresarApodo db 10,13, "Ingrese su nombre o apodo: ", "$" 
    max db 25 ,"$"
    long db ? ,"$"
    apodo db 25 dup(' '),"$" 
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

imprimirApodo proc
                       
lea si, apodo        
imprimirCadena:
    mov bh, [si]
    mov char,bh
    cmp bh, 0dh  ;enter en ascii
    je Final
    mov dl,char
    mov ah, 02h
    int 21h
    inc si
    jmp imprimirCadena
ret
endp           
imprimirLinea proc
    ;mov ah,02h
    ;mov dh,10h
    ;mov dl,10h
    ;mov bx,00h
    ;int 10h


    ;mov ah,09h
    ;mov dx,offset[apodo]
    ;nt 21h */  
    gotoxy 0,35 ;macro gotoxy
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