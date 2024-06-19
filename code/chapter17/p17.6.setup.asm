assume cs:code
code segment
              db   200H dup(0)                             ; 下面的程序安装在0:200H处，这里占200H字节空间，以确保下面的标号从200H后顺延
    rwdisk:   
              push dx
              call analysis

              add  ah,2                                    ; 0读1写 转换成 2读3写
              mov  al,1                                    ; 只读写一个扇区
              mov  dl,0                                    ; 认为A盘是3.5英寸软盘的盘符
              int  13h                                     ; 调用int 13h中断例程对磁盘进行读写
    ; 返回参数：
    ; 操作成功: (ah)=0，(al)=读(写)入的扇区数
    ; 操作失败: (ah)=出错代码
              pop  dx
              iret

    ; 参数：dx 逻辑扇区号
    ; 返回: 面号(dh)、磁道号(ch)、扇区号(cl)
    analysis: 
              push ax
              push bx

              mov  ax,dx
              mov  dx,0
              mov  bx,1440
              div  bx                                      ; ax=int(逻辑扇区号/1440) dx=rem(逻辑扇区号/1440)
              push ax                                      ; 暂存ax,其低8位al为面号

              mov  ax,dx
              mov  dx,0
              mov  bx,18
              div  bx                                      ; ax=int(rem(逻辑扇区号/1440)/18) dx=rem(rem(逻辑扇区号/1440)/18)
              push ax                                      ; 暂存ax,其低8位al为磁道号

              mov  cl,dl
              add  cl,1                                    ; 扇区号

              pop  ax
              mov  ch,al                                   ; 磁道号

              pop  ax
              mov  dh,al                                   ; 面号

              pop  bx
              pop  ax
              ret

            
    rwdiskend:nop

    start:    mov  ax,cs
              mov  ds,ax
              mov  si,offset rwdisk                        ; 设置 ds:si 指向源地址 (setscreen=002DH)

              mov  ax,0
              mov  es,ax
              mov  di,200H                                 ; 设置 es:di 指向目的地址

              mov  cx,offset rwdiskend -  offset rwdisk    ; 设置 cx 为传输长度 (setscreenend-setscreen=00ADH)
              cld                                          ; 设置传输方向为正
              rep  movsb                                   ; 复制

              mov  ax,0
              mov  es,ax
              mov  word ptr es:[7ch*4],200h
              mov  word ptr es:[7ch*4+2],0                 ; 设置中断向量表

              mov  ax,4c00h
              int  21h
code ends
end start