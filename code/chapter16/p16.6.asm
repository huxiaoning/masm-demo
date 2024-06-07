assume cs:code
code segment

      ; 用al传送要显示的数据
      showbyte:jmp  short show
      table    db   '0123456789ABCDEF'         ; 字符表

      show:    push bx
               push es

               mov  ah,al
               shr  ah,1
               shr  ah,1
               shr  ah,1
               shr  ah,1                       ; 右移4位,ah中得到高4位的值
               and  al,00001111b               ; al中为低4位的值(高4位置为0其他不变)

               mov  bl,ah
               mov  bh,0
               mov  ah,table[bx]               ; 用高4位的值作为相对于table的偏移,取得对应的字符

               mov  bx,0b800h
               mov  es,bx
               mov  es:[160*12+40*2],ah        ; 显示高4位的16进制到屏幕

               mov  bl,al
               mov  bh,0
               mov  al,table[bx]               ; 用低4位的值作为相对于table的偏移,取得对应的字符

               mov  es:[160*12+40*2+2],al      ; 显示低4位的16进制到屏幕

               pop  es
               pop  bx
               ret
code ends
end start