.syntax unified 
.equ INPUT_DIR,		1 
.equ OUTPUT_DIR,	0
.equ OFF,	0
.equ ON,    1


/*
	Initializes colours and IO pins by setting direction.

*/
.thumb_func 
.global init
init: 
push {lr}

	mov r0, #0
	mov r1, #17 
	bl pioa_dir_set

	mov r0, #0
	mov r1, #24
	bl pioa_dir_set

	mov r0, #0
	mov r1, #23
	bl pioa_dir_set

	mov r0, #0
	mov r1, #1
	bl pioa_dir_set

	mov r0, #0
	mov r1, #3
	bl pioa_dir_set

	mov r0, #0
	mov r1, #21
	bl pioa_dir_set

	mov r0, #0
	mov r1, 25
	bl pioc_dir_set


	mov r0, #0
	mov r1, #24
	bl pioc_dir_set

	mov r0, #0
	mov r1, #19
	bl pioc_dir_set

	mov r0, #0
	mov r1, #26
	bl pioc_dir_set

	mov r0, #0
	mov r1, #29
	bl pioc_dir_set

	mov r0, #0
	mov r1, #21
	bl pioc_dir_set

	mov r0, #0
	mov r1, #20
	bl pioc_dir_set

	mov r2, OFF
	bl set_r0

	mov r2, OFF
	bl set_g0

	mov r2, OFF
	bl set_b0 

	mov r2, OFF
	bl set_r1

	mov r2,OFF
	bl set_g1

	mov r2,OFF
	bl set_b1 


pop {pc}
/*
	Loads 32x32 grid into memory
	{r9} contains address address of first byte of grid within flash 

*/
.thumb_func 
.global load_grid
load_grid:

push {r0,r2,r9,r12,lr}
ldr r9, = _etext
mov r0, #0 
ldr r2, =0x20000000 
notloaded:
	cmp r0, #512 // (Height/2)*(Width)
	beq loaded

	ldrb r12, [r9], #1
	strb r12, [r2], #1
	add r0, #1
	b notloaded

loaded:
pop {r0,r2,r9,r12,pc}


/*
	// color 0 = black, 1 = blue, 2 = green, 3 = cyan, 4 = red, 5 = magenta, 6 = yellow, 7 = white
	Updates the grid by setting pixel {r8,r9,r10}
		- {r8} = x; 1 <= x <= 32
		- {r9} = y; 1 <= y <= 32
		- {r10} = colour; 0 <= colour <= 7
		
	As stored in the grid it will have the format [0,0,colour], colour [r1,g1,b1,r0,g0,b0]

*/
.thumb_func 
.global set_pixel
set_pixel:
push {r0,r1,r2,r3,lr}
cmp r6, #1
beq gohere

cmp r9, #16
blt case1		
sub r0, r9, #16	// y >= 16
mov r1, #32
mul r0, r0, r1
add r0, r8
ldr r2, =0x20000000
ldrb r3, [r2,r0]
and r3, 0x17 // so that r1 actually can change value of 4th bit
and r1, #0

orr r1, r10

lsl r1, r1, #3
orr r1, r3
strb r1, [r2,r0]
b done

case1: // y < 16
mov r1, #32
mul r0, r9, r1
add r0, r8
and r1, 0 
orr r1, r10
ldr r2, =0x20000000
ldrb r3, [r2,r0]
and r3, 0x1E
orr r1, r3
strb r1, [r2,r0]
b done

gohere: 


cmp r9, #16
blt case1b		
sub r0, r9, #16	// y >= 16
mov r1, #32
mul r0, r0, r1
add r0, r8

and r1, 0 
orr r1, r10
ldr r2, =0x20000000
lsl r1, r1, #4
ldrb r3, [r2,r0]
and r3, 0x0F
orr r1, r3
strb r1, [r2,r0]
b done

case1b: // y < 16
mov r1, #32
mul r0, r9, r1
add r0, r8
and r1, 0 
orr r1, r10
ldr r2, =0x20000000
ldrb r3, [r2,r0]
and r3, 0x1D

lsl r1, r1, #1
orr r1, r3
strb r1, [r2,r0]


done:
pop {r0,r1,r2,r3,pc}


.thumb_func 
.global set_pixel_init
set_pixel_init:
push {r0,r1,r2,lr}

pop {r0,r1,r2,pc}

