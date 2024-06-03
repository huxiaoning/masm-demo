; 如何依次显示"a"~"z"。

assume cs:code
code segment
      start:mov  ax,0b800h
            mov  es,ax
            mov  ah,'a'
      s:    
            mov  es:[160*12+40*2],ah
            call delay
            inc  ah
            cmp  ah,'z'
            jna  s                        ; ah <= 'z' 时跳转到s处

            mov  ax,4c00h
            int  21h

      delay:push ax
            push dx
            mov  dx,1h                 ; 循环10000000h次，读者可以根据自己机器的速度调整循环次数
            mov  ax,0
      s1:   sub  ax,1
            sbb  dx,0
            cmp  ax,0
            jne  s1
            cmp  dx,0
            jne  s1
            pop  dx
            pop  ax
            ret

code ends
end start