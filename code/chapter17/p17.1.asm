assume cs:code
code segment
    start:
          mov ah,0
          int 16h

          mov ax,4c00h
          int 21h
code ends
end start