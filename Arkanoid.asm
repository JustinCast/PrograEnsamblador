stacksg segment para stack 'stack'      
stacksg ends
;---------------------------------
datasg segment 'data'
    ingresarApodo 10,13 "Ingrese su nombre o apodo $" 
    apodo db ?                                       
datasg ends

