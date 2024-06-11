assume cs:code
stack segment
          db 128 dup(0)
stack ends
code segment
    start:mov ax,stack
          mov ss,ax
          mov sp,128
    
          mov ah,3
          int 7ch

          mov ax,4c00h
          int 21h
code ends
end start