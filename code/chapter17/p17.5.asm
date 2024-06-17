assume cs:code
code segment
     start:mov ax,0b800h
           mov es,ax
           mov bx,0          ; es:bx 指向将写入磁盘的数据

           mov al,8          ; (al)=写入的扇区数
           mov ch,0          ; (ch)=磁道号
           mov cl,1          ; (cl)=扇区号
           mov dl,0          ; (dl)=驱动器号
           mov dh,0          ; (dh)=磁头号(面)
           mov ah,3          ; (ah)=int 13h的功能号 (3表示写扇区)
           int 13h
     ; 返回参数：
     ; 操作成功: (ah)=0，(al)=写入的扇区数
     ; 操作失败: (ah)=出错代码

           mov ax,4c00h
           int 21h
code ends
end start