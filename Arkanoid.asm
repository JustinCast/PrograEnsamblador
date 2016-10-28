.MODEL tiny ;tamano peque
.DATA   
    msg db 13,10,"Ingrese su nombre o apodo: $"    
    nombre  DB  16 DUP('$')  
.CODE

Inicio:
    ;Mover los datos al registro principal
    mov ax, @data
    mov dx, ax  
    ;Mostrar 'Ingresar apodo'
    mov dx, offset msg
    mov ah, 9h
    int 21h 
    
    ;Leer el nombre
    mov ah,01h
    int 21H
    mov nombre, al
    int 21h
     
    ;Mostrar el nombre
    lea dx, nombre
    mov ah, 9h
    int 21h 
    jmp Fin
    
    
Fin:    
    ;=============
    ;Terminar Programa
    mov ah,0x4C
    int 0x21  