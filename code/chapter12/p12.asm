assume cs:code
code segment
       start:   
                mov  ax,cs
                mov  ds,ax
                mov  si,offset do0                        ; 设置 ds:si 指向源地址

                mov  ax,0
                mov  es,ax
                mov  di,200H                              ; 设置 es:di 指向目的地址

                mov  cx,offset do0end -  offset do0       ; 设置 cx 为传输长度
      
                cld                                       ; 设置传输方向为正
                rep  movsb

                mov  ax,0
                mov  es,ax
                mov  word ptr es:[0*4],200h
                mov  word ptr es:[0*4+2],0                ; 设置中断向量表
                
                mov  ax,4c00h
                int  21h

       do0:     
                jmp  short do0start
                db   "divide error!"                      ; 修改显示的字符串内容
       do0start:
                mov  ax,cs
                mov  ds,ax
                mov  si,202h                              ; 设置ds:si指向"overflow!"字符串
      
                mov  ax,0b800h
                mov  es,ax
                mov  di,12*160+36*2                       ; 设置 es:di 指向显存空间的中间位置

                mov  cx,13                                ; 字符串长度由9修改为13
       s:       mov  al,[si]
                mov  es:[di],al
                inc  si
                add  di,2
                loop s

                mov  ax,4c00h
                int  21h
       do0end:  nop
code ends
end start