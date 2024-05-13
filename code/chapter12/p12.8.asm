assume cs:code
code segment
    start:                ; do0 安装程序
    ; 设置中断向量表
          mov ax,4c00h
          int 21h

    ; do0: 显示字符串"overflow!"
          mov ax,4c00h
          int 21h
code ends
end start