mov ah,2    ; 置光标
mov bh,0    ;第 0 页
mov dh, 5   ;dh 中放行号
mov dl,12   ; dl 中放列号
int 10h