; 检测点11.4
; 下面的程序执行后: (ax)=?
; 0000 0000 0100 0101B    (10进制的69 16进制的45H)

assume cs:code
data segment
           db 16 dup (0)
data ends
code segment
      start:
            mov   ax,0              ; ax=0
            push  ax                ; 0入栈
            popf                    ; 栈顶的0出栈，存入到标志寄存器中(标志寄存器中16位全是0)
            mov   ax,0fff0h         ; ax=0fff0h (传送指令不影响标志寄存器)
            add   ax,0010h          ; ax=1 0000H (0)
      ; PF=1(0的bit位中有0个1,属于是偶数个1)
      ; 无符号:65520+16=65536(65535+1) 最大值的下一个数，即0   CF=1 (无符号有进位) ZF=1(结果为零)
      ; 有符号:-16+16=0 OF=0(没有溢出) SF=0(不为负)
            pushf                   ; 将标志寄存器压入栈
            pop   ax                ; ax现在等级标志寄存器中的值 xxxx 0xxx 01xx x1x1
            and   al,11000101B      ; xxxx 0xxx 0100 0101   (低8位的相关位设为0)
            and   ah,00001000B      ; 0000 0000 0100 0101   (高8位的相关位设为0)

            mov   ax,4c00h
            int   21h
code ends
end start