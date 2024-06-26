assume cs:code,ds:data
data segment
           db 128 dup(0)      ; 用作字符栈
data ends
code segment

      start:    mov  ax,data
                mov  ds,ax
                mov  si,0                            ; ds:si指向字符串首地址
                call getstr

                mov  ax,4c00h
                int  21h

      getstr:   push ax

      getstrs:  mov  ah,0
                int  16h                             ; 是从键盘缓冲区中读取一个键盘输入,结果: (ah)=扫描码，(al)=ASCII码。
                cmp  al,20h
                jb   nochar                          ; ASCII码小于20h，说明不是字符
                mov  ah,0
                call charstack                       ; 字符入栈
                mov  ah,2
                call charstack                       ; 显示栈中的字符
                jmp  getstrs

      nochar:   cmp  ah,0eh                          ; 退格键的扫描码
                je   backspace
                cmp  ah,1ch
                je   enter                           ; Enter 键的扫描码
                jmp  getstrs

      backspace:mov  ah,1
                call charstack                       ; 字符出栈
                mov  ah,2
                call charstack                       ; 显示栈中的字符
                jmp  getstrs

      enter:    mov  al,0
                mov  ah,0
                call charstack                       ; 0 入栈
                mov  ah,2
                call charstack                       ; 显示栈中的字符
                pop  ax
                ret

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