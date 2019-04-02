.syntax unified 

/*
Output Pins:

R0 -- PIOA 17 
G0 -- PIOA 24
B0 -- PIOA 23
R1 -- PIOA 1
G1 -- PIOA 3 
B1 -- PIOA 21

A0 -- PIOC 25
A1 -- PIOC 24
A2 -- PIOC 19 
A3 -- PIOC 26

CLK -- PIOC 29
STB -- PIOC 21 
OE  -- PIOC 20  


*/ 
.equ INPUT_DIR,		1 
.equ OUTPUT_DIR,	0
.equ OFF,	0
.equ ON,    1

.section .vectors 
.word _estack
.word main 

.section .text
.thumb_func
.global main
main:
ldr r9, =grid // Loads grid to avoid optimization
bl init

bl load_grid
mov r6, #0 // {r0} must be set to zero at the start

mov r8, #4
mov r9, #25
mov r10, #1
bl set_pixel


mov r8, #5
mov r9, #25
mov r10, #1
bl set_pixel



mov r8, #6
mov r9, #25
mov r10, #1
bl set_pixel

/*
mov r8, #15
mov r9, #15
mov r10, #1
bl set_pixel

mov r8, #16
mov r9, #15
mov r10, #1
bl set_pixel

mov r8, #17
mov r9, #15
mov r10, #1
bl set_pixel

mov r8, #15
mov r9, #16
mov r10, #1
bl set_pixel

mov r8, #17
mov r9, #16
mov r10, #1
bl set_pixel

mov r8, #15
mov r9, #17
mov r10, #1
bl set_pixel

mov r8, #16
mov r9, #17
mov r10, #1
bl set_pixel

mov r8, #17
mov r9, #17
mov r10, #1
bl set_pixel

mov r8, #15
mov r9, #18
mov r10, #1
bl set_pixel

mov r8, #16
mov r9, #18
mov r10, #1
bl set_pixel*/

update_grid:
cmp r6, #0
beq set_to_1
mov r6, #0
b rickroll
set_to_1:
mov r6, #1
rickroll:
mov r12, 0
bl update


main2:
mov r11, 0xFF
cmp r12, r11
beq update_grid
add r12, #1

mov r7, #0
loop1: 
cmp r7, #16
beq end1
mov r3, #0

mov r4, #32
mul r4, r7, r4  // r4 = row * matrix_width = row*32

	loop2: 
		cmp r3, #32
		beq end2
		
		add r5, r4, r3
		
		ldr r1,  =0x20000000 
		ldrb r1, [r1,r5]

		mov r9, r6
		mov r2, r1
		lsr r2,r2, r9
		and r2, 0x01
		bl set_r0
		
		add r9, r6, #3
		mov r2, r1
		lsr r2,r2, r9
		and r2, #1
		bl set_r1
	

		mov r2, ON
		bl set_clk

		mov r2, OFF
		bl set_clk

		add r3, #1
		b loop2
	end2: 

mov r2, ON
 bl set_oe


/*
row#  = {r7} = [abcd] (a,b,c,d bits)
	a0 = d
	a1 = c
	a2 = b
	a3 = a
*/

and r2, r7, #1
bl set_a0 

lsr r5, r7, #1
and r2, r5, #1
bl set_a1

lsr r5, r7, #2
and  r2, r5, #1
bl set_a2

lsr r5, r7, #3
and r2, r5, #1
bl set_a3


mov r2, ON
bl set_stb

mov r2, OFF
bl set_stb

mov r2, OFF
bl set_oe 


add r7, #1
b loop1
end1: 
b main2 




.thumb_func
.global update 
update:
push {r0,r1,r2,r3,r8,r9,r10,lr}
mov r0, #1// CHANGE BACK TO 1 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
mov r3, 1
/*
	 {r0} outer loop counter: row
	 {r1} inner loop counter: column 
	 {r2} number of neighbours alive

*/


update_loop1: /////////////////////////////////////////

	cmp r0, #30
	beq update_end1
	mov r3, #1

	update_loop2: /////////////////////////////////////////
		cmp r3, #30
		beq update_end2

			// Find number of neighbours alive
			mov r2, #0
			// r5 Y
			// r4 X
			// Top Left

				sub r5, r0, #1
				sub r4, r3, #1
				bl isAlive
				add r2, r4
			// Above 
				sub r5, r0, #1
				mov r4, r3
				bl isAlive
				add r2, r4 
			// Top Right 
				sub r5, r0, #1
				add r4, r3, #1
				bl isAlive
				add r2, r4

			// Bottom Left
				add r5, r0, #1
				sub r4, r3, #1
				bl isAlive
				add r2, r4

			// Bottom Right 
				add r5, r0, #1
				add r4, r3, #1
				bl isAlive
				add r2, r4

			// Below
				add r5, r0, #1
				mov r4, r3
				bl isAlive
				add r2, r4
			// Left 
				mov r5, r0
				sub r4, r3, #1
				bl isAlive
				add r2, r4
			//Right 
				mov r5, r0
				add r4, r3, #1
				bl isAlive
				add r2, r4

			// is current square alive? 
				mov r5, r0
				mov r4, r3
				bl isAlive
				
				cmp r4, #1
				beq square_is_alive // square is alive
									// square is dead
				cmp r2, #3
				beq dead_eq3
				// No cases apply, leave node as is

				mov r8, r3
				mov r9, r0
				mov r10, 0
				bl set_pixel
				b  end_of_loop

				dead_eq3: 
					mov r8, r3
					mov r9, r0
					mov r10, 1
					bl set_pixel
					b end_of_loop
					

				square_is_alive:
					cmp r2, #2
						blt alive_lt2 
					cmp r2, #3
						bgt	alive_gt3

						// keep the pixel alive
						mov r8, r3
						mov r9, r0
						mov r10, 1
						bl set_pixel
						b end_of_loop

				alive_lt2:
					mov r8, r3
					mov r9, r0
					mov r10, 0
					bl set_pixel
					b end_of_loop


				alive_gt3:
					mov r8, r3
					mov r9, r0
					mov r10, 0
					bl set_pixel
					b end_of_loop

				

		end_of_loop:
		add r3, #1
		b update_loop2
	update_end2: /////////////////////////////////////////

	add r0, #1
	b update_loop1
update_end1: /////////////////////////////////////////

pop {r0,r1,r2,r3,r8,r9,r10,pc}



/*
	Given a node (x,y) it reports if colour > 0 (is the).
	ARGS:
	 {r4} -- x
	 {r5} -- y 

	OUTPUT: 
	{r4}
	
	if	 {r4} = 0 <==> dead
	else {r4} = 1 <==> alive

*/
.thumb_func 
.global isAlive 
isAlive:

push {r0,r1,r2,lr}
cmp r6, #0
beq r6_eq_0


cmp r5, #16
blt isAlive_case1a		// y < 16
sub r0, r5, #16			// y >= 16
mov r1, #32
mul r0, r0, r1
add r0, r4
ldr r2, =0x20000000
ldrb r1, [r2,r0]
lsr r1, r1, #3
and r1, r1, 0x01 // most signifigant bit
mov r4, r1
b isAlive_done

isAlive_case1a: 
mov r1, #32
mul r0, r5, r1
add r0, r4

ldr r2, =0x20000000
ldrb r1, [r2,r0]
and r1, 0x01
mov r4,r1
b isAlive_done
r6_eq_0: ////////////////////////////////////

cmp r5, #16
blt isAlive_case1b		// y < 16
sub r0, r5, #16			// y >= 16
mov r1, #32
mul r0, r0, r1
add r0, r4
ldr r2, =0x20000000
ldrb r1, [r2,r0]
lsr r1, r1, #4
and r1, r1, 0x01 // most signifigant bit
mov r4, r1
b isAlive_done

isAlive_case1b: 
mov r1, #32
mul r0, r5, r1
add r0, r4
ldr r2, =0x20000000
ldrb r1, [r2,r0]
lsr r1, r1, #1
and r1, 0x01
mov r4,r1



isAlive_done:
pop {r0,r1,r2,pc}


// Most definitly there is a better way to do this, but this works. 
.section .data
grid: .long 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
			

