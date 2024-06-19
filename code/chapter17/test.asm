assume cs:code
code segment
    start:   
             mov  dx,2800
             call analysis

             mov  ax,4c00h
             int  21h

    ; 参数：dx 逻辑扇区号
    ; 返回: 面号(dh)、磁道号(ch)、扇区号(cl)
    analysis:
             push ax
             push bx

             mov  ax,dx
             mov  dx,0
             mov  bx,1440
             div  bx          ; ax=int(逻辑扇区号/1440) dx=rem(逻辑扇区号/1440)
             push ax          ; 暂存ax,其低8位al为面号

             mov  ax,dx
             mov  dx,0
             mov  bx,18
             div  bx          ; ax=int(rem(逻辑扇区号/1440)/18) dx=rem(rem(逻辑扇区号/1440)/18)
             push ax          ; 暂存ax,其低8位al为磁道号

             mov  cl,dl
             add  cl,1        ; 扇区号 0B

             pop  ax
             mov  ch,al       ; 磁道号 4B

             pop  ax
             mov  dh,al       ; 面号 01

             pop  bx
             pop  ax
             ret
code ends
end start