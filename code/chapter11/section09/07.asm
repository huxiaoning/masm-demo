; 检测点11.3
; (2) 补全下面的程序，统计F000:0处32个字节中，大小在(32,128)的数据的个数。

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
            jna  s0             ; al<=32 跳到s0
            cmp  al,128
            jnb  s0             ; al>=128 跳到s0
            inc  dx
      s0:   inc  bx
            loop s

            mov  ax,4c00h
            int  21h
code ends
end start