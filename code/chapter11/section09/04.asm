; 编程，统计data段中数值大于8的字节的个数，用ax保存统计结果。

assume cs:code
data segment
           db 8,11,8,1,8,5,63,38
data ends
code segment
      start:
            mov  ax,data
            mov  ds,ax

            mov  ax,0
            mov  bx,0
            mov  cx,8
      s:    
            cmp  byte ptr ds:[bx],8
            jna  next

            inc  ax

      next: inc  bx
            loop s

            mov  ax,4c00h
            int  21h
code ends
end start