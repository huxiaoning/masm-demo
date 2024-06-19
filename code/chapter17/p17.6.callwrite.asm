assume cs:code,ss:stack,ds:data
stack segment
            db 128 dup(0)
stack ends
data segment
           db 512 dup(1)      ; 够存放1个扇区的空间
data ends
code segment
      start:mov ax,stack
            mov ss,ax
            mov sp,128
      
            mov bx,data
            mov es,bx
            mov bx,0          ; 用es:bx指向存储读出数据或写入数据的内存区。

            mov ah,1          ; 用ah寄存器传递功能号： 0表示读， 1表示写；
            mov dx,2800       ; 用dx寄存器传递要读写的扇区的逻辑扇区号； (0~2879)

            int 7ch

            mov ax,4c00h
            int 21h
code ends
end start