assume cs:code
code segment

        setscreen:   jmp  short set                                         ; (jmp 020AH)
        table        dw   sub1, sub2, sub3, sub4                            ; dw 004A,0065,0083,00A5 (这个是安装时的值，有问题？？？！！！)
        set:         push bx                                                ; (020AH)
                     cmp  ah, 3                                             ; 判断功能号是否大于 3
                     ja   sret
                     mov  bl,ah
                     mov  bh,0
                     add  bx,bx                                             ; 根据ah中的功能号计算对应子程序在table表中的偏移
                     call word ptr table[bx]                                ; 调用对应的功能子程序
        sret:        pop  bx
                     ret
        
        sub1:        push bx                                                ; (021D)
                     push cx
                     push es
                     mov  bx,0b800h
                     mov  es,bx
                     mov  bx,0
                     mov  cx,2000
        subls:       mov  byte ptr es:[bx],' '
                     add  bx,2
                     loop subls
                     pop  es
                     pop  cx
                     pop  bx
                     ret

        sub2:        push bx
                     push cx
                     push es
                     mov  bx,0b800h
                     mov  es,bx
                     mov  bx,1
                     mov  cx,2000
        sub2s:       and  byte ptr es:[bx],11111000b
                     or   es:[bx],al
                     add  bx,2
                     loop sub2s
                     pop  es
                     pop  cx
                     pop  bx
                     ret

        sub3:        push bx
                     push cx
                     push es
                     mov  cl,4
                     shl  al,cl
                     mov  bx,0b800h
                     mov  es,bx
                     mov  bx,1
                     mov  cx,2000
        sub3s:       and  byte ptr es:[bx],10001111b
                     or   es:[bx],al
                     add  bx,2
                     loop sub3s
                     pop  es
                     pop  cx
                     pop  bx
                     ret

        sub4:        push cx
                     push si
                     push di
                     push es
                     push ds
                     mov  si,0b800h
                     mov  es,si
                     mov  ds,si
                     mov  si,160                                            ; ds:si指向第n+1行
                     mov  di,0                                              ; es:di指向第n行
                     cld
                     mov  cx,24                                             ; 共复制24行
        sub4s:       push cx
                     mov  cx,160
                     rep  movsb                                             ; 复制
                     pop  cx
                     loop sub4s
                     mov  cx,80
                     mov  si,0
        sub4s1:      mov  byte ptr [160*24+si],' '                          ; 最后一行清空
                     loop sub4s1
                     add  si,2
                     pop  ds
                     pop  es
                     pop  di
                     pop  si
                     pop  cx
                     ret
        setscreenend:nop

        start:       mov  ax,cs
                     mov  ds,ax
                     mov  si,offset setscreen                               ; 设置 ds:si 指向源地址 (setscreen=002DH)

                     mov  ax,0
                     mov  es,ax
                     mov  di,200H                                           ; 设置 es:di 指向目的地址

                     mov  cx,offset setscreenend -  offset setscreen        ; 设置 cx 为传输长度 (setscreenend-setscreen=00ADH)
                     cld                                                    ; 设置传输方向为正
                     rep  movsb                                             ; 复制

                     mov  ax,0
                     mov  es,ax
                     mov  word ptr es:[7ch*4],200h
                     mov  word ptr es:[7ch*4+2],0                           ; 设置中断向量表

                     mov  ax,4c00h
                     int  21h
code ends
end start