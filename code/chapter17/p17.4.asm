assume cs:code
code segment

           mov ax, 0
           mov es,ax
           mov bx,200h

           mov al,1         ; (al)=读取的扇区数
           mov ch,0         ; (ch)=磁道号
           mov cl,1         ; (cl)=扇区号
           mov dl,0         ; (dl)=驱动器号
           mov dh,0         ; (dh)=磁头号 (对于软盘即面号，因为一个面用一个磁头来读写)
           mov ah,2         ;(ah)=int 13h的功能号 (2表示读扇区)
           int 13h

code ends
end start