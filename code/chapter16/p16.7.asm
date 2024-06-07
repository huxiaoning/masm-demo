assume cs:code
code segment

      ; 用ax向子程序传递角度
      showsin:jmp  short show
      table   dw   ag0,ag30,ag60,ag90,ag120,ag150,ag180      ; 字符串偏移地址表
      ag0     db   '0',0                                     ; sin(0)对应的字符串"0"
      ag30    db   '0.5',0                                   ; sin(30)对应的字符串"0.5"
      ag60    db   '0.866',0                                 ; sin(60)对应的字符串"0.866"
      ag90    db   '1',0                                     ; sin(90)对应的字符串"1"
      ag120   db   '0.866',0                                 ; sin(120)对应的字符串"0.866"
      ag150   db   '0.5',0                                   ; sin(150)对应的字符串"0.5"
      ag180   db   '0',0                                     ; sin(180)对应的字符串"0"

      show:   push bx                                        ; 少备份了一个ax?
              push es
              push si
              mov  bx,0b800h
              mov  es,bx
      ; 以下用角度值/30作为相对于table的偏移,取得对应的字符串的偏移地址,放在bx中
              mov  ah,0                                      ; 这行好像是多余的？ax/30为啥要把ax的高8位置0
              mov  bl,30
              div  bl                                        ; 除法的结果放在al中
              mov  bl,al
              mov  bh,0                                      ; bx就是table的索引
              add  bx,bx                                     ; bx需要*=2 因为table是dw,每个都是字单元(2节字)
              mov  bx,table[bx]                              ; bx现是在arg0 ~ ag180其中的一行起始位置

      ; 以下显示sin(x)对应的字符串
              mov  si,160*12+40*2
      shows:  mov  ah,cs:[bx]
              cmp  ah,0
              je   showret                                   ; ah==0时break跳出死循环
              mov  es:[si],ah
              inc  bx
              add  si,2
              jmp  short shows                               ; 自旋(死循环)
      showret:pop  si
              pop  es
              pop  bx
              ret

code ends
end start