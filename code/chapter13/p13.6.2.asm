mov ah, 9       ; 在光标位置显示字符
mov al,'a'      ; 字符
mov bl,7        ; 颜色属性
mov bh,0        ; 第0 页
mov cx,3        ; 字符重复个数
int 10h