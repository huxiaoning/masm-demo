assume cs:code
code segment
    start:      mov  ax,cs
                mov  ds,ax
                mov  si,offset printstr
                mov  ax,0
                mov  es,ax
                mov  di,200h
                mov  cx,offset printstrend-offset printstr
                cld
                rep  movsb

                mov  ax,0
                mov  es,ax
                mov  word ptr es:[7ch*4],200h
                mov  word ptr es:[7ch*4+2],0

                mov  ax,4c00h
                int  21h

    printstr:   
                push ax
                push bx
                push cx
                push es
                push si

                

                mov  ax,0b800h
                mov  es,ax

                mov  al,160
                mul  dh
                mov  bx,ax
                mov  al,2
                mul  dl
                add  bx,ax                                    ; bx=dh*160+dl*2

                mov  al,cl                                    ; 把颜色参数放到al里面,cl用来遍历字符串和控制跳转
                mov  ch,0
    s:          
                mov  cl,ds:[si]
                jcxz ok
                mov  es:[bx],cl
                inc  bx
                mov  es:[bx],al
                inc  si
                inc  bx
                jmp  short s

    ok:         
                pop  si
                pop  es
                pop  cx
                pop  bx
                pop  ax
                iret
    printstrend:nop
code ends
end start