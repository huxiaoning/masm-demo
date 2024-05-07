; 如果(ah)=(bh) 则(ah)=(ah)+(ah)，否则(ah)=(ah)+(bh)。

assume cs:code
code segment
    start:
          cmp ah,bh
          je  s

          add ah,bh       ; else 执行这一行
          jmp short ok    ; 这里必须要跳转，否则下一行也要执行

    s:    add ah,ah       ; ah=bh执行这一行

    ok:   
          mov ax,4c00h
          int 21h
code ends
end start