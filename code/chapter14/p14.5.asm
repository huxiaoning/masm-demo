; 编程，以 "年/月/日 时:分:秒" 的格式，显示当前的日期、时间。
; 秒：0	分：2	时：4	日：7	月：8	年：9
; 24/05/28 19:51:02
assume cs:code
data segment
         db 9,8,7,4,2,0    ; cmos单元，即 年月日时分秒 对应的单位位置 (0~5)
         db '// :: '       ; 分隔符(这里为了方便最后多加了一个空格做最后秒后面的分隔符)(6~11)
data ends
code segment
    start:    
              mov  ax,data
              mov  ds,ax

              mov  ax,0b800h
              mov  es,ax
              mov  di,160*12+30*2            ; 从第12行的大概中间处开始显示

              mov  cx,6
              mov  bx,0
    s:        
              mov  ax,ds:[bx]                ; al被赋值为要读取的cmos单元
              call read_cmos
              mov  byte ptr es:[di],ah       ; 十位
              mov  byte ptr es:[di+1],02h    ; 绿色
              mov  byte ptr es:[di+2],al     ; 个位
              mov  byte ptr es:[di+3],04h    ; 红色
              mov  al,byte ptr ds:[bx+6]
              mov  byte ptr es:[di+4],al     ; 分隔符
              mov  byte ptr es:[di+5],1h     ; 白低蓝色

              inc  bx
              add  di,6
              loop s
  

              mov  ax,4c00h
              int  21h

    ; 名称：read_cmos
    ; 功能：读取CMOS RAM中的时间数据
    ; 参数：al=CMOS单元
    ; 返回：ah=BCD高四位数字对应的阿斯克码
    ;       al=BCD低四位数字对应的阿斯克码
    read_cmos:
              push cx
              out  70h,al
              in   al,71h

              mov  ah,al                     ; al 中为从 CMOS RAM 的 8 号单元中读出的数据
              mov  cl,4
              shr  ah,cl                     ; ah 中为月份的十位数码值 (高4位右移至低四位处)
              and  al,00001111b              ; al 中为月份的个位数码值 (高4位置0)

              add  ah,30h
              add  al,30h

              pop  cx
              ret
code ends
end start