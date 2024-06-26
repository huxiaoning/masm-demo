assume cs:code
code segment

           mov ax, 0
           mov es,ax
           mov bx,200h      ; es:bx 指向接收从扇区读入数据的内存区

           mov al,1         ; (al)=读取的扇区数
           mov ch,0         ; (ch)=磁道号
           mov cl,1         ; (cl)=扇区号
           mov dl,0         ; (dl)=驱动器号
           mov dh,0         ; (dh)=磁头号 (对于软盘即面号，因为一个面用一个磁头来读写)
           mov ah,2         ;(ah)=int 13h的功能号 (2表示读扇区)
           int 13h
      ; 返回参数：
      ; 操作成功: (ah)=0，(al)=读入的扇区数
      ; 操作失败: (ah)=出错代码



           mov ax,0
           mov es,ax
           mov bx,200h      ; es:bx 指向将写入磁盘的数据

           mov al,1         ; (al)=写入的扇区数
           mov ch,0         ; (ch)=磁道号
           mov cl,1         ; (cl)=扇区号
           mov dl,0         ; (dl)=驱动器号
           mov dh,0         ; (dh)=磁头号(面)
           mov ah, 3        ; (ah)=int 13h的功能号 (3表示写扇区)
           int 13h
      ; 返回参数：
      ; 操作成功: (ah)=0，(al)=写入的扇区数
      ; 操作失败: (ah)=出错代码
code ends
end start