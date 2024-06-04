assume cs:code
stack segment
           db 128 dup (0)
stack ends
code segment
     start:  mov   ax,stack
             mov   ss,ax
             mov   sp,128

             push  cs
             pop   ds

             mov   ax,0
             mov   es,ax

             mov   si,offset int9                    ; 设置 ds:si 指向源地址
             mov   di,204h                           ; 设置 es:di 指向目的地址
             mov   cx,offset int9end-offset int9     ; 设置 cx 为传输长度
             cld                                     ; 设置传输方向为正
             rep   movsb

             push  es:[9*4]
             pop   es:[200h]                         ; 保存原int 9中断处理程序的偏移地址(IP)
             push  es:[9*4+2]
             pop   es:[202h]                         ; 保存原int 9中断处理程序的段地址(CS)

             cli
             mov   word ptr es:[9*4],204h
             mov   word ptr es:[9*4+2],0
             sti

             mov   ax,4c00h
             int   21h

     int9:   push  ax
             push  bx
             push  cx
             push  es

             in    al,60h

             pushf
             call  dword ptr cs:[200h]               ; 当此中断例程执行时(CS)=0

             cmp   al,3bh                            ; F1 的扫描码为 3bh
             jne   int9ret

             mov   ax,0b800h
             mov   es,ax
             mov   bx,1
             mov   cx,2000
     S:      
             add   bx,2
             inc   byte ptr es:[bx]
             loop  s

     int9ret:pop   es
             pop   cx
             pop   bx
             pop   ax
             iret
     int9end:nop
code ends
end start