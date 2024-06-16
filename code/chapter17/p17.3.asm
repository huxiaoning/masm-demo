assume cs:code
code segment


      ; 参数说明: (ah)=功能号，0表示入栈，1表示出栈，2表示显示ds:si指向字符栈空间；
      ; 对于0号功能: (al)=入栈字符；
      ; 对于1号功能: (al)=返回的字符；
      ; 对于2号功能: (dh)、(dl)=字符串在屏幕上显示的行、列位置。

      charstack:jmp  short charstart
      table     dw   charpush, charpop,charshow
      top       dw   0                               ; 栈顶
                
      charstart:push bx
                push dx
                push di
                push es
                cmp  ah,2
                ja   sret                            ; ah>2直接return
      ; 这里是不是应该加两行，判断ah<0 return
                mov  bl,ah
                mov  bh,0
                add  bx,bx
                jmp  word ptr table[bx]              ; 跳转到对应的功能

      charpush: mov  bx,top                          ; bx指向栈顶
                mov  [si][bx],al                     ; 输入字符入栈
                inc  top                             ; 栈指针++
                jmp  sret

      charpop:  cmp  top,0
                je   sret
                dec  top                             ; 栈指针--
                mov  bx,top
                mov  al,[si][bx]
                jmp  sret

      charshow: mov  bx,0b800h
                mov  es,bx
                mov  al,160
                mov  ah,0
                mul  dh
                mov  di,ax
                add  dl,dl
                mov  dh,0
                add  di,dx                           ; di = 160*行号 + 列号*2
                mov  bx,0
      charshows:cmp  bx,top
                jne  noempty
                mov  byte ptr es:[di],' '
                jmp  sret
      noempty:  mov  al,[si][bx]
                mov  es:[di],al
                mov  byte ptr es:[di+2],' '
                inc  bx
                add  di,2
                jmp  charshows

      sret:     pop  es
                pop  di
                pop  dx
                pop  bx
                ret
code ends
end start