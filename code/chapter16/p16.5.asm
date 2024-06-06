assume cs:code,es:data
data segment
      a    db 1,2,3,4,5,6,7,8
      b    dw 0
data ends
code segment
      start:mov  ax,data
            mov  es,ax          ; 一定要是es,assume中指定es:data后，后面的mov al,a[si] 会被解释为 mov al,es:0[si]

            mov  si,0
            mov  cx, 8
      s:    mov  al,a[si]
            mov  ah,0
            add  b,ax
            inc  si
            loop s

            mov  ax, 4c00h
            int  21h
code ends
end start