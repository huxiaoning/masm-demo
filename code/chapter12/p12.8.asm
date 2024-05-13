assume cs:code
code segment
      start:
      ; 设置 es：di 指向目的地址
      ; 设置 ds：si 指向源地址
      ; 设置 cx 为传输长度
      ; 设置传输方向为正
            rep movsb

      ; 设置中断向量表
            mov ax,4c00h
            int 21h

      ; do0: 显示字符串"overflow!"
            mov ax,4c00h
            int 21h
code ends
end start