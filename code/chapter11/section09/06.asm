; 编程，统计data段中数值小于8的字节的个数，用ax保存统计结果。

assume cs:code
data segment
           db 8,11,8,1,8,5,63,38
data ends
code segment
      start:
            mov  ax,0f000h
            mov  ds,ax
            mov  bx,0
            mov  dx,0
            mov  cx,32
      s:    mov  al,[bx]
            cmp  al,32
            jb   s0             ; al<32 跳到s0
            cmp  al,128
            ja   s0             ; al>128 跳到s0
            inc  dx
      s0:   inc  bx
            loop s

            mov  ax,4c00h
            int  21h
code ends
end start