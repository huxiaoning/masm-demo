assume cs:code
code segment
    s1:   db   'Good,better,best,','$'
    s2:   db   'Never let it rest,','$'
    s3:   db   'Till good is better,','$'
    s4:   db   'And better,best.','$'
    s:    dw   offset s1,offset s2,offset s3,offset s4
    row:  db   2,4,6,8

    start:mov  ax,cs
          mov  ds,ax
          mov  bx,offset s
          mov  si,offset row
          mov  cx, 4
    ok:   mov  bh,0                                       ; 第0页
          mov  dh,ds:[si]                                 ; dh中放行号
          mov  dl,0                                       ; dl中放列号
          mov  ah,2                                       ; 置光标
          int  10h                                        ; bios提供的设置光标位置的功能

          mov  dx,ds:[bx]                                 ; ds:dx指向字符串的首地址data:0
          mov  ah,9                                       ; 在光标位置显示字符串
          int  21h                                        ; dos提供的在光标处显示字符串的功能

          inc  si
          add  bx,2
          loop ok

          mov  ax,4c00h
          int  21h
code ends
end start