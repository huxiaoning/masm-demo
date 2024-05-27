assume cs:code
code segment
    start:
          mov ax,100      ; 初始化ax=100

          shl ax,1        ; ax*=2
          mov dx,ax       ; 把ax*2放到dx里面

          mov cl,2
          shl ax,cl       ; ax*=8
          add dx,ax       ; 把ax*8加到dx里面

          mov ax,dx       ; 把最终结构放到ax中

          mov ax,4c00h
          int 21h
code ends
end start