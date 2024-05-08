; (2) 编程，用串传送指令，将F000H段中的最后16个字符复制到data段中。

assume cs:code
data segment
           db 16 dup (0)
data ends
code segment
      start:
            mov ax,data
            mov es,ax
            mov di,15

            mov ax,0F000H
            mov ds,ax
            mov si,0FFFFH

            std                ; df置1,让di si每次递减
            mov cx,16          ; mov cx,8
            rep movsb          ; rep movsw

            mov ax,4c00h
            int 21h
code ends
end start