assume cs:code
data segment
           db 'conversation',0
data ends
code segment
      start:mov ax,data
            mov ds,ax
            mov si,0
            mov ax,0b800h
            mov es,ax
            mov di,12*160
      s:    cmp byte ptr [si],0
            je  ok                         ; 如果是 0 跳出循环
            mov al, [si]
            mov es:[di],al
            inc si
            add di,2
            mov bx,offset s-offset ok      ; 设置从标号ok到标号s的转移位移
            int 7ch                        ; 转移到标号s处
      ok:   
            mov ax,4c00h
            int 21h
code ends
end start