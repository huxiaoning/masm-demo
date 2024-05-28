assume cs:code
code segment
    start:
          mov al,8
          out 70h,al
          in  al,71h

          mov ah,al                             ; al 中为从 CMOS RAM 的 8 号单元中读出的数据
          mov cl,4
          shr ah,cl                             ; ah 中为月份的十位数码值 (高4位右移至低四位处)
          and al,00001111b                      ; al 中为月份的个位数码值 (高4位置0)

          add ah,30h
          add al,30h

          mov bx,0b800h
          mov es,bx
          mov byte ptr es:[160*12+40*2],ah      ; 显示月份的十位数码
          mov byte ptr es:[160*12+40*2+2],al    ; 接着显示月份的个位数码

          mov ax,4c00h
          int 21h
code ends
end start