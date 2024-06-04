assume cs:code
code segment
             mov  ax,0b800h
             mov  es,ax
             mov  bx,1
             mov  cx,2000
        s:   
             inc  byte ptr es:[bx]
             add  bx,2
             loop s
code ends
end start