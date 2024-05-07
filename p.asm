assume cs:code
code segment
    start:mov ax,2
          add ax,ax
          add ax,ax
	
          mov ax,4c00H    ;程序返回
          int 21H         ;程序返回
code ends
end start