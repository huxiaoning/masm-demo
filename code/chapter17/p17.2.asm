assume cs:code
code segment
    start:mov  ah,0
          int  16h

          mov  ah,1                           ; 画线 - 初始化 ah=00000001 表示Blue蓝色
          cmp  al,'r'
          je   red
          cmp  al,'g'
          je   green
          cmp  al,'b'
          je   blue
          jmp  short sret

    red:  shl  ah,1                           ; 画线 - 跳转到这里ah最终会左移两次,为 00000100 表示Red红色
    green:shl  ah,1                           ; 画线 - 跳转到这里ah最终会左移一次,为 00000010 表示Green绿色
    blue: mov  bx,0b800h                      ; 跳转到这里ah不变 还是Blue蓝色
          mov  es,bx
          mov  bx,1
          mov  cx,2000
    S:    
          and  byte ptr es: [bx],11111000b
          or   es: [bx],ah
          add  bx,2
          loop s

    sret: mov  ax,4c00h
          int  21h
code ends
end start