org 7c00h      ; set location counter. 
use16
push ds
push ds
push ds
jmp start 

e: 
ret

e1:
pop ds
ret

put_circle:
 finit       
 mov di,2000 
 fldz          
next:
 fld st0      
 fsincos       
 fimul [Radiusc]   
 fistp [tmpc]     
 mov cx,[tmpc]    
 fimul [Radiusc]    
 fistp [tmpc]
 mov dx,[tmpc]      
 fadd [stepc]   
 dec di      
 add dx,[xc]
 add cx,[yc]
 mov al,[boxc]
 call put_pix 
 dec di
 jnz next 
 ret       



tmpc   dw 0
Radiusc dw 10
anglec  dd 0
stepc   dd 0.01
xc       dw 0 ;; Center of circle X
yc       dw 0 ;;                  Y   


vertical: 
mov dx,[lx1]
mov cx,[ly1]
mov ax,[lx2]
mov bx,[ly2]
cmp cx,bx
jbe cycle_0_h  
push dx
mov dx,ax
pop ax 
push cx
mov cx,bx
pop bx
cycle_0_h:
call put_box
pop ax    
ret       

horizontal: 
mov dx,[lx1]
mov cx,[ly1]
mov ax,[lx2]
mov bx,[ly2]
cmp dx,ax
jbe cycle_0_v 
push dx
mov dx,ax
pop ax 
push cx
mov cx,bx
pop bx
cycle_0_v:
inc bx
call put_box
pop ax
ret

check_vertical_horizontal:
sub dx,ax
cmp dx,0000h
jz vertical 
sub cx,bx
cmp cx,0000h
jz horizontal
ret
         
put_line: 
mov [lx1],dx
mov [ly1],cx
mov [lx2],ax
mov [ly2],bx
call check_vertical_horizontal  
mov dx,[lx1]
mov cx,[ly1]
mov ax,[lx2]
mov bx,[ly2]
cmp dx,ax
jbe cycle_0 
push dx
mov dx,ax
pop ax 
push cx
mov cx,bx
pop bx
cycle_0:    
mov [lup],00h
cmp cx,bx
jna cycle_1
mov [lup],01h
cycle_1:  
mov [lx1],dx
mov [ly1],cx
mov [lx2],ax
mov [ly2],bx  
mov al,[boxc]
cmp dx,320
ja skip_put_pixel_3
cmp cx,200
ja skip_put_pixel_3 
call put_pix    
skip_put_pixel_3:
mov dx,[lx1]
mov cx,[ly1]
mov ax,[lx2]
mov bx,[ly2]
sub dx,ax
cmp dx,0000h
finit
fild  [lx2]
fisub [lx1] 
cmp [lup],00h
jnz cycle_2
fild  [ly2]
fisub [ly1]   
jmp cycle_3
cycle_2:
fild [ly1]
fisub [ly2] 
cycle_3: 
fdiv st0,st1
fstp [lstep]
fild [ly1]
fstp [ltemp]
fwait 
fld [lstep]
fld   [ltemp]  
inc [lx1]       
cycle:   
mov dx,[ly1]
mov [lyt],dx
cmp [lup],01h   
jz cycle_up
jmp cycle_down

cycle_up:
fsub  [lstep]
fist  [ly1] 
jmp cycle_draw    
cycle_down:   
fadd  [lstep]
fist  [ly1] 
jmp cycle_draw 

cycle_draw: 
mov dx,[lx1]
mov cx,[ly1] 
mov al,[boxc]  
cmp dx,320
ja skip_put_pixel_2
cmp cx,200
ja skip_put_pixel_2 
call put_pix
skip_put_pixel_2:  
inc [lx1]  
cmp [lup],01h
jz put_skiped_pixels_up
mov dx,[ly1]
sub dx,[lyt]
put_skiped_pixels_up_return:
cmp dx,1
ja put_skiped_pixels
cycle_ret: 
inc [lx2]  
mov dx,[lx1]
cmp dx,[lx2]
jz e      
dec [lx2]
dec dx
jmp cycle 

put_skiped_pixels_up:
mov dx,[lyt]
sub dx,[ly1]
jmp put_skiped_pixels_up_return          

put_skiped_pixels: 
dec [lx1]
put_skiped_pixels_0: 
cmp [lup],01h
jz put_skiped_pixel_1     
inc [lyt]
inc [lyt]                       
put_skiped_pixel_1:
dec [lyt]  
mov dx,[lx1]
mov cx,[lyt] 
mov al,[boxc]
cmp dx,320
ja skip_put_pixel_1 
cmp cx,200
ja skip_put_pixel_1 
call put_pix       
skip_put_pixel_1: 
cmp [lup],01h
jz put_ckiped_pixel_2
mov dx,[ly1]
sub dx,[lyt]
cmp dx,1   
jnz put_skiped_pixels_0
inc [lx1]
jmp cycle_ret

put_ckiped_pixel_2:
mov dx,[lyt]
sub dx,[ly1]
cmp dx,1   
jnz put_skiped_pixels_0   
inc [lx1]
jmp cycle_ret       






lup   db 0
lstep dd 0
lx1   dw 0
ly1   dw 0
lx2   dw 0
ly2   dw 0 
lyt   dw 0 
ltemp dd 0
boxc db 0   
ldebug dw 0


    
put_pix_box: 
push ax
push bx
push cx
push dx

push dx
mov ax, 08000h 
mov es, ax 
mov ax,320 
mul cx 
pop dx 
add ax,dx 
mov di,ax 
mov al,[boxc]
stosb  
pop dx
pop cx
pop bx
pop ax
ret 

put_box_new_line:
inc cx
cmp cx,bx
jz e  
dec cx
inc cx
mov dx,[bxr]
jmp ppb0 

put_box: 
mov [bxr],dx 
ppb0:   
call put_pix_box  
cmp cx,bx
jz e    
cmp ax,dx
jz put_box_new_line
inc dx
jmp ppb0 

;; AX - x2
;; DX - x1

;; CX - y1
;; BX - y2


bxr  dw 0


put_pix:
push di 
push ax 
push dx 
mov ax, 0A000h 
mov es, ax 
mov ax,320 
mul cx 
pop dx 
add ax,dx 
mov di,ax 
pop ax 
stosb  
pop di
ret 

fill_disp: 
push ds
push ax 
mov ax,08000h 
mov ds,ax 
pop ax 
mov ah,al 
mov bx,0FFFAh 
mov [bx],ax 
p0: 
add bx,6 
mov [bx],ax   
mov [bx+2],ax
mov [bx+4],ax
mov [bx+6],ax 
cmp bx,0FFFAh 
jz e1 
jmp p0

e_draw: 
pop dx 
pop bx 
mov [x],dx 
mov [y],bx
pop ds 
ret 

draw_sprite_nexline: 
inc si 
mov al,00h 
cmp al,[bx+si] 
jz e_draw 
dec si 
add [y],01h 
mov ax,[x_ret] 
mov [x],ax 
inc si 
jmp draw_sprite_1 

draw_sprite: 
push ds
mov ax,bx 
mov dx,[x] 
mov bx,[y] 
push bx 
push dx 
mov bx,ax 
mov ax,[x] 
mov [x_ret],ax 
mov si,0000h 
draw_sprite_1: 
mov ax, 8000h 
mov es, ax 
mov ax,320 
mov cx,[y] 
mul cx 
mov dx,[x] 
add ax,dx 
mov di,ax 
mov al,[bx+si] 
cmp al,255 
jz draw_sprite_2 
stosb 
draw_sprite_2: 
inc si 
mov al,00h 
cmp al,[bx+si] 
jz draw_sprite_nexline 
add [x],1 
jmp draw_sprite_1 

draw_display:
push ds 
mov di,0000h 
mov bx,0000h 
mov si,0000h 
mov ax,8000h 
mov ds,ax 
mov ax,0A000h 
mov es,ax 
draw_display_1: 
cmp bx,0FFFCh 
jz draw_display_2 
mov al,[bx] 
stosb      
mov al,[bx+1]
stosb
mov al,[bx+2]
stosb
mov al,[bx+3]
stosb
add bx,4 
jmp draw_display_1 
draw_display_2: 
jz e1   

get_pix:
push ax
push dx
mov ax,320 
mul cx 
pop dx 
add ax,dx
mov di,ax 
pop ax 
push ds
mov ax,0A000h
mov ds,ax
mov al,[di]
pop ds
ret

db '51-1'




draw_triangle_lines: 
mov dx,[tx1]
mov ax,[tx2]
mov cx,[ty1]
mov bx,[ty2] 
add dx,[x]
add ax,[x]
add cx,[y]
add bx,[y]
call put_line  
mov dx,[tx2]
mov ax,[tx3]
mov cx,[ty2]
mov bx,[ty3]  
add dx,[x]
add ax,[x]
add cx,[y]
add bx,[y]
call put_line 
mov dx,[tx3]
mov ax,[tx1]
mov cx,[ty3]
mov bx,[ty1]
add dx,[x]
add ax,[x]
add cx,[y]
add bx,[y]
call put_line 
ret  

tx1 dw 0
ty1 dw 0
tx2 dw 0
ty2 dw 0
tx3 dw 0
ty3 dw 0  

;; beta version

draw_polygons:
mov al,[bx+0]
mov ah,[bx+1]  
mov [tx1],ax  
mov al,[bx+2]
mov ah,[bx+3]  
mov [ty1],ax    
mov al,[bx+4]
mov ah,[bx+5]  
mov [tx2],ax  
mov al,[bx+6]
mov ah,[bx+7]  
mov [ty2],ax 
mov al,[bx+8]
mov ah,[bx+9]  
mov [tx3],ax  
mov al,[bx+10]
mov ah,[bx+11]  
mov [ty3],ax            
push bx
call draw_triangle_lines 
pop bx
add bx,12
mov al,00h
mov si,0000h
check_null_poly: 
mov al,[bx+si]
cmp si,12
jz e
inc si
cmp al,00
jz check_null_poly 
jmp draw_polygons

ray_throw: 
finit
mov byte [buff.e],0  
fld  [buff.null]
fstp [buff.lenght]
fldpi
fidiv [x180]   
fmul [buff.angle0]
fsincos
fmul [buff.step]
fst [buff.x_ray]  
fstp [buff.cos_x]  
fmul [buff.step]
fst [buff.y_ray]
fstp [buff.sin_y]   
.p0:  
fld [buff.x_ray]
fadd [buff.cos_x]
fstp [buff.x_ray]
fld [buff.y_ray]
fadd [buff.sin_y]
fstp [buff.y_ray]
;;
fld  [buff.lenght]
fadd [buff.one]
fstp [buff.lenght]
 
;;
fld [buff.x_ray]
fadd [player_pos.x]  
fld [buff.y_ray]
fadd [player_pos.y]
fistp [buff.y]
fistp [buff.x]  
fwait
;;
mov ax,[buff.y]
mov dl,6
mul dl
add ax,[buff.x]
add ax,map
mov bx,ax
cmp byte [bx],00h
jz .p0    
mov byte [buff.e],1
ret




x180 dw 180                
buff:
.angle0 dd 45.0
.x_ray  dd 0
.y_ray  dd 0
.step   dd 0.1 
.x      dw ?
.y      dw ?
.e      db 0  
.cos_x  dd 0
.sin_y  dd 0  
.lenght dd 0 
.null   dd 1.0
.one    dd 0.1



raycast_render: 
mov [.tmp],0
fld  [player_pos.angle]
fstp [buff.angle0]
.p0:
call ray_throw
cmp [buff.e],00
jz .p1
call .draw_line
.p1:
cmp [.tmp],319
jz e          
fld  [buff.angle0]
fadd [.tmp1]
fstp [buff.angle0]
inc [.tmp]
jmp .p0           

.draw_line:
mov al,[bx]
cmp al,01h
jz .draw_white
cmp al,02h
jz .draw_grey
cmp al,03h
jz .draw_red
cmp al,04h
jz .draw_black

.draw_white:
mov [boxc],0Fh
jmp .draw_line0  
.draw_grey:
mov [boxc],04h
jmp .draw_line0 
.draw_red:
mov [boxc],28h
jmp .draw_line0 
.draw_black:
mov [boxc],10h 


.draw_line0: 
fld   [buff.lenght]     
fild  [.buff]
fdiv st0,st1 
fistp [.lenght] 
mov ax,[.lenght] 
mov bx,200
sub bx,ax
mov ax,bx
xor bx,bx
mov bl,02h
div bl   
mov ah,0
mov cx,ax
mov bx,200
sub bx,cx
mov dx,[.tmp]
mov ax,[.tmp]
call put_box 
ret              

.div2    dw 2
.lenght dw 0    
.tmp    dw 0
.tmp1   dd 0.28125 
.buff   dw 200

left:
fld  [player_pos.angle]
fsub [raycast_render.tmp1]     
fsub [raycast_render.tmp1]
fstp [player_pos.angle]
jmp p4
    
right:
fld  [player_pos.angle]
fadd [raycast_render.tmp1]     
fadd [raycast_render.tmp1]
fstp [player_pos.angle]
jmp p4    

forword:  
fldpi
fidiv [x180]
fld [player_pos.angle]
fadd [player_pos.center_of_view]   
fmul st0,st1
fsincos                
fmul [buff.step]
fadd [player_pos.x]
fstp [player_pos.x]  
fmul [player_pos.speed]
fadd [player_pos.y]
fstp [player_pos.y]
jmp p4

backforword: 
fldpi
fidiv [x180]   
fld [player_pos.angle]
fadd [player_pos.center_of_view] 
fmul st0,st1
fsincos                
fmul [buff.step]
fld  [player_pos.x]
fsub st0,st1
fstp [player_pos.x]
fmul [player_pos.speed] 
fld  [player_pos.y]
fsub st0,st1
fstp [player_pos.y]
jmp p4


start:  
mov ah,0
mov al,13h
int 10h 
p4:      
mov [boxc],09h
mov dx,0
mov cx,0
mov ax,320
mov bx,100
call put_box     
mov [boxc],02h
mov dx,0
mov cx,100
mov ax,320
mov bx,200
call put_box       
call raycast_render   
call draw_display   
mov ah,00h
int 16h
cmp al,'a'
jz left
cmp al,'d'
jz right
cmp al,'w'
jz forword
cmp al,'s'
jz backforword
jmp p4  
   
   
map:
db 1,1,1,1,1,1
db 2,0,0,0,0,3
db 2,0,0,0,0,3   
db 2,0,0,0,0,3
db 2,0,0,0,0,3 
db 4,4,0,0,4,4
db 0,1,0,0,1,0  
db 0,1,0,0,1,0 
db 0,1,0,0,1,0 
db 0,1,0,0,1,0 
db 0,1,0,0,1,0 
db 0,1,0,0,1,0 
db 0,1,0,0,1,0  
db 1,1,0,0,1,1
db 2,0,0,0,0,3
db 2,0,0,0,0,3   
db 2,0,0,0,0,3
db 2,0,0,0,0,3 
db 4,4,4,4,4,4

   


     
player_pos:
.x     dd 3.0
.y     dd 3.0    
.angle dd 90
.speed  dd 0.05  
.center_of_view dd 45.0






;; Calls:
;; draw_sprite, Output sprite.
            ;; BX - offset of sprite
            ;; SI - 0000h 
            ;; [x] - X offset
            ;; [y] - Y offset  
            
;; put_pix, Output pixel
        ;; CX - Y offset
        ;; DX - X offset
         
;; get_pix, Get color of pixel
        ;; CX - Y offset
        ;; DX - X offset   
         ;; return AL 
                 
;; fill_disp, Fill display
            ;; AL - color
            
;; put_box, Output box
            ;; DX - X1
            ;; CX - Y1
            ;; AX - X2
            ;; BX - Y2 
            
;; put_line, Draw line
            ;; DX - X1
            ;; CX - Y1
            ;; AX - X2          
            ;; BX - Y2          
            ;; [boxc] - color

;; put_circle, Draw circle
            ;; [xc] - X offset of center
            ;; [yc] - Y offset of center
            ;; [Raduisc] - Radius of circle
            ;; [boxc]    - Color
            
  
            
              


;; AX - x2
;; DX - x1

;; CX - y1
;; BX - y2


wait_commets dw 0
;; -------------------------------------------------------------------------------
x_ret dw 0                                                                      ;-
x dw 0                                                                          ;-
y dw 0                                                                          ;-
                                                                                ;-
tx dw 0                                                                         ;-
ty dw 0                                                                         ;-
;; Global offsets for procedure draw_sprite || draw_triangle_lines              ;-
;-------------------------------------------------------------------------------;-   







INT 19h        ; reboot

