; 实验11
; 编写一个子程序，将包含任意字符，以0结尾的字符串中的小写字母转变成大写字母

assume cs:codesg
datasg segment
             db "Beginner's All-purpose Symbolic Instruction Code.",0
datasg ends
codesg segment
      begin:   mov  ax,datasg
               mov  ds,ax
               mov  si,0
               call letterc

               mov  ax,4c00h
               int  21h

      ; 功能：将以0结尾的字符串中的小写字母转变成大写字母
      ; 参数：ds:si指向字符串首地址
      ; 返回：无
      letterc: 
               push cx
               push si

               mov  ch,0                     ; cx高8位置0
      s:       
               mov  cl,byte ptr ds:[si]
               jcxz break                    ; 如果cx==0就break
      ; 小写字符的ASCII码范围是[61H,7AH], 减去20H就可以转化为大写字母
               cmp  cl,61H
               jb   continue                 ; cl < 61H 不是小写字母
               cmp  cl,7AH
               ja   continue                 ; cl > 7AH 不是小写字母

               sub  cl,20H                   ; 转大写
               mov  byte ptr ds:[si],cl


      continue:inc  si
               jmp  short s

      break:   
               pop  si
               pop  cx
               ret
codesg ends
end begin