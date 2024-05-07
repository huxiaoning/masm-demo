assume cs:code
data segment
         db '1975', '1976', '1977', '1978', '1979', '1980', '1981', '1982', '1983'
         db '1984', '1985', '1986', '1987', '1988', '1989', '1990', '1991', '1992'
         db '1993', '1994', '1995'
    ; 以上是表示21年的21个字符串(0~83)(0、4、8...)

         dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
         dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
    ; 以上是表示21年公司总收入的21个dword型数据(84~167)

         dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
         dw 11542,14430,15257,17800
    ; 以上是表示21年公司雇员人数的21个word型数据(168~209)
         db 32 dup (0)                                                                ; (210 ~ 241) (ds:[si]将指向这里，用来暂存每次需要显示的字符串)
data ends
stack segment
          db 64 dup (0)
stack ends
code segment
    start:      

                mov  ax,stack
                mov  ss,ax
                mov  sp,32                    ; 空栈

                mov  ax,data
                mov  ds,ax

                mov  bx,0
                mov  cx,21
    main_s:     
                call show_line
                inc  bx
                loop main_s

    ;mov dx,0				; 循环 TODO hxn
    ;mov ax,12666
    ;mov si,210
    ;call dtoc

    ;mov dh,8
    ;mov dl,3
    ;mov cl,2
    ;call show_str

                mov  ax,4c00h
                int  21h

    ; 名称: show_line
    ; 功能: 将某一行数据显示到屏幕上。
    ; 参数: (bx)=行号(0~20)
    ; 返回: 无
    show_line:  
                push ax
                push cx
                push dx
                push bp
                push di
                push si

                mov  ax,4
                mul  bx
                mov  bp,ax                    ; bp=bx*4 (数值较小，忽略高位dx,仅取低位ax中的内容即可)

                mov  ax,2                     ; 后面的雇员数和人均收入数据都是字型数据，占2字节 用di来索引
                mul  bx
                mov  di,ax                    ; di=bx*2 (数值较小，忽略高位dx,仅取低位ax中的内容即可)

    ; --- 年份(4字符依次入栈) ---
                mov  si,0
                mov  cx,4
    main_year_s:
                mov  al,ds:0[bp][si]
                mov  ds:210[si],al
                inc  si
                loop main_year_s
                mov  byte ptr ds:210[si],0

                mov  dh,bl                    ; 行
                inc  dh                       ; (我的窗口好像显示不全，往下挪一行)
                mov  dl,0                     ; 列
                mov  cl,2                     ; 颜色属性
                mov  si,210
                call show_str

    ; --- 总收入 ---
                mov  ax,ds:84[bp][0]          ; 低16位
                mov  dx,ds:84[bp][2]          ; 高16位
                mov  si,210
                call dtoc
                mov  dh,bl                    ; 行
                inc  dh                       ; (我的窗口好像显示不全，往下挪一行)
                mov  dl,5                     ; 列
                mov  cl,2                     ; 颜色属性
                call show_str

    ; --- 雇员数 ---

                mov  ax,ds:168[di][0]         ; 低16位
                mov  dx,0                     ; 高16位
                mov  si,210
                call dtoc
                mov  dh,bl                    ; 行
                inc  dh                       ; (我的窗口好像显示不全，往下挪一行)
                mov  dl,13                    ; 列
                mov  cl,2                     ; 颜色属性
                call show_str

    ; --- 人均收入 ---
                mov  ax,ds:84[bp][0]          ; 总收入的低16位
                mov  dx,ds:84[bp][2]          ; 总收入的高16位
                mov  cx,ds:168[di][0]         ; 雇员数低16位
                call divdw                    ; 收入/人数=人均，结果存储在(dx:ax)中,余数在cx中(忽略)
                mov  si,210
                call dtoc
                mov  dh,bl                    ; 行
                inc  dh                       ; (我的窗口好像显示不全，往下挪一行)
                mov  dl,19                    ; 列
                mov  cl,2                     ; 颜色属性
                call show_str

                pop  si
                pop  di
                pop  bp
                pop  dx
                pop  cx
                pop  ax

                ret

    ; 名称: dtoc
    ; 功能: 将dword型数转变为表示十进制数的字符串，字符串以0为结尾符。
    ; 参数: (ax)=dword型数据的低16位 (dx)=dword型数据的高16位 ds:si指向字符串的首地址
    ; 返回: 无
    dtoc:       
                push ax
                push bx
                push cx
                push dx
                push si

                mov  bx,0                     ; 用来记录余数入栈的数量
    dtoc_s:     
                mov  cx,10                    ; cx传参除数
                call divdw                    ; 余数在cx中返回 商以(dx:ax)形式返回
                push cx
                inc  bx

                mov  cx,ax
                add  cx,dx                    ; cx=ax+dx 如果cx(商)为0，就跳出循环
                jcxz dtoc_ok

                jmp  short dtoc_s
    dtoc_ok:    
    ; 把栈中的余数出栈放入data段中，并以0结尾
                mov  cx,bx
    dtoc_s1:    
                pop  bx                       ; 把当前的余数入到bx中
                add  bx,30H                   ; 余数数字转字符ASCII
                mov  ds:[si],bl               ; 忽略bx(余数)的高位
                inc  si
                loop dtoc_s1
                mov  byte ptr ds:[si],0

                pop  si
                pop  dx
                pop  cx
                pop  bx
                pop  ax
                ret

    ; 功能：进行不会产生溢出的除法运算，被除数为dword型，除数为word型，结果为dword型。
    ; 参数: (ax)=dword型数据的低16位
    ;         (dx)=dword型数据的高16位
    ;         (cx)=除数
    ; 返回: (dx)=结果的高16位, (ax)=结果的低16位, (cx)=余数
    ; 公式: X/N=int(H/N)*65536+[rem(H/N)*65536+L]/N
    divdw:      
                push bx
                mov  bx,ax                    ; 被除数的低16位放到bx中
                mov  ax,dx                    ; 被除数的高16位放到ax中
                mov  dx,0
                div  cx                       ; H/N   int(H/N)存储在ax中 rem(H/N)存储在dx中

    ; X/N=int(H/N)*65536+[rem(H/N)*65536+L]/N
    ; X/N=ax*65536+[dx*65536+L]/N
    ; X/N=ax*65536+[dx*65536+bx]/cx
    ; X/N=ax*10000H+[dx*10000H+bx]/cx
    ; ax*10000H 的结果 高16位就是ax,低16位就是0，把这32位压入栈中
                push ax
    ;mov ax,0   ; (低位0也可以不入栈)
    ;push ax	; (低位0也可以不入栈)

    ; dx*10000H 的结果 高16位就是dx,低16位就是0，把这32位压入栈中
    ; dx*10000H+bx 的结果 高16位就是dx,低16位就是bx
    ; [dx*10000H+bx]/cx 的结果 高16位就是dx,低16位就是bx
                mov  ax,bx                    ; [dx:ax]/cx
                div  cx                       ; 结果ax存商，dx存余数


                mov  cx,dx                    ; 返回余数

    ;pop bx			; 栈中的低位(0) ; (低位0也可以不入栈)
                pop  dx                       ; 返回高位
    ; ax已经是结果的低位了，这里需要ax+栈中的低位，但栈中的低位是0 add ax,0


                pop  bx
                ret


    ; 名称: show_str
    ; 功能: 在指定的位置，用指定的颜色，显示一个用0结束的字符串。
    ; 参数: (dh)=行号 (取值范围0~24)，(dl)=列号 (取值范围0~79)，(cl)=颜色，ds:si指向字符串的首地址。
    ; 返回: 无
    ; 应用举例: 在屏幕的8行3列，用绿色显示data段中的字符串。
    show_str:   
                push ax
                push bx
                push cx
                push es
                push si

    ; 显存段
                mov  ax,0B800H
                mov  es,ax


    ; 显示起始地址偏移 dh*160 + dl*2
                mov  al,160
                mul  dh                       ; ax=al*dh=160*dh
                mov  bx,ax                    ; bx=160*dh
                mov  al,2
                mul  dl                       ; ax=al*dl=2*dl
                add  bx,ax                    ; bx=160*dh+2*dl
    ; 颜色丰到al中,一会需要用到cx
                mov  al,cl
    s:          
                mov  ch,0
                mov  cl,ds:[si]
                jcxz ok                       ; 计到0表示字符串结束了,跳出循环
                mov  es:[bx],cl               ; 写入字符
                inc  bx                       ; bx指向后面的颜色属性字节
                mov  es:[bx],al               ; 写入颜色属性
                inc  bx
                inc  si
                jmp  short s
    ok:         
                pop  si
                pop  es
                pop  cx
                pop  bx
                pop  ax
                ret
code ends
end start