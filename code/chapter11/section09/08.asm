; (1) 编程，用串传送指令，将data段中的第一个字符串复制到它后面的空间中。

assume cs:code
data segment
           db 'Welcome to masm!'
           db 16 dup (0)
data ends
code segment
      start:
            mov ax,data
            mov ds,ax
            mov es,ax

            mov si,0
            mov di,16

            cld               ; df置0,让di si每次递增
            mov cx,8          ; mov cx,16
            rep movsw         ; rep movsb

            mov ax,4c00h
            int 21h
code ends
end start